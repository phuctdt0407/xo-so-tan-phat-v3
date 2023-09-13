namespace TANPHAT.CRM.Models
{
    public class UserSessionInfo
    {
        public int UserId { get; set; }
        public int UserRoleId { get; set; }
        public string Account { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public int UserTitleId { get; set; }
        public string SubUserTitle { get; set; }
        public string UserTitleName { get; set; }
        public bool IsSuperAdmin { get; set; }
        public bool IsManager { get; set; }
        public bool IsStaff { get; set; }
        public int SalePointId { get; set; }
        public int ShiftDistributeId { get; set; }
    }
}