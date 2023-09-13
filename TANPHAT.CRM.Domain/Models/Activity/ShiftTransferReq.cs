using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class ShiftTransferReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int UserRoleId { get; set; }
        public int ShiftDistributeId { get; set; }
        public string Data { get; set; }
       
        public ActivityPostType Money { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
