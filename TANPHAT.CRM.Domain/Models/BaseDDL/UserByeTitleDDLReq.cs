using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class UserByeTitleDDLReq : IRequestType<BaseDDLGetType>
    {
        public int UserTitleId { get; set; }
        public bool? IsGetFull { get; set; }
        public BaseDDLGetType TypeName { get; set; }
    }
}
