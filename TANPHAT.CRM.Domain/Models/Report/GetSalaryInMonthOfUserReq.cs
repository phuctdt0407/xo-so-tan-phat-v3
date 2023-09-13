using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class GetSalaryInMonthOfUserReq : IRequestType<ReportGetType>
    {
        public int UserId { get; set; }
        public string Month { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
