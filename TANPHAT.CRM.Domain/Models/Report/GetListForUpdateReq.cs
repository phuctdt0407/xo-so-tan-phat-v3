using System;
using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class GetListForUpdateReq : IRequestType<ReportGetType>
    {
        public int SalepointId { get; set; }
        public int ShiftId { get; set; }
        public DateTime Date { get; set; }
        public ReportGetType TypeName { get; set;}
    }
}
