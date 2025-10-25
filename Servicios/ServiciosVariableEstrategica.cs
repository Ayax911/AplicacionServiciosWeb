using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosVariableEstrategica
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosVariableEstrategica(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<IEnumerable<VariableEstrategica>> GetVariablesEstrategicas()
        {
            return await _serviciosAPI.GetAPIAsync<IEnumerable<VariableEstrategica>>($"api/VariableEstrategica");
        }

        public async Task<RespuestaAPI> PutVariableEstrategica(CUVariableEstrategica variable, string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.PutAPIAsync<CUVariableEstrategica, RespuestaAPI>(
                    $"api/VariableEstrategica/{palabraClav}/{valorclav}", variable
                );
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }

        public async Task<RespuestaAPI> PostVariableEstrategica(CUVariableEstrategica variable)
        {
            try
            {
                return await _serviciosAPI.PostAPIAsync<CUVariableEstrategica, RespuestaAPI>(
                    $"api/VariableEstrategica", variable
                );
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }

        public async Task<RespuestaAPI> DeleteVariableEstrategica(string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.DeleteAPIAsync<RespuestaAPI>(
                    $"api/VariableEstrategica/{palabraClav}/{valorclav}"
                );
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
    }
}
