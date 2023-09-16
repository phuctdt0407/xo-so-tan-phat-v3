using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class InternByTitleDDLModel
    {
        public int UserId { get; set; }
        public string Name { get; set; }

        public bool IsActive { get; set; }

        public bool IsIntern { get; set; }
    }
}
