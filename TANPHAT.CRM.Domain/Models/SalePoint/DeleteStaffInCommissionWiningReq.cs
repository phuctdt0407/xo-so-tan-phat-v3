using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class DeleteStaffInCommissionWiningReq : IRequestType<SalePointPostType>
    {
        public int CommissionId { get; set; }
        public SalePointPostType TypeName { get; set; }
    }
}
