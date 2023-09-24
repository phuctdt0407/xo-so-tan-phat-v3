using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity;
using TANPHAT.CRM.Provider;

namespace TANPHAT.CRM.Business
{
    public interface IActivityBusiness
    {
        Task<ReturnMessage> UpdateActivityGuestAction(UpdateActivityGuestActionReq req);
        Task<ReturnMessage> ReceiveLotteryFromAgency(ReceivedLotteryFromAgencyReq req); 
        Task<List<GetTmpWinningTicketModel>> GetTmpWinningTicket(GetTmpWinningTicketReq req);
        Task<List<DataReceivedFromAgencyModel>> GetDataReceivedFromAgency(DataReceivedFromAgencyReq req);

        Task<ReturnMessage> DistributeForSalesPoint(DistributeForSalePointReq req);

        Task<List<DataDistributeForSalePointModel>> GetDataDistributeForSalePoint(DataDistributeForSalePointReq req);

        Task<ReturnMessage> SellLottery(SellLotteryReq req);

        Task<DataSellModel> GetDataSell(DataSellReq req);

        Task<ReturnMessage> InsertTransitionLog(InsertTransitionLogReq req);

        Task<List<SalePointLogModel>> GetSalePointLog(SalePointLogReq req);

        Task<ReturnMessage> InsertRepayment(InsertRepaymentReq req);

        Task<DataSellModel> GetDataInventory(DataSellReq req);

        Task<List<RepaymentLogModel>> GetRepaymentLog(SalePointLogReq req);

        Task<List<InventoryLogModel>> GetInventoryLog(DataSellReq req);

        Task<ReturnMessage> InsertWinningLottery(InsertWinningLotteryReq req);

        Task<ReturnMessage> ShiftTransfer(ShiftTransferReq req);

        Task<ReturnMessage> ReceiveScratchcardFromAgency(ReceiveScratchcardFromAgencyReq req);

        Task<List<DataScratchcardFromAgency>> GetDataScratchcardFromAgency(DataScratchcardFromAgencyReq req);

        Task<ReturnMessage> DistributeScratchForSalesPoint(DistributeScratchForSalePointReq req);

        Task<ScratchcardFullModel> GetScratchcardFull();

        Task<List<DataDistributeScratchForSalePointModel>> GetDataDistributeScratchForSalePoint();
        Task<List<DataDistributeScratchForSubAgencyModel>> GetDataDistributeScratchForSubAgency();

        Task<List<WinningListModel>> GetWinningList(WinningListReq req);

        Task<List<WinningListModel>> GetWinningListByMonth(WinningListByMonthReq req);

        Task<List<TransitionListToConfirmModel>> GetTransitionListToConfirm(TransitionListToConfirmReq req);

        Task<List<ShiftDistributeByDateModel>> GetShiftDistributeByDate(ShiftDistributeByDateReq req);

        Task<ReturnMessage> ConfirmTransition(ConfirmTransitionReq req);

        Task<List<SoldLogDetailModel>> GetSoldLogDetail(SalePointLogReq req);

        Task<List<TransLogDetailModel>> GetTransLogDetail(SalePointLogReq req);

        Task<List<InventoryLogModel>> GetSalePointReturn(DataSellReq req);

        Task<List<LotteryPriceAgencyModel>> GetLotteryPriceAgency(LotteryPriceAgencyReq req);
        Task<List<LotteryForReturnModel>> GetListLotteryForReturn(LotteryForReturnReq req);
        Task<List<GetListSubAgencyModel>> GetListSubAgency(GetListSubAgencyReq req);
        
        Task<ReturnMessage> InsertOrUpdateAgency(InsertOrUpdateAgencyReq req);
        Task<ReturnMessage> InsertOrUpdateSubAgency(InsertOrUpdateSubAgencyReq req);
        Task<ReturnMessage> CreateSalePoint(CreateSalePointReq req);
        Task<ReturnMessage> UpdateLotteryPriceAgency(UpdateLotteryPriceAgencyReq req);
        Task<ReturnMessage> UpdateLotteryPriceSubAgency(UpdateLotteryPriceSubAgencyReq req);
        Task<ReturnMessage> ReturnLottery(ReturnLotteryReq req);

        Task<ReturnMessage> UpdateConstantPrice(UpdateConstantPriceReq req);
        Task<ReturnMessage> UpdateIsdeletedSalepointLog(UpdateIsdeletedSalepointLogReq req);
        
