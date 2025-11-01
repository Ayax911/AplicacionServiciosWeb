using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosArchivoEntregable
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosArchivoEntregable(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOArchivoEntregable>> ObtenerArchivoEntregablesAsync()
        {
            string url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPArchivoEntregableDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOArchivoEntregable>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de asociaciones Archivo-Entregable.");

            return respuesta.Resultados;
        }

        public async Task<bool> GuardarArchivoEntregableAsync(int idArchivo, int idEntregable)
        {
            if (idArchivo <= 0 || idEntregable <= 0)
                return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object?>
                {
                    { "nombreSP", "SPArchivoEntregableGuardar" },
                    { "IdArchivo", idArchivo },
                    { "IdEntregable", idEntregable }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine("❌ No se recibió respuesta válida del SPArchivoEntregableGuardar");
                    return false;
                }

                Console.WriteLine($"✅ SPArchivoEntregableGuardar ejecutado correctamente.");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al guardar Archivo_Entregable: {ex.Message}");
                return false;
            }
        }

        public async Task<bool> EliminarArchivoEntregableAsync(int idArchivo, int idEntregable)
        {
            if (idArchivo <= 0 || idEntregable <= 0) return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPArchivoEntregableEliminar" },
                    { "IdArchivo", idArchivo },
                    { "IdEntregable", idEntregable }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
                return respuesta?.Resultados != null && respuesta.Resultados.Any();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al eliminar Archivo_Entregable: {ex.Message}");
                return false;
            }
        }
    }
}

