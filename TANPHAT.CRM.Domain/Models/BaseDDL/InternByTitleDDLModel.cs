using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class InternByTitleDDLModel
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public Boolean IsIntern { get; set; }
    }
}
