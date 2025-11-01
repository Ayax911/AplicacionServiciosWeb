using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosProductos
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosProductos(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }
        public async Task<List<DTOProductos>> ObtenerProductosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPProductoObtener" }
            };
            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOProductos>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Proyectos.");

            return respuesta.Resultados;
        }
        public async Task<bool> GuardarProductoAsync(int id,string codigo, string titulo, string tipoProducto,
                                                     string? descripcion = null, DateTime? fechaInicio = null,
                                                     DateTime? fechaFinPrevista = null, string? rutaLogo = null)
        {
            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object?>
        {
            { "nombreSP", "SPProductoGuardar" },
            { "Id", id },
            { "Codigo", codigo },
            { "Titulo", titulo },
            { "TipoProducto", tipoProducto },
            { "Descripcion", descripcion },
            { "FechaInicio", fechaInicio },
            { "FechaFinPrevista", fechaFinPrevista },
            { "RutaLogo", rutaLogo }
        };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);

                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine("❌ No se recibió respuesta válida del SPProductoGuardar");
                    return false;
                }

                var resultado = respuesta.Resultados.First();

                // Mostrar en consola lo que devolvió el SP (útil para debugging)
                if (resultado.ContainsKey("Mensaje"))
                    Console.WriteLine($"✅ SPProductoGuardar: {resultado["Mensaje"]}");
                else
                    Console.WriteLine("SPProductoGuardar ejecutado correctamente.");

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al guardar producto: {ex.Message}");
                return false;
            }
        }
        public async Task<bool> EliminarProductoAsync(int id) {
            if (id <= 0)
                return false;
            try
            {
                var url = $"api/Producto/Id/{id}?esquema=dbo";
                return await _serviciosAPI.DeleteAPIAsync<bool>(url);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al eliminar Proyecto: {ex.Message}");
                return false;

            }
        }
    }
}
