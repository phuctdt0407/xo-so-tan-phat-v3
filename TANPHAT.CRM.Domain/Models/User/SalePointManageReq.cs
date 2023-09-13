using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class SalePointManageReq : IRequestType<UserGetType>
    {
        public DateTime Date { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
