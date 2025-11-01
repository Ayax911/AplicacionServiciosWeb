namespace BlazorApp1.Models
{
    public class DTOProducto_entregable
    {
        public int IdProducto { get; set; }
        public int IdEntregable { get; set; }
        public string ProductoCodigo { get; set; }
        public string ProductoTitulo { get; set; }

        public DateTime FechaAsociacion { get; set; }
        public string EntregableCodigo { get; set; }

        public string EntregableTitulo { get; set; }
    }
}
