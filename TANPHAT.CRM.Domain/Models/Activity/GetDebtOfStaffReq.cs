using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;


namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetDebtOfStaffReq : BaseCreateUpdateReq, IRequestType<ActivityGetType>
    {
        public int UserTitleId { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
