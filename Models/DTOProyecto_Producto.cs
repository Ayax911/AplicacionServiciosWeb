namespace BlazorApp1.Models
{
    public class DTOProyecto_Producto
    {
      public  int IdProducto { get; set; } 
       public  int IdProyecto { get; set; }
       public DateTime FechaAsociacion { get; set; }

       public string ProyectoCodigo { get; set; }

       public string ProyectoTitulo { get; set; }

        public string ProductoCodigo { get; set; }

        public string ProductoTitulo { get; set; }


    }
}
