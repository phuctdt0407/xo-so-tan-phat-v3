using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class DistributeShiftMonthReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public string Month { get; set; }
        public string DistributeData { get; set; }
        public string AttendanceData { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
