using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using KTHub.Core.Client;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity;
using TANPHAT.CRM.Domain.Models.Activity.Enum;

namespace TANPHAT.CRM.Client
{
    public interface IActivityClient
    {
        Task<ApiResponse<ReturnMessage>> UpdateActivityGuestAction(UpdateActivityGuestActionReq req);
        Task<ApiResponse<ReturnMessage>> ReceiveLotteryFromAgency(ReceivedLotteryFromAgencyReq req);

        Task<ApiResponse<List<DataReceivedFromAgencyModel>>> GetDataReceivedFromAgency(DataReceivedFromAgencyReq req);

        Task<ApiResponse<ReturnMessage>> DistributeForSalesPoint(DistributeForSalePointReq req);

        Task<ApiResponse<List<DataDistributeForSalePointModel>>> GetDataDistributeForSalePoint(
            DataDistributeForSalePointReq req);

        Task<ApiResponse<List<GetTmpWinningTicketModel>>> GetTmpWinningTicket(GetTmpWinningTicketReq req);
        
        Task<ApiResponse<ReturnMessage>> InsertOrUpdateAgency(InsertOrUpdateAgencyReq req);
        Task<ApiResponse<ReturnMessage>> SellLottery(SellLotteryReq req);
        Task<ApiResponse<DataSellModel>> GetDataSell(DataSellReq req);

        Task<ApiResponse<ReturnMessage>> InsertTransitionLog(InsertTransitionLogReq req);

        Task<ApiResponse<List<SalePointLogModel>>> GetSalePointLog(SalePointLogReq req);

        Task<ApiResponse<ReturnMessage>> InsertRepayment(InsertRepaymentReq req);

        Task<ApiResponse<DataSellModel>> GetDataInventory(DataSellReq req);

        Task<ApiResponse<List<RepaymentLogModel>>> GetRepaymentLog(SalePointLogReq req);

        Task<ApiResponse<List<InventoryLogModel>>> GetInventoryLog(DataSellReq req);
        
        Task<ApiResponse<ReturnMessage>> InsertWinningLottery(InsertWinningLotteryReq req);
        Task<ApiResponse<ReturnMessage>> InsertOrUpdateSubAgency(InsertOrUpdateSubAgencyReq req);
        Task<ApiResponse<ReturnMessage>> ShiftTransfer(ShiftTransferReq req);

        Task<ApiResponse<ReturnMessage>> ReceiveScratchcardFromAgency(ReceiveScratchcardFromAgencyReq req);

        Task<ApiResponse<List<DataScratchcardFromAgency>>> GetDataScratchcardFromAgency(
            DataScratchcardFromAgencyReq req);
        Task<ApiResponse<List<GetListSubAgencyModel>>> GetListSubAgency(GetListSubAgencyReq req);
        
        Task<ApiResponse<ReturnMessage>> DistributeScratchForSalesPoint(DistributeScratchForSalePointReq req);

        Task<ApiResponse<ScratchcardFullModel>> GetScratchcardFull();

        Task<ApiResponse<List<DataDistributeScratchForSalePointModel>>> GetDataDistributeScratchForSalePoint();
        Task<ApiResponse<List<DataDistributeScratchForSubAgencyModel>>> GetDataDistributeScratchForSubAgency();

        Task<ApiResponse<List<WinningListModel>>> GetWinningList(WinningListReq req);

        Task<ApiResponse<List<TransitionListToConfirmModel>>>
            GetTransitionListToConfirm(TransitionListToConfirmReq req);

        Task<ApiResponse<List<ShiftDistributeByDateModel>>> GetShiftDistributeByDate(ShiftDistributeByDateReq req);

        Task<ApiResponse<ReturnMessage>> ConfirmTransition(ConfirmTransitionReq req);
        Task<ApiResponse<ReturnMessage>> UpdateIsdeletedSalepointLog(UpdateIsdeletedSalepointLogReq req);

        Task<ApiResponse<List<SoldLogDetailModel>>> GetSoldLogDetail(SalePointLogReq req);
        Task<ApiResponse<List<GetListLotteryPriceSubAgencyModel>>> GetListLotteryPriceSubAgency(GetListLotteryPriceSubAgencyReq req);
        Task<ApiResponse<List<TransLogDetailModel>>> GetTransLogDetail(SalePointLogReq req);

        Task<ApiResponse<List<InventoryLogModel>>> GetSalePointReturn(DataSellReq req);

        Task<ApiResponse<ReturnMessage>> CreateSalePoint(CreateSalePointReq req);

