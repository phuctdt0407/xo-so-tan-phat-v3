using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetListReportMoneyInADayReq : BaseListReq, IRequestType<ActivityGetType>
    {
        public DateTime Date { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
