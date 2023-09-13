namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class ShiftDistributeByDateModel
	{
        public int ShiftDistributeId { get; set; }
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
		public int ShiftId { get; set; }
		public string ShiftName { get; set; }
		public string WorkingTime { get; set; }
		public int UserId { get; set; }
		public string FullName { get; set; }
		public int ShiftTypeId { get; set; }
		public string ShiftTypeName { get; set; }
		public bool CanClick { get; set; }
		public string Message { get; set; }
	}
}
