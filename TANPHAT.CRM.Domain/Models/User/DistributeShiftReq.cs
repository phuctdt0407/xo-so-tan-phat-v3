using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class DistributeShiftReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public int SalePointId { get; set; }
        public string DistributeData { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
