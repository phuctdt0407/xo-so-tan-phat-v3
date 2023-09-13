using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class GuestDDLModel
	{
        public int GuestId { get; set; }
		public string FullName { get; set; }
		public string Phone { get; set; }
		public int SalePointId { get; set; }
		public int WholesalePriceId { get; set; }
		public decimal WholesalePrice { get; set; }
		public int ScratchPriceId { get; set; }
		public decimal ScratchPrice { get; set; }
		public decimal Debt { get; set; }
		public bool CanBuyWholesale { get; set; }
	}
}
