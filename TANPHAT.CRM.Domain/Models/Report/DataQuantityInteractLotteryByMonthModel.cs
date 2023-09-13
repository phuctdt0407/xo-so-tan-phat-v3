using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class DataQuantityInteractLotteryByMonthModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
		public int LotteryTypeId{ get; set; }
		public string LotteryTypeName { get; set; }
		public DateTime DistributeDate{ get; set; }
		public int TotalReceived { get; set; }
		public int TotalReturns{ get; set; }
		public int TotalTrans { get; set; }
		public int TotalSold{ get; set; }
		public int TotalRemaining{ get; set; }
	}
}
