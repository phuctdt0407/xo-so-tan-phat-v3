using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class AllShiftInMonthOfOneUserModel
	{
		public int UserId { get; set; }
		public DateTime DistributeDate{get; set; }
		public int SalePointId{get; set;}
		public string SalePointName{get; set;}
		public int ShiftId{get; set;}
		public string ShiftName { get; set;}
		public int ShiftTypeId{get; set;}
		public string ShiftTypeName { get; set;}
	}
}
