using System;
namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class WinningListModel
	{
        public int WinningId { get; set; }
		public int WinningTypeId { get; set; }
		public string WinningTypeName { get; set; }
		public string LotteryNumber { get; set; }
		public int LotteryChannelId { get; set; }
		public string LotteryChannelName { get; set; }
		public int Quantity { get; set; }
		public decimal WinningPrice { get; set; }
		public string ActionBy { get; set; }
		public string ActionByName { get; set; }
		public DateTime ActionDate { get; set; }
		public int FromSalePointId { get; set; }
		public string FromSalePointName { get; set; }
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
	}
}
