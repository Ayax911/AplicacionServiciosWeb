namespace BlazorApp1.Models
{
    public class DTOArchivo
    {
        public int Id { get; set; }
        public int IdUsuario { get; set; }
        public string Ruta { get; set; }
        public string Nombre { get; set; }
        public string Tipo { get; set; }
        public DateTime? Fecha { get; set; }

        // Campos relacionados (JOIN con Usuario)
        public string EmailUsuario { get; set; }
    }
}
