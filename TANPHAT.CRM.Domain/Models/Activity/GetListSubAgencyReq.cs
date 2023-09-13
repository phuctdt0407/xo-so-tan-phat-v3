using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetListSubAgencyReq : IRequestType<ActivityGetType>
    {
        public ActivityGetType TypeName { get; set; }
    }
}
