using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosTResponsable
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosTResponsable(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }
        public async Task<IEnumerable<TipoResponsable>> GetResponsables()
        {
            return await _serviciosAPI.GetAPIAsync<IEnumerable<TipoResponsable>>($"api/TipoResponsable");
        }
        public async Task<RespuestaAPI> PutResponsable(CUTipoResponsable responsable, string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.PutAPIAsync<CUTipoResponsable, RespuestaAPI>($"api/TipoResponsable/{palabraClav}/{valorclav}", responsable);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }

        public async Task<RespuestaAPI> PostResponsable(CUTipoResponsable responsable)
        {
            try
            {
                return await _serviciosAPI.PostAPIAsync<CUTipoResponsable, RespuestaAPI>($"api/TipoResponsable", responsable);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
        public async Task<RespuestaAPI> DeleteResponsable(string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.DeleteAPIAsync<RespuestaAPI>($"api/TipoResponsable/{palabraClav}/{valorclav}");
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }


    }
}
