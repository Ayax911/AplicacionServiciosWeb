using BlazorApp1.Models;
using BlazorApp1.Models.DTO;

namespace BlazorApp1.Servicios
{
    public class ServiciosEjecucionPresupuesto
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosEjecucionPresupuesto(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOEjecucionPresupuesto>> ObtenerEjecucionesPresupuestoAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPEjecucionPresupuestoDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOEjecucionPresupuesto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Ejecuciones de Presupuesto.");

            return respuesta.Resultados;
        }

        public async Task<bool> GuardarEjecucionPresupuestoAsync(
            int? id,
            int idPresupuesto,
            int anio,
            decimal montoPlaneado,
            decimal montoEjecutado,
            string? observaciones = null)
        {
            try
            {
                string url = "api/procedimientos/ejecutarsp";

                var parametros = new Dictionary<string, object?>
                {
                    { "nombreSP", "SPEjecucionPresupuestoGuardar" },
                    { "Id", id },
                    { "IdPresupuesto", idPresupuesto },
                    { "Anio", anio },
                    { "MontoPlaneado", montoPlaneado },
                    { "MontoEjecutado", montoEjecutado },
                    { "Observaciones", observaciones }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);

                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine(" No se recibió respuesta válida del SPEjecucionPresupuestoGuardar");
                    return false;
                }

                var resultado = respuesta.Resultados.First();

                if (resultado.ContainsKey("Mensaje"))
                    Console.WriteLine($"SPEjecucionPresupuestoGuardar: {resultado["Mensaje"]}");
                else
                    Console.WriteLine("SPEjecucionPresupuestoGuardar ejecutado correctamente.");

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Error al guardar ejecución de presupuesto: {ex.Message}");
                return false;
            }
        }

        public async Task<bool> EliminarEjecucionPresupuestoAsync(int id)
        {
            if (id <= 0)
                return false;

            try
            {
                var url = $"api/EjecucionPresupuesto/Id/{id}?esquema=dbo";
                return await _serviciosAPI.DeleteAPIAsync<bool>(url);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al eliminar Ejecución de Presupuesto: {ex.Message}");
                return false;
            }
        }
    }
}
