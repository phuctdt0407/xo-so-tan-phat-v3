using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class UpdateLotteryPriceSubAgencyReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int ActionType { get; set; }
        public string Data { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
