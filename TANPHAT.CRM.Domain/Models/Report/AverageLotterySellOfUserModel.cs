﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class AverageLotterySellOfUserModel
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
        public Decimal Average { get; set; }
    }
}
