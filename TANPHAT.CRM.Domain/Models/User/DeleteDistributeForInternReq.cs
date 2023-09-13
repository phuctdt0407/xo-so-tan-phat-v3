using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class DeleteDistributeForInternReq : IRequestType<UserPostType>
    {
        public int ShiftDistributeId { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
