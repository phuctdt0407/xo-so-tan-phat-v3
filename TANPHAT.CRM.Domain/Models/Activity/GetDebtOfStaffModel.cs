using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetDebtOfStaffModel
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
        public int TotalDebt { get; set; }
        public int PayedDebt { get; set; }
        public int UserTitleId { get; set; }
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
    }
}
