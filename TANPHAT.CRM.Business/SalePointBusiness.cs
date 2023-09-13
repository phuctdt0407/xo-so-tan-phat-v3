using System.Collections.Generic;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.SalePoint;
using TANPHAT.CRM.Provider;

namespace TANPHAT.CRM.Business
{
    public interface ISalePointBusiness
    {
        Task<ReturnMessage> UpdateSalePoint(UpdateSalePointReq req);

        Task<ReturnMessage> UpdateItemInSalePoint(UpdateItemInSalePointReq req);

        Task<ReturnMessage> UpdateFeeOutSite(UpdateFeeOutSiteReq req);

        Task<ReturnMessage> UpdateOrCreateGuest(UpdateOrCreateGuestReq req);

        Task<ReturnMessage> UpdateOrCreateGuestAction(UpdateOrCreateGuestActionReq req);

        Task<ReturnMessage> ConfirmListPayment(ConfirmListPaymentReq req);

        Task<ReturnMessage> CreateListConfirmPayment(CreateListConfirmPaymentReq req);

        Task<ReturnMessage> UpdateCommission(UpdateCommissionReq req);

        Task<ReturnMessage> UpdateHistoryOrder(UpdateHistoryOrderReq req);

        Task<ReturnMessage> InsertUpdateTransaction(InsertUpdateTransactionReq req);

        Task<ReturnMessage> UpdateDateOffOfLeader(UpdateDateOffOfLeaderReq req);

        Task<ReturnMessage> UpdateLeaderAttendent(UpdateLeaderAttendentReq req);

        Task<ReturnMessage> UpdatePercent(UpdatePercentReq req);

        Task<List<GetListSalePointModel>> GetListSalePoint(GetListSalePointReq req);

        Task<List<GetListFeeOutsiteModel>> GetListFeeOutsite(GetListFeeOutsiteReq req);

        Task<List<GetListItemConfirmModel>> GetListItemConfirm(GetListItemConfirmReq req);

        Task<List<GetListConfirmPaymentModel>> GetListConfirmPayment(GetListConfirmPaymentReq req);

        Task<List<ListComissionModel>> GetListComission(ListCommissionReq req);

        Task<List<ListHistoryOrderModel>> GetListHistoryOrder(ListHistoryOrderReq req);

        Task<List<ListUserByDateAndSalePointModel>> GetListUserByDateAndSalePoint(ListUserByDateAndSalePointReq req);

        Task<List<DataForGuestReturnModel>> GetDataForGuestReturn(DataForGuestReturnReq req);

        Task<List<GuestForConfirmModel>> GetListGuestForConfirm(GuestForConfirmReq req);

        Task<List<FeeOfCommissionModel>> GetListFeeOfCommission(FeeOfCommissionReq req);

        Task<List<TransactionModel>> GetListTransaction(TransactionReq req);

        Task<List<PaymentForConfirmModel>> GetListPaymentForConfirm(PaymentForConfirmReq req);

        Task<List<SalePointOfLeaderModel>> GetListSalePointOfLeader(SalePointOfLeaderReq req);

        Task<List<ListAttendentOfLeaderModel>> GetListAttendentOfLeader(ListAttendentOfLeaderReq req);
        
        Task<List<ListSaleOfVietLottInDateModel>> GetListSaleOfVietLottInDate(ListSaleOfVietLottInDateReq req);

        Task<List<ListSaleOfVietLottInMonthModel>> GetListSaleOfVietLottInMonth(ListSaleOfVietLottInMonthReq req);

        Task<List<ListSaleOfLotoInMonthModel>> GetListSaleOfLotoInMonth(ListSaleOfLotoInMonthReq req);

        Task<List<ListFeeOutSiteInMonthModel>> GetListFeeOutSiteInMonth(ListFeeOutSiteInMonthReq req);

        Task<List<ListHistoryOfGuestModel>> GetListHistoryOfGuest(ListHistoryOfGuestReq req);

        Task<List<ListPayVietlottModel>> GetListPayVietlott(ListPayVietlottReq req);

        Task<List<ListSalePointPercentModel>> GetListSalePointPercent(ListSalePointPercentReq req);

        Task<List<ListLotteryAwardExpectedModel>> GetListLotteryAwardExpected(ListLotteryAwardExpectedReq req);

