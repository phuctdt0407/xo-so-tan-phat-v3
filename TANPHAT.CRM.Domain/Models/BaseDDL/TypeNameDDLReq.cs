using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class TypeNameDDLReq : IRequestType<BaseDDLGetType>
    {
        public int TransactionTypeId { get; set; }
        public BaseDDLGetType TypeName { get; set; }
    }
}
