namespace BlazorApp1.Models
{
    public class DTOResponsableEntregable
    {
        public int IdResponsable { get; set; }
        public int IdEntregable { get; set; }
        public DateTime? FechaAsociacion { get; set; }

        // Campos relacionados (JOIN con Responsable)
        public string NombreResponsable { get; set; }
        public string TipoResponsable { get; set; }

        // Campos relacionados (JOIN con Entregable)
        public string TituloEntregable { get; set; }
        public string CodigoEntregable { get; set; }
    }
}
