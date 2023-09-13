using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class ReportRequestModel : IRequestType<ReportGetType>
    {
        public DateTime Date { get; set; }
        public string Month { get; set; }
        public int SalePoint { get; set; }
        public int UserRoleId { get; set; }
        public int ShiftDistributeId { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
