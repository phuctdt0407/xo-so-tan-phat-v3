using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateUserInfoReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public int UserId { get; set; }
        public string Data { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
