using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class UpdateORDeleteSalePointLogReq : BaseCreateUpdateReq, IRequestType<ReportPostType>
    {
        public int DistributeId { get; set; }
        public int SalePointId { get; set; }
	    public string UpdateData { get; set; }
        public ReportPostType TypeName { get; set; }
    }
}
