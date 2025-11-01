using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosActividad
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosActividad(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOActividad>> ObtenerActividadesAsync()
        {
            string url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPActividadDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOActividad>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de actividades.");

            return respuesta.Resultados;
        }

        public async Task<bool> GuardarActividadAsync(
            int? id,
            int idEntregable,
            string titulo,
            string descripcion,
            DateTime fechaInicio,
            DateTime fechaFinPrevista)
        {
            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object?>
                {
                    { "nombreSP", "SPActividadGuardar" },
                    { "Id", id },
                    { "IdEntregable", idEntregable },
                    { "Titulo", titulo },
                    { "Descripcion", descripcion },
                    { "FechaInicio", fechaInicio },
                    { "FechaFinPrevista", fechaFinPrevista }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine("❌ No se recibió respuesta válida del SPActividadGuardar");
                    return false;
                }

                Console.WriteLine($"✅ SPActividadGuardar ejecutado correctamente.");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al guardar Actividad: {ex.Message}");
                return false;
            }
        }

        public async Task<bool> EliminarActividadAsync(int id)
        {
            if (id <= 0)
            {
                Console.WriteLine("❌ ID inválido para eliminar");
                return false;
            }

            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object>
        {
            { "nombreSP", "SPActividadEliminar" },
            { "Id", id }
        };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);

                if (respuesta?.Resultados != null && respuesta.Resultados.Any())
                {
                    var resultado = respuesta.Resultados.First();

                    // Verificar si la eliminación fue exitosa
                    if (resultado.ContainsKey("Resultado"))
                    {
                        int codigoResultado = Convert.ToInt32(resultado["Resultado"]);
                        string mensaje = resultado.ContainsKey("Mensaje") ? resultado["Mensaje"].ToString() : "";

                        if (codigoResultado > 0)
                        {
                            Console.WriteLine($"✅ {mensaje}");
                            return true;
                        }
                        else
                        {
                            Console.WriteLine($"⚠️ {mensaje}");
                            return false;
                        }
                    }
                }

                Console.WriteLine($" No se recibió respuesta del SP");
                return false;
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Error al eliminar actividad: {ex.Message}");
                return false;
            }
        }
    }
}

