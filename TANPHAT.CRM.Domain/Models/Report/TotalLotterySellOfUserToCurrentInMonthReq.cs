using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalLotterySellOfUserToCurrentInMonthReq : IRequestType<ReportGetType>
    {
        public string Month { get; set; }
        public int UserId { get; set; }
        public int LotteryTypeId { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
