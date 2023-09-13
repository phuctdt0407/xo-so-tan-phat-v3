using TANPHAT.CRM.Domain.Commons;
using System;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListUserModel : BaseListModel
	{
        public int UserId { get; set; }
		public string Account { get; set; }
		public string Phone { get; set; }
		public string FullName { get; set; }
		public string Email { get; set; }
		public bool IsActive { get; set; }
		public bool IsDeleted { get; set; }
		public DateTime? EndDate { get; set; }
		public DateTime? StartDate { get; set; }
		public int UserTitleId { get; set; }
		public string UserTitleName { get; set; }
		public int SalePointId { get; set; }
		public int BasicSalary { get; set; }
		public string Address { get; set; }
		public string BankAccount { get; set; }
		public string NumberIdentity { get; set; }
		public bool IsIntern { get; set; }
	}
}
