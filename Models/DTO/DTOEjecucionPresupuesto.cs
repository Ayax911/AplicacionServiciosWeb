namespace BlazorApp1.Models.DTO
{
    public class DTOEjecucionPresupuesto
    {
        public int Id { get; set; }
        public int IdPresupuesto { get; set; }
        public int Anio { get; set; }
        public decimal MontoPlaneado { get; set; }
        public decimal MontoEjecutado { get; set; }
        public string? Observaciones { get; set; }
    }
}
