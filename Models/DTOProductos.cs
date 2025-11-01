namespace BlazorApp1.Models
{
    public class DTOProductos
    {
        public int Id { get; set; }
        public int IdTipoProducto { get; set; }
        public string Codigo { get; set; }
        public string Titulo { get; set; }
        public string Descripcion { get; set; }
        public DateTime? FechaInicio { get; set; }
        public DateTime? FechaFinPrevista { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public DateTime? FechaFinalizacion { get; set; }
        public string RutaLogo { get; set; }

        // Datos calculados para mostrar en la UI
        public string TipoProducto { get; set; }
        public string DescripcionTipoProducto { get; set; }
    }
}
