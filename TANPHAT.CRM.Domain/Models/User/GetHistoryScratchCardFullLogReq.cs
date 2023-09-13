using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class GetHistoryScratchCardFullLogReq : IRequestType<UserGetType>
    {
        public int PageSize { get; set; }
        public int PageNumber { get; set; }
        public string Date { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
