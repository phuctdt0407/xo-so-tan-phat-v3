using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class WinningListReq : IRequestType<ActivityGetType>
    {
        public int ShiftDistributeId { get; set; }
        public int SalePointId { get; set; }
        public DateTime Date { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
