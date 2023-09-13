using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListBorrowForConfirmReq : BaseListReq, IRequestType<UserGetType>
    {
        public int UserId { get; set; }
        public DateTime Date { get; set; }
        public UserGetType TypeName { get; set; }
    }
}
