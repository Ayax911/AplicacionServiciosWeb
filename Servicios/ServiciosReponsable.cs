
using System.Reflection.Metadata.Ecma335;
using BlazorApp1.Models;

namespace BlazorApp1.Servicios
{
    public class ServiciosReponsable
    {
        readonly ServiciosAPI _serviciosAPI;
        public ServiciosReponsable(ServiciosAPI serviciosAPI)
        {
            _serviciosAPI = serviciosAPI;
        }

        public async Task<List<DTOResponsableT>> ObtenerResponsablesAsync()
        {
            string url = "api/procedimientos/ejecutarsp";

            var parametros = new Dictionary<string, object>
            {
                { "nombreSP", "SPResponsableTDetalle" }
            };
            var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<DTOResponsableT>>(url, parametros);

            if (respuesta == null || respuesta.Resultados == null)
                throw new Exception("No se pudo obtener la lista de responsables.");

            return respuesta.Resultados;
        }
        public async Task<bool> CrearResponsable(string nombre, string tipoResponsable, int UsuarioID)
        {
            if (string.IsNullOrWhiteSpace(nombre) || string.IsNullOrWhiteSpace(tipoResponsable) || UsuarioID <= 0)
                return false;

            try
            {
                string url = "api/procedimientos/ejecutarsp";
                var parametros = new Dictionary<string, object>
{
    { "nombreSP", "SPResponsableGuardar" },
    { "Nombre", nombre },
    { "TipoResponsable", tipoResponsable },
    { "idUsuario", UsuarioID }
};


                var respuesta = await _serviciosAPI.SpAPIAsync<SPResponse<Dictionary<string, object>>>(url, parametros);

                if (respuesta == null || respuesta.Resultados == null || !respuesta.Resultados.Any())
                {
                    Console.WriteLine("❌ No se recibió respuesta válida del SPResponsableGuardar");
                    return false;
                }

                var resultado = respuesta.Resultados.First();

                // Mostrar en consola lo que devolvió el SP (útil para debugging)
                if (resultado.ContainsKey("Mensaje"))
                    Console.WriteLine($"✅ SPResponsableGuardar: {resultado["Mensaje"]}");
                else
                    Console.WriteLine("SPResponsableGuardar ejecutado correctamente.");

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al guardar responsable: {ex.Message}");
                return false;
            }
        }
        public async Task<bool> EliminarResponsable(int usuarioID)
        {
            if (usuarioID <= 0)
                return false;
            try
            {
                var url = $"api/Responsable/IdUsuario/{usuarioID}?esquema=dbo";
                return await _serviciosAPI.DeleteAPIAsync<bool>(url);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error al eliminar responsable: {ex.Message}");
                return false;

            }


        }
        public async Task<List<TipoResponsable>> obtenerTiposReponsables()
        {
           string URL = "api/TipoResponsable";
           var tipos = await _serviciosAPI.GetAPIAsync<List<TipoResponsable>>(URL);
           if(tipos == null)
           {
            throw new Exception("No se pudieron obtener los tipos de responsables.");
            }
              return tipos;
        }
    }
}


