using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetListOtherFeesModel
    {
        public int TransactionId { get; set; }
        public string Note { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public decimal TotalPrice { get; set; }
        public int UserId { get; set; }
        public int ShiftDistributeId { get; set; }
        public int ShiftId { get; set; }
        public string SalePointName { get; set; }
        public DateTime ActionDate { get; set; }
        public int TypeNameId { get; set; }
        public string Name { get; set; }
        public int ActionBy { get; set; }
        public string ActionName { get; set; }  
    }
}
