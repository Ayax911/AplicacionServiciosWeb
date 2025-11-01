using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosResponsableEntregable
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosResponsableEntregable(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        // Obtiene todas las asociaciones Responsable-Entregable
        public async Task<List<DTOResponsableEntregable>> ObtenerResponsableEntregablesAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPResponsableEntregableDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOResponsableEntregable>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de asociaciones Responsable-Entregable.");

            return respuesta.Resultados;
        }

        //asociar un responsable a un entregable
        public async Task<bool> GuardarResponsableEntregableAsync(int idResponsable, int idEntregable, DateTime? fechaAsociacion)
        {
            if (idResponsable <= 0 || idEntregable <= 0)
                return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";

                var parametros = new Dictionary<string, object?>
                {
                    { "nombreSP", "SPResponsableEntregableGuardar" },
                    { "IdResponsable", idResponsable },
                    { "IdEntregable", idEntregable },
                    { "FechaAsociacion", fechaAsociacion }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);

                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine("❌ No se recibió respuesta válida del SPResponsableEntregableGuardar");
                    return false;
                }

                var resultado = respuesta.Resultados.First();

                if (resultado.ContainsKey("Mensaje"))
                    Console.WriteLine($"✅ SPResponsableEntregableGuardar: {resultado["Mensaje"]}");
                else
                    Console.WriteLine("SPResponsableEntregableGuardar ejecutado correctamente.");

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al guardar Responsable_Entregable: {ex.Message}");
                return false;
            }
        }

        //Eliminar una asociación Responsable-Entregable
        public async Task<bool> EliminarResponsableEntregableAsync(int idResponsable, int idEntregable)
        {
            if (idResponsable <= 0 || idEntregable <= 0)
                return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object>
        {
            { "nombreSP", "SPResponsableEntregableEliminar" },
            { "IdResponsable", idResponsable },
            { "IdEntregable", idEntregable }
        };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);
                return respuesta?.Resultados != null && respuesta.Resultados.Any();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al eliminar Responsable_Entregable: {ex.Message}");
                return false;
            }
        }

        //Obtener lista de Responsables
        public async Task<List<Responsable>> ObtenerResponsablesAsync()
        {
            return await _serviciosAPI.GetAPIAsync<List<Responsable>>($"api/Responsable");
        }

        // Obtener lista de Entregables
        public async Task<List<Entregable>> ObtenerEntregablesAsync()
        {
            return await _serviciosAPI.GetAPIAsync<List<Entregable>>($"api/Entregable");
        }
    }
}


