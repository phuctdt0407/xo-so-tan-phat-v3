using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class UpdatePriceForSubAgencyReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int AgencyId { get; set; }
        public double Price { get; set; }
        public DateTime Date { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
