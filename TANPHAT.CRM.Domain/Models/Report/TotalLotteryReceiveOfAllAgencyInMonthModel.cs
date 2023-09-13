using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalLotteryReceiveOfAllAgencyInMonthModel
    {
        public int AgencyId { get; set; }
        public string AgencyName { get; set; }
        public DateTime ActionDate { get; set; }
        public int TotalReceived { get; set; }
        public int TotalDupReceived { get; set; }
    }
}
