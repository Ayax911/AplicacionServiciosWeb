using System.ComponentModel.DataAnnotations;

namespace BlazorApp1.Models.ENTIDADES
{
    public class RegistroRequest
    {
        [Required(ErrorMessage = "El email es obligatorio")]
        [EmailAddress(ErrorMessage = "Debe ser un email válido")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "La contraseña es obligatoria")]
        [MinLength(6, ErrorMessage = "La contraseña debe tener al menos 6 caracteres")]
        public string Contrasena { get; set; } = string.Empty;

        [Required(ErrorMessage = "Debe confirmar la contraseña")]
        [Compare(nameof(Contrasena), ErrorMessage = "Las contraseñas no coinciden")]
        public string ConfirmarContrasena { get; set; } = string.Empty;

        [Range(typeof(bool), "true", "true", ErrorMessage = "Debe aceptar los términos y condiciones")]
        public bool AceptaTerminos { get; set; } = false;
    }
}
