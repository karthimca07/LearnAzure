using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ShoppingApp.Pages;

public class IndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly IConfiguration _configuration;

    public IndexModel(ILogger<IndexModel> logger, IConfiguration configuration)
    {
        _logger = logger;
        _configuration = configuration;
    }

    public IActionResult OnGet()
    {
        ViewData["ApiBaseUrl"] = "https://fd-shopping-dev-endpoint-gmhfguacc8cqhebx.z01.azurefd.net"; // "https://app-shopping-api-dev.azurewebsites.net";//_configuration["ApiSettings:ApiBaseUrl"];
        
        _logger.LogInformation("API Base URL: {ApiBaseUrl}", ViewData["ApiBaseUrl"]);   
        Console.WriteLine("API Base URL: " + ViewData["ApiBaseUrl"]);
        return Page();
    }
}
