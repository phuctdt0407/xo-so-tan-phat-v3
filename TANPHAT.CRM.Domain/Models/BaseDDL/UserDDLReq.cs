using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class UserDDLReq : IRequestType<BaseDDLGetType>
    {
        public int UserTitleId { get; set; }
        public DateTime Date { get; set; }
        public BaseDDLGetType TypeName { get; set; }
    }
}
