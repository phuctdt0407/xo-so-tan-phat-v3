using System;
namespace TANPHAT.CRM.Domain.Models.Report
{
    public class LogDistributeForSalepointModel
    {
            public DateTime LotteryDate {get;set;}
            public int LotteryChannelId {get;set;}
            public int TotalReceived {get;set;}
            public int TotalDupReceived {get;set;}
            public int SalePointId {get;set;}
            public DateTime ActionDate {get;set;}
            public string ShortName {get; set;} 
            public string SalePointName { get; set; }
    }
}
