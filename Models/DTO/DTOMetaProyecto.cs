namespace BlazorApp1.Models.DTO
{
    public class DTOMetaProyecto
    {
        
        public int IdMeta { get; set; }
        public int IdProyecto { get; set; }

        
        public DateTime FechaAsociacion { get; set; }

        public string TituloMeta { get; set; }
        public string DescripcionMeta { get; set; }
        public string ObjetivoEstrategico { get; set; } 

       
        public string CodigoProyecto { get; set; }
        public string TituloProyecto { get; set; }
        public string TipoProyecto { get; set; }
        public string ResponsableProyecto { get; set; }
    }
}
