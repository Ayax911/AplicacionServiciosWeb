using System.Net.Http.Json;
using System.Net.WebSockets;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
namespace BlazorApp1.Servicios
{
    public class ServiciosAPI
    {
        readonly HttpClient _httpClient;
        public ServiciosAPI(HttpClient client)
        {
            _httpClient = client;
        }
        public async Task<T> GetAPIAsync<T>(string url)
        {
            var response = await _httpClient.GetAsync(url);
            if (!response.IsSuccessStatusCode)
                throw new Exception("Error en la llamada a la API: " + response.ReasonPhrase);

            var responseString = await response.Content.ReadAsStringAsync();

            var json = JObject.Parse(responseString);

            if (json["datos"] != null)
            {
                var datosJson = json["datos"]!.ToString();
                var result = JsonConvert.DeserializeObject<T>(datosJson);
                return result!;
            }

            // fallback si no tiene propiedad "datos"
            var resultNormal = JsonConvert.DeserializeObject<T>(responseString);
            if (resultNormal == null)
                throw new Exception("Error: La deserialización devolvió un valor nulo.");

            return resultNormal;
        }

        public async Task<TResponse> PostAPIAsync<TRequest, TResponse>(string url, TRequest data)
        {
            var response = await _httpClient.PostAsJsonAsync(url, data);
            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<TResponse>() ?? throw new Exception("Error: La deserialización devolvió un valor nulo.");
            }
            else
            {
                throw new Exception("Error en la llamada a la API: " + response.ReasonPhrase);
            }
        }
        public async Task<TResponse> PutAPIAsync<TRequest, TResponse>(string url, TRequest data)
        {
            var response = await _httpClient.PutAsJsonAsync(url, data);
            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<TResponse>() ?? throw new Exception("Error: La deserialización devolvió un valor nulo.");
            }
            else
            {
                throw new Exception("Error en la llamada a la API: " + response.ReasonPhrase);
            }
        }
        public async Task<TResponse> DeleteAPIAsync<TResponse>(string url)
        {
            var response = await _httpClient.DeleteAsync(url);
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception("Error en la llamada a la API: " + response.ReasonPhrase);
            }
            return await response.Content.ReadFromJsonAsync<TResponse>() ?? throw new Exception("Error: La deserialización devolvió un valor nulo.");
        }
        public async Task<TResponse> SpAPIAsync<TResponse>(string url, Dictionary<string, object> parametros)
        {
            var json = Newtonsoft.Json.JsonConvert.SerializeObject(parametros);

            using var contenido = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

            var response = await _httpClient.PostAsync(url, contenido);

            if (!response.IsSuccessStatusCode)
            {
                var error = await response.Content.ReadAsStringAsync();
                throw new Exception($"Error en la llamada a la API: {response.ReasonPhrase} | {error}");
            }

            var body = await response.Content.ReadAsStringAsync();
            return Newtonsoft.Json.JsonConvert.DeserializeObject<TResponse>(body)
                   ?? throw new Exception("Error: deserialización devolvió null.");
        }
    }
}

