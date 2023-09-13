using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListHistoryOrderModel
	{
        public int HistoryOfOrderId { get; set; }
		public int SalePointId { get; set; }
		public int PrintTimes { get; set; }
		public string ListPrint { get; set; }
		public string Data { get; set; }
		public int TotalCount { get; set; }
		public DateTime CreatedDate { get; set; }
	}
}
