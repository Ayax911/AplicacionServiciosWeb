using BlazorApp1.Models;
using BlazorApp1.Models.DTO;
using BlazorApp1.Models.ENTIDADES;

namespace BlazorApp1.Servicios
{
    public class ServiciosMetaEstrategica
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosMetaEstrategica(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOMetaEstrategica>> ObtenerMetasEstrategicasAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaEstrategicaDetalle" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaEstrategica>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Metas Estrategicas.");

            return respuesta.Resultados;
        }


        public async Task<List<ObjetivoEstrategico>> ObtenerObjetivosEstrategicosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPObjetivoEstrategicoListar" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<ObjetivoEstrategico>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                return new List<ObjetivoEstrategico>();

            return respuesta.Resultados;
        }

        public async Task<DTOMetaEstrategica?> CrearMetaEstrategicaAsync(MetaEstrategica meta)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaEstrategicaCrear" },
                { "IdObjetivo", meta.IdObjetivo },
                { "Titulo", meta.Titulo },
                { "Descripcion", meta.Descripcion ?? "" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaEstrategica>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }

        public async Task<DTOMetaEstrategica?> ActualizarMetaEstrategicaAsync(MetaEstrategica meta)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPMetaEstrategicaActualizar" },
                { "Id", meta.Id },
                { "IdObjetivo", meta.IdObjetivo },
                { "Titulo", meta.Titulo },
                { "Descripcion", meta.Descripcion ?? "" }
            };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOMetaEstrategica>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }


        public async Task<bool> EliminarMetaEstrategicaAsync(int id)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
    {
        { "nombreSP", "SPMetaEstrategicaEliminar" },
        { "Id", id }
    };

            try
            {
                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<object>>(url, parametros);
                return respuesta != null;
            }
            catch (Exception ex)
            {

                if (ex.Message.Contains("Meta") || ex.Message.Contains("asociada"))
                {
                    throw new Exception("No se puede eliminar la Meta Estratégica porque tiene registros asociados.", ex);
                }
                throw;
            }
        }
    }
}
