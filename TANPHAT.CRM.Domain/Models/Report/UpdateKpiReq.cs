using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class UpdateKpiReq : BaseCreateUpdateReq, IRequestType<ReportPostType>
    {
        public string Note { get; set; }
        public string KPILogId { get; set; }
        public ReportPostType TypeName { get; set; }
    }
}
