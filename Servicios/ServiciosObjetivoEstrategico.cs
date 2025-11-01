using BlazorApp1.Models.ENTIDADES;
using BlazorApp1.Models.DTO;
using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosObjetivoEstrategico
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosObjetivoEstrategico(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOObjetivoEstrategico>> ObtenerObjetivosEstrategicosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPObjetivoEstrategicoDetalle" }
                };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOObjetivoEstrategico>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Objetivos Estratégicos.");

            return respuesta.Resultados;
        }

        public async Task<DTOObjetivoEstrategico?> CrearObjetivoEstrategicoAsync(ObjetivoEstrategico objetivo)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPObjetivoEstrategicoCrear" },
                    { "IdVariable", objetivo.IdVariable },
                    { "Titulo", objetivo.Titulo },
                    { "Descripcion", objetivo.Descripcion ?? "" }
                };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOObjetivoEstrategico>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }

        public async Task<DTOObjetivoEstrategico?> ActualizarObjetivoEstrategicoAsync(ObjetivoEstrategico objetivo)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPObjetivoEstrategicoActualizar" },
                    { "Id", objetivo.Id },
                    { "IdVariable", objetivo.IdVariable },
                    { "Titulo", objetivo.Titulo },
                    { "Descripcion", objetivo.Descripcion ?? "" }
                };

            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOObjetivoEstrategico>>(url, parametros);
            return respuesta?.Resultados?.FirstOrDefault();
        }


        public async Task<bool> EliminarObjetivoEstrategicoAsync(int id)
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
                {
                    { "nombreSP", "SPObjetivoEstrategicoEliminar" },
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
                    throw new Exception("No se puede eliminar el objetivo porque tiene metas estratégicas asociadas.", ex);
                }
                throw;
            }
        }
    }
}