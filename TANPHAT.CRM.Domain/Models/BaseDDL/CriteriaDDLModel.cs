using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class CriteriaDDLModel
    {
        public int CriteriaId { get; set; }
        public string CriteriaName { get; set; }
        public decimal Coef { get; set; }
        public decimal MaxValue { get; set; }
        public int UserTitleId { get; set; }
    }
}
