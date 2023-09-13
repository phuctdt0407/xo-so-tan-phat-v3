using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using TANPHAT.CRM.Domain.Commons;


namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class UpdateLeaderAttendentReq : BaseCreateUpdateReq, IRequestType<SalePointPostType>
    {
        public string Data { get; set; }
        public SalePointPostType TypeName { get; set; }
    }
}
