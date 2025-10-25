
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BlazorApp1.Models
{
    public class TipoResponsable
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        [Required(ErrorMessage = "El titulo es obligatorio"),StringLength(50,ErrorMessage ="cantidad de caracteres maxima de 50")]
        public string Titulo { get; set; }
        [Required(ErrorMessage = "La descripcion es obligatoria"),StringLength(255,ErrorMessage ="Cantidad de caracteres maxima de 255")]
        public string Descripcion { get; set; }
    }
}
