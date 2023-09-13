using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListOffOfLeaderModel
	{
        public int UserId { get; set; }
        public string FullName { get; set; }
        public DateTime Date { get; set; }
        public string Note { get; set; }
        public int ActionBy { get; set; }
        public string ActionByName { get; set; }
        public DateTime ActionDate { get; set; }
    }
}
