using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalLotteryNotSellOfAllSalePointModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public int LotteryChannelId { get; set; }
        public string LotteryChannelName { get; set; }
        public int TotalRemaining { get; set; }
        public int TotalDupRemaining { get; set; }
        public string DataShift { get; set; }
    }
}
