﻿using KTHub.Core.Client.Models;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;
using System;
using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListHistoryOrderReq : BaseListReq, IRequestType<SalePointGetType>
    {
        public DateTime? Date { get; set; }
        public int? SalePointId { get; set; }
        public int? ShiftDistributeId { get; set; }
        public SalePointGetType TypeName { get; set; }
    }
}
