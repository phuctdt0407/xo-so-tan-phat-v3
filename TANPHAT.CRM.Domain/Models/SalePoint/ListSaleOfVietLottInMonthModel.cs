using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListSaleOfVietLottInMonthModel
    {
        public DateTime Date { get; set; }
        public int UserId { get; set; }
        public int ShiftId { get; set; }
        public string FullName { get; set; }
        public decimal TotalPrice { get; set; }
        public int SalePointId { get; set; }
        public int ShiftDistributeId { get; set; }
    }
}
