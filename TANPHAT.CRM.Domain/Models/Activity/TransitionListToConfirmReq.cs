using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class TransitionListToConfirmReq : BaseListReq, IRequestType<ActivityGetType>
    {
        public DateTime Date { get; set; }
        public int SalePointId { get; set; }
        public int TransitionTypeId { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
