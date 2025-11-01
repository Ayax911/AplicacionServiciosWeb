namespace BlazorApp1.Models
{
    public class DTOArchivoEntregable
    {
        public int IdArchivo { get; set; }
        public int IdEntregable { get; set; }

        // Campos relacionados (JOIN con Archivo)
        public string NombreArchivo { get; set; }
        public string TipoArchivo { get; set; }
        public DateTime? FechaArchivo { get; set; }

        // Campos relacionados (JOIN con Entregable)
        public string TituloEntregable { get; set; }
        public string CodigoEntregable { get; set; }
    }
}
