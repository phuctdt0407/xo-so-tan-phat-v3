using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdatePermissionRoleReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public int UserTitleId { get; set; }
        public string ListRole { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
