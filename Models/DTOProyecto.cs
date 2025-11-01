namespace BlazorApp1.Models
{
    // DTO Principal para mostrar en la tabla
    public class DTOProyecto
    {
        public int Id { get; set; } = 0;
        public string Codigo { get; set; }
        public string Titulo { get; set; }
        public string Descripcion { get; set; }
        public DateTime? FechaInicio { get; set; }
        public DateTime? FechaFinPrevista { get; set; }

        public string Estado { get; set; }

        public string DescripcionEstado { get; set; }
        public DateTime?FechaFinalizacion { get; set; }

        public int? IdTipoProyecto { get; set; }

        public int? IdResponsable { get; set; }

        public int? IdProyectoPadre { get; set; }

        public string RutaLogo { get; set; } = string.Empty;

        // Datos del Responsable
        public string Responsable { get; set; }

        // Datos del Tipo de Proyecto
        public string TipoProyecto { get; set; }
        public string DescripcionTipoProyecto { get; set; }

        // Datos del Proyecto Padre (si existe)
        public string ProyectoPadre { get; set; }
        public string CodigoProyectoPadre { get; set; }
    }


    // Entidad simplificada de Responsable
    public class Responsable
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public int IdTipoResponsable { get; set; }
        public int IdUsuario { get; set; }
    }

}

