using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetPayedDebtAndNewDebtAllTimeReq : IRequestType<ActivityGetType>
    {
        public int UserId { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
