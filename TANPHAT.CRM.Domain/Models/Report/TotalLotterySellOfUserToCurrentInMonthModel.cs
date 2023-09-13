
namespace TANPHAT.CRM.Domain.Models.Report
{
    public class TotalLotterySellOfUserToCurrentInMonthModel
    {
        public int UserId { get; set; }
        public string Fullname { get; set; }
        public int? SalePointId { get; set; }
        public string SalePointName { get; set; }
        public int? LotteryTypeId { get; set; }
        public string LotteryTypeName { get; set; }
        public string DateSell { get; set; }
        public int TotalLottery { get; set; }
    }
}
