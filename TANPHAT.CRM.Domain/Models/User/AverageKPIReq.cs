using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class AverageKPIReq : IRequestType<UserGetType>
    {
        public int UserId { get; set; }
        public string Month { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
