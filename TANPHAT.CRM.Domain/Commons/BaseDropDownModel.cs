namespace TANPHAT.CRM.Domain.Commons
{
    public class BaseDropDownModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string NameEN { get; set; }
        public string Email { get; set; }
        public decimal WinningPrize { get; set; }
        public bool HasSalePoint { get; set; }
        public bool HasFourNumber { get; set; }
        public bool HasChannel { get; set; }
        public bool CanChangePrice { get; set; }
        public bool IsActive { get; set; }
    }
}
