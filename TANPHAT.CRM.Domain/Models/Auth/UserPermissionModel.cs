namespace TANPHAT.CRM.Domain.Models.Auth
{
    public class UserPermissionModel
    {
		public string RoleName { get; set; }
		public string RoleDisplayName { get; set; }
		public string ActionName { get; set; }
		public bool IsShowMenu { get; set; }
		public string PermissionName { get; set; }
		public string ControllerName { get; set; }
		public string CssIcon { get; set; }
		public bool IsSubMenu { get; set; }
		public int Sort { get; set; }
	}
}
