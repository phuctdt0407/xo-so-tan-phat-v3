using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class GetListExemptKpiModel
    {
        public int ExemptKpiId { get; set; }
        public int UserId { get; set; }
        public int WeekId { get; set; }
        public string Month { get; set; }
        public bool IsSumKpi { get; set; }
    }
}