        Task<ApiResponse<ReturnMessage>> UpdateLotteryPriceAgency(UpdateLotteryPriceAgencyReq req);
        Task<ApiResponse<ReturnMessage>> UpdateLotteryPriceSubAgency(UpdateLotteryPriceSubAgencyReq req);

        Task<ApiResponse<ReturnMessage>> ReturnLottery(ReturnLotteryReq req);

        Task<ApiResponse<ReturnMessage>> UpdateConstantPrice(UpdateConstantPriceReq req);

        Task<ApiResponse<ReturnMessage>> DeleteLogWinning(DeleteLogWinningReq req);

        Task<ApiResponse<List<LotteryPriceAgencyModel>>> GetLotteryPriceAgency(LotteryPriceAgencyReq req);

        Task<ApiResponse<List<LotteryForReturnModel>>> GetListLotteryForReturn(LotteryForReturnReq req);

        Task<ApiResponse<List<GetListHistoryForManagerModel>>>GetListHistoryForManager(GetListHistoryForManagerReq req);

        Task<ApiResponse<List<GetListReportMoneyInADayModel>>>GetListReportMoneyInADay(GetListReportMoneyInADayReq req);

        Task<ApiResponse<ReturnMessage>> UpdateReportMoneyInAShift(UpdateReportMoneyInAShiftReq req);

        Task<ApiResponse<ReturnMessage>> UpdatePriceForGuest(UpdatePriceForGuestReq req);

        Task<ApiResponse<ReturnMessage>> DeleteGuestAction(DeleteGuestActionReq req);
        Task<ApiResponse<ReturnMessage>> DistributeForSubAgency(DistributeForSubAgencyReq req);
        Task<ApiResponse<List<GetDataSubAgencyModel>>> GetDataSubAgency(GetDataSubAgencyReq req);
        Task<ApiResponse<ReturnMessage>> UpdatePriceForSubAgency(UpdatePriceForSubAgencyReq req);
        Task<ApiResponse<List<GetStaticFeeModel>>> GetStaticFee(GetStaticFeeReq req);
        Task<ApiResponse<ReturnMessage>> UpdateStaticFee(UpdateStaticFeeReq req);
        Task<ApiResponse<ReturnMessage>> DistributeForSubAgency(DistributeScratchForSubAgencyReq req);
        Task<ApiResponse<List<GetDebtOfStaffModel>>> GetDebtOfStaff(GetDebtOfStaffReq req);
        Task<ApiResponse<ReturnMessage>> UpdateDebt(UpdateDebtReq req);
        Task<ApiResponse<List<GetPayedDebtAndNewDebtAllTimeModel>>> GetPayedDebtAndNewDebtAllTime(GetPayedDebtAndNewDebtAllTimeReq req);
    }

    public class ActivityClient : BaseApiClient, IActivityClient
    {
        private string urlSend { get; set; }

        public ActivityClient(ApiConfigs configs) : base(configs)
        {
            urlSend = base.GetUrlSend(UrlCommon.T_Activity);
        }

