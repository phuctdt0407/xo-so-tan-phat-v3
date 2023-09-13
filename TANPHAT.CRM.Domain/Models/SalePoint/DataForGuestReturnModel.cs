using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class DataForGuestReturnModel
	{
        public int LotteryChannelId { get; set; }
		public bool IsScratchcard { get; set; }
		public string LotteryChannelName { get; set; }	
		public int TotalReceived { get; set; }
		public decimal TotalValueReceived { get; set; }
		public int TotalReturn { get; set; }
		public decimal TotalValueReturn { get; set; }
		public int TotalCanReturn { get; set; }
		public decimal TotalValueCanReturn { get; set; }
	}
}
