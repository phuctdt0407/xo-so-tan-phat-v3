using System;
namespace TANPHAT.CRM.Domain.Models.Report
{
    public class UserShiftReportModel
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
        public int? ShiftTypeId { get; set; }
        public string ShiftTypeName { get; set; }
        public int? SalePointId { get; set ; }
        public string SalePointName { get; set; }
        public int Quantity { get; set; }
        public int Sum { get; set; }
        public int MainSalePointId { get; set; }
    }
}
