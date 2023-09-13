using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class DataInventoryInMonthOfAllSalePointReq : IRequestType<ReportGetType>
    {
        public string InventoryMonth { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
