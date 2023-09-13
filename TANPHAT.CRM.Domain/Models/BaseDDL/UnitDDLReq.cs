using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class UnitDDLReq : IRequestType<BaseDDLGetType>
    {
        public int UnitId { get; set; }
        public BaseDDLGetType TypeName { get; set; }
    }
}
