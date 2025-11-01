namespace BlazorApp1.Models
{
    public class DTOPresupuestos
    {
        public int Id { get; set; }
        public int IdProyecto { get; set; }
        public decimal MontoSolicitado { get; set; }
        public string Estado { get; set; }
        public decimal? MontoAprobado { get; set; }
        public int? PeriodoAnio { get; set; }
        public DateTime? FechaSolicitud { get; set; }
        public DateTime? FechaAprobacion { get; set; }
        public string Observaciones { get; set; }

        // Campos relacionados (JOIN con Proyecto)
        public string TituloProyecto { get; set; }
        public string CodigoProyecto { get; set; }
    }
}
