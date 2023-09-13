using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetListSalePointReq : IRequestType<SalePointGetType>
    {
        public int Id { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
