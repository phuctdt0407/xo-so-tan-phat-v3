using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListTargetReq : IRequestType<UserGetType>
    {
        public UserGetType TypeName { get; set; }
    }
}
