using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class LotteryChannelDDLModel : BaseDropDownModel
    {
        public string ShortName { get; set; }
        public string ChannelTypeShortName { get; set; }
        public bool IsScratchcard { get; set; }
        public string DayIds { get; set; }
    }
}
