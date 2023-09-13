using System.Collections.Generic;
using System.Threading.Tasks;
using KTHub.Core.Client;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.SalePoint;
using TANPHAT.CRM.Domain.Models.SalePoint.Enum;

namespace TANPHAT.CRM.Client
{
    public interface ISalePointClient
    {
        Task<ApiResponse<ReturnMessage>> UpdateSalePoint(UpdateSalePointReq req);

        Task<ApiResponse<List<GetListSalePointModel>>> GetListSalePoint(GetListSalePointReq req);

        Task<ApiResponse<ReturnMessage>> UpdateItemInSalePoint(UpdateItemInSalePointReq req);

        Task<ApiResponse<List<GetListFeeOutsiteModel>>> GetListFeeOutsite(GetListFeeOutsiteReq req);

        Task<ApiResponse<ReturnMessage>> UpdateFeeOutSite(UpdateFeeOutSiteReq req);

        Task<ApiResponse<ReturnMessage>> UpdateOrCreateGuest(UpdateOrCreateGuestReq req);

        Task<ApiResponse<ReturnMessage>> UpdateOrCreateGuestAction(UpdateOrCreateGuestActionReq req);

        Task<ApiResponse<ReturnMessage>> ConfirmListPayment(ConfirmListPaymentReq req);

        Task<ApiResponse<ReturnMessage>> CreateListConfirmPayment(CreateListConfirmPaymentReq req);

        Task<ApiResponse<ReturnMessage>> UpdateCommission(UpdateCommissionReq req);

        Task<ApiResponse<ReturnMessage>> UpdateHistoryOrder(UpdateHistoryOrderReq req);

        Task<ApiResponse<ReturnMessage>> InsertUpdateTransaction(InsertUpdateTransactionReq req);

        Task<ApiResponse<ReturnMessage>> UpdateDateOffOfLeader(UpdateDateOffOfLeaderReq req);

        Task<ApiResponse<ReturnMessage>> UpdateLeaderAttendent(UpdateLeaderAttendentReq req);

        Task<ApiResponse<ReturnMessage>> UpdatePercent(UpdatePercentReq req);

        Task<ApiResponse<List<GetListItemConfirmModel>>> GetListItemConfirm(GetListItemConfirmReq req);

        Task<ApiResponse<List<GetListConfirmPaymentModel>>> GetListConfirmPayment(GetListConfirmPaymentReq req);

        Task<ApiResponse<List<ListComissionModel>>> GetListComission(ListCommissionReq req);

        Task<ApiResponse<List<ListHistoryOrderModel>>> GetListHistoryOrder(ListHistoryOrderReq req);

        Task<ApiResponse<List<ListUserByDateAndSalePointModel>>> GetListUserByDateAndSalePoint(ListUserByDateAndSalePointReq req);

        Task<ApiResponse<List<DataForGuestReturnModel>>> GetDataForGuestReturn(DataForGuestReturnReq req);

        Task<ApiResponse<List<GuestForConfirmModel>>> GetListGuestForConfirm(GuestForConfirmReq req);

        Task<ApiResponse<List<FeeOfCommissionModel>>> GetListFeeOfCommission(FeeOfCommissionReq req);

        Task<ApiResponse<List<TransactionModel>>> GetListTransaction(TransactionReq req);

        Task<ApiResponse<List<PaymentForConfirmModel>>> GetListPaymentForConfirm(PaymentForConfirmReq req);

        Task<ApiResponse<List<SalePointOfLeaderModel>>> GetListSalePointOfLeader(SalePointOfLeaderReq req);

        Task<ApiResponse<List<ListAttendentOfLeaderModel>>> GetListAttendentOfLeader(ListAttendentOfLeaderReq req);
        
        Task<ApiResponse<List<ListSaleOfVietLottInDateModel>>> GetListSaleOfVietLottInDate(ListSaleOfVietLottInDateReq req);

        Task<ApiResponse<List<ListSaleOfVietLottInMonthModel>>> GetListSaleOfVietLottInMonth(ListSaleOfVietLottInMonthReq req);

        Task<ApiResponse<List<ListSaleOfLotoInMonthModel>>> GetListSaleOfLotoInMonth(ListSaleOfLotoInMonthReq req);

        Task<ApiResponse<List<ListFeeOutSiteInMonthModel>>> GetListFeeOutSiteInMonth(ListFeeOutSiteInMonthReq req);

