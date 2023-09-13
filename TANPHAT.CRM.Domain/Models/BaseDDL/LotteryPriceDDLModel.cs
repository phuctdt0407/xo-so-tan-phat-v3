namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class LotteryPriceDDLModel
    {
        public int LotteryPriceId { get; set; }
	    public string LotteryPriceName { get; set; }
        public decimal Price { get; set; }
        public float Value { get; set; }
        public int Step { get; set; }
        public string LotteryTypeIds { get; set; }
    }
}