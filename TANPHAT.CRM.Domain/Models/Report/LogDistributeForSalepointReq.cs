using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class LogDistributeForSalepointReq : IRequestType<ReportGetType>
    {
        public DateTime Date { get; set; }
        public int SalePointId { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
