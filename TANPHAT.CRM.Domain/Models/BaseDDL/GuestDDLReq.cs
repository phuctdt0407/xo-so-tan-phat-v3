using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class GuestDDLReq : IRequestType<BaseDDLGetType>
    {
        public int SalePointId { get; set; }
        public int GuestId { get; set; }
        public BaseDDLGetType TypeName { get; set; }
    }
}
