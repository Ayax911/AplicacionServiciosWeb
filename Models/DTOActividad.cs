namespace BlazorApp1.Models
{
    public class DTOActividad
    {
        public int Id { get; set; }
        public int IdEntregable { get; set; }
        public string Titulo { get; set; }
        public string Descripcion { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFinPrevista { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public DateTime? FechaFinalizacion { get; set; }

        // Campos relacionados opcionales (para mostrar datos unidos)
        public string TituloEntregable { get; set; }
        public string CodigoEntregable { get; set; }
    }
}
