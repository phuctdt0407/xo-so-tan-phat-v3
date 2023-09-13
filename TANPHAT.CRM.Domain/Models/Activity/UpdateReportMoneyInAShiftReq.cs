using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity 
{
    public class UpdateReportMoneyInAShiftReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int ShiftDistributeId { get; set; }
        public DateTime Date { get; set; }
        public int Money { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
