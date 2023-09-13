using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class PaymentForConfirmModel
	{
        public string ArrayGuestActionId { get; set; }
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
		public int GuestId { get; set; }
		public string FullName { get; set; }
		public DateTime CreatedDate { get; set; }
		public string Note { get; set; }
		public decimal TotalPrice { get; set; }      
		public int GuestActionTypeId { get; set; }
		public string TypeName { get; set; }
		public string GuestInfo { get; set; }
		public bool DoneTransfer { get; set; }
	}
}
