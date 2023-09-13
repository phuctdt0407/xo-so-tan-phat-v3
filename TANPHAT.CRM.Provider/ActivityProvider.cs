using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using KTHub.Core.DBConnection;
using Microsoft.Extensions.Configuration;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Activity;

namespace TANPHAT.CRM.Provider
{
    public interface IActivityProvider
    {
        Task<ReturnMessage> ReceiveLotteryFromAgency(ReceivedLotteryFromAgencyReq req);
        Task<List<DataReceivedFromAgencyModel>> GetDataReceivedFromAgency(DataReceivedFromAgencyReq req);
        Task<List<GetTmpWinningTicketModel>> GetTmpWinningTicket(GetTmpWinningTicketReq req);
        Task<ReturnMessage> DistributeForSalesPoint(DistributeForSalePointReq req);
        Task<ReturnMessage> UpdateActivityGuestAction(UpdateActivityGuestActionReq req);
        Task<List<DataDistributeForSalePointModel>> GetDataDistributeForSalePoint(DataDistributeForSalePointReq req);
        Task<ReturnMessage> UpdateIsdeletedSalepointLog(UpdateIsdeletedSalepointLogReq req);
        Task<ReturnMessage> SellLottery(SellLotteryReq req);
        Task<DataSellModel> GetDataSell(DataSellReq req);
        Task<ReturnMessage> InsertTransitionLog(InsertTransitionLogReq req);
        Task<List<SalePointLogModel>> GetSalePointLog(SalePointLogReq req);
        Task<ReturnMessage> InsertRepayment(InsertRepaymentReq req);
        Task<DataSellModel> GetDataInventory(DataSellReq req);
        Task<List<RepaymentLogModel>> GetRepaymentLog(SalePointLogReq req);
        Task<List<InventoryLogModel>> GetInventoryLog(DataSellReq req);
        Task<List<InventoryLogModel>> GetSalePointReturn(DataSellReq req);
        Task<ReturnMessage> InsertWinningLottery(InsertWinningLotteryReq req);
        Task<ReturnMessage> ShiftTransfer(ShiftTransferReq req);
        Task<ReturnMessage> ReceiveScratchcardFromAgency(ReceiveScratchcardFromAgencyReq req);
        Task<List<GetListLotteryPriceSubAgencyModel>> GetListLotteryPriceSubAgency(GetListLotteryPriceSubAgencyReq req);
        Task<List<DataScratchcardFromAgency>> GetDataScratchcardFromAgency(DataScratchcardFromAgencyReq req);
        Task<ReturnMessage> InsertOrUpdateSubAgency(InsertOrUpdateSubAgencyReq req);
        Task<ReturnMessage> DistributeScratchForSalesPoint(DistributeScratchForSalePointReq req);
        Task<ScratchcardFullModel> GetScratchcardFull();

        Task<List<DataDistributeScratchForSalePointModel>> GetDataDistributeScratchForSalePoint();
        Task<List<DataDistributeScratchForSubAgencyModel>> GetDataDistributeScratchForSubAgency();

        Task<List<WinningListModel>> GetWinningList(WinningListReq req);

        Task<List<TransitionListToConfirmModel>> GetTransitionListToConfirm(TransitionListToConfirmReq req);

        Task<List<ShiftDistributeByDateModel>> GetShiftDistributeByDate(ShiftDistributeByDateReq req);
        
        Task<ReturnMessage> ConfirmTransition(ConfirmTransitionReq req);
        Task<ReturnMessage> InsertOrUpdateAgency(InsertOrUpdateAgencyReq req);
        Task<List<SoldLogDetailModel>> GetSoldLogDetail(SalePointLogReq req);

        Task<List<TransLogDetailModel>> GetTransLogDetail(SalePointLogReq req);

        Task<List<LotteryPriceAgencyModel>> GetLotteryPriceAgency(LotteryPriceAgencyReq req);

        Task<List<LotteryForReturnModel>> GetListLotteryForReturn(LotteryForReturnReq req);

        Task<ReturnMessage> CreateSalePoint(CreateSalePointReq req);

        Task<ReturnMessage> UpdateLotteryPriceAgency(UpdateLotteryPriceAgencyReq req);
        Task<ReturnMessage> UpdateLotteryPriceSubAgency(UpdateLotteryPriceSubAgencyReq req);
        Task<ReturnMessage> ReturnLottery(ReturnLotteryReq req);

