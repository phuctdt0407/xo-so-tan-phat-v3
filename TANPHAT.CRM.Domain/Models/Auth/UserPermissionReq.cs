using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Auth.Enum;

namespace TANPHAT.CRM.Domain.Models.Auth
{
    public class UserPermissionReq : IRequestType<AuthGetType>
    {
        public int UserRoleId { get; set; }
        public AuthGetType TypeName { get; set; }
    }
}
