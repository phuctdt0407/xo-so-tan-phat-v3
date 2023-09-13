using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class LotteryChannelDDLReq : IRequestType<BaseDDLGetType>
    {
        public int RegionId { get; set; }
        public DateTime? LotteryDate { get; set; }
        public BaseDDLGetType TypeName { get; set; }
    }
}
