using HowToAKS.Web.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace HowToAKS.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> Test()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var request = new HttpRequestMessage
                    {
                        RequestUri = new Uri("http://myapp-howtoaks-api.howtoaks:8081/weatherforecast") // When deploying in the default namespace, then you only use the container/pod name in the dns.
                        // RequestUri = new Uri("http://howtoaks-webapi.back-end:8081/api/values") // When deploying in custom namespaces, then you must include the namespace in the dns.
                    };

                    var response = await client.SendAsync(request);
                    ViewBag.Result = await response.Content.ReadAsStringAsync();
                }
            }
            catch (Exception ex)
            {
                ViewBag.Result = ex;
            }

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
