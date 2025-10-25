namespace BlazorApp1.Models
{
    public class RespuestaAPI
    {
       public int Estado { get; set; }

       public string Mensaje { get; set; }

       public string Tabla { get; set; }

       public string esquema { get; set; }

        public string? filtro { get; set; }

        public int? filasAfectadas { get; set; }

        public string? camposEncriptados { get; set; }
    }
}
