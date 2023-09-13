using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GuestForConfirmModel
	{
        public DateTime ActionDate { get; set; }
		public int ActionBy { get; set; }
		public string ActionByName { get; set; }
		public int ConfirmStatusId { get; set; }
		public string ConfirmStatusName { get; set; }
		public string DataConfirm { get; set; }
		public int SalePointId { get; set; }
		public string SalePointName { get; set; }
	}
}
