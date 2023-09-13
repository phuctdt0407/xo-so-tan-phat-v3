using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListUserByDateAndSalePointModel
    {
        public int ShiftDistributeId { get; set; }
        public int UserId { get; set; }
        public string FullName { get; set; }
        public int ShiftId { get; set; }
    }
}
