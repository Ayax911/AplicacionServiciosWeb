using BlazorApp1.Models.ENTIDADES;
using System.Text;
using System.Text.Json;

namespace BlazorApp1.Servicios
{
    public class ServiciosAutenticacion
    {
        private readonly HttpClient _httpClient;
        private const string TOKEN_KEY = "authToken";
        private const string USER_KEY = "currentUser";
        private const string EXPIRATION_KEY = "tokenExpiration";

        public ServiciosAutenticacion(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<RespuestaAutenticacion?> LoginAsync(CredencialesLogin credenciales)
        {
            try
            {
                string url = "api/autenticacion/token";

                var json = JsonSerializer.Serialize(credenciales);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await _httpClient.PostAsync(url, content);
                var responseContent = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    var respuesta = JsonSerializer.Deserialize<RespuestaAutenticacion>(
                        responseContent,
                        new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                    );

                    if (respuesta != null && !string.IsNullOrEmpty(respuesta.Token))
                    {
                        await GuardarSesionAsync(respuesta);
                        return respuesta;
                    }
                }

                var error = JsonSerializer.Deserialize<RespuestaAutenticacion>(
                    responseContent,
                    new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                );

                return error ?? new RespuestaAutenticacion
                {
                    Estado = (int)response.StatusCode,
                    Mensaje = "Error al autenticar usuario"
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error en LoginAsync: {ex.Message}");
                return new RespuestaAutenticacion
                {
                    Estado = 500,
                    Mensaje = $"Error de conexión: {ex.Message}"
                };
            }
        }

        private async Task GuardarSesionAsync(RespuestaAutenticacion respuesta)
        {
            try
            {
                await Task.Run(() =>
                {
                    SessionData.Token = respuesta.Token;
                    SessionData.Usuario = respuesta.Usuario;
                    SessionData.Expiracion = respuesta.Expiracion;
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al guardar sesión: {ex.Message}");
            }
        }

        public string? ObtenerToken()
        {
            return SessionData.Token;
        }

        public string? ObtenerUsuario()
        {
            return SessionData.Usuario;
        }

        public bool EstaAutenticado()
        {
            var token = SessionData.Token;
            var expiracion = SessionData.Expiracion;

            if (string.IsNullOrEmpty(token))
                return false;

            if (expiracion.HasValue && expiracion.Value <= DateTime.UtcNow)
            {
                CerrarSesion();
                return false;
            }

            return true;
        }

        public void CerrarSesion()
        {
            SessionData.Token = null;
            SessionData.Usuario = null;
            SessionData.Expiracion = null;
        }

        public void ConfigurarHeaderAutorizacion()
        {
            var token = ObtenerToken();
            if (!string.IsNullOrEmpty(token))
            {
                _httpClient.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
            }
        }
    }

    public static class SessionData
    {
        public static string? Token { get; set; }
        public static string? Usuario { get; set; }
        public static DateTime? Expiracion { get; set; }
    }
}