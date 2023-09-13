using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetListFeeOutsiteModel
	{
        public int TransactionId { get; set; }
        public string Note { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public decimal TotalPrice { get; set; }
        public int UserId { get; set; }
        public int ShiftDistributeId { get; set; }
        public int ShiftId { get; set; }
        public int SalePointId { get; set; }
        public DateTime ActionDate { get; set; }
        public int TypeNameId { get; set; }
        public string Name { get; set; }
    }
}
