namespace TANPHAT.CRM.Domain.Models.Report
{
    public class DataInventoryInMonthOfAllSalePointModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public int TotalReceived { get; set; }
        public int TotalRemaining { get; set; }
        public int TotalDupReceived { get; set; }
        public int TotalDupRemaining { get; set; }
    }
}
