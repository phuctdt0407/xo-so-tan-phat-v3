using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class TypeNameDDLModel
    {
        public int TypeNameId { get; set; }
        public string Name { get; set; }
        public int TransactionTypeId { get; set; }
        public string TransactionTypeName { get; set; }
        public decimal Price { get; set; }
        public bool RequireSalePoint { get; set; }
    }
}
