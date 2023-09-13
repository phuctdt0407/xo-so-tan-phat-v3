using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using KTHub.Core.DBConnection;
using Microsoft.Extensions.Configuration;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Auth;

namespace TANPHAT.CRM.Provider
{
    public interface IAuthProvider
    {
        Task<LoginRes> CheckLogin(CheckLoginReq req);

        Task<List<UserPermissionModel>> GetUserPermission(UserPermissionReq req);

        Task<GetFirstPageShowModel> GetFirstPageShow(GetFirstPgaeShowReq req);

        Task<ReturnMessage> ForgotPassword(ForgotPasswordReq req);

        Task<ReturnMessage> ChangePassword(ChangePasswordReq req);
    }

    public class AuthProvider : PostgreExecute, IAuthProvider
    {
        public AuthProvider(IConfiguration configuration) : base(configuration, DBCommon.TANPHATCRMConnStr)
        {
        }

        public  async Task<ReturnMessage> ChangePassword(ChangePasswordReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
                p_current_password = req.CurrentPassword,
                p_new_password = req.NewPassword
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_auth_change_password", obj)).FirstOrDefault();
            return res;
        }

        public async Task<LoginRes> CheckLogin(CheckLoginReq req)
        {
            var obj = new
            {
                p_account = req.Account,
                p_password = req.Password,
                p_mac_address = req.MACAddress,
                p_ip_address = req.IPAddress
            };
            var res = (await base.ExecStoredProcAsync<LoginRes>("crm_auth_checklogin", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> ForgotPassword(ForgotPasswordReq req)
        {
            var obj = new
            {
                p_email = req.Email,
                p_new_password = req.NewPassword
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_auth_forgot_password", obj)).FirstOrDefault();
            return res;
        }

        public async Task<GetFirstPageShowModel> GetFirstPageShow(GetFirstPgaeShowReq req)
        {
            var obj = new
            {
                p_user_role_id = req.UserRoleId
            };
            var res = (await base.ExecStoredProcAsync<GetFirstPageShowModel>("crm_permission_get_first_page_show", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<UserPermissionModel>> GetUserPermission(UserPermissionReq req)
        {
            var obj = new
            {
                p_user_role_id = req.UserRoleId
            };
            var res = await base.ExecStoredProcAsync<UserPermissionModel>("crm_auth_get_permission", obj);
            return res;
        }
    }
}