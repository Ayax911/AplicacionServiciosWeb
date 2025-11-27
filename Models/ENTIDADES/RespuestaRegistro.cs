namespace BlazorApp1.Models.ENTIDADES
{
    public class RespuestaRegistro
    {
        public int Estado { get; set; }
        public string Mensaje { get; set; } = string.Empty;
        public string? Usuario { get; set; }
        public DateTime? FechaRegistro { get; set; }
    }
}
