using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateShiftReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public DateTime DistributeDate { get; set; }
        public int SalePointId { get; set; }
        public int ShiftId { get; set; }
        public int UserId { get; set; }
        public int ShiftTypeId { get; set; }
        public string Note { get; set; }
        public UserPostType TypeName { get; set; }
    }
}