        public async Task<ApiResponse<ReturnMessage>> ReceiveLotteryFromAgency(ReceivedLotteryFromAgencyReq req)
        {
            req.TypeName = ActivityPostType.ReceiveLotteryFromAgency;
            return await PostAsync<ReturnMessage, ReceivedLotteryFromAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataReceivedFromAgencyModel>>> GetDataReceivedFromAgency(
            DataReceivedFromAgencyReq req)
        {
            req.TypeName = ActivityGetType.GetDataReceivedFromAgency;
            return await GetAsync<List<DataReceivedFromAgencyModel>, DataReceivedFromAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DistributeForSalesPoint(DistributeForSalePointReq req)
        {
            req.TypeName = ActivityPostType.DistributeForSalesPoint;
            return await PostAsync<ReturnMessage, DistributeForSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataDistributeForSalePointModel>>> GetDataDistributeForSalePoint(
            DataDistributeForSalePointReq req)
        {
            req.TypeName = ActivityGetType.GetDataDistributeForSalePoint;
            return await GetAsync<List<DataDistributeForSalePointModel>, DataDistributeForSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> SellLottery(SellLotteryReq req)
        {
            req.TypeName = ActivityPostType.SellLottery;
            return await PostAsync<ReturnMessage, SellLotteryReq>(urlSend, req);
        }

        public async Task<ApiResponse<DataSellModel>> GetDataSell(DataSellReq req)
        {
            req.TypeName = ActivityGetType.GetDataSell;
            return await GetAsync<DataSellModel, DataSellReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> InsertTransitionLog(InsertTransitionLogReq req)
        {
            req.TypeName = ActivityPostType.InsertTransitionLog;
            return await PostAsync<ReturnMessage, InsertTransitionLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<SalePointLogModel>>> GetSalePointLog(SalePointLogReq req)
        {
            req.TypeName = ActivityGetType.GetSalePointLog;
            return await GetAsync<List<SalePointLogModel>, SalePointLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> InsertRepayment(InsertRepaymentReq req)
        {
            req.TypeName = ActivityPostType.InsertRepayment;
            return await PostAsync<ReturnMessage, InsertRepaymentReq>(urlSend, req);
        }

        public async Task<ApiResponse<DataSellModel>> GetDataInventory(DataSellReq req)
        {
            req.TypeName = ActivityGetType.GetDataInventory;
            return await GetAsync<DataSellModel, DataSellReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<RepaymentLogModel>>> GetRepaymentLog(SalePointLogReq req)
        {
            req.TypeName = ActivityGetType.GetRepaymentLog;
            return await GetAsync<List<RepaymentLogModel>, SalePointLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<InventoryLogModel>>> GetInventoryLog(DataSellReq req)
        {
            req.TypeName = ActivityGetType.GetInventoryLog;
            return await GetAsync<List<InventoryLogModel>, DataSellReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> InsertWinningLottery(InsertWinningLotteryReq req)
        {
            req.TypeName = ActivityPostType.InsertWinningLottery;
            return await PostAsync<ReturnMessage, InsertWinningLotteryReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ShiftTransfer(ShiftTransferReq req)
        {
            req.TypeName = ActivityPostType.ShiftTransfer;
            return await PostAsync<ReturnMessage, ShiftTransferReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ReceiveScratchcardFromAgency(ReceiveScratchcardFromAgencyReq req)
        {
            req.TypeName = ActivityPostType.ReceiveScratchcardFromAgency;
            return await PostAsync<ReturnMessage, ReceiveScratchcardFromAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataScratchcardFromAgency>>> GetDataScratchcardFromAgency(
            DataScratchcardFromAgencyReq req)
        {
            req.TypeName = ActivityGetType.GetDataScratchcardFromAgency;
            return await GetAsync<List<DataScratchcardFromAgency>, DataScratchcardFromAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DistributeScratchForSalesPoint(
            DistributeScratchForSalePointReq req)
        {
            req.TypeName = ActivityPostType.DistributeScratchForSalesPoint;
            return await PostAsync<ReturnMessage, DistributeScratchForSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<ScratchcardFullModel>> GetScratchcardFull()
        {
            return await GetAsync<ScratchcardFullModel, ActivityGetType>(urlSend, ActivityGetType.GetScratchcardFull);
        }

        public async Task<ApiResponse<List<DataDistributeScratchForSalePointModel>>>
            GetDataDistributeScratchForSalePoint()
        {
            return await GetAsync<List<DataDistributeScratchForSalePointModel>, ActivityGetType>(urlSend,
                ActivityGetType.GetDataDistributeScratchForSalePoint);
        }

        public async Task<ApiResponse<List<DataDistributeScratchForSubAgencyModel>>>
            GetDataDistributeScratchForSubAgency()
        {
            return await GetAsync<List<DataDistributeScratchForSubAgencyModel>, ActivityGetType>(urlSend,
                ActivityGetType.GetDataDistributeScratchForSubAgency);
        }
        public async Task<ApiResponse<List<WinningListModel>>> GetWinningList(WinningListReq req)
        {
            req.TypeName = ActivityGetType.GetWinningList;
            return await GetAsync<List<WinningListModel>, WinningListReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<TransitionListToConfirmModel>>> GetTransitionListToConfirm(
            TransitionListToConfirmReq req)
        {
            req.TypeName = ActivityGetType.GetTransitionListToConfirm;
            return await GetAsync<List<TransitionListToConfirmModel>, TransitionListToConfirmReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ShiftDistributeByDateModel>>> GetShiftDistributeByDate(
            ShiftDistributeByDateReq req)
        {
            req.TypeName = ActivityGetType.GetShiftDistributeByDate;
            return await GetAsync<List<ShiftDistributeByDateModel>, ShiftDistributeByDateReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ConfirmTransition(ConfirmTransitionReq req)
        {
            req.TypeName = ActivityPostType.ConfirmTransition;
            return await PostAsync<ReturnMessage, ConfirmTransitionReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<SoldLogDetailModel>>> GetSoldLogDetail(SalePointLogReq req)
        {
            req.TypeName = ActivityGetType.GetSoldLogDetail;
            return await GetAsync<List<SoldLogDetailModel>, SalePointLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<TransLogDetailModel>>> GetTransLogDetail(SalePointLogReq req)
        {
            req.TypeName = ActivityGetType.GetTransLogDetail;
            return await GetAsync<List<TransLogDetailModel>, SalePointLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<InventoryLogModel>>> GetSalePointReturn(DataSellReq req)
        {
            req.TypeName = ActivityGetType.GetSalePointReturn;
            return await GetAsync<List<InventoryLogModel>, DataSellReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> CreateSalePoint(CreateSalePointReq req)
        {
            req.TypeName = ActivityPostType.CreateSalePoint;
            return await PostAsync<ReturnMessage, CreateSalePointReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateLotteryPriceAgency(UpdateLotteryPriceAgencyReq req)
        {
            req.TypeName = ActivityPostType.UpdateLotteryPriceAgency;
            return await PostAsync<ReturnMessage, UpdateLotteryPriceAgencyReq>(urlSend, req);
        }
        public async Task<ApiResponse<ReturnMessage>> UpdateLotteryPriceSubAgency(UpdateLotteryPriceSubAgencyReq req)
        {
            req.TypeName = ActivityPostType.UpdateLotteryPriceSubAgency;
            return await PostAsync<ReturnMessage, UpdateLotteryPriceSubAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<LotteryPriceAgencyModel>>> GetLotteryPriceAgency(LotteryPriceAgencyReq req)
        {
            req.TypeName = ActivityGetType.GetLotteryPriceAgency;
            return await GetAsync<List<LotteryPriceAgencyModel>, LotteryPriceAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<LotteryForReturnModel>>> GetListLotteryForReturn(LotteryForReturnReq req)
        {
            req.TypeName = ActivityGetType.GetListLotteryForReturn;
            return await GetAsync<List<LotteryForReturnModel>, LotteryForReturnReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ReturnLottery(ReturnLotteryReq req)
        {
            req.TypeName = ActivityPostType.ReturnLottery;
            return await PostAsync<ReturnMessage, ReturnLotteryReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateConstantPrice(UpdateConstantPriceReq req)
        {
            req.TypeName = ActivityPostType.UpdateConstantPrice;
            return await PostAsync<ReturnMessage, UpdateConstantPriceReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DeleteLogWinning(DeleteLogWinningReq req)
        {
            req.TypeName = ActivityPostType.DeleteLogWinning;
            return await PostAsync<ReturnMessage, DeleteLogWinningReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListHistoryForManagerModel>>> GetListHistoryForManager(
            GetListHistoryForManagerReq req)
        {
            req.TypeName = ActivityGetType.GetListHistoryForManager;
            return await GetAsync<List<GetListHistoryForManagerModel>, GetListHistoryForManagerReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListReportMoneyInADayModel>>> GetListReportMoneyInADay(
            GetListReportMoneyInADayReq req)
        {
            req.TypeName = ActivityGetType.GetListReportMoneyInADay;
            return await GetAsync<List<GetListReportMoneyInADayModel>, GetListReportMoneyInADayReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateReportMoneyInAShift(UpdateReportMoneyInAShiftReq req)
        {
            req.TypeName = ActivityPostType.UpdateReportMoneyInAShift;
            return await PostAsync<ReturnMessage, UpdateReportMoneyInAShiftReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetTmpWinningTicketModel>>> GetTmpWinningTicket(GetTmpWinningTicketReq req)
        {
            req.TypeName = ActivityGetType.GetTmpWinningTicket;
            return await GetAsync<List<GetTmpWinningTicketModel>, GetTmpWinningTicketReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateIsdeletedSalepointLog(UpdateIsdeletedSalepointLogReq req)
        {
            req.TypeName = ActivityPostType.UpdateIsdeletedSalepointLog;
            return await PostAsync<ReturnMessage, UpdateIsdeletedSalepointLogReq>(urlSend, req);
        }


        public async Task<ApiResponse<ReturnMessage>> UpdateActivityGuestAction(UpdateActivityGuestActionReq req)
        {
            req.TypeName = ActivityPostType.UpdateActivityGuestAction;
            return await PostAsync<ReturnMessage, UpdateActivityGuestActionReq>(urlSend, req);
        }


        public async Task<ApiResponse<ReturnMessage>> UpdatePriceForGuest(UpdatePriceForGuestReq req)
        {
            req.TypeName = ActivityPostType.UpdatePriceForGuest;
            return await PostAsync<ReturnMessage, UpdatePriceForGuestReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DeleteGuestAction(DeleteGuestActionReq req)
        {
            req.TypeName = ActivityPostType.DeleteGuestAction;
            return await PostAsync<ReturnMessage, DeleteGuestActionReq>(urlSend, req);

        }

        public async Task<ApiResponse<ReturnMessage>> DistributeForSubAgency(DistributeForSubAgencyReq req)
        {
            req.TypeName = ActivityPostType.DistributeForSubAgency;
            return await PostAsync<ReturnMessage, DistributeForSubAgencyReq>(urlSend, req); 
        }

        public async Task<ApiResponse<List<GetDataSubAgencyModel>>> GetDataSubAgency(GetDataSubAgencyReq req)
        {
            req.TypeName = ActivityGetType.GetDataSubAgency;
            return await GetAsync<List<GetDataSubAgencyModel>, GetDataSubAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdatePriceForSubAgency(UpdatePriceForSubAgencyReq req)
        {
            req.TypeName = ActivityPostType.UpdatePriceForSubAgency;
            return await PostAsync<ReturnMessage, UpdatePriceForSubAgencyReq>(urlSend, req);

        }

        public async Task<ApiResponse<ReturnMessage>> InsertOrUpdateAgency(InsertOrUpdateAgencyReq req)
        {
            req.TypeName = ActivityPostType.InsertOrUpdateAgency;
            return await PostAsync<ReturnMessage, InsertOrUpdateAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> InsertOrUpdateSubAgency(InsertOrUpdateSubAgencyReq req)
        {
            req.TypeName = ActivityPostType.InsertOrUpdateSubAgency;
            return await PostAsync<ReturnMessage, InsertOrUpdateSubAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListSubAgencyModel>>> GetListSubAgency(GetListSubAgencyReq req)
        {
            req.TypeName = ActivityGetType.GetListSubAgency;
            return await GetAsync<List<GetListSubAgencyModel>, GetListSubAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListLotteryPriceSubAgencyModel>>> GetListLotteryPriceSubAgency(GetListLotteryPriceSubAgencyReq req)
        {
            req.TypeName = ActivityGetType.GetListLotteryPriceSubAgency;
            return await GetAsync<List<GetListLotteryPriceSubAgencyModel>, GetListLotteryPriceSubAgencyReq>(urlSend, req);
        }
        public async Task<ApiResponse<List<GetStaticFeeModel>>> GetStaticFee(GetStaticFeeReq req)
        {
            req.TypeName = ActivityGetType.GetStaticFee;
            return await GetAsync<List<GetStaticFeeModel>, GetStaticFeeReq>(urlSend, req);
        }
        public async Task<ApiResponse<ReturnMessage>> UpdateStaticFee(UpdateStaticFeeReq req)
        {
            req.TypeName = ActivityPostType.UpdateStaticFee;
            return await PostAsync<ReturnMessage, UpdateStaticFeeReq>(urlSend, req);

        }

        public async Task<ApiResponse<ReturnMessage>> DistributeForSubAgency(DistributeScratchForSubAgencyReq req)
        {
            req.TypeName = ActivityPostType.DistributeScratchForSubAgency;
            return await PostAsync<ReturnMessage, DistributeScratchForSubAgencyReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetDebtOfStaffModel>>> GetDebtOfStaff(GetDebtOfStaffReq req)
        {
            req.TypeName = ActivityGetType.GetDebtOfStaff;
            return await GetAsync<List<GetDebtOfStaffModel>, GetDebtOfStaffReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateDebt(UpdateDebtReq req)
        {
            req.TypeName = ActivityPostType.UpdateDebt;
            return await PostAsync<ReturnMessage, UpdateDebtReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetPayedDebtAndNewDebtAllTimeModel>>> GetPayedDebtAndNewDebtAllTime(GetPayedDebtAndNewDebtAllTimeReq req)
        {
            req.TypeName = ActivityGetType.GetPayedDebtAndNewDebtAllTime;
            return await GetAsync<List<GetPayedDebtAndNewDebtAllTimeModel>, GetPayedDebtAndNewDebtAllTimeReq>(urlSend, req);
        }
    }
}