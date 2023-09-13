using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListPayVietlottModel
    {
        public int SalePointId { get; set; }
	    public string SalePointName { get; set; }
        public decimal TotalPrice { get; set; }
        public string ListHistory { get; set; }
    }
}
