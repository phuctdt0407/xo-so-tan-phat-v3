using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetDataSubAgencyModel
    {
        public int AgencyId { get; set; }
        public int SubAgencyId { get; set; }
        public string SubAgencyName { get; set; }
        public int LotteryChannelId { get; set; }
        public int TotalReceived { get; set; }
        public int TotalDupReceived { get; set; }
    }
}
