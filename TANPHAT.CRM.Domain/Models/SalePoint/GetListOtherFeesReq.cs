using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetListOtherFeesReq : IRequestType<SalePointGetType>
    {
        public DateTime Date { get; set; }
        public int SalePointId { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
