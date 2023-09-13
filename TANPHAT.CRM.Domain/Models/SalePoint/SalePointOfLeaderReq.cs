﻿using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class SalePointOfLeaderReq : IRequestType<SalePointGetType>
    {
        public int UserId { get; set; }
        public DateTime? Date { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
