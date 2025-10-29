using BlazorApp1.Models;
using BlazorApp1.Models.DTO;
using BlazorApp1.Models.ENTIDADES;

namespace BlazorApp1.Servicios
{
    public class ServiciosMetaProyecto
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosMetaProyecto(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOMetaProyecto>> ObtenerMetasProyectosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaProyectoDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaProyecto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Meta-Proyectos.");

            return respuesta.Resultados;
        }
        public async Task<List<DTOMetaProyecto>> ObtenerMetasPorProyectoAsync(int idProyecto)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaProyectoPorProyecto" },
                { "IdProyecto", idProyecto }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaProyecto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                return new List<DTOMetaProyecto>();

            return respuesta.Resultados;
        }
        public async Task<List<DTOMetaProyecto>> ObtenerProyectosPorMetaAsync(int idMeta)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaProyectoPorMeta" },
                { "IdMeta", idMeta }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaProyecto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                return new List<DTOMetaProyecto>();

            return respuesta.Resultados;
        }

        public async Task<DTOMetaProyecto?> CrearMetaProyectoAsync(int idMeta, int idProyecto)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaProyectoCrear" },
                { "IdMeta", idMeta },
                { "IdProyecto", idProyecto },
                { "FechaAsociacion", DateTime.Now }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaProyecto>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }

        public async Task<DTOMetaProyecto?> ActualizarMetaProyectoAsync(int idMeta, int idProyecto, DateTime fechaAsociacion)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaProyectoActualizar" },
                { "IdMeta", idMeta },
                { "IdProyecto", idProyecto },
                { "FechaAsociacion", fechaAsociacion }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaProyecto>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }

        public async Task<bool> EliminarMetaProyectoAsync(int idMeta, int idProyecto)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaProyectoEliminar" },
                { "IdMeta", idMeta },
                { "IdProyecto", idProyecto }
            };

            try
            {
                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<object>>(url, parametros);
                return respuesta != null;
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("asociada") || ex.Message.Contains("referencia"))
                {
                    throw new Exception("No se puede eliminar la asociación porque tiene registros dependientes.", ex);
                }
                throw;
            }
        }

        public async Task<bool> EliminarMetasPorProyectoAsync(int idProyecto)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaProyectoEliminarPorProyecto" },
                { "IdProyecto", idProyecto }
            };

            try
            {
                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<object>>(url, parametros);
                return respuesta != null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Error al eliminar metas del proyecto: {ex.Message}");
                return false;
            }
        }

        public async Task<bool> ExisteAsociacionAsync(int idMeta, int idProyecto)
        {
            try
            {
                var metas = await ObtenerMetasPorProyectoAsync(idProyecto);
                return metas.Any(m => m.IdMeta == idMeta);
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Error al verificar asociación: {ex.Message}");
                return false;
            }
        }
    }
}