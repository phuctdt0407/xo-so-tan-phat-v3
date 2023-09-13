using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class ReportWinningTypeDDLModel
    {
        public int WinningTypeId { get; set; }
        public string WinningTypeName { get; set; }
        public decimal WinningPrize { get; set; }
    }
}
