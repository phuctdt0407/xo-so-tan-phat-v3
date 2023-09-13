﻿using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;
using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class GetListConfirmPaymentReq : BaseListReq, IRequestType<SalePointGetType>
    {
        public int? SalePointId { get; set; }
        public int? GuestId { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}

