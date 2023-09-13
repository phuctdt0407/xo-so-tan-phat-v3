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
    public class UpdateIsdeletedSalepointLogReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int Count { get; set; }
        public int SalePointId { get; set; }
        public string Number { get; set; }
        public int LotteryChannelId { get; set; }
        public DateTime Day { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
