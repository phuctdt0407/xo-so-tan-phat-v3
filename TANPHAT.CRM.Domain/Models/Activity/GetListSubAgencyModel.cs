using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetListSubAgencyModel
    {
        public int AgencyId { get; set; }
        public string AgencyName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDelete { get; set; }
        public double Price { get; set; }
    }
}
