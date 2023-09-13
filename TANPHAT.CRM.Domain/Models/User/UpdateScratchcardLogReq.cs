using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateScratchcardLogReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public int ScratchcardLogId { get; set; }
        public int RevisionNumber { get; set; }
        public bool IsDeleted { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
