using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.BaseDDL
{
    public class ItemDDLModel
    {
        public int ItemId { get; set; }
	    public string ItemName { get; set; }
        public int UnitId { get; set; }
        public string UnitName { get; set; }
        public int Price { get; set; }
        public int Quotation { get; set; }
        public int TypeOfItemId { get; set; }
        public string TypeName { get; set; }
    }
}
