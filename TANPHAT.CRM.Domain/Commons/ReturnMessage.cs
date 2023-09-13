namespace TANPHAT.CRM.Domain.Commons
{
    public class ReturnMessage
    {
        public int Id { get; set; }
        public string Message { get; set; }
        public int? OrderId { get; set; }
        public string PromotionCode { get; set; }
    }
}
