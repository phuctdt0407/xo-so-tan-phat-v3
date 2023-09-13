using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetTotalCommisionAndFeeModel
    {
        public int CommissionId { get; set; }
        public string User { get; set; }
        public int SalePointId { get; set; }
        public string SalePointName {  get; set; }
        public DateTime Date { get; set; }
        public int TotalCommision { get; set; }
        public int Fee { get; set; }
        public DateTime CreatedDate { get; set; }   
    }
}
