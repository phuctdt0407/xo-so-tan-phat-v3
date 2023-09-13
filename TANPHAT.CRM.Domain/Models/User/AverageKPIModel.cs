using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class AverageKPIModel
    {
        public int UserId { get; set; }
	    public int SalePointId { get; set; }
        public decimal KPI { get; set; }
        public int TotalWeek { get; set; }
        public decimal AverageKPI { get; set; }
        public string DataWeek { get; set; }
    }
}
