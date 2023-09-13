using System.Collections.Generic;
using System.Threading.Tasks;
using KTHub.Core.Client;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Auth;
using TANPHAT.CRM.Domain.Models.Auth.Enum;

namespace TANPHAT.CRM.Client
{
    public interface IAuthClient
    {
        Task<ApiResponse<LoginRes>> CheckLogin(CheckLoginReq req);

        Task<ApiResponse<List<UserPermissionModel>>> GetUserPermission(UserPermissionReq req);

        Task<ApiResponse<GetFirstPageShowModel>> GetFirstPageShow(GetFirstPgaeShowReq req);

        Task<ApiResponse<ReturnMessage>> ForgotPassword(ForgotPasswordReq req);

        Task<ApiResponse<ReturnMessage>> ChangePassword(ChangePasswordReq req);
    }

    public class AuthClient : BaseApiClient, IAuthClient
    {
        private string urlSend { get; set; }

        public AuthClient(ApiConfigs configs) : base(configs)
        {
            urlSend = base.GetUrlSend(UrlCommon.T_Auth);
        }

        public async Task<ApiResponse<LoginRes>> CheckLogin(CheckLoginReq req)
        {
            return await PostAsync<LoginRes, CheckLoginReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<UserPermissionModel>>> GetUserPermission(UserPermissionReq req)
        {
            req.TypeName = AuthGetType.GetUserPermission;
            return await GetAsync<List<UserPermissionModel>, UserPermissionReq>(urlSend, req);
        }

        public async Task<ApiResponse<GetFirstPageShowModel>> GetFirstPageShow(GetFirstPgaeShowReq req)
        {
            req.TypeName = AuthGetType.GetFirstPageShow;
            return await GetAsync<GetFirstPageShowModel, GetFirstPgaeShowReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ForgotPassword(ForgotPasswordReq req)
        {
            req.TypeName = AuthPostType.ForgotPassword;
            return await PostAsync<ReturnMessage, ForgotPasswordReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ChangePassword(ChangePasswordReq req)
        {
            req.TypeName = AuthPostType.ChangePassword;
            return await PostAsync<ReturnMessage, ChangePasswordReq>(urlSend, req);
        }
    }
}
