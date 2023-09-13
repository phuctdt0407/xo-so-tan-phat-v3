using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListSalaryModel
    {
        public int UserId { get; set; }
	    public string FullName { get; set; }
        public int UserTitleId { get; set; }
        public string UserTitleName { get; set; }
        public string SalaryData { get; set; }
    }
}
