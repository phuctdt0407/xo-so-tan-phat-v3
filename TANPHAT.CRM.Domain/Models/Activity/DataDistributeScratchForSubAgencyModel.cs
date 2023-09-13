using System;
namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DataDistributeScratchForSubAgencyModel
    {
        public int AgencyId { get; set; }
        public string SalePointName { get; set; }
        public int TotalReceived { get; set; }
        public int TotalRemaining { get; set; }
        public int LotteryChannelId { get; set; }
        public string LotteryChannelName{ get; set; }
        public string ShortName{ get; set; }
    }
}