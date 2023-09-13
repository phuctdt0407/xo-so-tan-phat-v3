using System.Threading.Tasks;
using KTHub.Core.Listener.Cotroller;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Business;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.SalePoint;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;

namespace TANPHAT.CRM.ApiListener.Controllers
{
    [ApiExplorerSettings(IgnoreApi = false)]
    [Route(UrlCommon.T_SalePoint)]
    public class SalePointController : BaseApiController
    {
        private ISalePointBusiness _salePointBusiness;

        public SalePointController(ConsumerConfigs consumerConfigs, ISalePointBusiness salePointBusiness) : base(consumerConfigs)
        {
            _salePointBusiness = salePointBusiness;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var requestType = GetRequestType<SalePointGetType>();
            switch (requestType)
            {
                case SalePointGetType.GetListSalePoint:
                    {
                        var reqModel = GetRequestData<GetListSalePointReq>();
                        var result = await _salePointBusiness.GetListSalePoint(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListFeeOutsite:
                    {
                        var reqModel = GetRequestData<GetListFeeOutsiteReq>();
                        var result = await _salePointBusiness.GetListFeeOutsite(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListItemConfirm:
                    {
                        var reqModel = GetRequestData<GetListItemConfirmReq>();
                        var result = await _salePointBusiness.GetListItemConfirm(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListConfirmPayment:
                    {
                        var reqModel = GetRequestData<GetListConfirmPaymentReq>();
                        var result = await _salePointBusiness.GetListConfirmPayment(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListCommission:
                    {
                        var reqModel = GetRequestData<ListCommissionReq>();
                        var result = await _salePointBusiness.GetListComission(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListHistoryOrder:
                    {
                        var reqModel = GetRequestData<ListHistoryOrderReq>();
                        var result = await _salePointBusiness.GetListHistoryOrder(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListUserByDateAndSalePoint:
                    {
                        var reqModel = GetRequestData<ListUserByDateAndSalePointReq>();
                        var result = await _salePointBusiness.GetListUserByDateAndSalePoint(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetDataForGuestReturn:
                    {
                        var reqModel = GetRequestData<DataForGuestReturnReq>();
                        var result = await _salePointBusiness.GetDataForGuestReturn(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListGuestForConfirm:
                    {
                        var reqModel = GetRequestData<GuestForConfirmReq>();
                        var result = await _salePointBusiness.GetListGuestForConfirm(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListFeeOfCommission:
                    {
                        var reqModel = GetRequestData<FeeOfCommissionReq>();
                        var result = await _salePointBusiness.GetListFeeOfCommission(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListTransaction:
                    {
                        var reqModel = GetRequestData<TransactionReq>();
                        var result = await _salePointBusiness.GetListTransaction(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListPaymentForConfirm:
                    {
                        var reqModel = GetRequestData<PaymentForConfirmReq>();
                        var result = await _salePointBusiness.GetListPaymentForConfirm(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListSalePointOfLeader:
                    {
                        var reqModel = GetRequestData<SalePointOfLeaderReq>();
                        var result = await _salePointBusiness.GetListSalePointOfLeader(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListAttendentOfLeader:
                    {
                        var reqModel = GetRequestData<ListAttendentOfLeaderReq>();
                        var result = await _salePointBusiness.GetListAttendentOfLeader(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListSaleOfVietLottInDate:
                    {
                        var reqModel = GetRequestData<ListSaleOfVietLottInDateReq>();
                        var result = await _salePointBusiness.GetListSaleOfVietLottInDate(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListSaleOfVietLottInMonth:
                    {
                        var reqModel = GetRequestData<ListSaleOfVietLottInMonthReq>();
                        var result = await _salePointBusiness.GetListSaleOfVietLottInMonth(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListSaleOfLotoInMonth:
                    {
                        var reqModel = GetRequestData<ListSaleOfLotoInMonthReq>();
                        var result = await _salePointBusiness.GetListSaleOfLotoInMonth(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListFeeOutSiteInMonth:
                    {
                        var reqModel = GetRequestData<ListFeeOutSiteInMonthReq>();
                        var result = await _salePointBusiness.GetListFeeOutSiteInMonth(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListUnionInYear:
                    {
                        var reqModel = GetRequestData<ListUnionInYearReq>();
                        var result = await _salePointBusiness.GetListUnionInYear(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListHistoryOfGuest:
                    {
                        var reqModel = GetRequestData<ListHistoryOfGuestReq>();
                        var result = await _salePointBusiness.GetListHistoryOfGuest(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListPayVietlott:
                    {
                        var reqModel = GetRequestData<ListPayVietlottReq>();
                        var result = await _salePointBusiness.GetListPayVietlott(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListSalePointPercent:
                    {
                        var reqModel = GetRequestData<ListSalePointPercentReq>();
                        var result = await _salePointBusiness.GetListSalePointPercent(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListLotteryAwardExpected:
                    {
                        var reqModel = GetRequestData<ListLotteryAwardExpectedReq>();
                        var result = await _salePointBusiness.GetListLotteryAwardExpected(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetListOtherFees:
                    {
                        var reqModel = GetRequestData<GetListOtherFeesReq>();
                        var result = await _salePointBusiness.GetListOtherFees(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetTotalCommisionAndFee:
                    {
                        var reqModel = GetRequestData<GetTotalCommisionAndFeeReq>();
                        var result = await _salePointBusiness.GetTotalCommisionAndFee(reqModel);
                        return OkResult(result);
                    }
                case SalePointGetType.GetAllStaticFee:
                    {
                        var reqModel = GetRequestData<GetAllStaticFeeReq>();
                        var result = await _salePointBusiness.GetAllStaticFee(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }


        [HttpPost]
        public async Task<IActionResult> Post()
        {
            var requestType = GetRequestType<SalePointPostType>();
            switch (requestType)
            {
                case SalePointPostType.UpdateSalePoint:
                    {
                        var reqModel = GetRequestData<UpdateSalePointReq>();
                        var result = await _salePointBusiness.UpdateSalePoint(reqModel);
                        return OkResult(result);
                    }

                case SalePointPostType.UpdateItemInSalePoint:
                    {
                        var reqModel = GetRequestData<UpdateItemInSalePointReq>();
                        var result = await _salePointBusiness.UpdateItemInSalePoint(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdateFeeOutSite:
                    {
                        var reqModel = GetRequestData<UpdateFeeOutSiteReq>();
                        var result = await _salePointBusiness.UpdateFeeOutSite(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdateOrCreateGuest:
                    {
                        var reqModel = GetRequestData<UpdateOrCreateGuestReq>();
                        var result = await _salePointBusiness.UpdateOrCreateGuest(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdateOrCreateGuestAction:
                    {
                        var reqModel = GetRequestData<UpdateOrCreateGuestActionReq>();
                        var result = await _salePointBusiness.UpdateOrCreateGuestAction(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.CreateListConfirmPayment:
                    {
                        var reqModel = GetRequestData<CreateListConfirmPaymentReq>();
                        var result = await _salePointBusiness.CreateListConfirmPayment(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.ConfirmListPayment:
                    {
                        var reqModel = GetRequestData<ConfirmListPaymentReq>();
                        var result = await _salePointBusiness.ConfirmListPayment(reqModel);
                         return OkResult(result);
                    }
                case SalePointPostType.UpdateCommission:
                    {
                        var reqModel = GetRequestData<UpdateCommissionReq>();
                        var result = await _salePointBusiness.UpdateCommission(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdateHistoryOrder:
                    {
                        var reqModel = GetRequestData<UpdateHistoryOrderReq>();
                        var result = await _salePointBusiness.UpdateHistoryOrder(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.InsertUpdateTransaction:
                    {
                        var reqModel = GetRequestData<InsertUpdateTransactionReq>();
                        var result = await _salePointBusiness.InsertUpdateTransaction(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdateDateOffOfLeader:
                    {
                        var reqModel = GetRequestData<UpdateDateOffOfLeaderReq>();
                        var result = await _salePointBusiness.UpdateDateOffOfLeader(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdateLeaderAttendent:
                    {
                        var reqModel = GetRequestData<UpdateLeaderAttendentReq>();
                        var result = await _salePointBusiness.UpdateLeaderAttendent(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdatePercent:
                    {
                        var reqModel = GetRequestData<UpdatePercentReq>();
                        var result = await _salePointBusiness.UpdatePercent(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.UpdateCommisionAndFee:
                    {
                        var reqModel = GetRequestData<UpdateCommisionAndFeeReq>();
                        var result = await _salePointBusiness.UpdateCommisionAndFee(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.DeleteStaffInCommissionWining:
                    {
                        var reqModel = GetRequestData<DeleteStaffInCommissionWiningReq>();
                        var result = await _salePointBusiness.DeleteStaffInCommissionWining(reqModel);
                        return OkResult(result);
                    }
                case SalePointPostType.CreateSubAgency:
                    {
                        var reqModel = GetRequestData<CreateSubAgencyReq>();
                        var result = await _salePointBusiness.CreateSubAgency(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }

        

    }
}
