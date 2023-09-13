using KTHub.Core.Client.Models;
using System;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class DataInventoryInDayOfAllSalePointReq : IRequestType<ReportGetType>
    {
        public string Month { get; set; }
        public int SalePointId { get; set; }
        public ReportGetType TypeName { get; set; }

    }
}
