using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User 
{
    public class ListEventDateReq : IRequestType<UserGetType>
    {
        public int Month { get; set; }
        public int Year { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
