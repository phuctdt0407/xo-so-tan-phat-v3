using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListComissionModel
	{
        public int UserId { get; set; }
		public string FullName { get; set; }
		public int UserTitleId { get; set; }
		public string UserTitleName { get; set; }
		public int SalePointId { get; set; }
		public int TotalCommision { get; set; }
		public DateTime Date { get; set; }
	}
}
