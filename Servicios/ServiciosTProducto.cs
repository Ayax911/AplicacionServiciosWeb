using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosTProducto
    {
        readonly ServiciosAPI _serviciosAPI;

        public ServiciosTProducto(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<IEnumerable<TipoProducto>> GetTipoProductos()
        {
            return await _serviciosAPI.GetAPIAsync<IEnumerable<TipoProducto>>($"api/TipoProducto");
        }

        public async Task<RespuestaAPI> PutTipoProducto(CUTipoProducto TProducto, string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.PutAPIAsync<CUTipoProducto, RespuestaAPI>(
                    $"api/TipoProducto/{palabraClav}/{valorclav}", TProducto
                );
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }

        public async Task<RespuestaAPI> PostTipoProducto(CUTipoProducto TProducto)
        {
            try
            {
                return await _serviciosAPI.PostAPIAsync<CUTipoProducto, RespuestaAPI>(
                    $"api/TipoProducto", TProducto
                );
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }

        public async Task<RespuestaAPI> DeleteTipoProducto(string palabraClav, int valorclav)
        {
            try
            {
                return await _serviciosAPI.DeleteAPIAsync<RespuestaAPI>(
                    $"api/TipoProducto/{palabraClav}/{valorclav}"
                );
            }
            catch (Exception ex)
            {
                return new RespuestaAPI { Estado = 0, Mensaje = ex.Message };
            }
        }
    }
}
