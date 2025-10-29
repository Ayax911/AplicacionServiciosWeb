using BlazorApp1.Models;
using BlazorApp1.Models.DTO;

namespace BlazorApp1.Servicios
{
    public class ServiciosDistribucionPresupuesto
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosDistribucionPresupuesto(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

     
        public async Task<List<DTODistribucionPresupuesto>> ObtenerDistribucionesPresupuestoAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPDistribucionPresupuestoDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTODistribucionPresupuesto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Distribuciones de Presupuesto.");

            return respuesta.Resultados;
        }

       
        public async Task<List<DTODistribucionPresupuesto>> ObtenerDistribucionesPorPresupuestoAsync(int idPresupuestoPadre)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPDistribucionPresupuestoPorPresupuesto" },
                { "IdPresupuestoPadre", idPresupuestoPadre }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTODistribucionPresupuesto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                return new List<DTODistribucionPresupuesto>();

            return respuesta.Resultados;
        }

        public async Task<List<DTODistribucionPresupuesto>> ObtenerDistribucionesPorProyectoHijoAsync(int idProyectoHijo)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPDistribucionPresupuestoPorProyectoHijo" },
                { "IdProyectoHijo", idProyectoHijo }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTODistribucionPresupuesto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                return new List<DTODistribucionPresupuesto>();

            return respuesta.Resultados;
        }


        public async Task<DTODistribucionPresupuesto?> CrearDistribucionPresupuestoAsync(
            int idPresupuestoPadre,
            int idProyectoHijo,
            decimal montoAsignado)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPDistribucionPresupuestoCrear" },
                { "IdPresupuestoPadre", idPresupuestoPadre },
                { "IdProyectoHijo", idProyectoHijo },
                { "MontoAsignado", montoAsignado }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTODistribucionPresupuesto>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }


 
        public async Task<DTODistribucionPresupuesto?> ActualizarDistribucionPresupuestoAsync(
            int id,
            decimal montoAsignado)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPDistribucionPresupuestoActualizar" },
                { "Id", id },
                { "MontoAsignado", montoAsignado }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTODistribucionPresupuesto>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }

 
        public async Task<bool> EliminarDistribucionPresupuestoAsync(int id)
        {
            if (id <= 0)
                return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";

                var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPDistribucionPresupuestoEliminar" },
                    { "Id", id }
                };

                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<object>>(url, parametros);
                return respuesta != null;
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("asociada") || ex.Message.Contains("referencia"))
                {
                    throw new Exception("No se puede eliminar la distribución porque tiene registros dependientes.", ex);
                }
                throw;
            }
        }

        public async Task<bool> EliminarDistribucionesPorPresupuestoAsync(int idPresupuestoPadre)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPDistribucionPresupuestoEliminarPorPresupuesto" },
                { "IdPresupuestoPadre", idPresupuestoPadre }
            };

            try
            {
                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<object>>(url, parametros);
                return respuesta != null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al eliminar distribuciones del presupuesto: {ex.Message}");
                return false;
            }
        }

     
        public async Task<bool> ExisteDistribucionAsync(int idPresupuestoPadre, int idProyectoHijo)
        {
            try
            {
                var distribuciones = await ObtenerDistribucionesPorPresupuestoAsync(idPresupuestoPadre);
                return distribuciones.Any(d => d.IdProyectoHijo == idProyectoHijo);
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Error al verificar distribución: {ex.Message}");
                return false;
            }
        }
    }
}