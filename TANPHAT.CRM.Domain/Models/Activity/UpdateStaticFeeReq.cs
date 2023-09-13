using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class UpdateStaticFeeReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public string Data { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
