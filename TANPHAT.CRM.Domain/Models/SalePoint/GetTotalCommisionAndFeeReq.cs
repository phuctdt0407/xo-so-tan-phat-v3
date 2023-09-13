using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetTotalCommisionAndFeeReq : IRequestType<SalePointGetType>
    {
        public string Date { get; set; }
        public int SalePointId { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
