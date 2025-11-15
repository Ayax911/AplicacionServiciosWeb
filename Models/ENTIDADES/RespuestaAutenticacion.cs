namespace BlazorApp1.Models.ENTIDADES
{
    public class RespuestaAutenticacion
    {
        public int Estado { get; set; }
        public string Mensaje { get; set; } = string.Empty;
        public string Usuario { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
        public DateTime Expiracion { get; set; }
    }
}
