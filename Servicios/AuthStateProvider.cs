using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;

namespace BlazorApp1.Servicios
{
    public class AuthStateProvider : AuthenticationStateProvider
    {
        private readonly ServiciosAutenticacion _serviciosAutenticacion;

        public AuthStateProvider(ServiciosAutenticacion serviciosAutenticacion)
        {
            _serviciosAutenticacion = serviciosAutenticacion;
        }

        public override Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            var token = _serviciosAutenticacion.ObtenerToken();

            if (string.IsNullOrEmpty(token))
            {
                var anonimo = new ClaimsPrincipal(new ClaimsIdentity());
                return Task.FromResult(new AuthenticationState(anonimo));
            }

            try
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);

                var claims = new List<Claim>(jwtToken.Claims)
                {
                    new Claim(ClaimTypes.NameIdentifier, _serviciosAutenticacion.ObtenerUsuario() ?? "")
                };

                var identity = new ClaimsIdentity(claims, "jwt");
                var usuario = new ClaimsPrincipal(identity);

                return Task.FromResult(new AuthenticationState(usuario));
            }
            catch
            {
                var anonimo = new ClaimsPrincipal(new ClaimsIdentity());
                return Task.FromResult(new AuthenticationState(anonimo));
            }
        }

        public void NotificarLogin(string usuario)
        {
            var handler = new JwtSecurityTokenHandler();
            var token = _serviciosAutenticacion.ObtenerToken();

            if (!string.IsNullOrEmpty(token))
            {
                var jwtToken = handler.ReadJwtToken(token);
                var claims = new List<Claim>(jwtToken.Claims)
                {
                    new Claim(ClaimTypes.NameIdentifier, usuario)
                };

                var identity = new ClaimsIdentity(claims, "jwt");
                var usuario_principal = new ClaimsPrincipal(identity);
                NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(usuario_principal)));
            }
        }

        public void NotificarLogout()
        {
            var anonimo = new ClaimsPrincipal(new ClaimsIdentity());
            NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(anonimo)));
        }
    }
}