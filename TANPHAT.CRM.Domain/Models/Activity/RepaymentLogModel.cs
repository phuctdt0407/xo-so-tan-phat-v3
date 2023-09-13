using System;
namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class RepaymentLogModel
	{
        public int GuestActionId { get; set; }
        public int GuestId { get; set; }
        public string FullName { get; set; }
        public decimal TotalPrice { get; set; }
        public string Note { get; set; }
        public int CreatedBy { get; set; }
        public string CreatedByName { get; set; }
        public DateTime CreatedDate { get; set; }
        public int SalePointId { get; set; }
        public string PaymentName { get; set; }
    }
}
