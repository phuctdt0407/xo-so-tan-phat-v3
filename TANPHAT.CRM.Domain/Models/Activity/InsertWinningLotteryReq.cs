using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class InsertWinningLotteryReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int UserRoleId { get; set; }
        public int WinningTypeId { get; set; }
        public string LotteryNumber { get; set; }
        public int LotteryChannelId { get; set; }
        public int Quantity { get; set; }
        public decimal WinningPrice { get; set; }
        public int FromSalePointId { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
