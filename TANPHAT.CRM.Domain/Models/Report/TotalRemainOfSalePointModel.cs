using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalRemainOfSalePointModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public DateTime LotteryDate { get; set; }
        public int TotalRemaining { get; set; }
        public int TotalDupRemaining { get; set; }
    }
}
