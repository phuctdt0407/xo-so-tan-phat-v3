namespace TANPHAT.CRM.Domain.Commons
{
    public class BaseListReq
    {
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int QuitJob { get; set; }
        public string SearchText { get; set; }
        public int UserRoleId { get; set; }
     

    }
}
