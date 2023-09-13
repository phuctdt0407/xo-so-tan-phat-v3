using System;
using Microsoft.AspNetCore.Mvc.Filters;
using TANPHAT.CRM.Domain.Models.Auth;

namespace TANPHAT.CRM.Middleware
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class AuthorizeAttribute : Attribute, IAuthorizationFilter
    {
        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var account = (LoginRes)context.HttpContext.Items["Id"];
            if (account == null)
            {
                //context.Result = new JsonResult(new { message = "Unauthorized" }) { StatusCode = StatusCodes.Status401Unauthorized };
            }
        }
    }
}
