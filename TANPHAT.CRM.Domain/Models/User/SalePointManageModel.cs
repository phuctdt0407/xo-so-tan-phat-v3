namespace TANPHAT.CRM.Domain.Models.User
{
    public class SalePointManageModel
	{
        public int RowNumber { get; set; }
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
		public int ShiftId { get; set; }
		public int UserId { get; set; }
		public string FullName { get; set; }
		public int ManagerId { get; set; }
		public string ManagerName { get; set; }
	}
}
