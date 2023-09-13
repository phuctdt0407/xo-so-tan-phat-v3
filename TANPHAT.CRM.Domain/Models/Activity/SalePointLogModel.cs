using System;
namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class SalePointLogModel
	{
        public int SalePointId { get; set; }
		public DateTime LotteryDate { get; set; }
		public int LotteryChannelId { get; set; }
		public string LotteryChannelName { get; set; }
		public int TotalTrans { get; set; }
		public int TotalTransDup { get; set; }
		public int TotalTransScratch { get; set; }
		public int ActionBy { get; set; }
		public string ActionByName { get; set; }
		public DateTime ActionDate { get; set; }
		public int LotteryTypeId { get; set; }
		public string LotteryTypeName { get; set; }
		public decimal TotalValue { get; set; }
		public int TransitionId { get; set; }
		public int SalePointLogId { get; set; }
		public int TransitionTypeId { get; set; }
		public int FromSalePointId { get; set; }
		public int ToSalePointId { get; set; }
		public int ManagerId { get; set; }
		public string ManagerName { get; set; }
		public string PromotionCode { get; set; }
	}
}
