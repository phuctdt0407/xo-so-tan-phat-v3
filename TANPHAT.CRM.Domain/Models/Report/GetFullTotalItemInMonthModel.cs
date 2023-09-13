using System;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class GetFullTotalItemInMonthModel
    {
		public int ItemId { get; set; }
		public int SalePointId { get; set; }
		public double TotalReceive { get; set; }
		public double TotalRemaining { get; set; }
		public int Import { get; set; }
		public int Export { get; set; }
		public int Use { get; set; }
		public int ImportPrice { get; set; }
		public int ExportPrice { get; set; }
		public int UsePrice { get; set; }
		public int Quotation { get; set; }
		public string Note { get; set; }
		public int ActionBy { get; set; }
		public int TypeOfItemId { get; set; }
		public double AVGPrice { get; set; }
		public string ActionByName { get; set; }
		public DateTime ActionDate { get; set; }
	}
}
