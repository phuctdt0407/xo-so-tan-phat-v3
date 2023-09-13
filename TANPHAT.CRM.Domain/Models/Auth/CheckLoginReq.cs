using System.ComponentModel.DataAnnotations;
using TANPHAT.CRM.Domain.Models.Auth.Enum;
using KTHub.Core.Client.Models;

namespace TANPHAT.CRM.Domain.Models.Auth
{
    public class CheckLoginReq : IRequestType<AuthPostType>
    {
        [Required]
        public string Account { get; set; }
        [Required]
        public string Password { get; set; } 
        public string MACAddress { get; set; } 
        public string IPAddress { get; set; }
        public AuthPostType TypeName { get; set; }
    }
}
