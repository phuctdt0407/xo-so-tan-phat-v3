﻿using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class SubAgencyDDLReq : IRequestType<BaseDDLGetType>
    {
        public BaseDDLGetType TypeName { get; set; }
    }
}
