namespace BlazorApp1.Models
{
    public class SPResponse<T>
    {
        public string Procedimiento { get; set; }
        public List<T> Resultados { get; set; }
        public int Total { get; set; }
        public string Mensaje { get; set; }
    }

}
