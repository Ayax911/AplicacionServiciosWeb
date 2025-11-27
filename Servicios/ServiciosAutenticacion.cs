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

        public async Task<RespuestaRegistro> RegisterAsync(RegistroRequest registro)
        {
            try
            {
                // FASE 1: VALIDACIONES BÁSICAS DEL LADO CLIENTE
                if (string.IsNullOrWhiteSpace(registro.Email))
                {
                    return new RespuestaRegistro
                    {
                        Estado = 400,
                        Mensaje = "El email es obligatorio"
                    };
                }

                if (string.IsNullOrWhiteSpace(registro.Contrasena))
                {
                    return new RespuestaRegistro
                    {
                        Estado = 400,
                        Mensaje = "La contraseña es obligatoria"
                    };
                }

                if (registro.Contrasena != registro.ConfirmarContrasena)
                {
                    return new RespuestaRegistro
                    {
                        Estado = 400,
                        Mensaje = "Las contraseñas no coinciden"
                    };
                }

                if (!registro.AceptaTerminos)
                {
                    return new RespuestaRegistro
                    {
                        Estado = 400,
                        Mensaje = "Debe aceptar los términos y condiciones"
                    };
                }

                // FASE 2: PREPARAR DATOS PARA EL API
                // Convertir RegistroRequest a UsuarioRegistro (sin campo de confirmación)
                var usuarioParaCrear = new UsuarioRegistro
                {
                    Email = registro.Email.Trim().ToLower(), // Normalizar email
                    Contrasena = registro.Contrasena, // Se encriptará en el API
                    Activo = true, // Usuario activo por defecto
                    RutaAvatar = "https://i.pravatar.cc/150?img=1" // Avatar por defecto
                };

                // FASE 3: ENVIAR PETICIÓN AL API
                string url = "api/usuario?camposEncriptar=contrasena";  // Endpoint genérico del EntidadesController

                var json = JsonSerializer.Serialize(usuarioParaCrear, new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                });

                var content = new StringContent(json, Encoding.UTF8, "application/json");

                Console.WriteLine($"[REGISTRO] Enviando petición a: {url}");
                Console.WriteLine($"[REGISTRO] Datos: {json}");

                var response = await _httpClient.PostAsync(url, content);
                var responseContent = await response.Content.ReadAsStringAsync();

                Console.WriteLine($"[REGISTRO] Status Code: {response.StatusCode}");
                Console.WriteLine($"[REGISTRO] Respuesta: {responseContent}");

                // FASE 4: PROCESAR RESPUESTA DEL API
                if (response.IsSuccessStatusCode)
                {
                    // Intentar deserializar la respuesta del API
                    var respuestaApi = JsonSerializer.Deserialize<Dictionary<string, object>>(
                        responseContent,
                        new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                    );

                    return new RespuestaRegistro
                    {
                        Estado = 200,
                        Mensaje = "Usuario registrado exitosamente. Ahora puedes iniciar sesión.",
                        Usuario = registro.Email,
                        FechaRegistro = DateTime.UtcNow
                    };
                }
                else if (response.StatusCode == System.Net.HttpStatusCode.Conflict)
                {
                    // 409 Conflict - Usuario ya existe
                    return new RespuestaRegistro
                    {
                        Estado = 409,
                        Mensaje = "Este email ya está registrado. Intenta iniciar sesión o usa otro email."
                    };
                }
                else
                {
                    // Intentar extraer mensaje de error del API
                    try
                    {
                        var errorApi = JsonSerializer.Deserialize<Dictionary<string, object>>(
                            responseContent,
                            new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                        );

                        var mensajeError = errorApi?.ContainsKey("mensaje") == true
                            ? errorApi["mensaje"].ToString()
                            : "Error al registrar usuario";

                        return new RespuestaRegistro
                        {
                            Estado = (int)response.StatusCode,
                            Mensaje = mensajeError ?? "Error desconocido"
                        };
                    }
                    catch
                    {
                        return new RespuestaRegistro
                        {
                            Estado = (int)response.StatusCode,
                            Mensaje = "Error al registrar usuario"
                        };
                    }
                }
            }
            catch (HttpRequestException httpEx)
            {
                Console.WriteLine($"Error HTTP en RegisterAsync: {httpEx.Message}");
                return new RespuestaRegistro
                {
                    Estado = 500,
                    Mensaje = $"Error de conexión: No se pudo conectar con el servidor"
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error general en RegisterAsync: {ex.Message}");
                Console.WriteLine($"StackTrace: {ex.StackTrace}");
                return new RespuestaRegistro
                {
                    Estado = 500,
                    Mensaje = $"Error inesperado: {ex.Message}"
                };
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