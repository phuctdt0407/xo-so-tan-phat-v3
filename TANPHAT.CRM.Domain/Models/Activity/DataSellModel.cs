namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DataSellModel
    {
        public int ManagerId { get; set; }
        public string ManagerName { get; set; }
        public int UserId { get; set; }
        public int SalePointId { get; set; }
	    public string SalePointName { get; set; }
        public int ShiftDistributeId { get; set; }
        public bool Flag { get; set; }
        public string TodayData { get; set; }
        public string TomorrowData { get; set; }
        public string ScratchcardData { get; set; }
        public string SoldData { get; set; }
        public string SalePointAddress { get; set; }
    }
}
