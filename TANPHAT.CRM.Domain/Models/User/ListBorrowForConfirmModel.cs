using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListBorrowForConfirmModel
	{
        public int ConfirmLogId { get; set; }
		public DateTime ActionDate { get; set; }
		public int ActionBy { get; set; }
		public string ActionByName { get; set; }
		public int ConfirmStatusId { get; set; }
		public string ConfirmStatusName { get; set; }
		public string DataConfirm { get; set; }
		public int UserId { get; set; }
		public string FullName { get; set; }
		public string Note { get; set; }
	}
}