        Task<ReturnMessage> UpdateConstantPrice(UpdateConstantPriceReq req);

        Task<ReturnMessage> DeleteLogWinning(DeleteLogWinningReq req);
        Task<List<GetListHistoryForManagerModel>> GetListHistoryForManager(GetListHistoryForManagerReq req);
        Task<List<GetListReportMoneyInADayModel>> GetListReportMoneyInADay(GetListReportMoneyInADayReq req);
        Task<ReturnMessage> UpdateReportMoneyInAShift(UpdateReportMoneyInAShiftReq req);

        Task<ReturnMessage> UpdatePriceForGuest(UpdatePriceForGuestReq req);

        Task<ReturnMessage> DeleteGuestAction(DeleteGuestActionReq req);
        Task<ReturnMessage> DistributeForSubAgency(DistributeForSubAgencyReq req);
        Task<List<GetDataSubAgencyModel>> GetDataSubAgency(GetDataSubAgencyReq req);
        Task<ReturnMessage> UpdatePriceForSubAgency(UpdatePriceForSubAgencyReq req);
        Task<List<GetListSubAgencyModel>> GetListSubAgency(GetListSubAgencyReq req);
        Task<List<GetStaticFeeModel>> GetStaticFee(GetStaticFeeReq req);
        Task<ReturnMessage> UpdateStaticFee(UpdateStaticFeeReq req);
        Task<ReturnMessage> DistributeScratchForSubAgency(DistributeScratchForSubAgencyReq req);
        Task<List<GetDebtOfStaffModel>> GetDebtOfStaff(GetDebtOfStaffReq req);
        Task<ReturnMessage> UpdateDebt(UpdateDebtReq req);
        Task<List<GetPayedDebtAndNewDebtAllTimeModel>> GetPayedDebtAndNewDebtAllTime(GetPayedDebtAndNewDebtAllTimeReq req);
    }
    

    public class ActivityProvider : PostgreExecute, IActivityProvider
    {
        public ActivityProvider(IConfiguration configuration) : base(configuration, DBCommon.TANPHATCRMConnStr)
        {
        }

