﻿using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class InsertTransitionLogReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int ShiftDistributeId { get; set; }
        public int UserRoleId { get; set; }
        public string TransData { get; set; }
        public int TransTypeId { get; set; }
        public int ManagerId { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
