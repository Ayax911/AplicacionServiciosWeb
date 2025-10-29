namespace BlazorApp1.Models.DTO
{
    public class DTOPresupuesto
    {
        // Datos principales
        public int Id { get; set; }
        public int IdProyecto { get; set; }
        public decimal MontoSolicitado { get; set; }
        public string Estado { get; set; }
        public decimal? MontoAprobado { get; set; }
        public int PeriodoAnio { get; set; }
        public DateTime FechaSolicitud { get; set; }
        public DateTime? FechaAprobacion { get; set; }
        public string? Observaciones { get; set; }

        // Información denormalizada del Proyecto
        public string CodigoProyecto { get; set; }
        public string TituloProyecto { get; set; }
        public string TipoProyecto { get; set; }
        public string ResponsableProyecto { get; set; }
    }
}
