using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class LotteryPriceAgencyModel
	{
        public int AgencyId { get; set; }	
		public string AgencyName { get; set; }
		public int LotteryChannelId { get; set; }
		public string LotteryChannelName { get; set; }
		public int IsScratchcard { get; set; }
		public decimal Price { get; set; }
		public DateTime CreatedDate { get; set; }
	}
}
