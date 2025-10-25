using System.ComponentModel.DataAnnotations;

namespace BlazorApp1.Models
{
    public class CUTipoProyecto
    {
        [Required(ErrorMessage = "El Nombre es obligatorio"), StringLength(50, ErrorMessage = "cantidad de caracteres maxima de 50")]
        public string Nombre { get; set; }
        [Required(ErrorMessage = "La descripcion es obligatoria"), StringLength(255, ErrorMessage = "Cantidad de caracteres maxima de 255")]
        public string Descripcion { get; set; }
    }
}
