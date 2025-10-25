using System.ComponentModel.DataAnnotations;

namespace BlazorApp1.Models
{
    public class CUEntregable
    {
        [Required(ErrorMessage = "El código es obligatorio")]
        [StringLength(20, ErrorMessage = "La cantidad máxima de caracteres para el código es 20")]
        public string Codigo { get; set; }

        [Required(ErrorMessage = "El título es obligatorio")]
        [StringLength(50, ErrorMessage = "La cantidad máxima de caracteres para el título es 50")]
        public string Titulo { get; set; }

        [Required(ErrorMessage = "La descripción es obligatoria")]
        [StringLength(255, ErrorMessage = "La cantidad máxima de caracteres para la descripción es 255")]
        public string Descripcion { get; set; }

        [Required(ErrorMessage = "La fecha de inicio es obligatoria")]
        public DateTime FechaInicio { get; set; }

        [Required(ErrorMessage = "La fecha fin prevista es obligatoria")]
        public DateTime FechaFinPrevista { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public DateTime? FechaFinalizacion { get; set; }
    }
}
