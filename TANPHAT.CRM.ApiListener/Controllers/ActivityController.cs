using System.Threading.Tasks;
using KTHub.Core.Listener.Cotroller;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Business;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.ApiListener.Controllers
{
    [ApiExplorerSettings(IgnoreApi = false)]
    [Route(UrlCommon.T_Activity)]
    public class ActivityController : BaseApiController
    {
        private IActivityBusiness _activityBusiness;

        public ActivityController(ConsumerConfigs consumerConfigs, IActivityBusiness activityBusiness) : base(consumerConfigs)
        {
            _activityBusiness = activityBusiness;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var requestType = GetRequestType<ActivityGetType>();
            switch (requestType)
            {
                case ActivityGetType.GetDataReceivedFromAgency:
                    {
                        var reqModel = GetRequestData<DataReceivedFromAgencyReq>();
                        var result = await _activityBusiness.GetDataReceivedFromAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetTmpWinningTicket:
                    {
                        var reqModel = GetRequestData<GetTmpWinningTicketReq>();
                        var result = await _activityBusiness.GetTmpWinningTicket(reqModel);
                        return OkResult(result);
                    }
                    
                case ActivityGetType.GetDataDistributeForSalePoint:
                    {
                        var reqModel = GetRequestData<DataDistributeForSalePointReq>();
                        var result = await _activityBusiness.GetDataDistributeForSalePoint(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetDataSell:
                    {
                        var reqModel = GetRequestData<DataSellReq>();
                        var result = await _activityBusiness.GetDataSell(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetSalePointLog:
                    {
                        var reqModel = GetRequestData<SalePointLogReq>();
                        var result = await _activityBusiness.GetSalePointLog(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetDataInventory:
                    {
                        var reqModel = GetRequestData<DataSellReq>();
                        var result = await _activityBusiness.GetDataInventory(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetRepaymentLog:
                    {
                        var reqModel = GetRequestData<SalePointLogReq>();
                        var result = await _activityBusiness.GetRepaymentLog(reqModel);
                        return OkResult(result);
                    }

                case ActivityGetType.GetInventoryLog:
                    {
                        var reqModel = GetRequestData<DataSellReq>();
                        var result = await _activityBusiness.GetInventoryLog(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetDataScratchcardFromAgency:
                    {
                        var reqModel = GetRequestData<DataScratchcardFromAgencyReq>();
                        var result = await _activityBusiness.GetDataScratchcardFromAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetDataDistributeScratchForSalePoint:
                    {
                        var result = await _activityBusiness.GetDataDistributeScratchForSalePoint();
                        return OkResult(result);
                    }
                case ActivityGetType.GetDataDistributeScratchForSubAgency:
                {
                    var result = await _activityBusiness.GetDataDistributeScratchForSubAgency();
                    return OkResult(result);
                }
                case ActivityGetType.GetScratchcardFull:
                    {
                        var result = await _activityBusiness.GetScratchcardFull();
                        return OkResult(result);
                    }
                case ActivityGetType.GetWinningList:
                    {
                        var reqModel = GetRequestData<WinningListReq>();
                        var result = await _activityBusiness.GetWinningList(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetTransitionListToConfirm:
                    {
                        var reqModel = GetRequestData<TransitionListToConfirmReq>();
                        var result = await _activityBusiness.GetTransitionListToConfirm(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetShiftDistributeByDate:
                    {
                        var reqModel = GetRequestData<ShiftDistributeByDateReq>();
                        var result = await _activityBusiness.GetShiftDistributeByDate(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetSoldLogDetail:
                    {
                        var reqModel = GetRequestData<SalePointLogReq>();
                        var result = await _activityBusiness.GetSoldLogDetail(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetTransLogDetail:
                    {
                        var reqModel = GetRequestData<SalePointLogReq>();
                        var result = await _activityBusiness.GetTransLogDetail(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetSalePointReturn:
                    {
                        var reqModel = GetRequestData<DataSellReq>();
                        var result = await _activityBusiness.GetSalePointReturn(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetLotteryPriceAgency:
                    {
                        var reqModel = GetRequestData<LotteryPriceAgencyReq>();
                        var result = await _activityBusiness.GetLotteryPriceAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetListLotteryForReturn:
                    {
                        var reqModel = GetRequestData<LotteryForReturnReq>();
                        var result = await _activityBusiness.GetListLotteryForReturn(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetListHistoryForManager:
                    {
                        var reqModel = GetRequestData<GetListHistoryForManagerReq>();
                        var result = await _activityBusiness.GetListHistoryForManager(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetListReportMoneyInADay:
                    {
                        var reqModel = GetRequestData<GetListReportMoneyInADayReq>();
                        var result = await _activityBusiness.GetListReportMoneyInADay(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetDataSubAgency:
                    {
                        var reqModel = GetRequestData<GetDataSubAgencyReq>();
                        var result = await _activityBusiness.GetDataSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetListSubAgency:
                    {
                        var reqModel = GetRequestData<GetListSubAgencyReq>();
                        var result = await _activityBusiness.GetListSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetListLotteryPriceSubAgency:
                    {
                        var reqModel = GetRequestData<GetListLotteryPriceSubAgencyReq>();
                        var result = await _activityBusiness.GetListLotteryPriceSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetStaticFee:
                    {
                        var reqModel = GetRequestData<GetStaticFeeReq>();
                        var result = await _activityBusiness.GetStaticFee(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetDebtOfStaff:
                    {
                        var reqModel = GetRequestData<GetDebtOfStaffReq>();
                        var result = await _activityBusiness.GetDebtOfStaff(reqModel);
                        return OkResult(result);
                    }
                case ActivityGetType.GetPayedDebtAndNewDebtAllTime:
                    {
                        var reqModel = GetRequestData<GetPayedDebtAndNewDebtAllTimeReq>();
                        var result = await _activityBusiness.GetPayedDebtAndNewDebtAllTime(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }

        [HttpPost]
        public async Task<IActionResult> Post()
        {
            var requestType = GetRequestType<ActivityPostType>();
            switch (requestType)
            {
                case ActivityPostType.ReceiveLotteryFromAgency:
                    {
                        var reqModel = GetRequestData<ReceivedLotteryFromAgencyReq>();
                        var result = await _activityBusiness.ReceiveLotteryFromAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateActivityGuestAction:
                    {
                        var reqModel = GetRequestData<UpdateActivityGuestActionReq>();
                        var result = await _activityBusiness.UpdateActivityGuestAction(reqModel);
                        return OkResult(result);
                    }
                    
                case ActivityPostType.DistributeForSalesPoint:
                    {
                        var reqModel = GetRequestData<DistributeForSalePointReq>();
                        var result = await _activityBusiness.DistributeForSalesPoint(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.SellLottery:
                    {
                        var reqModel = GetRequestData<SellLotteryReq>();
                        var result = await _activityBusiness.SellLottery(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.InsertOrUpdateAgency:
                    {
                        var reqModel = GetRequestData<InsertOrUpdateAgencyReq>();
                        var result = await _activityBusiness.InsertOrUpdateAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.InsertOrUpdateSubAgency:
                    {
                        var reqModel = GetRequestData<InsertOrUpdateSubAgencyReq>();
                        var result = await _activityBusiness.InsertOrUpdateSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.InsertTransitionLog:
                    {
                        var reqModel = GetRequestData<InsertTransitionLogReq>();
                        var result = await _activityBusiness.InsertTransitionLog(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.InsertRepayment:
                    {
                        var reqModel = GetRequestData<InsertRepaymentReq>();
                        var result = await _activityBusiness.InsertRepayment(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.InsertWinningLottery:
                    {
                        var reqModel = GetRequestData<InsertWinningLotteryReq>();
                        var result = await _activityBusiness.InsertWinningLottery(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.ShiftTransfer:
                    {
                        var reqModel = GetRequestData<ShiftTransferReq>();
                        var result = await _activityBusiness.ShiftTransfer(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.ReceiveScratchcardFromAgency:
                    {
                        var reqModel = GetRequestData<ReceiveScratchcardFromAgencyReq>();
                        var result = await _activityBusiness.ReceiveScratchcardFromAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.DistributeScratchForSalesPoint:
                    {
                        var reqModel = GetRequestData<DistributeScratchForSalePointReq>();
                        var result = await _activityBusiness.DistributeScratchForSalesPoint(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.ConfirmTransition:
                    {
                        var reqModel = GetRequestData<ConfirmTransitionReq>();
                        var result = await _activityBusiness.ConfirmTransition(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.CreateSalePoint:
                    {
                        var reqModel = GetRequestData<CreateSalePointReq>();
                        var result = await _activityBusiness.CreateSalePoint(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateLotteryPriceAgency:
                    {
                        var reqModel = GetRequestData<UpdateLotteryPriceAgencyReq>();
                        var result = await _activityBusiness.UpdateLotteryPriceAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateLotteryPriceSubAgency:
                    {
                        var reqModel = GetRequestData<UpdateLotteryPriceSubAgencyReq>();
                        var result = await _activityBusiness.UpdateLotteryPriceSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateIsdeletedSalepointLog:
                    {
                        var reqModel = GetRequestData<UpdateIsdeletedSalepointLogReq>();
                        var result = await _activityBusiness.UpdateIsdeletedSalepointLog(reqModel);
                        return OkResult(result);
                    }
                    
                case ActivityPostType.ReturnLottery:
                    {
                        var reqModel = GetRequestData<ReturnLotteryReq>();
                        var result = await _activityBusiness.ReturnLottery(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateConstantPrice:
                    {
                        var reqModel = GetRequestData<UpdateConstantPriceReq>();
                        var result = await _activityBusiness.UpdateConstantPrice(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.DeleteLogWinning:
                    {
                        var reqModel = GetRequestData<DeleteLogWinningReq>();
                        var result = await _activityBusiness.DeleteLogWinning(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateReportMoneyInAShift:
                    {
                        var reqModel = GetRequestData<UpdateReportMoneyInAShiftReq>();
                        var result = await _activityBusiness.UpdateReportMoneyInAShift(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdatePriceForGuest:
                    {
                        var reqModel = GetRequestData<UpdatePriceForGuestReq>();
                        var result = await _activityBusiness.UpdatePriceForGuest(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.DeleteGuestAction:
                    {
                        var reqModel = GetRequestData<DeleteGuestActionReq>();
                        var result = await _activityBusiness.DeleteGuestAction(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.DistributeForSubAgency:
                    {
                        var reqModel = GetRequestData<DistributeForSubAgencyReq>();
                        var result = await _activityBusiness.DistributeForSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdatePriceForSubAgency:
                    {
                        var reqModel = GetRequestData<UpdatePriceForSubAgencyReq>();
                        var result = await _activityBusiness.UpdatePriceForSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateStaticFee:
                    {
                        var reqModel = GetRequestData<UpdateStaticFeeReq>();
                        var result = await _activityBusiness.UpdateStaticFee(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.DistributeScratchForSubAgency:
                    {
                        var reqModel = GetRequestData<DistributeScratchForSubAgencyReq>();
                        var result = await _activityBusiness.DistributeScratchForSubAgency(reqModel);
                        return OkResult(result);
                    }
                case ActivityPostType.UpdateDebt:
                    {
                        var reqModel = GetRequestData<UpdateDebtReq>();
                        var result = await _activityBusiness.UpdateDebt(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }
    }
}