        Task<ReturnMessage> DeleteLogWinning(DeleteLogWinningReq req);
        Task<List<GetListHistoryForManagerModel>> GetListHistoryForManager(GetListHistoryForManagerReq req);
        Task<List<GetListReportMoneyInADayModel>> GetListReportMoneyInADay(GetListReportMoneyInADayReq req);
        Task<ReturnMessage> UpdateReportMoneyInAShift(UpdateReportMoneyInAShiftReq req);
        Task<List<GetListLotteryPriceSubAgencyModel>> GetListLotteryPriceSubAgency(GetListLotteryPriceSubAgencyReq req);
        Task<ReturnMessage> UpdatePriceForGuest(UpdatePriceForGuestReq req);

        Task<ReturnMessage> DeleteGuestAction(DeleteGuestActionReq req);
        Task<ReturnMessage> DistributeForSubAgency(DistributeForSubAgencyReq req);
        Task<List<GetDataSubAgencyModel>> GetDataSubAgency(GetDataSubAgencyReq req);
        Task<ReturnMessage> UpdatePriceForSubAgency(UpdatePriceForSubAgencyReq req);
        Task<List<GetStaticFeeModel>> GetStaticFee(GetStaticFeeReq req);
        Task<ReturnMessage> UpdateStaticFee(UpdateStaticFeeReq req);
        Task<ReturnMessage> DistributeScratchForSubAgency(DistributeScratchForSubAgencyReq req);
        Task<List<GetDebtOfStaffModel>> GetDebtOfStaff(GetDebtOfStaffReq req);
        Task<ReturnMessage> UpdateDebt(UpdateDebtReq req);
        Task<List<GetPayedDebtAndNewDebtAllTimeModel>> GetPayedDebtAndNewDebtAllTime(GetPayedDebtAndNewDebtAllTimeReq req);
    }

    public class ActivityBusiness : IActivityBusiness
    {
        private IActivityProvider _activityProvider;

        public ActivityBusiness(IActivityProvider activityProvider)
        {
            _activityProvider = activityProvider;
        }

        public async Task<ReturnMessage> DistributeForSalesPoint(DistributeForSalePointReq req)
        {
            var res = await _activityProvider.DistributeForSalesPoint(req);
            return res;
        }

        public async Task<List<DataDistributeForSalePointModel>> GetDataDistributeForSalePoint(DataDistributeForSalePointReq req)
        {
            var res = await _activityProvider.GetDataDistributeForSalePoint(req);
            return res;
        }

        public async Task<DataSellModel> GetDataInventory(DataSellReq req)
        {
            var res = await _activityProvider.GetDataInventory(req);
            return res;
        }


        public async Task<List<DataReceivedFromAgencyModel>> GetDataReceivedFromAgency(DataReceivedFromAgencyReq req)
        {
            var res = await _activityProvider.GetDataReceivedFromAgency(req);
            return res;
        }

        public async Task<DataSellModel> GetDataSell(DataSellReq req)
        {
            var res = await _activityProvider.GetDataSell(req);
            return res;
        }

        public async Task<List<RepaymentLogModel>> GetRepaymentLog(SalePointLogReq req)
        {
            var res = await _activityProvider.GetRepaymentLog(req);
            return res;
        }

        public async Task<List<SalePointLogModel>> GetSalePointLog(SalePointLogReq req)
        {
            var res = await _activityProvider.GetSalePointLog(req);
            return res;
        }

        public async Task<ReturnMessage> InsertRepayment(InsertRepaymentReq req)
        {
            var res = await _activityProvider.InsertRepayment(req);
            return res;
        }

        public async Task<ReturnMessage> InsertTransitionLog(InsertTransitionLogReq req)
        {
            var res = await _activityProvider.InsertTransitionLog(req);
            return res;
        }

        public async Task<ReturnMessage> ReceiveLotteryFromAgency(ReceivedLotteryFromAgencyReq req)
        {
            var res = await _activityProvider.ReceiveLotteryFromAgency(req);
            return res;
        }

        public async Task<ReturnMessage> SellLottery(SellLotteryReq req)
        {
            var res = await _activityProvider.SellLottery(req);
            return res;
        }
        public async Task<List<InventoryLogModel>> GetInventoryLog(DataSellReq req)
        {
            var res = await _activityProvider.GetInventoryLog(req);
            return res;
        }

        public async Task<ReturnMessage> InsertWinningLottery(InsertWinningLotteryReq req)
        {
            var res = await _activityProvider.InsertWinningLottery(req);
            return res;
        }

