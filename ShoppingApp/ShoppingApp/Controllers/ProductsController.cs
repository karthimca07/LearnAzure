using Microsoft.AspNetCore.Mvc;
using ShoppingApp.Models;

namespace ShoppingApp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private static readonly List<Product> _products = new()
    {
        new Product { Id = 1, Name = "Laptop", Description = "High-performance laptop", Price = 999.99m, ImageUrl = "/images/laptop.jpg" },
        new Product { Id = 2, Name = "Smartphone", Description = "Latest smartphone", Price = 699.99m, ImageUrl = "/images/phone.jpg" },
        new Product { Id = 3, Name = "Headphones", Description = "Wireless noise-canceling headphones", Price = 199.99m, ImageUrl = "/images/headphones.jpg" }
    };

    [HttpGet]
    public ActionResult<IEnumerable<Product>> Get()
    {
        return Ok(_products);
    }
}
