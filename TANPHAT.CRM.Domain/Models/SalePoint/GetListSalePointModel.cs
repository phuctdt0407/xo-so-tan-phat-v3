using System;
namespace TANPHAT.CRM.Domain.Models.SalePoint
{
	public class GetListSalePointModel
	{
		public int Id {get;set;}
		public string Name {get;set;}
		public bool IsActive {get;set;}
		public int ActionBy {get;set;}
		public string ActionByName {get;set;}
		public string FullAddress {get;set;}
		public string Note { get; set; }
		public string RentHomeFee {get;set;}
		public string WaterFee {get;set;}
	}
}
