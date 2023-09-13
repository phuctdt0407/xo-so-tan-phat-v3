using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class ReportRemainingLotteryModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public string LotteryChannelName { get; set; }
        public DateTime LotteryDate { get; set; }
        public int TotalRemaining { get; set; }

    }
}
