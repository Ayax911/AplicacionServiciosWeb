namespace BlazorApp1.Models.ENTIDADES
{
    /// <summary>
    /// Modelo para las credenciales de login
    /// </summary>
    public class CredencialesLogin
    {
        public string Tabla { get; set; } = "usuario";
        public string CampoUsuario { get; set; } = "email";
        public string CampoContrasena { get; set; } = "contrasena";
        public string Usuario { get; set; } = string.Empty;
        public string Contrasena { get; set; } = string.Empty;
    }
}