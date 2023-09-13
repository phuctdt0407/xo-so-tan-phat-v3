using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class ItemDDLReq : IRequestType<BaseDDLGetType>
    {
        public int ItemId { get; set; }
        public BaseDDLGetType TypeName { get; set; }
    }
}
