using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class UserDDLModel
	{
        public int UserId { get; set; }
        public string Account { get; set; }
        public string Phone { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public bool IsActive { get; set; }
        public string IsDeleted { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int UserTitleId { get; set; }
        public string UserTitleName { get; set; }
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public string ListSalePoint { get; set; }
    }
}
