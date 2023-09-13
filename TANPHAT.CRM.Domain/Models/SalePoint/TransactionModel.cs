using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class TransactionModel
	{
        public int TransactionId { get; set; }
		public int TransactionTypeId { get; set; }
		public string TransactionTypeName { get; set; }
		public string Note { get; set; }
		public bool IsSum { get; set; }
		public int Quantity { get; set; }
		public decimal Price { get; set; }
		public decimal TotalPrice { get; set; }
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
		public string TypeName { get; set; }
		public int ActionBy { get; set; }
		public string ActionByName { get; set; }
		public DateTime ActionDate { get; set; }
		public int ShiftDistributeId { get; set; }
		public int UserId { get; set; }
		public DateTime Date { get; set; }
	}
}
