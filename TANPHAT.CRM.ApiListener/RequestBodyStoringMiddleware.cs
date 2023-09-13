using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace TANPHAT.CRM.ApiListener
{
    public class RequestBodyStoringMiddleware
    {
        private readonly RequestDelegate _next;

        public RequestBodyStoringMiddleware(RequestDelegate next) =>
            _next = next;

        public async Task Invoke(HttpContext httpContext)
        {
            httpContext.Request.EnableBuffering();
            string body;
            using (var streamReader = new System.IO.StreamReader(
                httpContext.Request.Body, System.Text.Encoding.UTF8, leaveOpen: true))
                body = await streamReader.ReadToEndAsync();

            httpContext.Request.Body.Position = 0;

            httpContext.Items["body"] = body;
            await _next(httpContext);
        }
    }
}