        public async Task<ReturnMessage> ShiftTransfer(ShiftTransferReq req)
        {
            var res = await _activityProvider.ShiftTransfer(req);
            return res;
        }

        public async Task<ReturnMessage> ReceiveScratchcardFromAgency(ReceiveScratchcardFromAgencyReq req)
        {
            var res = await _activityProvider.ReceiveScratchcardFromAgency(req);
            return res;
        }

        public async Task<List<DataScratchcardFromAgency>> GetDataScratchcardFromAgency(DataScratchcardFromAgencyReq req)
        {
            var res = await _activityProvider.GetDataScratchcardFromAgency(req);
            return res;
        }

        public async Task<ReturnMessage> DistributeScratchForSalesPoint(DistributeScratchForSalePointReq req)
        {
            var res = await _activityProvider.DistributeScratchForSalesPoint(req);
            return res;
        }

        public async Task<ScratchcardFullModel> GetScratchcardFull()
        {
            var res = await _activityProvider.GetScratchcardFull();
            return res;
        }

        public async Task<List<DataDistributeScratchForSalePointModel>> GetDataDistributeScratchForSalePoint()
        {
            var res = await _activityProvider.GetDataDistributeScratchForSalePoint();
            return res;
        }
        
        public async Task<List<DataDistributeScratchForSubAgencyModel>> GetDataDistributeScratchForSubAgency()
        {
            var res = await _activityProvider.GetDataDistributeScratchForSubAgency();
            return res;
        }

        public async Task<List<WinningListModel>> GetWinningList(WinningListReq req)
        {
            var res = await _activityProvider.GetWinningList(req);
            return res;
        }

        public async Task<List<WinningListModel>> GetWinningListByMonth(WinningListByMonthReq req)
        {
            var res = await _activityProvider.GetWinningListByMonth(req);
            return res;
        }

        public async Task<List<TransitionListToConfirmModel>> GetTransitionListToConfirm(TransitionListToConfirmReq req)
        {
            var res = await _activityProvider.GetTransitionListToConfirm(req);
            return res;
        }

        public async Task<List<ShiftDistributeByDateModel>> GetShiftDistributeByDate(ShiftDistributeByDateReq req)
        {
            var res = await _activityProvider.GetShiftDistributeByDate(req);
            return res;
        }

        public async Task<ReturnMessage> ConfirmTransition(ConfirmTransitionReq req)
        {
            var res = await _activityProvider.ConfirmTransition(req);
            return res;
        }

        public async Task<List<SoldLogDetailModel>> GetSoldLogDetail(SalePointLogReq req)
        {
            var res = await _activityProvider.GetSoldLogDetail(req);
            return res;
        }

        public async Task<List<TransLogDetailModel>> GetTransLogDetail(SalePointLogReq req)
        {
            var res = await _activityProvider.GetTransLogDetail(req);
            return res;
        }

        public async Task<List<InventoryLogModel>> GetSalePointReturn(DataSellReq req)
        {
            var res = await _activityProvider.GetSalePointReturn(req);
            return res;
        }

