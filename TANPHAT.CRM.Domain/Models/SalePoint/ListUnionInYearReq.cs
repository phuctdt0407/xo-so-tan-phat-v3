using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListUnionInYearReq : IRequestType<SalePointGetType>
    {
        public int Year { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