        Task<ListUnionInYearModel> GetListUnionInYear(ListUnionInYearReq req);
        Task<List<GetListOtherFeesModel>> GetListOtherFees(GetListOtherFeesReq req);
        Task<List<GetTotalCommisionAndFeeModel>> GetTotalCommisionAndFee(GetTotalCommisionAndFeeReq req);
        Task<ReturnMessage> UpdateCommisionAndFee(UpdateCommisionAndFeeReq req);
        Task<ReturnMessage> DeleteStaffInCommissionWining(DeleteStaffInCommissionWiningReq req);
        Task<ReturnMessage> CreateSubAgency(CreateSubAgencyReq req);
        Task<List<GetAllStaticFeeModel>> GetAllStaticFee(GetAllStaticFeeReq req);
    }

    public class SalePointBusiness : ISalePointBusiness
    {
        private ISalePointProvider _salePointProvider;

        public SalePointBusiness(ISalePointProvider salePointProvider)
        {
            _salePointProvider = salePointProvider;
        }

        public async Task<ReturnMessage> CreateListConfirmPayment(CreateListConfirmPaymentReq req)
        {
            var res = await _salePointProvider.CreateListConfirmPayment(req);
            return res;
        }

        public async Task<List<GetListConfirmPaymentModel>> GetListConfirmPayment(GetListConfirmPaymentReq req)
        {
            var res = await _salePointProvider.GetListConfirmPayment(req);
            return res;
        }
        public async Task<List<ListComissionModel>> GetListComission(ListCommissionReq req)
        {
            var res = await _salePointProvider.GetListComission(req);
            return res;
        }

        public async Task<List<GetListFeeOutsiteModel>> GetListFeeOutsite(GetListFeeOutsiteReq req)
        {
            var res = await _salePointProvider.GetListFeeOutsite(req);
            return res;
        }

        public async Task<List<ListHistoryOrderModel>> GetListHistoryOrder(ListHistoryOrderReq req)
        {
            var res = await _salePointProvider.GetListHistoryOrder(req);
            return res;
        }

        public async Task<List<GetListItemConfirmModel>> GetListItemConfirm(GetListItemConfirmReq req)
        {
            var res = await _salePointProvider.GetListItemConfirm(req);
            return res;
        }

        public async Task<List<GetListSalePointModel>> GetListSalePoint(GetListSalePointReq req)
        {
            var res = await _salePointProvider.GetListSalePoint(req);
            return res;
        }

        public async Task<List<ListUserByDateAndSalePointModel>> GetListUserByDateAndSalePoint(ListUserByDateAndSalePointReq req)
        {
            var res = await _salePointProvider.GetListUserByDateAndSalePoint(req);
            return res;
        }

