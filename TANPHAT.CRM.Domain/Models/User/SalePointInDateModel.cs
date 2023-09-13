using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class SalePointInDateModel
    {
        public int ShiftDistributeId { get; set; }
	    public int ShiftId { get; set; }
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
    }
}
