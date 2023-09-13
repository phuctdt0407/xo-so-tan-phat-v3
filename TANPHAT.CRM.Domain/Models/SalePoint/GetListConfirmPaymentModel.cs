using System;
namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetListConfirmPaymentModel
	{
		public DateTime ActionDate { get; set; }
		public int ActionBy { get; set; }
		public string ActionByName { get; set; }
		public int GuestId { get; set; }
		public string GuestName { get; set; }
		public string DataConfirm { get; set; } 
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
		public bool CanBuyWholeSale { get; set; }
	}
}

