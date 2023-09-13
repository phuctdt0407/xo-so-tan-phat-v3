using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class GetListTotalNumberOfTicketsOfEachManagerReq : IRequestType<ReportGetType>
    {
        public string Month { get; set; }
        public ReportGetType TypeName { get; set; }
    }
}
