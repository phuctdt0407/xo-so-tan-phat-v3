using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class InsertRepaymentReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int SalePointId { get; set; }
        public string CustomerName { get; set; }
        public string Note { get; set; }
        public int Amount { get; set; }
        public int UserRoleId { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
