using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosProyecto_Productos
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosProyecto_Productos(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOProyecto_Producto>> ObtenerProyectos_ProductosAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPProdProyObtener" }
            };
            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOProyecto_Producto>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de Proyectos.");

            return respuesta.Resultados;
        }
        public async Task<ResultadoSP> EliminarRelacion(int idproyecto, int idproducto)
        {
            if (idproducto <= 0 || idproyecto <= 0)
                return new ResultadoSP { Id = -1, Mensaje = "Parámetros inválidos" };

            var url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
    {
        { "nombreSP", "EliminarRelacionPP" },
        { "idproyecto", idproyecto },
        { "idproducto", idproducto }
    };

            return await _serviciosAPI.SpAPIAsync<ResultadoSP>(url, parametros);
        }
        public async Task<(int,string)> GuardarRelacion(int idproyecto, int idproducto, DateTime FechaAsignada)
        {
            if (idproducto <= 0 || idproyecto <= 0)
                return (-1,"Información Imcompleta");

            var url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
    {
        { "nombreSP", "SPInsertarPP" },
        { "IdProyecto", idproyecto },
        { "IdProducto", idproducto },
        { "FechaAsociacion", FechaAsignada }
    };

            try
            {
                var resultado = await _serviciosAPI.SpAPIAsync<Dictionary<string, object>>(url, parametros);

                if (resultado == null || !resultado.ContainsKey("resultados"))
                    return (-1,"No hubo Resultados");

                // resultados es un array, así que lo convertimos a una lista de objetos dinámicos
                var resultados = resultado["resultados"] as Newtonsoft.Json.Linq.JArray;
                if (resultados == null || resultados.Count == 0)
                    return (-1, "Error en los Resultados");

                // Tomamos el primer elemento del array
                var item = resultados[0];
                int valorResultado = item.Value<int>("Resultado");
                string mensaje = item.Value<string>("Mensaje");


                // Retornar true solo si el Resultado fue 1
                return (valorResultado,mensaje);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error en GuardarRelacion: {ex.Message}");
                return (-1,"Error en GuardarRelación: "+ex.Message);
            }
        }
        public async Task<(int, string)> ActualizarRelacion(int idproyecto, int idproducto, DateTime FechaAsignada)
        {
            if (idproducto <= 0 || idproyecto <= 0)
                return (-1, "Información Imcompleta");
            var url = "api/procedimientos/ejecutarsp";
            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPActualizarPP" },
                { "IdProyecto", idproyecto },
                { "IdProducto", idproducto },
                { "FechaAsociacion", FechaAsignada }
            };
            try
            {
                var resultado = await _serviciosAPI.SpAPIAsync<Dictionary<string, object>>(url, parametros);
                if (resultado == null || !resultado.ContainsKey("resultados"))
                    return (-1, "No hubo Resultados");
                // resultados es un array, así que lo convertimos a una lista de objetos dinámicos
                var resultados = resultado["resultados"] as Newtonsoft.Json.Linq.JArray;
                if (resultados == null || resultados.Count == 0)
                    return (-1, "Error en los Resultados");
                // Tomamos el primer elemento del array
                var item = resultados[0];
                int valorResultado = item.Value<int>("Resultado");
                string mensaje = item.Value<string>("Mensaje");
                return(valorResultado, mensaje);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error en ActualizarRelacion: {ex.Message}");
                return (-1, "Error en ActualizarRelación: " + ex.Message);
            }
            }
        public class ResultadoSP
        {
            public int Id { get; set; }
            public string Mensaje { get; set; }
        }

    }
}
