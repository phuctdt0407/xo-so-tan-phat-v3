using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Auth.Enum;

namespace TANPHAT.CRM.Domain.Models.Auth
{
    public class ChangePasswordReq : IRequestType<AuthPostType>
    {
        public int UserId { get; set; }
        public string CurrentPassword { get; set; }
        public string NewPassword { get; set; }
        public AuthPostType TypeName { get; set; }
    }
}
