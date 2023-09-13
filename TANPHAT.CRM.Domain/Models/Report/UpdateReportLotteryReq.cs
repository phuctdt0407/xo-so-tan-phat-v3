using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class UpdateReportLotteryReq : IRequestType<ReportPostType>
    {
        public int ShiftId { get; set; }
        public int SalePointId { get; set; }
        public int LotteryChannelId { get; set; }
        public int LotteryTypeId { get; set; }
        public int ReportType { get; set; }
        public int Received { get; set; }
        public int Transfer { get; set; }
        public int SoldRetail { get; set; }
        public int SplitTickets { get; set; }
        public int LotteryDate { get; set; }
        public int SoldRetailMoney { get; set; }
        public int SoldWholeSale { get; set; }
        public int SoldWholeSaleMoney { get; set; }
        public ReportPostType TypeName { get; set; }
    }
}
