using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class DeleteShiftTransferReq : BaseCreateUpdateReq, IRequestType<ReportPostType>
    {
        public int ShiftDistributeId { get; set; }
        public ReportPostType TypeName { get; set; }
    }
}
