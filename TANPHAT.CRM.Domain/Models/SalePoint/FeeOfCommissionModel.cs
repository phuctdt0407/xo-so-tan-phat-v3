using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class FeeOfCommissionModel
	{
        public int SalePointId { get; set; }
		public DateTime Date { get; set; }
		public decimal TotalValue { get; set; }
		public decimal Fee { get; set; }
		public int ActionBy { get; set; }
		public string ActionByName { get; set; }
	}
}
