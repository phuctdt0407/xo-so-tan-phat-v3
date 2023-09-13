using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class UpdateActivityGuestActionReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public string ArrGuestActionId { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
