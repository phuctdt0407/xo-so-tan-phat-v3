using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using KTHub.Core.Security;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Auth;
using TANPHAT.CRM.Provider;

namespace TANPHAT.CRM.Business
{
    public interface IAuthBusiness
    {
        Task<LoginRes> CheckLogin(CheckLoginReq req);

        Task<List<UserPermissionModel>> GetUserPermission(UserPermissionReq req);

        Task<GetFirstPageShowModel> GetFirstPageShow(GetFirstPgaeShowReq req);

        Task<ReturnMessage> ForgotPassword(ForgotPasswordReq req);

        Task<ReturnMessage> ChangePassword(ChangePasswordReq req);
    }

    public class AuthBusiness : IAuthBusiness
    {
        private IAuthProvider _authProvider;
        const string chars = "abcdefghijklmNOPQRSTUVWXYZ0123456789";
        private Random random;

        public AuthBusiness(IAuthProvider authProvider)
        {
            _authProvider = authProvider;
            random = new Random();
        }

        public async Task<ReturnMessage> ChangePassword(ChangePasswordReq req)
        {
            req.CurrentPassword = KTHubCrytography.EncryptToString(req.CurrentPassword, KTHubCrytography.GetDefaultSaltKey());
            req.NewPassword = KTHubCrytography.EncryptToString(req.NewPassword, KTHubCrytography.GetDefaultSaltKey());
            var res = await _authProvider.ChangePassword(req);
            return res;
        }

        public async Task<LoginRes> CheckLogin(CheckLoginReq req)
        {
            req.Password = KTHubCrytography.EncryptToString(req.Password, KTHubCrytography.GetDefaultSaltKey());
            var res = await _authProvider.CheckLogin(req);
            return res;
        }

        public async Task<ReturnMessage> ForgotPassword(ForgotPasswordReq req)
        {
            var newPassword = new string(Enumerable.Repeat(chars, 8).Select(s => s[random.Next(s.Length)]).ToArray());
            req.NewPassword = KTHubCrytography.EncryptToString(newPassword, KTHubCrytography.GetDefaultSaltKey());
            var res = await _authProvider.ForgotPassword(req);
            if (res.Id > 0)
            {
                res.Message = newPassword;
            }
            return res;
        }

        public async Task<GetFirstPageShowModel> GetFirstPageShow(GetFirstPgaeShowReq req)
        {
            var res = await _authProvider.GetFirstPageShow(req);
            return res;
        }

        public async Task<List<UserPermissionModel>> GetUserPermission(UserPermissionReq req)
        {
            var res = await _authProvider.GetUserPermission(req);
            return res;
        }
    }
}
