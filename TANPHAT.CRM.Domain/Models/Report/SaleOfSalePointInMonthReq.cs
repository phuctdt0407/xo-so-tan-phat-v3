using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class SaleOfSalePointInMonthReq : IRequestType<ReportGetType>
    {
        public string Month { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
