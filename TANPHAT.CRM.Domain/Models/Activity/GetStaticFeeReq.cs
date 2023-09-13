using KTHub.Core.Client.Models;
using System;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetStaticFeeReq : IRequestType<ActivityGetType>
    {
        public DateTime Month { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
