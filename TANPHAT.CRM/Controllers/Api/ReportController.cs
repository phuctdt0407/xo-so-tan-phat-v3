using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Domain.Models.Report;

namespace TANPHAT.CRM.Controllers.Api
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ReportController
    {
        private IReportClient _reportClient;

        public ReportController(IReportClient reportClient)
        {
            _reportClient = reportClient;
        }

        [HttpGet("GetTotalShiftOfUserInMonth")]
        public async Task<object> GetTotalShiftOfUserInMonth(string month)
        {
            var obj = new ReportRequestModel
            {
                Month = month
            };
            var res = await _reportClient.GetTotalShiftOfUserInMonth(obj);
            return res;
        }
        [HttpGet("GetTransitonTypeOffset")]
        public async Task<object> GetTransitonTypeOffset(string month)
        {
            var obj = new GetTransitonTypeOffsetReq
            {
                Month = month
            };
            var res = await _reportClient.GetTransitonTypeOffset(obj);
            return res;
        }
        [HttpGet("GetSaleOfSalePointInMonth")]
        public async Task<object> GetSaleOfSalePointInMonth(string month)
        {
            var obj = new SaleOfSalePointInMonthReq
            {
                Month = month
            };
            var res = await _reportClient.GetSaleOfSalePointInMonth(obj);
            return res;
        }
        


        [HttpGet("GetTotalShiftOfUserBySalePointInMonth")]
        public async Task<object> GetTotalShiftOfUserBySalePointInMonth(string month, int? SalePointId = 0)
        {
            var obj = new ReportRequestModel
                {
                    Month = month,
                    SalePoint = SalePointId ?? 0
                };
            var res = await _reportClient.GetTotalShiftOfUserBySalePointInMonth(obj);
            return res;
        }

        [HttpGet("GetDataInventoryInDayOfAllSalePoint")]
        public async Task<object> GetDataInventoryInDayOfAllSalePoint(string month, int salePointId)
        {
            var obj = new DataInventoryInDayOfAllSalePointReq
            {
                Month = month,
                SalePointId = salePointId
            };
            var res = await _reportClient.GetDataInventoryInDayOfAllSalePoint(obj);
            return res;
        }

        [HttpGet("GetTotalLotterySellOfUserToCurrentInMonth")]
        public async Task<object> GetGetTotalLotterySellOfUserToCurrentInMonth(string month, int userid, int? lotteryTypeId = 0)
        {
            var obj = new TotalLotterySellOfUserToCurrentInMonthReq
            {
                Month = month,
                UserId = userid,
                LotteryTypeId = lotteryTypeId ?? 0
            };
            var res = await _reportClient.GetTotalLotterySellOfUserToCurrentInMonth(obj);
            return res;
        }

        [HttpGet("GetDataInventoryInMonthOfAllSalePoint")]
        public async Task<object> GetDataInventoryInMonthOfAllSalePoint(string month)
        {
            var obj = new DataInventoryInMonthOfAllSalePointReq
            {
                InventoryMonth = month
            };
            var res = await _reportClient.GetDataInventoryInMonthOfAllSalePoint(obj);
            return res;
        }

        [HttpGet("GetTotalLotteryReceiveOfAllAgencyInMonth")]
        public async Task<object> GetTotalLotteryReceiveOfAllAgencyInMonth(string month)
        {
            var obj = new ReportRequestModel
            {
                Month = month
            };
            var res = await _reportClient.GetTotalLotteryReceiveOfAllAgencyInMonth(obj);
            return res;
        }

        [HttpGet("GetTotalLotteryReturnOfAllSalePointInMonth")]
        public async Task<object> GetTotalLotteryReturnOfAllSalePointInMonth(string month, int salePointId)
        {
            var obj = new ReportRequestModel
            {
                Month = month,
                SalePoint = salePointId
            };
            var res = await _reportClient.GetTotalLotteryReturnOfAllSalePointInMonth(obj);
            return res;
        }
        //Đã cập nhật cho trưởng nhóm
        [HttpGet("GetTotalWinningOfSalePointInMonth")]
        public async Task<object> GetTotalWinningOfSalePointInMonth(int UserRole, int SalePointId, string month)
        {
            var obj = new ReportRequestModel
            {
                UserRoleId = UserRole,
                SalePoint = SalePointId,
                Month = month
            };
            var res = await _reportClient.GetTotalWinningOfSalePointInMonth(obj);
            return res;
        }

        [HttpGet("GetTotalRemainOfSalePoint")]
        public async Task<object> GetTotalRemainOfSalePoint(string month, int SalePointId = 0)
        {
            var obj = new ReportRequestModel
            {
                SalePoint = SalePointId,
                Month = month
            };
            var res = await _reportClient.GetTotalRemainOfSalePoint(obj);
            return res;
        }

        [HttpGet("GetDataShiftTransFer")]
        public async Task<object> GetDataShiftTransFer(int UserRole, int shiftDistributeId)
        {
            var obj = new ReportRequestModel
            {
                UserRoleId = UserRole,
                ShiftDistributeId = shiftDistributeId
            };
            var res = await _reportClient.GetDataShiftTransFer(obj);
            return res;
        }

        [HttpGet("GetTotalRemainingOfAllSalePointInDate")]
        public async Task<object> GetTotalRemainingOfAllSalePointInDate()
        {
            var obj = new ReportRequestModel();
            var res = await _reportClient.GetTotalRemainingOfAllSalePointInDate(obj);
            return res;
        }

        //Đã cập nhật cho trưởng nhóm

        [HttpGet("GetDataQuantityInteractLotteryByDate")]
        public async Task<object> GetDataQuantityInteractLotteryByDate(int UserRole,  DateTime date)
        {
            var obj = new ReportRequestModel
            {
                UserRoleId = UserRole,
                Date = date
            };
            var res = await _reportClient.GetDataQuantityInteractLotteryByDate(obj);
            return res;
        }


        //Đã cập nhật cho trưởng nhóm
        [HttpGet("GetDataQuantityInteractLotteryByMonth")]
        public async Task<object> GetDataQuantityInteractLotteryByMonth(int UserRole,  string month)
        {
            var obj = new ReportRequestModel 
            { 
                UserRoleId = UserRole,
                Month = month
            };
            var res = await _reportClient.GetDataQuantityInteractLotteryByMonth(obj);
            return res;
        }

        [HttpGet("GetReportManagerOverall")]
        public async Task<object> GetReportManagerOverall(DateTime lotteryDate, int salePointId, int userRoleId)
        {
            var obj = new ReportManagerOverallReq
            {
                LotteryDate = lotteryDate,
                SalePointId = salePointId,
                UserRoleId = userRoleId
            };
            var res = await _reportClient.GetReportManagerOverall(obj);
            return res;
        }
        [HttpGet("GetTotalLotteryNotSellOfAllSalePoint")]
        public async Task<object> GetTotalLotteryNotSellOfAllSalePoint(DateTime lotteryDate = new DateTime(), string month = null)
        {
            var obj = new ReportRequestModel
            {
                Date = lotteryDate,
                Month = month
            };
            var res = await _reportClient.GetTotalLotteryNotSellOfAllSalePoint(obj);
            return res;
        }
        [HttpGet("GetTotalLotterySoldOfSalePointThatYouManage")]
        public async Task<object> GetTotalLotterySoldOfSalePointThatYouManage(int UserRole,  DateTime date = new DateTime(), string month = null)
        {
            var obj = new ReportRequestModel
            {
                UserRoleId = UserRole,
                Date = date,
                Month = month
            };
            var res = await _reportClient.GetTotalLotterySoldOfSalePointThatYouManage(obj);
            return res;
        }
        [HttpGet("GetAverageLotterySellOfUser")]
        public async Task<object> GetAverageLotterySellOfUser(string month, int? userid = 0, int? lotteryTypeId = 0)
        {
            var obj = new TotalLotterySellOfUserToCurrentInMonthReq
            {
                Month = month,
                UserId = userid ?? 0,
                LotteryTypeId = lotteryTypeId ?? 0
            };
            var res = await _reportClient.GetAverageLotterySellOfUser(obj);
            return res;
        }

        [HttpGet("GetLogDistributeForSalepoint")]
        public async Task<object> GetLogDistributeForSalepoint(DateTime date = new DateTime(), int? salePointId=0)
        {
            var obj = new LogDistributeForSalepointReq
            {
                Date = date,
                SalePointId= salePointId ?? 0
            };
            var res = await _reportClient.GetLogDistributeForSalepoint(obj);
            return res;
        }

        [HttpGet("GetListForUpdate")]
        public async Task<object> GetListForUpdate(DateTime date = new DateTime(), int? salePointId = 0,int? shiftId=0)
        {
            var obj = new GetListForUpdateReq
            {
                Date = date,
                SalepointId = salePointId ?? 0,
                ShiftId = shiftId?? 0
            };
            var res = await _reportClient.GetListForUpdate(obj);
            return res;
        }

        [HttpPost("UpdateORDeleteSalePointLog")]
        public async Task<object> UpdateORDeleteSalePointLog(UpdateORDeleteSalePointLogReq model)
        {
            var result = await _reportClient.UpdateORDeleteSalePointLog(model);
            return result;
        }
        [HttpPost("UpdateReportLottery")]
        public async Task<object> UpdateReportLottery(UpdateReportLotteryReq model)
        {
            var result = await _reportClient.UpdateReportLottery(model);
            return result;
        }

        [HttpGet("GetFullTotalItemInMonth")]
        public async Task<object> GetFullTotalItemInMonth(string month)
        {
            var obj = new GetFullTotalItemInMonthReq
            {
                Month = month
            };
            var res = await _reportClient.GetFullTotalItemInMonth(obj);
            return res;
        }

        [HttpPost("UpdateORDeleteItem")]
        public async Task<object> UpdateORDeleteItem(UpdateORDeleteItemReq model)
        {
            var result = await _reportClient.UpdateORDeleteItem(model);
            return result;
        }
        
        [HttpGet("GetListUnsoldLotteryTicket")]
        public async Task<object> GetListUnsoldLotteryTicket(string month)
        {
            var obj = new GetListUnsoldLotteryTicketReq
            {
                Month = month
            };
            var res = await _reportClient.GetListUnsoldLotteryTicket(obj);
            return res;
        }

        [HttpGet("GetLotterySellInMonth")]
        public async Task<object> GetLotterySellInMonth(string month)
        {
            var obj = new GetLotterySellInMonthReq
            {
                Month = month
            };
            var res = await _reportClient.GetLotterySellInMonth(obj);
            return res;
        }


        [HttpPost("DeleteShiftTransfer")]
        public async Task<object> DeleteShiftTransfer(DeleteShiftTransferReq model)
        {
            var result = await _reportClient.DeleteShiftTransfer(model);
            return result;
        }


        [HttpGet("GetSalaryInMonthOfUser")]
        public async Task<object> GetSalaryInMonthOfUser(int userId,string month)
        {
            var obj = new GetSalaryInMonthOfUserReq
            {
                UserId = userId,
                Month = month
            };
            var res = await _reportClient.GetSalaryInMonthOfUser(obj);
            return res;
        }
        [HttpGet("TotalLotteryReceiveOfAllAgencyInDay")]
        public async Task<object> TotalLotteryReceiveOfAllAgencyInDay(int agencyId,string month)
        {
            var obj = new TotalLotteryReceiveOfAllAgencyInDayReq
            {   
                AgencyId = agencyId,
                Month = month
            };
            var res = await _reportClient.TotalLotteryReceiveOfAllAgencyInDay(obj);
            return res;
        }
        [HttpPost("UpdateReturnMoney")]
        public async Task<object> UpdateReturnMoney(UpdateReturnMoneyReq model)
        {
            var result = await _reportClient.UpdateReturnMoney(model);
            return result;
        }


        [HttpPost("UpdateKpi")]
        public async Task<object> UpdateKpi(UpdateKpiReq model)
        {
            var result = await _reportClient.UpdateKpi(model);
            return result;
        }
        [HttpPost("UpdateIsSumKpi")]
        public async Task<object> UpdateIsSumKpi(UpdateIsSumKpiReq model)
        {
            var result = await _reportClient.UpdateIsSumKpi(model);
            return result;
        }
        

        [HttpGet("ReportLotteryInADay")]
        public async Task<object> ReportLotteryInADay(int salePointId, DateTime date,int shiftId)
        {
            var obj = new ReportLotteryInADayReq
            {
                SalePointId = salePointId,
                Date = date,
                ShiftId = shiftId
            };
            var res = await _reportClient.ReportLotteryInADay(obj);
            return res;

        }
        [HttpGet("GetListExemptKpi")]
        public async Task<object> GetListExemptKpi(string month)
        {
            var obj = new GetListExemptKpiReq
            {
                Month = month
            };
            var res = await _reportClient.GetListExemptKpi(obj);
            return res;

        }

        
        [HttpGet("GetListTotalNumberOfTicketsOfEachManager")]
        public async Task<object> GetListTotalNumberOfTicketsOfEachManager( string month)
        {
            var obj = new GetListTotalNumberOfTicketsOfEachManagerReq
            {
                Month = month
            };
            var res = await _reportClient.GetListTotalNumberOfTicketsOfEachManager(obj);
            return res;
        }
        [HttpGet("ReportRemainingLottery")]
        public async Task<object> ReportRemainingLottery(string month)
        {
            var obj = new ReportRemainingLotteryReq
            {
                Month = month
            };
            var res = await _reportClient.ReportRemainingLottery(obj);
            return res;
        }
        [HttpGet("ReuseReportDataFinishShift")]
        public async Task<object> ReuseReportDataFinishShift(int userRole, int shiftDistributeId)
        {
            var obj = new ReuseReportDataFinishShiftReq
            {
                UserRole = userRole,
                ShiftDistributeId = shiftDistributeId
            };
            var res = await _reportClient.ReuseReportDataFinishShift(obj);
            return res;
        }
    }
}
