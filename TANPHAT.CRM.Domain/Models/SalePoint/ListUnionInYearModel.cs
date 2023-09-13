using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListUnionInYearModel
	{
        public decimal PriceUnionFirst { get; set; }
		public decimal TotalUnionSend { get; set; }
		public decimal TotalUse { get; set; }
		public decimal TotalRemain { get; set; }
		public string UserData { get; set; }
		public string DataUse { get; set; }
	}
}
