using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
    public class ListHistoryOfGuestModel: BaseListModel
	{

		public int HistoryOfOrderId { get; set; }
		public int SalePointId { get; set; }
		public string Data { get; set; }
		public DateTime CreatedDate { get; set; }
	}
}
