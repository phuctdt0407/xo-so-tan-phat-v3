using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class ReportLotteryInADayReq : IRequestType<ReportGetType>
    {
        public int SalePointId { get; set; }
        
        public DateTime Date { get; set; }
        public int ShiftId { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
