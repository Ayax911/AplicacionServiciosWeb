using System.ComponentModel.DataAnnotations;

namespace BlazorApp1.Models
{
    public class CUUsuario
    {
        [Required(ErrorMessage = "El correo es obligatorio"), EmailAddress(ErrorMessage = "Debe ser un correo valido")]
        public string? Email { get; set; }
        [Required(ErrorMessage = "Ingrese una contraseña")]
        public string? Contrasena { get; set; }
        [Required]
        public bool Activo { get; set; } = false;

        public string RutaAvatar { get; set; } = "";
    }
}
