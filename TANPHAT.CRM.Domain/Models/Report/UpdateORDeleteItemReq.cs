using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class UpdateORDeleteItemReq : BaseCreateUpdateReq, IRequestType<ReportPostType>
    {
        public string Data { get; set; }
        public ReportPostType TypeName { get; set; }
    }
}
