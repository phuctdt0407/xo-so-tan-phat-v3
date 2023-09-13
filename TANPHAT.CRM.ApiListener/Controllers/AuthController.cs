using System.Threading.Tasks;
using KTHub.Core.Listener.Cotroller;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Business;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Auth;
using TANPHAT.CRM.Domain.Models.Auth.Enum;

namespace TANPHAT.CRM.ApiListener.Controllers
{
    [ApiExplorerSettings(IgnoreApi = false)]
    [Route(UrlCommon.T_Auth)]
    public class AuthController : BaseApiController
    {
        private IAuthBusiness _authBusiness;

        public AuthController(ConsumerConfigs consumerConfigs, IAuthBusiness authBusiness) : base(consumerConfigs)
        {
            _authBusiness = authBusiness;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var requestType = GetRequestType<AuthGetType>();
            switch (requestType)
            {
                case AuthGetType.GetUserPermission:
                    {
                        var reqModel = GetRequestData<UserPermissionReq>();
                        var result = await _authBusiness.GetUserPermission(reqModel);
                        return OkResult(result);
                    }
                case AuthGetType.GetFirstPageShow:
                    {
                        var reqModel = GetRequestData<GetFirstPgaeShowReq>();
                        var result = await _authBusiness.GetFirstPageShow(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }

        [HttpPost]
        public async Task<IActionResult> Post()
        {
            var requestType = GetRequestType<AuthPostType>();
            switch (requestType)
            {
                case AuthPostType.CheckLogin:
                    {
                        var reqModel = GetRequestData<CheckLoginReq>();
                        var result = await _authBusiness.CheckLogin(reqModel);
                        return OkResult(result);
                    }
                case AuthPostType.ForgotPassword:
                    {
                        var reqModel = GetRequestData<ForgotPasswordReq>();
                        var result = await _authBusiness.ForgotPassword(reqModel);
                        return OkResult(result);
                    }
                case AuthPostType.ChangePassword:
                    {
                        var reqModel = GetRequestData<ChangePasswordReq>();
                        var result = await _authBusiness.ChangePassword(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }
    }
}
