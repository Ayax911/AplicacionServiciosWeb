using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosArchivo
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosArchivo(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOArchivo>> ObtenerArchivosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPArchivoDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOArchivo>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de archivos.");

            return respuesta.Resultados;
        }

        public async Task<bool> GuardarArchivoAsync(
            int? id,
            int idUsuario,
            string ruta,
            string nombre,
            string tipo,
            DateTime? fecha
            )
        {
            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object?>
                {
                    { "nombreSP", "SPArchivoGuardar" },
                    { "Id", id },
                    { "IdUsuario", idUsuario },
                    { "Ruta", ruta },
                    { "Nombre", nombre },
                    { "Tipo", tipo },
                    { "Fecha", fecha }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine("❌ No se recibió respuesta válida del SPArchivoGuardar");
                    return false;
                }

                Console.WriteLine($"✅ SPArchivoGuardar ejecutado correctamente.");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al guardar Archivo: {ex.Message}");
                return false;
            }
        }

        public async Task<bool> EliminarArchivoAsync(int id)
        {
            if (id <= 0) return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPArchivoEliminar" },
                    { "Id", id }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
                return respuesta?.Resultados != null && respuesta.Resultados.Any();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al eliminar Archivo: {ex.Message}");
                return false;
            }
        }
    }
}