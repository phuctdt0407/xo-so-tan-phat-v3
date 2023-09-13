using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class SellLotteryReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int ShiftDistributeId { get; set; }
        public int UserRoleId { get; set; }
        public string Data { get; set; }
        public ActivityPostType TypeName { get; set; }
        public int? GuestId { get; set; } 
        public int? OrderId { get; set; }
    }
}
