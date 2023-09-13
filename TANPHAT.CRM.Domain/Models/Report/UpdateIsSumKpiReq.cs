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
    public class UpdateIsSumKpiReq : BaseCreateUpdateReq, IRequestType<ReportPostType>
    {
        public int UserId { get; set; }
        public int WeekId { get; set; }
        public string Month { get; set; }
        public bool IsDeleted { get; set; }
        
        public ReportPostType TypeName { get; set; }
    }
}
