namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DataReceivedFromAgencyModel
    {
        public int AgencyId { get; set; }
	    public int LotteryChannelId { get; set; }
	    public int TotalReceived { get; set; }
	    public int TotalRemaining { get; set; }
        public bool IsBlocked { get; set; }
    }
}