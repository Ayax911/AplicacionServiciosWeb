using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosEstado
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosEstado(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }
        public async Task<IEnumerable<Estado>> GetEstados()
        {
            return await _serviciosAPI.GetAPIAsync<IEnumerable<Estado>>($"api/Estado");
        }
        public async Task<RespuestaAPI> PutEstado(CUEstado estado, string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.PutAPIAsync<CUEstado, RespuestaAPI>($"api/Estado/{palabraClav}/{valorclav}", estado);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }

        public async Task<RespuestaAPI> PostEstado(CUEstado estado)
        {
            try
            {
                return await _serviciosAPI.PostAPIAsync<CUEstado, RespuestaAPI>($"api/Estado", estado);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
        public async Task<RespuestaAPI> DeleteEstado(string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.DeleteAPIAsync<RespuestaAPI>($"api/Estado/{palabraClav}/{valorclav}");
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }


    }
}
