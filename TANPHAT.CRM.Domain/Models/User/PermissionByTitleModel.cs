namespace TANPHAT.CRM.Domain.Models.User
{
    public class PermissionByTitleModel
    {
		public int RoleId { get; set; }
		public string RoleName { get; set; }
		public int PermissionId { get; set; }
		public string PermissionName { get; set; }
		public string ControllerName { get; set; }
		public bool IsCheck { get; set; }
	}
}
