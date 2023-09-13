using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class GetShiftDistributeOfInternReq : IRequestType<UserGetType>
    {
        public string DistributeMonth { get; set; }
        public int SalePointId { get; set; }
        public bool IsActive { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
