using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetPayedDebtAndNewDebtAllTimeModel
    {
        public int UserId { get; set; }
        public string PayedDebtData { get; set; }
        public string DebtData { get; set; } 
    }
}
