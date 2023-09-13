using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetTmpWinningTicketReq : IRequestType<ActivityGetType>
    {
        public DateTime Day { get; set; }
        public string Number { get; set; }
        public int LotteryChannelId { get; set; }
        public int CountNumber { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
