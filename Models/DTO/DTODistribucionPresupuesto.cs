namespace BlazorApp1.Models.DTO
{
    public class DTODistribucionPresupuesto
    {
        public int Id { get; set; }
        public int IdPresupuestoPadre { get; set; }
        public int IdProyectoHijo { get; set; }
        public decimal MontoAsignado { get; set; }
    }
}
