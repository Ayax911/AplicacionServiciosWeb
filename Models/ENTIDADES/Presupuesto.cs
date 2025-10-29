namespace BlazorApp1.Models.ENTIDADES
{
    public class Presupuesto
    {
        public int Id { get; set; }
        public int IdProyecto { get; set; }
        public decimal MontoSolicitado { get; set; }
        public string Estado { get; set; } 
        public decimal? MontoAprobado { get; set; }
        public int PeriodoAnio { get; set; }
        public DateTime FechaSolicitud { get; set; }
        public DateTime? FechaAprobacion { get; set; }
        public string? Observaciones { get; set; }
    }
}
