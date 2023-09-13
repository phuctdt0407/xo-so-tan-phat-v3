using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListOffOfLeaderReq : IRequestType<UserGetType>
    {
        public string Month { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