        Task<ApiResponse<List<ListHistoryOfGuestModel>>> GetListHistoryOfGuest(ListHistoryOfGuestReq req);

        Task<ApiResponse<List<ListPayVietlottModel>>> GetListPayVietlott(ListPayVietlottReq req);

        Task<ApiResponse<List<ListSalePointPercentModel>>> GetListSalePointPercent(ListSalePointPercentReq req);

        Task<ApiResponse<List<ListLotteryAwardExpectedModel>>> GetListLotteryAwardExpected(ListLotteryAwardExpectedReq req);

        Task<ApiResponse<ListUnionInYearModel>> GetListUnionInYear(ListUnionInYearReq req);
        Task<ApiResponse<List<GetListOtherFeesModel>>> GetListOtherFees(GetListOtherFeesReq req);
        Task<ApiResponse<List<GetTotalCommisionAndFeeModel>>> GetTotalCommisionAndFee(GetTotalCommisionAndFeeReq req);
        Task<ApiResponse<ReturnMessage>> UpdateCommisionAndFee(UpdateCommisionAndFeeReq req);
        Task<ApiResponse<ReturnMessage>> DeleteStaffInCommissionWining(DeleteStaffInCommissionWiningReq req);
        Task<ApiResponse<ReturnMessage>> CreateSubAgency(CreateSubAgencyReq req);
        Task<ApiResponse<List<GetAllStaticFeeModel>>> GetAllStaticFee(GetAllStaticFeeReq req);
    }

    public class SalePointClient : BaseApiClient, ISalePointClient
    {
        private string urlSend { get; set; }

