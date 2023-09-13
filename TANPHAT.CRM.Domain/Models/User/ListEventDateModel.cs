using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class ListEventDateModel
    {
        public DateTime Date {get; set; }
        public string DateName { get; set; }
        public int EventDayId { get; set; }
    }
}
