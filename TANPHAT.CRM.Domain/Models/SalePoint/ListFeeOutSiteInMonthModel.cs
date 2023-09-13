using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListFeeOutSiteInMonthModel
	{
        public DateTime Date { get; set; }
        public int UserId { get; set; }
        public string FullName { get; set; }
        public int ShiftId { get; set; }
        public int ShiftDistributeId { get; set; }
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public string Data { get; set; }
        public int TotalPrice { get; set; }
    }
}