        public async Task<ReturnMessage> InsertUpdateTransaction(InsertUpdateTransactionReq req)
        {
            var res = await _salePointProvider.InsertUpdateTransaction(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateCommission(UpdateCommissionReq req)
        {
            var res = await _salePointProvider.UpdateCommission(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateFeeOutSite(UpdateFeeOutSiteReq req)
        {
            var res = await _salePointProvider.UpdateFeeOutSite(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateHistoryOrder(UpdateHistoryOrderReq req)
        {
            var res = await _salePointProvider.UpdateHistoryOrder(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateItemInSalePoint(UpdateItemInSalePointReq req)
        {
            var res = await _salePointProvider.UpdateItemInSalePoint(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateOrCreateGuest(UpdateOrCreateGuestReq req)
        {
            var res = await _salePointProvider.UpdateOrCreateGuest(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateOrCreateGuestAction(UpdateOrCreateGuestActionReq req)
        {
            var res = await _salePointProvider.UpdateOrCreateGuestAction(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateSalePoint(UpdateSalePointReq req)
        {
            var res = await _salePointProvider.UpdateSalePoint(req);
            return res;
        }

        public async Task<ReturnMessage> ConfirmListPayment(ConfirmListPaymentReq req)
        {
            var res = await _salePointProvider.ConfirmListPayment(req);
            return res;
        }

        public async Task<List<DataForGuestReturnModel>> GetDataForGuestReturn(DataForGuestReturnReq req)
        {
            var res = await _salePointProvider.GetDataForGuestReturn(req);
            return res;
        }

        public async Task<List<GuestForConfirmModel>> GetListGuestForConfirm(GuestForConfirmReq req)
        {
            var res = await _salePointProvider.GetListGuestForConfirm(req);
            return res;
        }

        public async Task<List<FeeOfCommissionModel>> GetListFeeOfCommission(FeeOfCommissionReq req)
        {
            var res = await _salePointProvider.GetListFeeOfCommission(req);
            return res;
        }

        public async Task<List<TransactionModel>> GetListTransaction(TransactionReq req)
        {
            var res = await _salePointProvider.GetListTransaction(req);
            return res;
        }

        public async Task<List<PaymentForConfirmModel>> GetListPaymentForConfirm(PaymentForConfirmReq req)
        {
            var res = await _salePointProvider.GetListPaymentForConfirm(req);
            return res;
        }

        public async Task<List<SalePointOfLeaderModel>> GetListSalePointOfLeader(SalePointOfLeaderReq req)
        {
            var res = await _salePointProvider.GetListSalePointOfLeader(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateDateOffOfLeader(UpdateDateOffOfLeaderReq req)
        {
            var res = await _salePointProvider.UpdateDateOffOfLeader(req);
            return res;
        }

        public async Task<List<ListAttendentOfLeaderModel>> GetListAttendentOfLeader(ListAttendentOfLeaderReq req)
        {
            var res = await _salePointProvider.GetListAttendentOfLeader(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateLeaderAttendent(UpdateLeaderAttendentReq req)
        {
            var res = await _salePointProvider.UpdateLeaderAttendent(req);
            return res;
        }

        public async Task<List<ListSaleOfVietLottInDateModel>> GetListSaleOfVietLottInDate(ListSaleOfVietLottInDateReq req)
        {
            var res = await _salePointProvider.GetListSaleOfVietLottInDate(req);
            return res;
        }

        public async Task<List<ListSaleOfVietLottInMonthModel>> GetListSaleOfVietLottInMonth(ListSaleOfVietLottInMonthReq req)
        {
            var res = await _salePointProvider.GetListSaleOfVietLottInMonth(req);
            return res;
        }

        public async Task<List<ListSaleOfLotoInMonthModel>> GetListSaleOfLotoInMonth(ListSaleOfLotoInMonthReq req)
        {
            var res = await _salePointProvider.GetListSaleOfLotoInMonth(req);
            return res;
        }

        public async Task<List<ListFeeOutSiteInMonthModel>> GetListFeeOutSiteInMonth(ListFeeOutSiteInMonthReq req)
        {
            var res = await _salePointProvider.GetListFeeOutSiteInMonth(req);
            return res;
        }

        public async Task<ListUnionInYearModel> GetListUnionInYear(ListUnionInYearReq req)
        {
            var res = await _salePointProvider.GetListUnionInYear(req);
            return res;
        }

        public async Task<List<ListHistoryOfGuestModel>> GetListHistoryOfGuest(ListHistoryOfGuestReq req)
        {
            var res = await _salePointProvider.GetListHistoryOfGuest(req);
            return res;
        }

        public async Task<List<ListPayVietlottModel>> GetListPayVietlott(ListPayVietlottReq req)
        {
            var res = await _salePointProvider.GetListPayVietlott(req);
            return res;
        }

        public async Task<List<ListSalePointPercentModel>> GetListSalePointPercent(ListSalePointPercentReq req)
        {
            var res = await _salePointProvider.GetListSalePointPercent(req);
            return res;
        }

        public async Task<ReturnMessage> UpdatePercent(UpdatePercentReq req)
        {
            var res = await _salePointProvider.UpdatePercent(req);
            return res;
        }

        public async Task<List<ListLotteryAwardExpectedModel>> GetListLotteryAwardExpected(ListLotteryAwardExpectedReq req)
        {
            var res = await _salePointProvider.GetListLotteryAwardExpected(req);
            return res;
        }
        public async Task<List<GetListOtherFeesModel>> GetListOtherFees(GetListOtherFeesReq req)
        {
            var res = await _salePointProvider.GetListOtherFees(req);
            return res;
        }

        public async Task<List<GetTotalCommisionAndFeeModel>> GetTotalCommisionAndFee(GetTotalCommisionAndFeeReq req)
        {
            var res = await _salePointProvider.GetTotalCommisionAndFee(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateCommisionAndFee(UpdateCommisionAndFeeReq req)
        {
            var res = await _salePointProvider.UpdateCommisionAndFee(req);
            return res;
        }

        public async Task<ReturnMessage> DeleteStaffInCommissionWining(DeleteStaffInCommissionWiningReq req)
        {
            var res = await _salePointProvider.DeleteStaffInCommissionWining(req);
            return res;
        }

        public async Task<ReturnMessage> CreateSubAgency(CreateSubAgencyReq req)
        {
            var res = await _salePointProvider.CreateSubAgency(req);
            return res;
        }

        public async Task<List<GetAllStaticFeeModel>> GetAllStaticFee(GetAllStaticFeeReq req)
        {
            var res = await _salePointProvider.GetAllStaticFee(req);
            return res;
        }
    }
}
