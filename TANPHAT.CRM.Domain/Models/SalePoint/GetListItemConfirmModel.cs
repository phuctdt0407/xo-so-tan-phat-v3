using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TANPHAT.CRM.Domain.Models.SalePoint
{
	public class GetListItemConfirmModel
	{
		public int ItemConfirmLogId { get; set; }
		public string ConfirmForTypeName { get;set;}
		public string Data { get; set; }
		public int TypeActionId { get; set; }
		public string ItemTypeName { get; set; }
		public int ConfirmStatusId { get; set; }
		public string ConfirmStatusName { get; set; }
		public int RequestBy { get; set; }
		public string RequestByName { get; set; }
		public DateTime RequestDate { get; set; }
		public int ConfirmBy { get; set; }
		public string ConfirmByName { get; set; }
		public DateTime ConfirmDate { get; set; }
	}
}