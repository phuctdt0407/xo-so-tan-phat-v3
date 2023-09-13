using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DistributeForSubAgencyReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public DateTime Date { get; set; }
        public string Data { get; set; }
        public bool Lock { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
