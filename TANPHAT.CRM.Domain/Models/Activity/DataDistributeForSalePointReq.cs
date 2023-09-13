using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DataDistributeForSalePointReq : IRequestType<ActivityGetType>
    {
        public DateTime LotteryDate { get; set; }
        public ActivityGetType TypeName { get; set; }
    }
}
