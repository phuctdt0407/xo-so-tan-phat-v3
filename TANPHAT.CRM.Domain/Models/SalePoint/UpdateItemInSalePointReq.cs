using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using TANPHAT.CRM.Domain.Commons;


namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class UpdateItemInSalePointReq : BaseCreateUpdateReq,  IRequestType<SalePointPostType>
    {
        public int TypeAction { get; set; }
        public string Data { get; set; }
        public int? ItemConfirmLogId { get; set; }
        public int? ConfirmTypeId { get; set; }
        public int? ConfirmFor { get; set; }
        public string DataInfo { get; set; }
        public int? GuestId { get; set; }
        public SalePointPostType TypeName { get; set; }
    }
}
