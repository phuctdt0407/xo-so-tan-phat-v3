using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class ReportManagerOverallReq : IRequestType<ReportGetType>
    {
        public int UserRoleId { get; set; }
        public int SalePointId { get; set; }
        public DateTime LotteryDate { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
