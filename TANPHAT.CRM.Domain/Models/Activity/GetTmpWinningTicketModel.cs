using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetTmpWinningTicketModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public int Count { get; set; }
    }
}
