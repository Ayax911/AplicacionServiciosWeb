using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosEntregable
    {
        private readonly ServiciosAPI _serviciosAPI;

        public ServiciosEntregable(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        // GET - Listar todos los entregables
        public async Task<IEnumerable<Entregable>> GetEntregables()
        {
            return await _serviciosAPI.GetAPIAsync<IEnumerable<Entregable>>("api/Entregable");
        }

        // POST - Crear entregable
        public async Task<RespuestaAPI> PostEntregable(CUEntregable entregable)
        {
            try
            {
                return await _serviciosAPI.PostAPIAsync<CUEntregable, RespuestaAPI>(
                    "api/Entregable", entregable
                );
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = $"Error al crear entregable: {ex.Message}" };
            }
        }

        // PUT - Actualizar entregable
        public async Task<RespuestaAPI> PutEntregable(CUEntregable entregable, string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.PutAPIAsync<CUEntregable, RespuestaAPI>($"api/Entregable/{palabraClav}/{valorclav}", entregable);
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
        public async Task<RespuestaAPI> DeleteEntregable(string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.DeleteAPIAsync<RespuestaAPI>($"api/Entregable/{palabraClav}/{valorclav}");
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
    }
}
