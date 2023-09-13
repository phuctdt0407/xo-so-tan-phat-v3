using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class GetHistoryScratchCardFullLogModel
    {
        public int ScratchcardFullLogId { get; set; }
        public string AgencyName { get; set; }
        public string ActionByName { get; set; }
        public string ActionDate { get; set; }
        public int TotalReceive { get; set; }
        public string LotteryChannelName { get; set; }
    }
}
