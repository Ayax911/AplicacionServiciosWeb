namespace BlazorApp1.Models.ENTIDADES
{
    public class DistribucionPresupuesto
    {
        public int Id { get; set; }
        public int IdPresupuestoPadre { get; set; }
        public int IdProyectoHijo { get; set; }
        public decimal MontoAsignado { get; set; }
    }
}
