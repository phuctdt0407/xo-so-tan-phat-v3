using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GuestForConfirmReq : IRequestType<SalePointGetType>
    {
        public int SalePointId { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
