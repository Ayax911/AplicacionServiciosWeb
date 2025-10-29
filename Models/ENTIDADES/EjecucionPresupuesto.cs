namespace BlazorApp1.Models.ENTIDADES
{
    public class EjecucionPresupuesto
    {
        public int Id { get; set; }
        public int IdPresupuesto { get; set; }
        public int Anio { get; set; }
        public decimal MontoPlaneado { get; set; }
        public decimal MontoEjecutado { get; set; }
        public string? Observaciones { get; set; }
    }
}
