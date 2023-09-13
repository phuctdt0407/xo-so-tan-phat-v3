    using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class GetShiftDistributeOfInternModel
    {
        public int ShiftDistributeId { get; set; }
        public DateTime DistributeDate { get; set; }
        public int SalePointId { get; set; }
        public int ShiftId { get; set; }
        public int? UserId { get; set; }
        public int ShiftTypeId { get; set; }
        public string ShiftTypeName { get; set; }
        public string Note { get; set; }
        public string ShiftMain { get; set; }
        public bool IsActive { get; set; }
    }
}
