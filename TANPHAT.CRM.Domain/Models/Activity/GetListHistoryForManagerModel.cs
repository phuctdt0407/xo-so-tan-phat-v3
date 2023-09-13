using System;
namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetListHistoryForManagerModel
    {
        public int HistoryOfOrderId { get; set; }
        public int SalePointId { get; set; }
        public int PrintTimes { get; set; }
        public string ListPrint { get; set; }
        public string Data { get; set; }
        public DateTime CreatedDate { get; set; }


}
}
