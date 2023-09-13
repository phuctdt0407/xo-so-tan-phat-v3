using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListSaleOfLotoInMonthModel
    {
        public DateTime Date { get; set; }
        public int SalePointId { get; set; }
        public decimal AllTotalPrice { get; set; }
        public string Data { get; set; }
    }
}
