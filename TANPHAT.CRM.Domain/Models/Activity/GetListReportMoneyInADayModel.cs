using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetListReportMoneyInADayModel
    {
        public int ReturnMoneyId { get; set; }
        public int ShiftDistributeId { get; set; }
        public int SalePointId { get; set; }
        public DateTime ActionDate { get; set; }
        public int ShiftId { get; set; }
        public Int64 TotalMoneyInADay { get; set; }
    }
}
