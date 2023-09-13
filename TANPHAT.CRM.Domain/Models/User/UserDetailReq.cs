using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UserDetailReq : IRequestType<UserGetType>
    {
        public int UserId { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
