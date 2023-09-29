using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalLotterySellOfUserInMonth
    {
        public int UserId { get; set; }
        public string Fullname { get; set; }
        public int? SalePointId { get; set; }
        public string SalePointName { get; set; }
        public int? LotteryTypeId { get; set; }
        public string LotteryTypeName { get; set; }
        public int LotteryChannelId { get; set; }
        public int RegionId { get; set; }
        public string DateSell { get; set; }
        public int TotalLottery { get; set; }
    }
}
