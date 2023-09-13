using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListTargetModel
    {
        public string ResponsibilityLottery { get; set; }
	    public string TargetVietlott { get; set; }
        public string TargetLottery { get; set; }
        public string TargetKPI { get; set; }
        public string TargetKPILeader { get; set; }
    }
}
