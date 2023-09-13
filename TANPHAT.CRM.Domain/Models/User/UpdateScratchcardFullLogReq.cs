using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateScratchcardFullLogReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public int ScratchcardFullLogId { get; set; }
        public int RevisionNumber { get; set; }
        public bool IsDeleted { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
