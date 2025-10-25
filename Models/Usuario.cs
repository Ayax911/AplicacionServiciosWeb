using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BlazorApp1.Models
{
    public class Usuario
    {
        //dataannotations para validaciones y configuraciones
        [Key,DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int? Id { get; set; }
        [Required(ErrorMessage ="El correo es obligatorio"),EmailAddress (ErrorMessage = "Debe ser un correo valido")]
        public string? Email { get; set; }
        [Required(ErrorMessage ="Ingrese una contraseña")]
        public string? Contrasena { get; set; }
        [Required]
        public bool Activo { get; set; } = false;

        public string RutaAvatar { get; set; } = "";

    }
}
