using KTHub.Core.Client.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.Domain.Models.User
{
    public class UpdateTotalFirstReq : BaseCreateUpdateReq, IRequestType<UserPostType>
    {
        public int UserId { get; set; }
        public int TotalFirst { get; set; }
        public UserPostType TypeName { get; set; }
        public int Insure { get; set; }
    }
}