        public SalePointClient(ApiConfigs configs) : base(configs)
        {
            urlSend = base.GetUrlSend(UrlCommon.T_SalePoint);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateSalePoint(UpdateSalePointReq req)
        {
            req.TypeName = SalePointPostType.UpdateSalePoint;
            return await PostAsync<ReturnMessage, UpdateSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListSalePointModel>>> GetListSalePoint(GetListSalePointReq req)
        {
            req.TypeName = SalePointGetType.GetListSalePoint;
            return await GetAsync<List<GetListSalePointModel>, GetListSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateItemInSalePoint(UpdateItemInSalePointReq req)
        {
            req.TypeName = SalePointPostType.UpdateItemInSalePoint;
            return await PostAsync<ReturnMessage, UpdateItemInSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListFeeOutsiteModel>>> GetListFeeOutsite(GetListFeeOutsiteReq req)
        {
            req.TypeName = SalePointGetType.GetListFeeOutsite;
            return await GetAsync<List<GetListFeeOutsiteModel>, GetListFeeOutsiteReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateFeeOutSite(UpdateFeeOutSiteReq req)
        {
            req.TypeName = SalePointPostType.UpdateFeeOutSite;
            return await PostAsync<ReturnMessage, UpdateFeeOutSiteReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateOrCreateGuest(UpdateOrCreateGuestReq req)
        {
            req.TypeName = SalePointPostType.UpdateOrCreateGuest;
            return await PostAsync<ReturnMessage, UpdateOrCreateGuestReq>(urlSend, req);
        }
        public async Task<ApiResponse<List<GetListItemConfirmModel>>> GetListItemConfirm(GetListItemConfirmReq req)
        {
            req.TypeName = SalePointGetType.GetListItemConfirm;
            return await GetAsync<List<GetListItemConfirmModel>, GetListItemConfirmReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateOrCreateGuestAction(UpdateOrCreateGuestActionReq req)
        {
            req.TypeName = SalePointPostType.UpdateOrCreateGuestAction;
            return await PostAsync<ReturnMessage, UpdateOrCreateGuestActionReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> CreateListConfirmPayment(CreateListConfirmPaymentReq req)
        {
            req.TypeName = SalePointPostType.CreateListConfirmPayment;
            return await PostAsync<ReturnMessage, CreateListConfirmPaymentReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListConfirmPaymentModel>>> GetListConfirmPayment(GetListConfirmPaymentReq req)
        {
            req.TypeName = SalePointGetType.GetListConfirmPayment;
            return await GetAsync<List<GetListConfirmPaymentModel>, GetListConfirmPaymentReq>(urlSend, req);
        }
        public async Task<ApiResponse<List<ListComissionModel>>> GetListComission(ListCommissionReq req)
        {
            req.TypeName = SalePointGetType.GetListCommission;
            return await GetAsync<List<ListComissionModel>, ListCommissionReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ConfirmListPayment(ConfirmListPaymentReq req)
        {
            req.TypeName = SalePointPostType.ConfirmListPayment;
            return await PostAsync<ReturnMessage, ConfirmListPaymentReq>(urlSend, req);
         }

        public async Task<ApiResponse<ReturnMessage>> UpdateCommission(UpdateCommissionReq req)
        {
            req.TypeName = SalePointPostType.UpdateCommission;
            return await PostAsync<ReturnMessage, UpdateCommissionReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateHistoryOrder(UpdateHistoryOrderReq req)
        {
            req.TypeName = SalePointPostType.UpdateHistoryOrder;
            return await PostAsync<ReturnMessage, UpdateHistoryOrderReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListHistoryOrderModel>>> GetListHistoryOrder(ListHistoryOrderReq req)
        {
            req.TypeName = SalePointGetType.GetListHistoryOrder;
            return await GetAsync<List<ListHistoryOrderModel>, ListHistoryOrderReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> InsertUpdateTransaction(InsertUpdateTransactionReq req)
        {
            req.TypeName = SalePointPostType.InsertUpdateTransaction;
            return await PostAsync<ReturnMessage, InsertUpdateTransactionReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListUserByDateAndSalePointModel>>> GetListUserByDateAndSalePoint(ListUserByDateAndSalePointReq req)
        {
            req.TypeName = SalePointGetType.GetListUserByDateAndSalePoint;
            return await GetAsync<List<ListUserByDateAndSalePointModel>, ListUserByDateAndSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataForGuestReturnModel>>> GetDataForGuestReturn(DataForGuestReturnReq req)
        {
            req.TypeName = SalePointGetType.GetDataForGuestReturn;
            return await GetAsync<List<DataForGuestReturnModel>, DataForGuestReturnReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GuestForConfirmModel>>> GetListGuestForConfirm(GuestForConfirmReq req)
        {
            req.TypeName = SalePointGetType.GetListGuestForConfirm;
            return await GetAsync<List<GuestForConfirmModel>, GuestForConfirmReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<FeeOfCommissionModel>>> GetListFeeOfCommission(FeeOfCommissionReq req)
        {
            req.TypeName = SalePointGetType.GetListFeeOfCommission;
            return await GetAsync<List<FeeOfCommissionModel>, FeeOfCommissionReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<TransactionModel>>> GetListTransaction(TransactionReq req)
        {
            req.TypeName = SalePointGetType.GetListTransaction;
            return await GetAsync<List<TransactionModel>, TransactionReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<PaymentForConfirmModel>>> GetListPaymentForConfirm(PaymentForConfirmReq req)
        {
            req.TypeName = SalePointGetType.GetListPaymentForConfirm;
            return await GetAsync<List<PaymentForConfirmModel>, PaymentForConfirmReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<SalePointOfLeaderModel>>> GetListSalePointOfLeader(SalePointOfLeaderReq req)
        {
            req.TypeName = SalePointGetType.GetListSalePointOfLeader;
            return await GetAsync<List<SalePointOfLeaderModel>, SalePointOfLeaderReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateDateOffOfLeader(UpdateDateOffOfLeaderReq req)
        {
            req.TypeName = SalePointPostType.UpdateDateOffOfLeader;
            return await PostAsync<ReturnMessage, UpdateDateOffOfLeaderReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListAttendentOfLeaderModel>>> GetListAttendentOfLeader(ListAttendentOfLeaderReq req)
        {
            req.TypeName = SalePointGetType.GetListAttendentOfLeader;
            return await GetAsync<List<ListAttendentOfLeaderModel>, ListAttendentOfLeaderReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateLeaderAttendent(UpdateLeaderAttendentReq req)
        {
            req.TypeName = SalePointPostType.UpdateLeaderAttendent;
            return await PostAsync<ReturnMessage, UpdateLeaderAttendentReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListSaleOfVietLottInDateModel>>> GetListSaleOfVietLottInDate(ListSaleOfVietLottInDateReq req)
        {
            req.TypeName = SalePointGetType.GetListSaleOfVietLottInDate;
            return await GetAsync<List<ListSaleOfVietLottInDateModel>, ListSaleOfVietLottInDateReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListSaleOfVietLottInMonthModel>>> GetListSaleOfVietLottInMonth(ListSaleOfVietLottInMonthReq req)
        {
            req.TypeName = SalePointGetType.GetListSaleOfVietLottInMonth;
            return await GetAsync<List<ListSaleOfVietLottInMonthModel>, ListSaleOfVietLottInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListSaleOfLotoInMonthModel>>> GetListSaleOfLotoInMonth(ListSaleOfLotoInMonthReq req)
        {
            req.TypeName = SalePointGetType.GetListSaleOfLotoInMonth;
            return await GetAsync<List<ListSaleOfLotoInMonthModel>, ListSaleOfLotoInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListFeeOutSiteInMonthModel>>> GetListFeeOutSiteInMonth(ListFeeOutSiteInMonthReq req)
        {
            req.TypeName = SalePointGetType.GetListFeeOutSiteInMonth;
            return await GetAsync<List<ListFeeOutSiteInMonthModel>, ListFeeOutSiteInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<ListUnionInYearModel>> GetListUnionInYear(ListUnionInYearReq req)
        {
            req.TypeName = SalePointGetType.GetListUnionInYear;
            return await GetAsync<ListUnionInYearModel, ListUnionInYearReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListHistoryOfGuestModel>>> GetListHistoryOfGuest(ListHistoryOfGuestReq req)
        {
            req.TypeName = SalePointGetType.GetListHistoryOfGuest;
            return await GetAsync<List<ListHistoryOfGuestModel>, ListHistoryOfGuestReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListPayVietlottModel>>> GetListPayVietlott(ListPayVietlottReq req)
        {
            req.TypeName = SalePointGetType.GetListPayVietlott;
            return await GetAsync<List<ListPayVietlottModel>, ListPayVietlottReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListSalePointPercentModel>>> GetListSalePointPercent(ListSalePointPercentReq req)
        {
            req.TypeName = SalePointGetType.GetListSalePointPercent;
            return await GetAsync<List<ListSalePointPercentModel>, ListSalePointPercentReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdatePercent(UpdatePercentReq req)
        {
            req.TypeName = SalePointPostType.UpdatePercent;
            return await PostAsync<ReturnMessage, UpdatePercentReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListLotteryAwardExpectedModel>>> GetListLotteryAwardExpected(ListLotteryAwardExpectedReq req)
        {
            req.TypeName = SalePointGetType.GetListLotteryAwardExpected;
            return await GetAsync<List<ListLotteryAwardExpectedModel>, ListLotteryAwardExpectedReq>(urlSend, req);
        }
        public async Task<ApiResponse<List<GetListOtherFeesModel>>> GetListOtherFees(GetListOtherFeesReq req)
        {
            req.TypeName = SalePointGetType.GetListOtherFees;
            return await GetAsync<List<GetListOtherFeesModel>, GetListOtherFeesReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetTotalCommisionAndFeeModel>>> GetTotalCommisionAndFee(GetTotalCommisionAndFeeReq req)
        {
            req.TypeName = SalePointGetType.GetTotalCommisionAndFee;
            return await GetAsync<List<GetTotalCommisionAndFeeModel>, GetTotalCommisionAndFeeReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateCommisionAndFee(UpdateCommisionAndFeeReq req)
        {
            req.TypeName = SalePointPostType.UpdateCommisionAndFee;
            return await PostAsync<ReturnMessage, UpdateCommisionAndFeeReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DeleteStaffInCommissionWining(DeleteStaffInCommissionWiningReq req)
        {
            req.TypeName = SalePointPostType.DeleteStaffInCommissionWining;
            return await PostAsync<ReturnMessage, DeleteStaffInCommissionWiningReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> CreateSubAgency(CreateSubAgencyReq req)
        {
            req.TypeName = SalePointPostType.CreateSubAgency;
            return await PostAsync<ReturnMessage, CreateSubAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetAllStaticFeeModel>>> GetAllStaticFee(GetAllStaticFeeReq req)
        {
            req.TypeName = SalePointGetType.GetAllStaticFee;
            return await GetAsync<List<GetAllStaticFeeModel>, GetAllStaticFeeReq>(urlSend, req);
        }
    }
}
