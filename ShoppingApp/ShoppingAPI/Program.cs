using ShoppingAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();
builder.Services.AddCors();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseCors(builder => builder
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader());

// Mock product data
var products = new[]
{
    new Product 
    { 
        Id = 1, 
        Name = "Smart LED TV", 
        Description = "55-inch 4K Ultra HD Smart LED TV with HDR", 
        Price = 699.99m,
        Category = "Electronics",
        ImageUrl = "/images/tv.jpg"
    },
    new Product 
    { 
        Id = 2, 
        Name = "Robot Vacuum Cleaner", 
        Description = "Smart robot vacuum with mapping technology and WiFi connectivity", 
        Price = 299.99m,
        Category = "Appliances",
        ImageUrl = "/images/vacuum.jpg"
    },
    new Product 
    { 
        Id = 3, 
        Name = "Coffee Maker", 
        Description = "Programmable coffee maker with 12-cup capacity", 
        Price = 79.99m,
        Category = "Kitchen",
        ImageUrl = "/images/coffee-maker.jpg"
    },
    new Product 
    { 
        Id = 4, 
        Name = "Air Purifier", 
        Description = "HEPA air purifier with smart sensors and quiet operation", 
        Price = 199.99m,
        Category = "Appliances",
        ImageUrl = "/images/air-purifier.jpg"
    },
    new Product 
    { 
        Id = 5, 
        Name = "Smart Speaker", 
        Description = "Voice-controlled smart speaker with premium sound", 
        Price = 129.99m,
        Category = "Electronics",
        ImageUrl = "/images/speaker.jpg"
    }
};

app.MapGet("/api/products", () =>
{
    return Results.Ok(products);
})
.WithName("GetProducts")
.WithOpenApi();

app.Run();
