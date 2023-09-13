using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class ShiftDistributeByDateReq : IRequestType<ActivityGetType>
    {
        public DateTime Date { get; set; }
        public int UserId { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
