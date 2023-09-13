using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Auth.Enum;

namespace TANPHAT.CRM.Domain.Models.Auth
{
    public class ForgotPasswordReq : IRequestType<AuthPostType>
    {
        public string Email { get; set; }
        public string NewPassword { get; set; }
        public string SystemInfo { get; set; }
        public string Time { get; set; }
        public AuthPostType TypeName { get; set; }
    }
}
