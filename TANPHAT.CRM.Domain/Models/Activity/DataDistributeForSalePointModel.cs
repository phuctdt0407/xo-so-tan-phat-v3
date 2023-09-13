namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DataDistributeForSalePointModel
    {
        public int AgencyId { get; set; }
	    public int SalePointId { get; set; }
        public int LotteryChannelId { get; set; }
        public int TotalReceived { get; set; }
        public int TotalDupReceived { get; set; }
    }
}
