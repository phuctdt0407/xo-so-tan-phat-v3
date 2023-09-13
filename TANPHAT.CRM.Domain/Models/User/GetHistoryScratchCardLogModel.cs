using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class GetHistoryScratchCardLogModel
    {
        public int ScratchcardLogId { get; set; }
        public string ActionByName { get; set; }
        public string ActionDate { get; set; }
        public string LotteryChannelName { get; set; }
        public string SalePointName { get; set; }
        public int TotalReceived { get; set; }
    }
}
