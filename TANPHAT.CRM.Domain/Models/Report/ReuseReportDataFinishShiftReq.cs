using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class ReuseReportDataFinishShiftReq : IRequestType<ReportGetType>
    {
        public int UserRole { get; set; }
        public int ShiftDistributeId { get; set; }
        public DateTime  LotteryDate { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
