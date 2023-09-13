using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DistributeScratchForSalePointReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public string ReceiveData { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
