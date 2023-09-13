using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetDataSubAgencyReq : IRequestType<ActivityGetType>
    {
        public DateTime Date { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
