﻿using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class DeleteLogWinningReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int WinningId { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
