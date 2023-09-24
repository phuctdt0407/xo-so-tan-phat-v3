using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Domain.Models.Activity;

namespace TANPHAT.CRM.Controllers.Api
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ActivityController : ControllerBase
    {
        private IActivityClient _activityClient;

        public ActivityController(IActivityClient activityClient)
        {
            _activityClient = activityClient;
        }

        [HttpPost("ReceiveLotteryFromAgency")]
        public async Task<object> ReceiveLotteryFromAgency(ReceivedLotteryFromAgencyReq model)
        {
            var res = await _activityClient.ReceiveLotteryFromAgency(model);
            return res;
        }
        [HttpPost("UpdateActivityGuestAction")]
        public async Task<object> UpdateActivityGuestAction(UpdateActivityGuestActionReq model)
        {
            var res = await _activityClient.UpdateActivityGuestAction(model);
            return res;
        }
        [HttpGet("GetDataReceivedFromAgency")]
        public async Task<object> GetDataReceivedFromAgency(DateTime lotteryDate)
        {
            var obj = new DataReceivedFromAgencyReq
            {
                LotteryDate = lotteryDate
            };
            var res = await _activityClient.GetDataReceivedFromAgency(obj);
            return res;
        }

        [HttpPost("DistributeForSalesPoint")]
        public async Task<object> DistributeForSalesPoint(DistributeForSalePointReq model)
        {
            var res = await _activityClient.DistributeForSalesPoint(model);
            return res;
        }

       [HttpGet("GetDataDistributeForSalePoint")]
        public async Task<object> GetDataDistributeForSalePoint(DateTime lotteryDate)
        {
            var obj = new DataDistributeForSalePointReq
            {
                LotteryDate = lotteryDate
            };
            var res = await _activityClient.GetDataDistributeForSalePoint(obj);
            return res;
        }

        [HttpPost("SellLottery")]
        public async Task<object> SellLottery(SellLotteryReq model)
        {
            var res = await _activityClient.SellLottery(model);
            return res;
        }
        [HttpPost("InsertOrUpdateAgency")]
        public async Task<object> InsertOrUpdateAgency(InsertOrUpdateAgencyReq model)
        {
            var res = await _activityClient.InsertOrUpdateAgency(model);
            return res;
        }
        [HttpPost("InsertOrUpdateSubAgency")]
        public async Task<object> InsertOrUpdateSubAgency(InsertOrUpdateSubAgencyReq model)
        {
            var res = await _activityClient.InsertOrUpdateSubAgency(model);
            return res;
        }

        [HttpGet("GetDataSell")]
        public async Task<object> GetDataSell(int shiftDistributeId, int userRoleId, DateTime date)
        {
            var obj = new DataSellReq
            {
                ShiftDistributeId = shiftDistributeId,
                UserRoleId = userRoleId,
                Date = date
            };
            var res = await _activityClient.GetDataSell(obj);
            return res;
        }
        [HttpGet("GetListSubAgency")]
        public async Task<object> GetListSubAgency()
        {
            var obj = new GetListSubAgencyReq
            {
            };
            var res = await _activityClient.GetListSubAgency(obj);
            return res;
        }
        [HttpGet("GetListLotteryPriceSubAgency")]
        public async Task<object> GetListLotteryPriceSubAgency(DateTime? date = null)
        {
            var obj = new GetListLotteryPriceSubAgencyReq
            {
                Date = date ?? null
            };
            var res = await _activityClient.GetListLotteryPriceSubAgency(obj);
            return res;
        }
        


        [HttpPost("InsertTransitionLog")]
        public async Task<object> InsertTransitionLog(InsertTransitionLogReq model)
        {
            var res = await _activityClient.InsertTransitionLog(model);
            return res;
        }

        [HttpGet("GetSalePointLog")]
        public async Task<object> GetSalePointLog(int shiftDistributeId, int salePointId, DateTime date)
        {
            var obj = new SalePointLogReq
            {
                ShiftDistributeId = shiftDistributeId,
                SalePointId = salePointId,
                Date = date
            };
            var res = await _activityClient.GetSalePointLog(obj);
            return res;
        }

        [HttpPost("InsertRepayment")]
        public async Task<object> InsertRepayment(InsertRepaymentReq model)
        {
            var res = await _activityClient.InsertRepayment(model);
            return res;
        }

        [HttpGet("GetDataInventory")]
        public async Task<object> GetDataInventory(DateTime date)
        {
            var obj = new DataSellReq
            {
                Date = date
            };
            var res = await _activityClient.GetDataInventory(obj);
            return res;
        }

        [HttpGet("GetRepaymentLog")]
        public async Task<object> GetRepaymentLog(int userRoleId, int salePointId, DateTime date)
        {
            var obj = new SalePointLogReq
            {
                UserRoleId = userRoleId,
                SalePointId = salePointId,
                Date = date
            };
            var res = await _activityClient.GetRepaymentLog(obj);
            return res;
        }

        [HttpGet("GetInventoryLog")]
        public async Task<object> GetInventoryLog(DateTime date)
        {
            var obj = new DataSellReq
            {
                Date = date
            };
            var res = await _activityClient.GetInventoryLog(obj);
            return res;
        }

        [HttpPost("InsertWinningLottery")]
        public async Task<object> InsertWinningLottery(InsertWinningLotteryReq model)
        {
            var res = await _activityClient.InsertWinningLottery(model);
            return res;
        }

        [HttpPost("ShiftTransfer")]
        public async Task<object> ShiftTransfer(ShiftTransferReq model)
        {
            var res = await _activityClient.ShiftTransfer(model);
            return res;
        }

        [HttpPost("ReceiveScratchcardFromAgency")]
        public async Task<object> ReceiveScratchcardFromAgency(ReceiveScratchcardFromAgencyReq model)
        {
            var res = await _activityClient.ReceiveScratchcardFromAgency(model);
            return res;
        }

        [HttpGet("GetDataScratchcardFromAgency")]
        public async Task<object> GetDataScratchcardFromAgency(DateTime date)
        {
            var obj = new DataScratchcardFromAgencyReq
            {
                Date = date
            };
            var res = await _activityClient.GetDataScratchcardFromAgency(obj);
            return res;
        }

        [HttpPost("DistributeScratchForSalesPoint")]
        public async Task<object> DistributeScratchForSalesPoint(DistributeScratchForSalePointReq model)
        {
            var res = await _activityClient.DistributeScratchForSalesPoint(model);
            return res;
        }

        [HttpGet("GetDataDistributeScratchForSalePoint")]
        public async Task<object> GetDataDistributeScratchForSalePoint()
        {
            var res = await _activityClient.GetDataDistributeScratchForSalePoint();
            return res;
        }
        [HttpGet("GetDataDistributeScratchForSubAgency")]
        public async Task<object> GetDataDistributeScratchForSubAgency()
        {
            var res = await _activityClient.GetDataDistributeScratchForSubAgency();
            return res;
        }

        [HttpGet("GetScratchcardFull")]
        public async Task<object> GetScratchcardFull()
        {
            var res = await _activityClient.GetScratchcardFull();
            return res;
        }

        [HttpGet("GetWinningList")]
        public async Task<object> GetWinningList(DateTime date, int shiftDistributeId, int? salePointId = 0)
        {
            var obj = new WinningListReq
            {
                Date = date,
                SalePointId = salePointId ?? 0,
                ShiftDistributeId = shiftDistributeId
            };
            var res = await _activityClient.GetWinningList(obj);
            return res;
        }

        [HttpGet("GetWinningListByMonth")]
        public async Task<object> GetWinningListByMonth(string month)
        {
            var obj = new WinningListByMonthReq
            {
                Month = month
            };
            var res = await _activityClient.GetWinningListByMonth(obj);
            return res;
        }

        [HttpGet("GetTransitionListToConfirm")]
        public async Task<object> GetTransitionListToConfirm(int ps, int p, DateTime date, int salePointId, int userRoleId, int transitionTypeId)
        {
            var obj = new TransitionListToConfirmReq
            {
                PageSize = ps,
                PageNumber = p,
                Date = date,
                SalePointId = salePointId,
                UserRoleId = userRoleId,
                TransitionTypeId = transitionTypeId,
            };
            var res = await _activityClient.GetTransitionListToConfirm(obj);
            return res;
        }

        [HttpGet("GetShiftDistributeByDate")]
        public async Task<object> GetShiftDistributeByDate(DateTime date, int userId)
        {
            var obj = new ShiftDistributeByDateReq
            {
                Date = date,
                UserId = userId
            };
            var res = await _activityClient.GetShiftDistributeByDate(obj);
            return res;
        }

        [HttpPost("ConfirmTransition")]
        public async Task<object> ConfirmTransition(ConfirmTransitionReq model)
        {
            var res = await _activityClient.ConfirmTransition(model);
            return res;
        }

        [HttpGet("GetSoldLogDetail")]
        public async Task<object> GetSoldLogDetail(int shiftDistributeId)
        {
            var obj = new SalePointLogReq
            {
                ShiftDistributeId = shiftDistributeId
            };
            var res = await _activityClient.GetSoldLogDetail(obj);
            return res;
        }

        [HttpGet("GetTransLogDetail")]
        public async Task<object> GetTransLogDetail(int shiftDistributeId)
        {
            var obj = new SalePointLogReq
            {
                ShiftDistributeId = shiftDistributeId
            };
            var res = await _activityClient.GetTransLogDetail(obj);
            return res;
        }

        [HttpGet("GetSalePointReturn")]
        public async Task<object> GetSalePointReturn(DateTime date)
        {
            var obj = new DataSellReq
            {
                Date = date
            };
            var res = await _activityClient.GetSalePointReturn(obj);
            return res;
        }
        [HttpGet("GetTmpWinningTicket")]
        public async Task<object> GetTmpWinningTicket(DateTime date, string number, int lotteryChannelId, int countNumber)
        {
            var obj = new GetTmpWinningTicketReq
            {
                Day = date,
                Number= number,
                LotteryChannelId = lotteryChannelId,
                CountNumber = countNumber
            };
            var res = await _activityClient.GetTmpWinningTicket(obj);
            return res;
        }
        
        [HttpPost("UpdateIsdeletedSalepointLog")]
        public async Task<object> UpdateIsdeletedSalepointLog(UpdateIsdeletedSalepointLogReq model)
        {
            
            var res = await _activityClient.UpdateIsdeletedSalepointLog(model);
            return res;
        }
        [HttpPost("CreateSalePoint")]
        public async Task<object> CreateSalePoint(CreateSalePointReq model)
        {
            var res = await _activityClient.CreateSalePoint(model);
            return res;
        }
        [HttpPost("UpdateLotteryPriceAgency")]
        public async Task<object> UpdateLotteryPriceAgency(UpdateLotteryPriceAgencyReq model)
        {
            var res = await _activityClient.UpdateLotteryPriceAgency(model);
            return res;
        }
        [HttpPost("UpdateLotteryPriceSubAgency")]
        public async Task<object> UpdateLotteryPriceSubAgency(UpdateLotteryPriceSubAgencyReq model)
        {
            var res = await _activityClient.UpdateLotteryPriceSubAgency(model);
            return res;
        }
        [HttpGet("GetLotteryPriceAgency")]
        public async Task<object> GetLotteryPriceAgency(DateTime? date = null)
        {
            var obj = new LotteryPriceAgencyReq
            {
                Date = date ?? null
            };
            var res = await _activityClient.GetLotteryPriceAgency(obj);
            return res;
        }
        [HttpGet("GetListLotteryForReturn")]
        public async Task<object> GetListLotteryForReturn(DateTime? lotteryDate = null)
        {
            var obj = new LotteryForReturnReq
            {
                LotteryDate = lotteryDate ?? null
            };
            var res = await _activityClient.GetListLotteryForReturn(obj);
            return res;
        }

        [HttpPost("ReturnLottery")]
        public async Task<object> ReturnLottery(ReturnLotteryReq model)
        {
            var res = await _activityClient.ReturnLottery(model);
            return res;
        }

        [HttpPost("UpdateConstantPrice")]
        public async Task<object> UpdateConstantPrice(UpdateConstantPriceReq model)
        {
            var res = await _activityClient.UpdateConstantPrice(model);
            return res;
        }
        [HttpPost("DeleteLogWinning")]
        public async Task<object> DeleteLogWinning(DeleteLogWinningReq model)
        {
            var res = await _activityClient.DeleteLogWinning(model);
            return res;
        }
        [HttpGet("GetListHistoryForManager")]
        public async Task<object> GetListHistoryForManager(int salePointId, int shiftId, DateTime date)
        {
            var obj = new GetListHistoryForManagerReq
            {
                Date = date,
                SalePoint = salePointId,
                ShiftId = shiftId,
            };
            var res = await _activityClient.GetListHistoryForManager(obj);
            return res;
        }
        [HttpGet("GetListReportMoneyInADay")]
        public async Task<object> GetListReportMoneyInADay(DateTime date)
        {
            var obj = new GetListReportMoneyInADayReq
            {
                Date = date
            };
            var res = await _activityClient.GetListReportMoneyInADay(obj);
            return res;
        }
        [HttpPost("UpdateReportMoneyInAShift")]
        public async Task<object> UpdateReportMoneyInAShift(UpdateReportMoneyInAShiftReq model)
        {
            var res = await _activityClient.UpdateReportMoneyInAShift(model);
            return res;
        }
        [HttpPost("UpdatePriceForGuest")]
        public async Task<object> UpdatePriceForGuest(UpdatePriceForGuestReq model)
        {
            var res = await _activityClient.UpdatePriceForGuest(model);
            return res;
        }
        [HttpPost("DeleteGuestAction")]
        public async Task<object> DeleteGuestAction(DeleteGuestActionReq model)
        {
            var res = await _activityClient.DeleteGuestAction(model);
            return res;
        }
        [HttpPost("DistributeForSubAgency")]
        public async Task<object> DistributeForSubAgency(DistributeForSubAgencyReq model)
        {
            var res = await _activityClient.DistributeForSubAgency(model);
            return res;
        }
        [HttpGet("GetDataSubAgency")]
        public async Task<object> GetDataSubAgency(DateTime date)
        {
            var obj = new GetDataSubAgencyReq
            {
                Date = date
            };
            var res = await _activityClient.GetDataSubAgency(obj);
            return res;
        }
        [HttpPost("UpdatePriceForSubAgency")]
        public async Task<object> UpdatePriceForSubAgency(UpdatePriceForSubAgencyReq model)
        {
            var res = await _activityClient.UpdatePriceForSubAgency(model);
            return res;
        }
        [HttpGet("GetStaticFee")]
        public async Task<object> GetStaticFee(DateTime month)
        {
            var obj = new GetStaticFeeReq
            {
                Month = month
            };
            var res = await _activityClient.GetStaticFee(obj);
            return res;
        }
        [HttpPost("UpdateStaticFee")]
        public async Task<object> UpdateStaticFee(UpdateStaticFeeReq model)
        {
            
            var res = await _activityClient.UpdateStaticFee(model);
            return res;
        }
        [HttpPost("DistributeScratchForSubAgency")]
        public async Task<object> DistributeForSubAgency(DistributeScratchForSubAgencyReq model)
        {
            var res = await _activityClient.DistributeForSubAgency(model);
            return res;
        }
        [HttpGet("GetDebtOfStaff")]
        public async Task<object> GetDebtOfStaff(int userTitleId)
        {
            var obj = new GetDebtOfStaffReq
            {
                UserTitleId = userTitleId
            };
            var res = await _activityClient.GetDebtOfStaff(obj);
            return res;
        }
        [HttpPost("UpdateDebt")]
        public async Task<object> UpdateDebt(UpdateDebtReq model)
        {
            var res = await _activityClient.UpdateDebt(model);
            return res;
        }
        [HttpGet("GetPayedDebtAndNewDebtAllTime")]
        public async Task<object> GetPayedDebtAndNewDebtAllTime(int userId)
        {
            var obj = new GetPayedDebtAndNewDebtAllTimeReq
            {
                UserId= userId
            };
            var res = await _activityClient.GetPayedDebtAndNewDebtAllTime(obj);
            return res;
        }
    }
}
