using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class UpdateReturnMoneyReq : BaseCreateUpdateReq, IRequestType<ReportPostType>
    {
        public int ReturnMoneyId { get; set; }
        public int ReturnMoney { get; set; }
        public ReportPostType TypeName { get; set; }
    }
}
