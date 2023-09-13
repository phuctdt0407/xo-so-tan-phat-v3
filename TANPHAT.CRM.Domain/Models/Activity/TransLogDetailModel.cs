using System;
namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class TransLogDetailModel
	{
        public int RowNumber { get; set; }
		public DateTime TransitionDate { get; set; }
		public int TransitionTypeId { get; set; }
		public string TransitionTypeName { get; set; }
		public int ManagerId { get; set; }
		public string ManagerName { get; set; }
		public int ConfirmStatusId { get; set; }
		public DateTime? ConfirmDate { get; set; }
		public string ConfirmStatusName { get; set; }
		public int FromSalePointId { get; set; }
		public string FromSalePointName { get; set; }
		public int ToSalePointId { get; set; }
		public string ToSalePointName { get; set; }
		public string DetailData { get; set; }
	}
}
