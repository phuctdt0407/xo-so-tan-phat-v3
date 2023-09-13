using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Activity
{
    public class GetStaticFeeModel
    {
        public int SalePointId { get; set; }

        public string SalePointName { get; set; }

        public double ElectronicFee { get; set; }

        public double WaterFee { get; set; }

        public double InternetFee { get; set; }

        public double EstateFee { get; set; }
    }
}
