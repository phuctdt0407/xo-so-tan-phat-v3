namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DataScratchcardFromAgency
    {
        public int AgencyId { get; set; }
	    public int TotalReceived { get; set; }
        public int LotteryChannelId { get; set; }
        public string LotteryChannelName { get; set; }
        public string ShortName { get; set; }
        public int LastActionBy { get; set; }
        public string LastActionByName { get; set; }
    }
}
