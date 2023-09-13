using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateListTargetnewReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public string Data { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
