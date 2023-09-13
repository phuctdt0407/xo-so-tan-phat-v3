using System;
namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class SoldLogDetailModel
    {
        public int RowNumber { get; set; }
	    public DateTime ActionDate { get; set; }
        public int TotalQuantity { get; set; }
        public decimal TotalPrice { get; set; }
        public string DetailData { get; set; }
        public int TotalValues { get; set; }
    }
}
