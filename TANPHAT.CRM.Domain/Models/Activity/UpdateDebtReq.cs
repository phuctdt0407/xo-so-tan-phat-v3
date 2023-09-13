using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class UpdateDebtReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int UserId { get; set; }
        public decimal PayedDebt { get; set; }
        public string Month { get; set; }
        public int SalePointId { get; set; }
        public decimal TotalDebt { get; set; }
        public bool Flag { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
