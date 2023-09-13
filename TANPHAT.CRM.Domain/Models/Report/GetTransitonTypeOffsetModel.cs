using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.Report
{
    public class GetTransitonTypeOffsetModel
    {
        public int ChannelGroup { get; set; }
        public string SalePointName { get; set; }
        public int SalePointId { get; set; }
        public DateTime TransitionDate { get; set; }
        public int TransferTicket { get; set; }
        public int TicketsReceived { get; set; }
        public int Offset { get; set; }
    }
}
