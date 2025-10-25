using BlazorApp1.Models;
namespace BlazorApp1.Servicios
{
    public class ServiciosUsuario
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosUsuario(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }
        public async Task<IEnumerable<Usuario>> GetUsuarios()
        {
            return await _serviciosAPI.GetAPIAsync<IEnumerable<Usuario>>($"api/Usuario");
        }
        public async Task<RespuestaAPI> PutUsuario(CUUsuario usuario, string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.PutAPIAsync<CUUsuario, RespuestaAPI>($"api/Usuario/{palabraClav}/{valorclav}", usuario);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
        public async Task<RespuestaAPI> PostUsuario(CUUsuario usuario)
        {
            try
            {
                return await _serviciosAPI.PostAPIAsync<CUUsuario, RespuestaAPI>($"api/Usuario", usuario);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
        public async Task<RespuestaAPI> DeleteUsuario(string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.DeleteAPIAsync<RespuestaAPI>($"api/Usuario/{palabraClav}/{valorclav}");
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
    }
}
