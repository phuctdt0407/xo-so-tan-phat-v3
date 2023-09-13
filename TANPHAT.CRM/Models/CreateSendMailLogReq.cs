namespace TANPHAT.CRM.Models
{
    public class CreateSendMailLogReq
    {
        public string BodyContent { get; set; }
        public string Subject { get; set; }
        public string Sender { get; set; }
        public string Receiver { get; set; }
    }
}