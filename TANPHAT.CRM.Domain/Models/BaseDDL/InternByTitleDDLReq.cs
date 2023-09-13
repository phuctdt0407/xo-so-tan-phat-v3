using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class InternByTitleDDLReq : IRequestType<BaseDDLGetType>
    {
        public BaseDDLGetType TypeName { get; set; }
    }
}
