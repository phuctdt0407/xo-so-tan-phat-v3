using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalRemainingOfAllSalePointInDateModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public int TotalRemainingTheNorth { get; set; }
        public int TotalRemainingTheCentral { get; set; }
        public int TotalRemainingTheSouth { get; set; }
    }
}