        public async Task<ReturnMessage> CreateSalePoint(CreateSalePointReq req)
        {
            var res = await _activityProvider.CreateSalePoint(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateLotteryPriceAgency(UpdateLotteryPriceAgencyReq req)
        {
            var res = await _activityProvider.UpdateLotteryPriceAgency(req);
            return res;
        }
        public async Task<ReturnMessage> UpdateLotteryPriceSubAgency(UpdateLotteryPriceSubAgencyReq req)
        {
            var res = await _activityProvider.UpdateLotteryPriceSubAgency(req);
            return res;
        }

        public async Task<List<LotteryPriceAgencyModel>> GetLotteryPriceAgency(LotteryPriceAgencyReq req)
        {
            var res = await _activityProvider.GetLotteryPriceAgency(req);
            return res;
        }

        public async Task<List<LotteryForReturnModel>> GetListLotteryForReturn(LotteryForReturnReq req)
        {
            var res = await _activityProvider.GetListLotteryForReturn(req);
            return res;
        }

        public async Task<ReturnMessage> ReturnLottery(ReturnLotteryReq req)
        {
            var res = await _activityProvider.ReturnLottery(req);
            return res; 
        }

        public async Task<ReturnMessage> UpdateConstantPrice(UpdateConstantPriceReq req)
        {
            var res = await _activityProvider.UpdateConstantPrice(req);
            return res;
        }

        public async Task<ReturnMessage> DeleteLogWinning(DeleteLogWinningReq req)
        {
            var res = await _activityProvider.DeleteLogWinning(req);
            return res;
        }

        public async Task<List<GetListHistoryForManagerModel>> GetListHistoryForManager(GetListHistoryForManagerReq req)
        {
            var res = await _activityProvider.GetListHistoryForManager(req);
            return res;
        }

        public async Task<List<GetListReportMoneyInADayModel>> GetListReportMoneyInADay(GetListReportMoneyInADayReq req)
        {
            var res = await _activityProvider.GetListReportMoneyInADay(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateReportMoneyInAShift(UpdateReportMoneyInAShiftReq req)
        {
            var res = await _activityProvider.UpdateReportMoneyInAShift(req);
            return res;
        }

        public async Task<List<GetTmpWinningTicketModel>> GetTmpWinningTicket(GetTmpWinningTicketReq req)
        {
            var res = await _activityProvider.GetTmpWinningTicket(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateIsdeletedSalepointLog(UpdateIsdeletedSalepointLogReq req)
        {
            var res = await _activityProvider.UpdateIsdeletedSalepointLog(req);
            return res;
        }


        public async Task<ReturnMessage> UpdateActivityGuestAction(UpdateActivityGuestActionReq req)
        {
            var res = await _activityProvider.UpdateActivityGuestAction(req);
            return res;
        }


        public async Task<ReturnMessage> UpdatePriceForGuest(UpdatePriceForGuestReq req)
        {
            var res = await _activityProvider.UpdatePriceForGuest(req);

            return res;
        }

        public async Task<ReturnMessage> DeleteGuestAction(DeleteGuestActionReq req)
        {
            var res = await _activityProvider.DeleteGuestAction(req);

            return res;
        }

        public async Task<ReturnMessage> DistributeForSubAgency(DistributeForSubAgencyReq req)
        {
            var res = await _activityProvider.DistributeForSubAgency(req);
            return res;
        }

        public async Task<List<GetDataSubAgencyModel>> GetDataSubAgency(GetDataSubAgencyReq req)
        {
            var res = await _activityProvider.GetDataSubAgency(req);
            return res;
        }

        public async Task<ReturnMessage> UpdatePriceForSubAgency(UpdatePriceForSubAgencyReq req)
        {
            var res = await _activityProvider.UpdatePriceForSubAgency(req);
            return res;
        }

        public async Task<ReturnMessage> InsertOrUpdateAgency(InsertOrUpdateAgencyReq req)
        {
            var res = await _activityProvider.InsertOrUpdateAgency(req);
            return res;
        }

        public async Task<ReturnMessage> InsertOrUpdateSubAgency(InsertOrUpdateSubAgencyReq req)
        {
            var res = await _activityProvider.InsertOrUpdateSubAgency(req);
            return res;
        }

        public async Task<List<GetListSubAgencyModel>> GetListSubAgency(GetListSubAgencyReq req)
        {
            var res = await _activityProvider.GetListSubAgency(req);
            return res;
        }

        public async Task<List<GetListLotteryPriceSubAgencyModel>> GetListLotteryPriceSubAgency(GetListLotteryPriceSubAgencyReq req)
        {
            var res = await _activityProvider.GetListLotteryPriceSubAgency(req);
            return res;
        }
        public async Task<List<GetStaticFeeModel>> GetStaticFee(GetStaticFeeReq req)
        {
            var res = await _activityProvider.GetStaticFee(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateStaticFee(UpdateStaticFeeReq req)
        {
            var res = await _activityProvider.UpdateStaticFee(req);
            return res;
        }

        public async Task<ReturnMessage> DistributeScratchForSubAgency(DistributeScratchForSubAgencyReq req)
        {
            var res = await _activityProvider.DistributeScratchForSubAgency(req);
            return res;
        }

        public async Task<List<GetDebtOfStaffModel>> GetDebtOfStaff(GetDebtOfStaffReq req)
        {
            var res = await _activityProvider.GetDebtOfStaff(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateDebt(UpdateDebtReq req)
        {
            var res = await _activityProvider.UpdateDebt(req);
            return res;
        }

        public async Task<List<GetPayedDebtAndNewDebtAllTimeModel>> GetPayedDebtAndNewDebtAllTime(GetPayedDebtAndNewDebtAllTimeReq req)
        {
            var res = await _activityProvider.GetPayedDebtAndNewDebtAllTime(req);
            return res;
        }
    }
}
