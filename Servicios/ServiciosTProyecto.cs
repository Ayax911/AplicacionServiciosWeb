using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosTProyecto
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosTProyecto(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }
        public async Task<IEnumerable<TipoProyecto>> GetTipoProyectos()
        {
            return await _serviciosAPI.GetAPIAsync<IEnumerable<TipoProyecto>>($"api/TipoProyecto");
        }
        public async Task<RespuestaAPI> PutTipoProyecto(CUTipoProyecto TProyecto, string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.PutAPIAsync<CUTipoProyecto, RespuestaAPI>($"api/TipoProyecto/{palabraClav}/{valorclav}", TProyecto);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }

        public async Task<RespuestaAPI> PostTipoProyecto(CUTipoProyecto Tproyecto)
        {
            try
            {
                return await _serviciosAPI.PostAPIAsync<CUTipoProyecto, RespuestaAPI>($"api/TipoProyecto", Tproyecto);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
        public async Task<RespuestaAPI> DeleteTipoProyecto(string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.DeleteAPIAsync<RespuestaAPI>($"api/TipoProyecto/{palabraClav}/{valorclav}");
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }


    }
}
