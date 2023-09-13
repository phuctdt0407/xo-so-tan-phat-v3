using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.Domain.Models.Auth
{
    public class LoginRes : ReturnMessage
    {
        public string Token { get; set; }
    }
}
