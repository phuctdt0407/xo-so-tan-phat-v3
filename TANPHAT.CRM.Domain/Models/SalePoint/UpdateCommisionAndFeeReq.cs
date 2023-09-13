using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class UpdateCommisionAndFeeReq : BaseCreateUpdateReq, IRequestType<SalePointPostType>
    {
        public DateTime Date { get; set; }
        public int CommisionId { get; set; }
        public int Commision { get; set; }
        public int Fee { get; set; }
        public SalePointPostType TypeName { get; set; }
    }
}
