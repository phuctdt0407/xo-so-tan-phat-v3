using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListLotteryAwardExpectedModel
    {
        public int SalePointId { get; set; }
	    public string SalePointName { get; set; }
        public string DataGroupType { get; set; }
        public decimal PriceLottery { get; set; }
        public decimal PriceLotteryDB { get; set; }
        public string DataWinning { get; set; }
    }
}
