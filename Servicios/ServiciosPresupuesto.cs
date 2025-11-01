using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosPresupuesto
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosPresupuesto(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOPresupuestos>> ObtenerPresupuestosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPPresupuestoDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOPresupuestos>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de presupuestos.");

            return respuesta.Resultados;
        }

        public async Task<bool> GuardarPresupuestoAsync(
            int? id,
            int idProyecto,
            decimal montoSolicitado,
            string estado,
            decimal? montoAprobado,
            int? periodoAnio,
            DateTime? fechaSolicitud,
            DateTime? fechaAprobacion,
            string? observaciones)
                {
                    try
                    {
                        if (idProyecto <= 0)
                        {
                            Console.WriteLine("⚠️ No se puede guardar: IdProyecto no válido.");
                            return false;
                        }

                        string url = "api/procedimientos/ejecutarsp";
                        var parametros = new Dictionary<string, object?>
                {
                    { "nombreSP", "SPPresupuestoGuardar" },
                    { "Id", (id == 0 ? null : id) },
                    { "IdProyecto", idProyecto },
                    { "MontoSolicitado", montoSolicitado },
                    { "MontoAprobado", montoAprobado },
                    { "Estado", estado },
                    { "PeriodoAnio", periodoAnio },
                    { "FechaSolicitud", fechaSolicitud },
                    { "FechaAprobacion", fechaAprobacion },
                    { "Observaciones", observaciones }
                };

                        var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);

                        if (respuesta?.Resultados == null || !respuesta.Resultados.Any())
                        {
                            Console.WriteLine("❌ No se recibió respuesta del SPPresupuestoGuardar");
                            return false;
                        }

                        var resultado = respuesta.Resultados.First();

                        int codigo = resultado.ContainsKey("Resultado") ? Convert.ToInt32(resultado["Resultado"]) : 0;
                        string mensaje = resultado.ContainsKey("Mensaje") ? resultado["Mensaje"].ToString() ?? "" : "";

                        Console.WriteLine($"📘 SPPresupuestoGuardar → Resultado={codigo}, Mensaje={mensaje}");

                        return codigo > 0;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"❌ Error al guardar Presupuesto: {ex.Message}");
                        return false;
                    }
        }


        public async Task<bool> EliminarPresupuestoAsync(int id)
        {
            if (id <= 0) return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPPresupuestoEliminar" },
                    { "Id", id }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
                return respuesta?.Resultados != null && respuesta.Resultados.Any();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al eliminar Presupuesto: {ex.Message}");
                return false;
            }
        }
    }
}

