    using BlazorApp1;
using BlazorApp1.Servicios;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");
string url = "http://localhost:5031";
builder.Services.AddScoped(sp => new HttpClient { BaseAddress = new Uri(url) });

builder.Services.AddScoped<ServiciosAutenticacion>();
builder.Services.AddScoped<AuthStateProvider>();
builder.Services.AddScoped<AuthenticationStateProvider>(provider =>
    provider.GetRequiredService<AuthStateProvider>());
builder.Services.AddAuthorizationCore();

builder.Services.AddScoped<ServiciosAPI>();
builder.Services.AddScoped<ServiciosUsuario>();
builder.Services.AddScoped<ServiciosTResponsable>();
builder.Services.AddScoped<ServiciosEstado>();
builder.Services.AddScoped<ServiciosTProyecto>();
builder.Services.AddScoped<ServiciosTProducto>();
builder.Services.AddScoped<ServiciosVariableEstrategica>();
builder.Services.AddScoped<ServiciosEntregable>();
builder.Services.AddScoped<ServiciosReponsable>();
builder.Services.AddScoped<ServiciosProyecto>();
builder.Services.AddScoped<ServiciosProductos>();
builder.Services.AddScoped<ServiciosProyecto_Productos>();
builder.Services.AddScoped<ServiciosProducto_entregable>();
builder.Services.AddScoped<ServiciosObjetivoEstrategico>();
builder.Services.AddScoped<ServiciosMetaEstrategica>();
builder.Services.AddScoped<ServiciosMetaProyecto>();
builder.Services.AddScoped<ServiciosEjecucionPresupuesto>();
builder.Services.AddScoped<ServiciosDistribucionPresupuesto>();
builder.Services.AddScoped<ServiciosActividad>();
builder.Services.AddScoped<ServiciosArchivo>();
builder.Services.AddScoped<ServiciosArchivoEntregable>();
builder.Services.AddScoped<ServiciosPresupuesto>();
builder.Services.AddScoped<ServiciosResponsableEntregable>();
await builder.Build().RunAsync();
