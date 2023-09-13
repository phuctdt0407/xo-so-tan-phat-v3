using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Domain.Models.SalePoint;

namespace TANPHAT.CRM.Controllers.Api
{

    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class SalePointController : ControllerBase
    {
        private ISalePointClient _salePointClient;

        public SalePointController(ISalePointClient salePointClient)
        {
            _salePointClient = salePointClient;
        }

        [HttpGet("GetListSalePoint")]
        public async Task<object> GetListSalePoint(int? id)
        {
            var obj = new GetListSalePointReq
            {
                Id = id?? 0,
            };
            var res = await _salePointClient.GetListSalePoint(obj);
            return res;
        }

        [HttpPost("UpdateSalePoint")]
        public async Task<object> UpdateSalePoint(UpdateSalePointReq model)
        {
            var res = await _salePointClient.UpdateSalePoint(model);
            return res;
        }

        [HttpPost("UpdateItemInSalePoint")]
        public async Task<object> UpdateItemInSalePoint(UpdateItemInSalePointReq model)
        {
            var res = await _salePointClient.UpdateItemInSalePoint(model);
            return res;
        }
        [HttpGet("GetListFeeOutsite")]
        public async Task<object> GetListFeeOutsite(DateTime? date = null, int? shiftDistributeId = 0, int? salePointId = 0)
        {
            var obj = new GetListFeeOutsiteReq
            {
                SalePointId = salePointId ?? 0,
                Date = date ?? DateTime.Now,
                ShiftDistributeId = shiftDistributeId ?? 0,
            };
            var res = await _salePointClient.GetListFeeOutsite(obj);
            return res;
        }
        [HttpPost("UpdateFeeOutSite")]
        public async Task<object> UpdateFeeOutSite(UpdateFeeOutSiteReq model)
        {
            var res = await _salePointClient.UpdateFeeOutSite(model);
            return res;
        }
        [HttpPost("UpdateOrCreateGuest")]
        public async Task<object> UpdateOrCreateGuest(UpdateOrCreateGuestReq model)
        {
            var res = await _salePointClient.UpdateOrCreateGuest(model);
            return res;
        }
        
        [HttpGet("GetListItemConfirm")]
        public async Task<object> GetListItemConfirm(string month, int? salePointId = 0, int? confirmForTypeId=1)
        {
            var obj = new GetListItemConfirmReq
            {
                SalePointId = salePointId ?? null,
                Month = month ?? null,
                ConfirmForTypeId= confirmForTypeId?? null
            };
            var res = await _salePointClient.GetListItemConfirm(obj);
            return res;
        }

        [HttpGet("GetListConfirmPayment")]
        public async Task<object> GetListConfirmPayment(int? salePointId = 0, int? guestId = 0, int? ps = 100, int? p = 1)
        {
            var obj = new GetListConfirmPaymentReq
            {
                SalePointId = salePointId ?? null,
                GuestId = guestId ?? null,
                PageSize = ps ?? 100,
                PageNumber = p ?? 0
            };
            var res = await _salePointClient.GetListConfirmPayment(obj);
            return res;
        }

        [HttpPost("UpdateOrCreateGuestAction")]
        public async Task<object> UpdateOrCreateGuestAction(UpdateOrCreateGuestActionReq model)
        {
            var res = await _salePointClient.UpdateOrCreateGuestAction(model);
            return res;
        }

        [HttpPost("CreateListConfirmPayment")]
        public async Task<object> CreateListConfirmPayment(CreateListConfirmPaymentReq model)
        {
            var res = await _salePointClient.CreateListConfirmPayment(model);
            return res;
        }
        [HttpGet("GetListComission")]
        public async Task<object> GetListComission(string month)
        {
            var obj = new ListCommissionReq
            {
                Month = month 
            };
            var res = await _salePointClient.GetListComission(obj);
            return res;
        }

        [HttpPost("ConfirmListPayment")]
        public async Task<object> ConfirmListPayment(ConfirmListPaymentReq model)
        {
            var res = await _salePointClient.ConfirmListPayment(model);
            return res;
        }

        [HttpPost("UpdateCommission")]
        public async Task<object> UpdateCommission(UpdateCommissionReq model)
        {
            var res = await _salePointClient.UpdateCommission(model);
            return res;
        }

        [HttpPost("UpdateHistoryOrder")]
        public async Task<object> UpdateHistoryOrder(UpdateHistoryOrderReq model)
        {
            var res = await _salePointClient.UpdateHistoryOrder(model);
            return res;
        }

        [HttpGet("GetListHistoryOrder")]
        public async Task<object> GetListHistoryOrder(DateTime? date = null, int? salePointId = 0, int? shiftDistributeId = 0,int? p =1, int? ps=20)
        {
            var obj = new ListHistoryOrderReq
            {
                PageNumber = p ?? 1,
                PageSize = ps ?? 20,
                Date = date,
                SalePointId = salePointId,
                ShiftDistributeId = shiftDistributeId
            };
            var res = await _salePointClient.GetListHistoryOrder(obj);
            return res;
        }

        [HttpPost("InsertUpdateTransaction")]
        public async Task<object> InsertUpdateTransaction(InsertUpdateTransactionReq model)
        {
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("RewardForUser")]
        public async Task<object> RewardForUser(InsertUpdateTransactionReq model)
        {
            //Thưởng cho nhân viên
            model.TransactionTypeId = 7;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("OvertimeForUser")]
        public async Task<object> OvertimeForUser(InsertUpdateTransactionReq model)
        {
            //Tăng ca nhân viên
            model.TransactionTypeId = 6;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("PunishUser")]
        public async Task<object> PunishUser(InsertUpdateTransactionReq model)
        {
            //Phạt nhân viên
            model.TransactionTypeId = 4;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("SaleOfVietlott")]
        public async Task<object> SaleOfVietlott(InsertUpdateTransactionReq model)
        {
            //Doanh thu vietlott
            model.TransactionTypeId = 2;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("SaleOfLoto")]
        public async Task<object> SaleOfLoto(InsertUpdateTransactionReq model)
        {
            //Doanh thu loto
            model.TransactionTypeId = 3;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("AdvanceSalary")]
        public async Task<object> AdvanceSalary(InsertUpdateTransactionReq model)
        {
            //Ứng lương nhân viên
            model.TransactionTypeId = 5;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("DebtForUser")]
        public async Task<object> DebtForUser(InsertUpdateTransactionReq model)
        {
            //Nợ cho nhân viên
            model.TransactionTypeId = 8;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }
        

        [HttpPost("PayVietlott")]
        public async Task<object> PayVietlott(InsertUpdateTransactionReq model)
        {
            //Nạp tiền vietlott
            model.TransactionTypeId = 9;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("PayFundOfUser")]
        public async Task<object> PayFundOfUser(InsertUpdateTransactionReq model)
        {
            //Trả quỹ nhân viên
            model.TransactionTypeId = 11;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("UseUnion")]
        public async Task<object> UseUnion(InsertUpdateTransactionReq model)
        {
            //Trích quỹ công đoàn
            model.TransactionTypeId = 12;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpPost("SaleOfVietlottForCheck")]
        public async Task<object> SaleOfVietlottForCheck(InsertUpdateTransactionReq model)
        {
            //Doanh thu vietlott kiểm tra
            model.TransactionTypeId = 10;
            var res = await _salePointClient.InsertUpdateTransaction(model);
            return res;
        }

        [HttpGet("GetListUserByDateAndSalePoint")]
        public async Task<object> GetListUserByDateAndSalePoint(int salePointId,  DateTime date)
        {
            var obj = new ListUserByDateAndSalePointReq
            {
                Date = date,
                SalePointId = salePointId
            };
            var res = await _salePointClient.GetListUserByDateAndSalePoint(obj);
            return res;
        }

        [HttpGet("GetDataForGuestReturn")]
        public async Task<object> GetDataForGuestReturn(int guestId, DateTime date)
        {
            var obj = new DataForGuestReturnReq
            {
                Date = date,
                GuestId = guestId
            };
            var res = await _salePointClient.GetDataForGuestReturn(obj);
            return res;
        }

        [HttpGet("GetListGuestForConfirm")]
        public async Task<object> GetListGuestForConfirm(int? salePointId = 0)
        {
            var obj = new GuestForConfirmReq
            {
                SalePointId = salePointId ?? 0
            };
            var res = await _salePointClient.GetListGuestForConfirm(obj);
            return res;
        }

        [HttpGet("GetListFeeOfCommission")]
        public async Task<object> GetListFeeOfCommission(string month)
        {
            var obj = new FeeOfCommissionReq
            {
                Month = month
            };
            var res = await _salePointClient.GetListFeeOfCommission(obj);
            return res;
        }

        [HttpGet("GetListTransaction")]
        public async Task<object> GetListTransaction(string month, int? userId = 0, int? type = 1)
        {
            var obj = new TransactionReq
            {
                Month = month,
                UserId = userId ?? 0,
                Type = type ?? 1
            };
            var res = await _salePointClient.GetListTransaction(obj);
            return res;
        }

        [HttpGet("GetListPaymentForConfirm")]
        public async Task<object> GetListPaymentForConfirm(int? salePointId = 0, DateTime? date = null, int? ps = 100, int? p = 1)
        {
            var obj = new PaymentForConfirmReq
            {
                PageSize = ps ?? 100,
                PageNumber = p ?? 1,
                SalePointId = salePointId ?? 0,
                Date = date ?? null
            };
            var res = await _salePointClient.GetListPaymentForConfirm(obj);
            return res;
        }

        [HttpGet("GetListSalePointOfLeader")]
        public async Task<object> GetListSalePointOfLeader(int? userId = 0, DateTime? date = null)
        {
            var obj = new SalePointOfLeaderReq
            {
                UserId = userId ?? 0,
                Date = date ?? null
            };
            var res = await _salePointClient.GetListSalePointOfLeader(obj);
            return res;
        }

        [HttpPost("UpdateDateOffOfLeader")]
        public async Task<object> UpdateDateOffOfLeader(UpdateDateOffOfLeaderReq model)
        {
            var res = await _salePointClient.UpdateDateOffOfLeader(model);
            return res;
        }

        [HttpGet("GetListAttendentOfLeader")]
        public async Task<object> GetListAttendentOfLeader(DateTime? date = null)
        {
            var obj = new ListAttendentOfLeaderReq
            {
                Date = date ?? null
            };
            var res = await _salePointClient.GetListAttendentOfLeader(obj);
            return res;
        }

        [HttpPost("UpdateLeaderAttendent")]
        public async Task<object> UpdateLeaderAttendent(UpdateLeaderAttendentReq model)
        {
            var res = await _salePointClient.UpdateLeaderAttendent(model);
            return res;
        }

        [HttpGet("GetListSaleOfVietLottInDate")]
        public async Task<object> GetListSaleOfVietLottInDate(DateTime? date = null)
        {
            var obj = new ListSaleOfVietLottInDateReq
            {
                Date = date ?? null
            };
            var res = await _salePointClient.GetListSaleOfVietLottInDate(obj);
            return res;
        }

        [HttpGet("GetListSaleOfVietLottInMonth")]
        public async Task<object> GetListSaleOfVietLottInMonth(string month, int salePointId)
        {
            var obj = new ListSaleOfVietLottInMonthReq
            {
                Month = month,
                SalePointId = salePointId
            };
            var res = await _salePointClient.GetListSaleOfVietLottInMonth(obj);
            return res;
        }

        [HttpGet("GetListSaleOfLotoInMonth")]
        public async Task<object> GetListSaleOfLotoInMonth(string month, int transactionType, int? salePointId = 0)
        {
            var obj = new ListSaleOfLotoInMonthReq
            {
                Month = month,
                SalePointId = salePointId ?? 0,
                TransactionType = transactionType
                
            };
            var res = await _salePointClient.GetListSaleOfLotoInMonth(obj);
            return res;
        }

        [HttpGet("GetListFeeOutSiteInMonth")]
        public async Task<object> GetListFeeOutSiteInMonth(string month, int? userId = 0)
        {
            var obj = new ListFeeOutSiteInMonthReq
            {
                Month = month,
                UserId = userId ?? 0
            };
            var res = await _salePointClient.GetListFeeOutSiteInMonth(obj);
            return res;
        }

        [HttpGet("GetListUnionInYear")]
        public async Task<object> GetListUnionInYear(int year)
        {
            var obj = new ListUnionInYearReq
            {
                Year = year
            };
            var res = await _salePointClient.GetListUnionInYear(obj);
            return res;
        }

        [HttpGet("GetListHistoryOfGuest")]
        public async Task<object> GetListHistoryOfGuest(int guestId, int? ps = 100, int? p = 1)
        {
            var obj = new ListHistoryOfGuestReq
            {
                PageSize = ps ?? 100,
                PageNumber = p ?? 1,
                GuestId = guestId,
            };
            var res = await _salePointClient.GetListHistoryOfGuest(obj);
            return res;
        }

        [HttpGet("GetListPayVietlott")]
        public async Task<object> GetListPayVietlott(string month)
        {
            var obj = new ListPayVietlottReq
            {
                Month = month
            };
            var res = await _salePointClient.GetListPayVietlott(obj);
            return res;
        }

        [HttpGet("GetListSalePointPercent")]
        public async Task<object> GetListSalePointPercent(string month)
        {
            var obj = new ListSalePointPercentReq
            {
                Month = month
            };
            var res = await _salePointClient.GetListSalePointPercent(obj);
            return res;
        }

        [HttpPost("UpdatePercent")]
        public async Task<object> UpdatePercent(UpdatePercentReq model)
        {
            var res = await _salePointClient.UpdatePercent(model);
            return res;
        }

        [HttpGet("GetListLotteryAwardExpected")]
        public async Task<object> GetListLotteryAwardExpected(DateTime date, int? salePointId = 0)
        {
            var obj = new ListLotteryAwardExpectedReq
            {
                Date = date,
                SalePointId = salePointId ?? 0
            };
            var res = await _salePointClient.GetListLotteryAwardExpected(obj);
            return res;
        }
        [HttpGet("GetListOtherFees")]
        public async Task<object> GetListOtherFees(DateTime date, int salePointId)
        {
            var obj = new GetListOtherFeesReq
            {
                Date = date,
                SalePointId = salePointId
            };
            var res = await _salePointClient.GetListOtherFees(obj);
            return res;
        }
        [HttpGet("GetTotalCommisionAndFee")]
        public async Task<object> GetTotalCommisionAndFee(string date, int salePointId)
        {
            var obj = new GetTotalCommisionAndFeeReq
            {
                Date = date,
                SalePointId = salePointId
            };
            var res = await _salePointClient.GetTotalCommisionAndFee(obj);
            return res;
        }
        [HttpPost("UpdateCommisionAndFee")]
        public async Task<object> UpdateCommisionAndFee(UpdateCommisionAndFeeReq model)
        {
            var res = await _salePointClient.UpdateCommisionAndFee(model);
            return res;
        }
        [HttpPost("DeleteStaffInCommissionWining")]
        public async Task<object> DeleteStaffInCommissionWining(DeleteStaffInCommissionWiningReq model)
        {
            var res = await _salePointClient.DeleteStaffInCommissionWining(model);
            return res;
        }
        [HttpPost("CreateSubAgency")]
        public async Task<object> CreateSubAgency(CreateSubAgencyReq model)
        {
            var res = await _salePointClient.CreateSubAgency(model);
            return res;
        }
        [HttpGet("GetAllStaticFee")]
        public async Task<object> GetAllStaticFee()
        {
            var obj = new GetAllStaticFeeReq
            {
            };
            var res = await _salePointClient.GetAllStaticFee(obj);
            return res;
        }
    }
}
