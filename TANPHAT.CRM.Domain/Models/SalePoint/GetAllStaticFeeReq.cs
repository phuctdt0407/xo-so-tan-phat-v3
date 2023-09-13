using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetAllStaticFeeReq : IRequestType<SalePointGetType>
    {
        public SalePointGetType TypeName { get; set; }
    }
}
