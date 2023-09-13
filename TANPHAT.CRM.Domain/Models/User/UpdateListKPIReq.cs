using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateListKPIReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public int ActionType { get; set; }
        public string Data { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
