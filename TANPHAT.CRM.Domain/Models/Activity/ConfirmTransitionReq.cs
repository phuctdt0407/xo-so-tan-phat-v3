using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class ConfirmTransitionReq : IRequestType<ActivityPostType>
    {
        public int UserRoleId { get; set; }
        public string Note { get; set; }
        public string Data { get; set; }
        public int TransitionTypeId { get; set; }
        public int SalePointId { get; set; }
        public bool IsConfirm { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
