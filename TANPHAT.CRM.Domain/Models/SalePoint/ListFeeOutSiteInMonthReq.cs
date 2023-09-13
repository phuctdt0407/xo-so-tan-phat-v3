﻿using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListFeeOutSiteInMonthReq : IRequestType<SalePointGetType>
    {
        public string Month { get; set; }
        public int UserId { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
