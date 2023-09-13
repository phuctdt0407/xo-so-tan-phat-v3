using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListSaleOfVietLottInDateModel
    {
        public int SalePointId { get; set; }
        public string SalePointName { get; set; }
        public string SalePointData { get; set; }
        public decimal RealData { get; set; }
        public bool IsEqual { get; set; }
    }
}
