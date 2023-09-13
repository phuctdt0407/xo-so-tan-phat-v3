using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateListTargetReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
       // public int TargetTypeId { get; set; }
        public string Data { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
