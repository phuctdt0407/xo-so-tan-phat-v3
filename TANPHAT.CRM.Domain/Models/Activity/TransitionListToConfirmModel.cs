using System;
using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class TransitionListToConfirmModel : BaseListModel
	{
		public DateTime TransitionDate { get; set; }
		public int ActionBy { get; set; }
		public string ActionByName { get; set; }
		public int TransitionTypeId { get; set; }
		public string TransitionTypeName { get; set; }
		public int FromSalePointId { get; set; }
		public string FromSalePointName { get; set; }
		public int ToSalePointId { get; set; }
		public string ToSalePointName { get; set; }
		public DateTime ConfirmDate { get; set; }
		public int ConfirmBy { get; set; }
		public string ConfirmByName { get; set; }
		public string TransData { get; set; }
		public int ManagerId { get; set; }
		public string ManagerName { get; set; }
		public int ConfirmStatusId { get; set; }
		public string ConfirmStatusName { get; set; }
	}
}
