using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosProyecto
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosProyecto(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }
        public async Task<bool> EliminarProyectoAsync(int id)
        {
            if (id <= 0)
                return false;
            try
            {
                var url = $"api/Proyecto/Id/{id}?esquema=dbo";
                return await _serviciosAPI.DeleteAPIAsync<bool>(url);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al eliminar Proyecto: {ex.Message}");
                return false;

            }
        }
        public async Task<List<Models.DTOProyecto>> ObtenerProyectosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPProyectosTRDetalle" }
            };
            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOProyecto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Proyectos.");

            return respuesta.Resultados;
        }
        public async Task<List<Models.Responsable>> ObtenerResponsablesAsync()
        {
                return await _serviciosAPI.GetAPIAsync<List<Models.Responsable>>($"api/Responsable");
        }

        public async Task<bool> GuardarProyectoAsync(
    int? id,
    int? idProyectoPadre,
    int idResponsable,
    string tipoProyecto,
    string codigo,
    string titulo,
    string? descripcion = null,
    DateTime? fechaInicio = null,
    DateTime? fechaFinPrevista = null,
    string? rutaLogo = null)
        {
            try
            {
                string url = "api/procedimientos/ejecutarsp";

                var parametros = new Dictionary<string, object?>
        {
            { "nombreSP", "SPProyectoGuardar" },
            { "Id", id },
            { "IdProyectoPadre", idProyectoPadre },
            { "IdResponsable", idResponsable },
            { "TipoProyecto", tipoProyecto },
            { "Codigo", codigo },
            { "Titulo", titulo },
            { "Descripcion", descripcion },
            { "FechaInicio", fechaInicio },
            { "FechaFinPrevista", fechaFinPrevista },
            { "RutaLogo", rutaLogo }
        };



                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);

                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine("❌ No se recibió respuesta válida del SPResponsableGuardar");
                    return false;
                }

                var resultado = respuesta.Resultados.First();

                // Mostrar en consola lo que devolvió el SP (útil para debugging)
                if (resultado.ContainsKey("Mensaje"))
                    Console.WriteLine($"✅ SPResponsableGuardar: {resultado["Mensaje"]}");
                else
                    Console.WriteLine("SPResponsableGuardar ejecutado correctamente.");

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al guardar responsable: {ex.Message}");
                return false;
            }
        }
      public async Task<bool> guardarRelacionEstado(int proyectoid, int estadoID, string codigo)
        {
            string url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SpEstadoPGuardar" },
                { "IdProyecto", proyectoid },
                { "IdEstado", estadoID },
                { "Codigo", codigo }
            };
            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
            return respuesta != null && respuesta.Resultados != null && respuesta.Resultados.Any();

        }
    }
}
