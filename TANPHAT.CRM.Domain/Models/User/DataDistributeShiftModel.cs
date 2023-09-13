using System;
namespace TANPHAT.CRM.Domain.Models.User
{
    public class DataDistributeShiftModel
    {
        public bool IsIntern { get; set; }
        public DateTime DistributeDate { get; set; }
        public int SalePointId { get; set; }
        public int ShiftId { get; set; }
        public int? UserId { get; set; }
        public int ShiftTypeId { get; set; }
        public string ShiftTypeName { get; set; }
        public string Note { get; set; }
        public string ShiftMain { get; set; }
        public bool IsActive { get; set; }
        //public string DistributeData { get; set; }
        //public string AttendanceData { get; set; }
    }
}
