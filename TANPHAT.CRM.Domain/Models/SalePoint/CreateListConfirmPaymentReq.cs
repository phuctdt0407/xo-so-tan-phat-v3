using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class CreateListConfirmPaymentReq : BaseCreateUpdateReq, IRequestType<SalePointPostType>
    {
	    public int GuestId { get; set; }
        public string LotteryData { get; set; }
        public string LotteryDataInfo { get; set; }
        public string PaymentData { get; set; }
        public int? OrderId { get; set; }
        public SalePointPostType TypeName { get; set; }
    }
}

