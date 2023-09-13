using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListBorrowInMonthReq : IRequestType<UserGetType>
    {
        public string Month { get; set; }
        public int UserId { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
