using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListKPIOfUserModel
	{
        public int KPILogId { get; set; }
		public int UserId { get; set; }
		public string FullName { get; set; }
		public int UserTitleId { get; set; }
		public int WeekId { get; set; }
		public int CriteriaId { get; set; }
		public string CriteriaName { get; set; }
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
		public int KPI { get; set; }
		public DateTime CreatedDate { get; set; }
	}
}
