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
    public class InsertOrUpdateSubAgencyReq : BaseCreateUpdateReq, IRequestType<ActivityPostType>
    {
        public int AgencyId { get; set; }
        public double Price { get; set; }
        public string AgencyName { get; set; }
        public bool Activity { get; set; }
        public bool IsDeleted { get; set; }
        public ActivityPostType TypeName { get; set; }
    }
}
