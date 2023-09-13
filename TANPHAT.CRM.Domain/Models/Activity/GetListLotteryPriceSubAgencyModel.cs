using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetListLotteryPriceSubAgencyModel
    {
        public int AgencyId { get; set; }
        public string AgencyName { get; set; }
        public int LotteryChannelId { get; set; }
        public string LotteryChannelName { get; set; }
        public bool IsScratchcard { get; set; }
        public double Price { get; set; }
        public int LotteryPriceAgencyId { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
