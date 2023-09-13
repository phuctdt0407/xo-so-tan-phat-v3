
using System;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class DataInventoryInDayOfAllSalePointModel
    {
        public int SalePointId {get; set;}
        public string SalePointName { get; set; }
        public DateTime LotteryDate { get; set; }
        public int TotalReceived { get; set; }
        public int TotalRemaining { get; set; }
        public int TotalDupReceived { get; set; }
        public int TotalDupRemaining { get; set; }
    }
}
