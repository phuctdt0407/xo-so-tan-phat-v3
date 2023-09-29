using System;
using System.Threading.Tasks;
using KTHub.Core.Listener.Cotroller;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Business;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.ApiListener.Controllers
{
    [ApiExplorerSettings(IgnoreApi = false)]
    [Route(UrlCommon.T_Report)]
    public class ReportController : BaseApiController
    {
        private IReportBusiness _reportBusiness;

        public ReportController(ConsumerConfigs consumerConfigs, IReportBusiness reportBusiness) : base(consumerConfigs)
        {
            _reportBusiness = reportBusiness;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var requestType = GetRequestType<ReportGetType>();
            switch (requestType)
            {
                case ReportGetType.GetTotalShiftOfUserInMonth:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalShiftOfUserInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalShiftOfUserBySalePointInMonth:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalShiftOfUserBySalePointInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetDataInventoryInDayOfAllSalePoint:
                    {
                        var reqModel = GetRequestData<DataInventoryInDayOfAllSalePointReq>();
                        var result = await _reportBusiness.GetDataInventoryInDayOfAllSalePoint(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalLotterySellOfUserInMonth:
                    {
                        var reqModel = GetRequestData<TotalLotterySellOfUserToCurrentInMonthReq>();
                        var result = await _reportBusiness.GetTotalLotterySellOfUserInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalLotterySellOfUserToCurrentInMonth:
                    {
                        var reqModel = GetRequestData<TotalLotterySellOfUserToCurrentInMonthReq>();
                        var result = await _reportBusiness.GetTotalLotterySellOfUserToCurrentInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetDataInventoryInMonthOfAllSalePoint:
                    {
                        var reqModel = GetRequestData<DataInventoryInMonthOfAllSalePointReq>();
                        var result = await _reportBusiness.GetDataInventoryInMonthOfAllSalePoint(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalLotteryReceiveOfAllAgencyInMonth:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalLotteryReceiveOfAllAgencyInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalLotteryReturnOfAllSalePointInMonth:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalLotteryReturnOfAllSalePointInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalWinningOfSalePointInMonth:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalWinningOfSalePointInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalRemainOfSalePoint:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalRemainOfSalePoint(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetDataShiftTransFer:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetDataShiftTransFer(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalRemainingOfAllSalePointInDate:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalRemainingOfAllSalePointInDate(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetDataQuantityInteractLotteryByDate:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetDataQuantityInteractLotteryByDate(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetDataQuantityInteractLotteryByMonth:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetDataQuantityInteractLotteryByMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetReportManagerOverall:
                    {
                        var reqModel = GetRequestData<ReportManagerOverallReq>();
                        var result = await _reportBusiness.GetReportManagerOverall(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalLotteryNotSellOfAllSalePoint:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalLotteryNotSellOfAllSalePoint(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTotalLotterySoldOfSalePointThatYouManage:
                    {
                        var reqModel = GetRequestData<ReportRequestModel>();
                        var result = await _reportBusiness.GetTotalLotterySoldOfSalePointThatYouManage(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetAverageLotterySellOfUser:
                    {
                        var reqModel = GetRequestData<TotalLotterySellOfUserToCurrentInMonthReq>();
                        var result = await _reportBusiness.GetAverageLotterySellOfUser(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetLogDistributeForSalepoint:
                    {
                        var reqModel = GetRequestData<LogDistributeForSalepointReq>();
                        var result = await _reportBusiness.GetLogDistributeForSalepoint(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetListForUpdate:
                    {
                        var reqModel = GetRequestData<GetListForUpdateReq>();
                        var result = await _reportBusiness.GetListForUpdate(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetFullTotalItemInMonth:
                    {
                        var reqModel = GetRequestData<GetFullTotalItemInMonthReq>();
                        var result = await _reportBusiness.GetFullTotalItemInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetLotterySellInMonth:
                    {
                        var reqModel = GetRequestData<GetLotterySellInMonthReq>();
                        var result = await _reportBusiness.GetLotterySellInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetSaleOfSalePointInMonth:
                    {
                        var reqModel = GetRequestData<SaleOfSalePointInMonthReq>();
                        var result = await _reportBusiness.GetSaleOfSalePointInMonth(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetTransitonTypeOffset:
                    {
                        var reqModel = GetRequestData<GetTransitonTypeOffsetReq>();
                        var result = await _reportBusiness.GetTransitonTypeOffset(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetSalaryInMonthOfUser:
                    {
                        var reqModel = GetRequestData<GetSalaryInMonthOfUserReq>();
                        var result = await _reportBusiness.GetSalaryInMonthOfUser(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.TotalLotteryReceiveOfAllAgencyInDay:
                    {
                        var reqModel = GetRequestData<TotalLotteryReceiveOfAllAgencyInDayReq>();
                        var result = await _reportBusiness.TotalLotteryReceiveOfAllAgencyInDay(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.ReportLotteryInADay:
                    {
                        var reqModel = GetRequestData<ReportLotteryInADayReq>();
                        var result = await _reportBusiness.ReportLotteryInADay(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.ReportRemainingLottery:
                    {
                        var reqModel = GetRequestData<ReportRemainingLotteryReq>();
                        var result = await _reportBusiness.ReportRemainingLottery(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.ReuseReportDataFinishShift:
                    {
                        var reqModel = GetRequestData<ReuseReportDataFinishShiftReq>();
                        var result = await _reportBusiness.ReuseReportDataFinishShift(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetListTotalNumberOfTicketsOfEachManager:
                    {
                        var reqModel = GetRequestData<GetListTotalNumberOfTicketsOfEachManagerReq>();
                        var result = await _reportBusiness.GetListTotalNumberOfTicketsOfEachManager(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetListUnsoldLotteryTicket:
                    {
                        var reqModel = GetRequestData<GetListUnsoldLotteryTicketReq>();
                        var result = await _reportBusiness.GetListUnsoldLotteryTicket(reqModel);
                        return OkResult(result);
                    }
                case ReportGetType.GetListExemptKpi:
                    {
                        var reqModel = GetRequestData<GetListExemptKpiReq>();
                        var result = await _reportBusiness.GetListExemptKpi(reqModel);
                        return OkResult(result);
                    }
                    


                default: break;
            }
            return NotFound();
        }

        [HttpPost]
        public async Task<IActionResult> Post()
        {
            var requestType = GetRequestType<ReportPostType>();
            switch (requestType)
            {
                case ReportPostType.UpdateORDeleteSalePointLog:
                    {
                        var reqModel = GetRequestData<UpdateORDeleteSalePointLogReq>();
                        var result = await _reportBusiness.UpdateORDeleteSalePointLog(reqModel);
                        return OkResult(result);
                    }
                case ReportPostType.UpdateReportLottery:
                    {
                        var reqModel = GetRequestData<UpdateReportLotteryReq>();
                        var result = await _reportBusiness.UpdateReportLottery(reqModel);
                        return OkResult(result);
                    }
                case ReportPostType.UpdateKpi:
                    {
                        var reqModel = GetRequestData<UpdateKpiReq>();
                        var result = await _reportBusiness.UpdateKpi(reqModel);
                        return OkResult(result);
                    }
                case ReportPostType.UpdateORDeleteItem:
                    {
                        var reqModel = GetRequestData<UpdateORDeleteItemReq>();
                        var result = await _reportBusiness.UpdateORDeleteItem(reqModel);
                        return OkResult(result);
                    }
                case ReportPostType.DeleteShiftTransfer:
                    {
                        var reqModel = GetRequestData<DeleteShiftTransferReq>();
                        var result = await _reportBusiness.DeleteShiftTransfer(reqModel);
                        return OkResult(result);
                    }
                case ReportPostType.UpdateReturnMoney:
                    {
                        var reqModel = GetRequestData<UpdateReturnMoneyReq>();
                        var result = await _reportBusiness.UpdateReturnMoney(reqModel);
                        return OkResult(result);
                    }
                case ReportPostType.UpdateIsSumKpi:
                    {
                        var reqModel = GetRequestData<UpdateIsSumKpiReq>();
                        var result = await _reportBusiness.UpdateIsSumKpi(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }
    }
}
