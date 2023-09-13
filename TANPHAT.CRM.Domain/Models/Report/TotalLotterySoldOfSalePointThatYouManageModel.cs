using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalLotterySoldOfSalePointThatYouManageModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public int LotteryTypeId { get; set; }
        public string LotteryTypeName { get; set; }
        public DateTime ActionDate { get; set; }
        public int TotalSold { get; set; }
    }
}
