namespace BlazorApp1.Models.ENTIDADES
{
    public class UsuarioRegistro
    {
        public string Email { get; set; } = string.Empty;
        public string Contrasena { get; set; } = string.Empty;
        public bool Activo { get; set; } = true; // Usuario activo por defecto al registrarse
        public string RutaAvatar { get; set; } = "/images/default-avatar.png"; // Avatar por defecto
    }
}