        public async Task<ReturnMessage> ConfirmTransition(ConfirmTransitionReq req)
        {
            var obj = new
            {
                p_user_role_id = req.UserRoleId,
                p_note =  req.Note,
                p_list_item = req.Data,
                p_is_confirm = req.IsConfirm,
                p_trans_type_id = req.TransitionTypeId,
                p_sale_point_id = req.SalePointId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_confirm_transition_v3", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DistributeForSalesPoint(DistributeForSalePointReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_lottery_date = req.LotteryDate,
                p_data = req.ReceiveData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_distribute_for_sales_point", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DistributeScratchForSalesPoint(DistributeScratchForSalePointReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.ReceiveData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_distribute_scratchcard_for_sales_point", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<DataDistributeForSalePointModel>> GetDataDistributeForSalePoint(DataDistributeForSalePointReq req)
        {
            var obj = new
            {
                p_lottery_date = req.LotteryDate
            };
            var res = await base.ExecStoredProcAsync<DataDistributeForSalePointModel>("crm_activity_get_data_distribute_for_sales_point", obj);
            return res;
        }

        public async Task<List<DataDistributeScratchForSalePointModel>> GetDataDistributeScratchForSalePoint()
        {
            var res = await base.ExecStoredProcAsync<DataDistributeScratchForSalePointModel>("crm_activity_get_data_distribute_scratchcard_for_sale_point");
            return res;
        }
        public async Task<List<DataDistributeScratchForSubAgencyModel>> GetDataDistributeScratchForSubAgency()
        {
            var res = await base.ExecStoredProcAsync<DataDistributeScratchForSubAgencyModel>("crm_activity_get_data_distribute_scratchcard_for_sub_agency");
            return res;
        }

        public async Task<DataSellModel> GetDataInventory(DataSellReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = (await base.ExecStoredProcAsync<DataSellModel>("crm_activity_sell_get_inventory_data", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<DataReceivedFromAgencyModel>> GetDataReceivedFromAgency(DataReceivedFromAgencyReq req)
        {
            var obj = new
            {
                p_lottery_date = req.LotteryDate
            };
            var res = await base.ExecStoredProcAsync<DataReceivedFromAgencyModel>("crm_activity_get_data_receive_from_agency", obj);
            return res;
        }

        public async Task<List<DataScratchcardFromAgency>> GetDataScratchcardFromAgency(DataScratchcardFromAgencyReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<DataScratchcardFromAgency>("crm_activity_get_data_receive_scratchcard_from_agency", obj);
            return res;
        }

        public async Task<DataSellModel> GetDataSell(DataSellReq req)
        {
            var obj = new
            {
                p_shift_distribute_id = req.ShiftDistributeId,
                p_user_role_id = req.UserRoleId,
                p_date = req.Date
            };
            var res = (await base.ExecStoredProcAsync<DataSellModel>("crm_activity_sell_get_data_v5", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<InventoryLogModel>> GetInventoryLog(DataSellReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<InventoryLogModel>("crm_activity_get_inventory_log", obj);
            return res;
        }

        public async Task<List<InventoryLogModel>> GetSalePointReturn(DataSellReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<InventoryLogModel>("crm_activity_get_sale_point_return", obj);
            return res;
        }

        public async Task<List<RepaymentLogModel>> GetRepaymentLog(SalePointLogReq req)
        {
            var obj = new
            {
                p_user_role_id = req.UserRoleId,
                p_sale_point_id = req.SalePointId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<RepaymentLogModel>("crm_activity_repayment_get_list_v3", obj);
            return res;
        }

        public async Task<List<SalePointLogModel>> GetSalePointLog(SalePointLogReq req)
        {
            var obj = new
            {
                p_shift_distribute_id = req.ShiftDistributeId,
                p_sale_point_id = req.SalePointId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<SalePointLogModel>("crm_activity_get_sell_point_log", obj);
            return res;
        }

        public async Task<ScratchcardFullModel> GetScratchcardFull()
        {
            var res = (await base.ExecStoredProcAsync<ScratchcardFullModel>("crm_scratch_card_full")).FirstOrDefault();
            return res;
        }

        public async Task<List<ShiftDistributeByDateModel>> GetShiftDistributeByDate(ShiftDistributeByDateReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_user_id = req.UserId
            };
            var res = await base.ExecStoredProcAsync<ShiftDistributeByDateModel>("crm_shift_distribute_get_by_date", obj);
            return res;
        }

        public async Task<List<SoldLogDetailModel>> GetSoldLogDetail(SalePointLogReq req)
        {
            var obj = new
            {
                p_shift_distribute_id = req.ShiftDistributeId,
                p_page_number = req.PageNumber,
                p_page_size = req.PageSize
            };
            var res = await base.ExecStoredProcAsync<SoldLogDetailModel>("crm_activity_sold_log_v1", obj);
            return res;
        }

        public async Task<List<TransitionListToConfirmModel>> GetTransitionListToConfirm(TransitionListToConfirmReq req)
        {
            var obj = new
            {
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber,
                p_date = req.Date,
                p_sale_point_id = req.SalePointId,
                p_trans_type_id = req.TransitionTypeId,
                p_user_role_id = req.UserRoleId,
            };
            var res = await base.ExecStoredProcAsync<TransitionListToConfirmModel>("crm_transition_get_list_to_confirm_v3", obj);
            return res;
        }

        public async Task<List<TransLogDetailModel>> GetTransLogDetail(SalePointLogReq req)
        {
            var obj = new
            {
                p_shift_distribute_id = req.ShiftDistributeId
            };
            var res = await base.ExecStoredProcAsync<TransLogDetailModel>("crm_activity_trans_log", obj);
            return res;
        }

        public async Task<List<WinningListModel>> GetWinningList(WinningListReq req)
        {
            var obj = new
            {
                p_shift_dis_id = req.ShiftDistributeId,
                p_sale_point_id = req.SalePointId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<WinningListModel>("crm_winning_get_list_v2", obj);
            return res;
        }

        public async Task<ReturnMessage> InsertRepayment(InsertRepaymentReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_sale_point_id = req.SalePointId,
                p_customer_name = req.CustomerName,
                p_note = req.Note,
                p_amount = req.Amount,
                p_user_role_id = req.UserRoleId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_log_repayment_v2", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> InsertTransitionLog(InsertTransitionLogReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_user_role_id = req.UserRoleId,
                p_tran_data = req.TransData,
                p_tran_type_id = req.TransTypeId,
                p_shift_dis_id = req.ShiftDistributeId,
                p_manager_id = req.ManagerId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_insert_transition_log_v3", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> InsertWinningLottery(InsertWinningLotteryReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_user_role_id = req.UserRoleId,
                p_winning_type_id = req.WinningTypeId,
                p_lottery_number = req.LotteryNumber,
                p_lottery_channel_id = req.LotteryChannelId,
                p_quantity = req.Quantity,
                p_winning_price = req.WinningPrice,
                p_from_sale_point_id = req.FromSalePointId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_insert_winning", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> ReceiveLotteryFromAgency(ReceivedLotteryFromAgencyReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_lottery_date = req.LotteryDate,
                p_data = req.ReceiveData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_receive_from_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> ReceiveScratchcardFromAgency(ReceiveScratchcardFromAgencyReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.ReceiveData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_receive_scratchcard_from_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> SellLottery(SellLotteryReq req)
        {
            var obj = new
            {
                p_shift_dis_id = req.ShiftDistributeId,
                p_user_role_id = req.UserRoleId,
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_guest_id = req.GuestId,
                p_order_id = req.OrderId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_sell_lottery_v4", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> ShiftTransfer(ShiftTransferReq req)
        {
            var obj = new
            {
                p_user_role_id = req.UserRoleId,
                p_shift_distribute = req.ShiftDistributeId,
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_money= req.Money
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_shift_transfer_v3", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> CreateSalePoint(CreateSalePointReq req)
        {
            var obj = new
            {

                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_salePoint_name = req.SalePointName
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_add_salepoint", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateLotteryPriceAgency(UpdateLotteryPriceAgencyReq req)
        {

            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_lottery_price_agency", obj)).FirstOrDefault();
            return res;
        }
        public async Task<ReturnMessage> UpdateLotteryPriceSubAgency(UpdateLotteryPriceSubAgencyReq req)
        {

            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_lottery_price_sub_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<LotteryPriceAgencyModel>> GetLotteryPriceAgency(LotteryPriceAgencyReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<LotteryPriceAgencyModel>("crm_activity_get_list_lottery_price_agency", obj);
            return res;
        }

        public async Task<List<LotteryForReturnModel>> GetListLotteryForReturn(LotteryForReturnReq req)
        {
            var obj = new
            {
                p_date = req.LotteryDate
            };
            var res = await base.ExecStoredProcAsync<LotteryForReturnModel>("crm_activity_get_list_lottery_for_return", obj);
            return res;
        }

        public async Task<ReturnMessage> ReturnLottery(ReturnLotteryReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_action_type = req.ActionType,
                p_date = req.Date
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_return_lottery", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateConstantPrice(UpdateConstantPriceReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_const_price", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DeleteLogWinning(DeleteLogWinningReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_winning_id = req.WinningId,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_delete_winning_log", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetListHistoryForManagerModel>> GetListHistoryForManager(GetListHistoryForManagerReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_sale_point= req.SalePoint,
                p_shift_id=req.ShiftId,
            };
            var res = await base.ExecStoredProcAsync<GetListHistoryForManagerModel>("crm_manager_get_list_history", obj);
            return res;
        }

        public async Task<List<GetListReportMoneyInADayModel>> GetListReportMoneyInADay(GetListReportMoneyInADayReq req)
        {
            var obj = new
            {
                p_date = req.Date,
            };
            var res = await base.ExecStoredProcAsync<GetListReportMoneyInADayModel>("crm_activity_get_all_report_money_in_a_day", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateReportMoneyInAShift(UpdateReportMoneyInAShiftReq req)
        {
            var obj = new
            {
                p_shift_distribute = req.ShiftDistributeId,
                p_date = req.Date,
                p_total_money = req.Money
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_report_money_in_a_shift", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetTmpWinningTicketModel>> GetTmpWinningTicket(GetTmpWinningTicketReq req)
        {
            var obj = new
            {
                p_day = req.Day,
                p_number =req.Number,
                p_lottery_channel_id = req.LotteryChannelId,
                p_count_number = req.CountNumber
            };
            var res = await base.ExecStoredProcAsync<GetTmpWinningTicketModel>("crm_activity_get_tmp_winning_ticket", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateIsdeletedSalepointLog(UpdateIsdeletedSalepointLogReq req)
        {

            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_count = req.Count,
                p_salepoint_id = req.SalePointId,
                p_lottery_channel_id = req.LotteryChannelId,
                p_number = req.Number,
                p_day = req.Day
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_isdeleted_salepoint_log", obj)).FirstOrDefault();
            return res;
        }



        public async Task<ReturnMessage> UpdateActivityGuestAction(UpdateActivityGuestActionReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_arr_guest_action_id = req.ArrGuestActionId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_update_activity_guest_action", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdatePriceForGuest(UpdatePriceForGuestReq req)
        {
            var obj = new
            {
                p_guest_id = req.GuestId,
                p_scratch_price = req.WholeSalePrice,
                p_whole_sale_price = req.ScracthPrice
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_price_for_guest", obj)).FirstOrDefault();

            return res;
        }
        public async Task<ReturnMessage> DeleteGuestAction(DeleteGuestActionReq req)
        {
            var obj = new
            {
                p_guest_id = req.GuestId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_delete_guest_action", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DistributeForSubAgency(DistributeForSubAgencyReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_lock = req.Lock,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_distribute_for_sup_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetDataSubAgencyModel>> GetDataSubAgency(GetDataSubAgencyReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<GetDataSubAgencyModel>("crm_activity_get_data_distribute_for_sup_agency", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdatePriceForSubAgency(UpdatePriceForSubAgencyReq req)
        {
            var obj = new
            {
                p_agency_id = req.AgencyId,
                p_price = req.Price,
                p_date = req.Date
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_price_for_lottery_of_sub_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> InsertOrUpdateAgency(InsertOrUpdateAgencyReq req)
        {
            var obj = new
            {
                p_agency_name = req.AgencyName,
                p_agency_id = req.AgencyId,
                p_is_activity = req.Activity,
                p_is_deleted = req.IsDeleted,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_insert_or_update_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> InsertOrUpdateSubAgency(InsertOrUpdateSubAgencyReq req)
        {

            var obj = new
            {
                p_agency_name = req.AgencyName,
                p_price = req.Price,
                p_agency_id = req.AgencyId,
                p_is_activity = req.Activity,
                p_is_deleted = req.IsDeleted,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_insert_or_update_sub_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetListSubAgencyModel>> GetListSubAgency(GetListSubAgencyReq req)
        {
            var obj = new
            {
            };
            var res = await base.ExecStoredProcAsync<GetListSubAgencyModel>("crm_activity_get_list_sub_agency", obj);
            return res;
        }
        public async Task<List<GetStaticFeeModel>> GetStaticFee(GetStaticFeeReq req)
        {
            var obj = new
            {
               p_month = req.Month,
            };
            var res = await base.ExecStoredProcAsync<GetStaticFeeModel>("crm_activity_get_static_fee_v2", obj);
            return res;
        }

        public async Task<List<GetListLotteryPriceSubAgencyModel>> GetListLotteryPriceSubAgency(GetListLotteryPriceSubAgencyReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<GetListLotteryPriceSubAgencyModel>("crm_activity_get_list_lottery_price_sub_agency", obj);
            
            return res;
        }

        public async Task<ReturnMessage> UpdateStaticFee(UpdateStaticFeeReq req)
        {
            Console.WriteLine(req.Data);
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_static_fee", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DistributeScratchForSubAgency(DistributeScratchForSubAgencyReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.ReceiveData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_distribute_scratchcard_for_sub_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetDebtOfStaffModel>> GetDebtOfStaff(GetDebtOfStaffReq req)
        {
            var obj = new
            {
                p_user_title_id = req.UserTitleId,
            };
            var res = await base.ExecStoredProcAsync<GetDebtOfStaffModel>("crm_activity_get_debt_of_staff", obj);

            return res;
        }

        public async Task<ReturnMessage> UpdateDebt(UpdateDebtReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
                p_payed_debt = req.PayedDebt,
                p_month = req.Month,
                p_salepoint_id = req.SalePointId,
                p_total_debt = req.TotalDebt,
                p_flag = req.Flag
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_activity_update_debt", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetPayedDebtAndNewDebtAllTimeModel>> GetPayedDebtAndNewDebtAllTime(GetPayedDebtAndNewDebtAllTimeReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
            };
            var res = await base.ExecStoredProcAsync<GetPayedDebtAndNewDebtAllTimeModel>("crm_get_every_payed_debt_and_new_debt_all_time", obj);

            return res;
        }
    }
}
