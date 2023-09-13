using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class PermissionByTitleReq : IRequestType<UserGetType>
    {
        public int UserTitleId { get; set; }
        public UserGetType TypeName { get; set; }
    }
}