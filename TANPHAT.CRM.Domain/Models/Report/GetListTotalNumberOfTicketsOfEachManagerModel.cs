using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class GetListTotalNumberOfTicketsOfEachManagerModel
    {
        public string FullName { get; set; }
        public DateTime LotteryDate { get; set; }
        public int SalePointId { get; set; }
        public int TotalReceived { get; set; }
        public int ManagerId { get; set; }
    }
}
