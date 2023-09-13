using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class CreateSubAgencyReq : IRequestType<SalePointPostType>
    {
        public string SubAgencyName { get; set; }
        public float Price { get; set; }
        public SalePointPostType TypeName { get; set; }
    }
}
