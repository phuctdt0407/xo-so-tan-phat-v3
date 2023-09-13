using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalLotteryReturnOfAllSalePointInMonthModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public DateTime DateReturn { get; set; }
        public int TotalReturn { get; set; }
    }
}
