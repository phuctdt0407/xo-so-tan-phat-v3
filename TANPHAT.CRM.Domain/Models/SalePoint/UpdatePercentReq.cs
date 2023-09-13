using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class UpdatePercentReq : BaseCreateUpdateReq, IRequestType<SalePointPostType>
    {
        public string Data { get; set; }
        public SalePointPostType TypeName { get; set; }
    }
}
