
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BlazorApp1.Models
{
    public class Entregable
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required(ErrorMessage = "El código es obligatorio")]
        [StringLength(50, ErrorMessage = "La cantidad máxima de caracteres es 50")]
        public string? Codigo { get; set; }

        [Required(ErrorMessage = "El título es obligatorio")]
        [StringLength(50, ErrorMessage = "La cantidad máxima de caracteres es 50")]
        public string? Titulo { get; set; }

        [Required(ErrorMessage = "La descripción es obligatoria")]
        [StringLength(255, ErrorMessage = "La cantidad máxima de caracteres es 255")]
        public string? Descripcion { get; set; }

        [Required(ErrorMessage = "La fecha de inicio es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime FechaInicio { get; set; }

        [Required(ErrorMessage = "La fecha fin prevista es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime FechaFinPrevista { get; set; }

        [DataType(DataType.Date)]
        public DateTime? FechaModificacion { get; set; }

        [DataType(DataType.Date)]
        public DateTime? FechaFinalizacion { get; set; }
    }
}
