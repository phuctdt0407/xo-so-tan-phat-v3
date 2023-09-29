using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using KTHub.Core.DBConnection;
using Microsoft.Extensions.Configuration;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report;

namespace TANPHAT.CRM.Provider
{
    public interface IReportProvider
    {
        Task<List<UserShiftReportModel>> GetTotalShiftOfUserInMonth(ReportRequestModel req);
        Task<List<GetTransitonTypeOffsetModel>> GetTransitonTypeOffset(GetTransitonTypeOffsetReq req);
        
        Task<List<UserShiftReportModel>> GetTotalShiftOfUserBySalePointInMonth(ReportRequestModel req);

        Task<List<DataInventoryInDayOfAllSalePointModel>> GetDataInventoryInDayOfAllSalePoint(DataInventoryInDayOfAllSalePointReq req);
        Task<List<GetListUnsoldLotteryTicketModel>> GetListUnsoldLotteryTicket(GetListUnsoldLotteryTicketReq req);
        Task<List<DataInventoryInMonthOfAllSalePointModel>> GetDataInventoryInMonthOfAllSalePoint(DataInventoryInMonthOfAllSalePointReq req);

        Task<List<TotalLotterySellOfUserToCurrentInMonthModel>> GetTotalLotterySellOfUserToCurrentInMonth(TotalLotterySellOfUserToCurrentInMonthReq req);
        Task<List<TotalLotterySellOfUserInMonth>> GetTotalLotterySellOfUserInMonth(TotalLotterySellOfUserToCurrentInMonthReq req);
        

        Task<List<TotalLotteryReceiveOfAllAgencyInMonthModel>> GetTotalLotteryReceiveOfAllAgencyInMonth(ReportRequestModel req);

        Task<List<TotalLotteryReturnOfAllSalePointInMonthModel>> GetTotalLotteryReturnOfAllSalePointInMonth(ReportRequestModel req);

        Task<List<TotalWinningOfSalePointInMonthModel>> GetTotalWinningOfSalePointInMonth(ReportRequestModel req);

        Task<List<TotalRemainOfSalePointModel>> GetTotalRemainOfSalePoint(ReportRequestModel req);

        Task<List<DataShiftTransFerModel>> GetDataShiftTransFer(ReportRequestModel req);

        Task<List<TotalRemainingOfAllSalePointInDateModel>> GetTotalRemainingOfAllSalePointInDate(ReportRequestModel req);

        Task<List<DataQuantityInteractLotteryByDateModel>> GetDataQuantityInteractLotteryByDate(ReportRequestModel req);

        Task<List<DataQuantityInteractLotteryByMonthModel>> GetDataQuantityInteractLotteryByMonth(ReportRequestModel req);

        Task<ReportManagerOverallModel> GetReportManagerOverall(ReportManagerOverallReq req);
        Task<List<GetListExemptKpiModel>> GetListExemptKpi(GetListExemptKpiReq req);
        
        Task<List<TotalLotteryNotSellOfAllSalePointModel>> GetTotalLotteryNotSellOfAllSalePoint(ReportRequestModel req);

        Task<List<TotalLotterySoldOfSalePointThatYouManageModel>> GetTotalLotterySoldOfSalePointThatYouManage(ReportRequestModel req);

        Task<List<AverageLotterySellOfUserModel>> GetAverageLotterySellOfUser(TotalLotterySellOfUserToCurrentInMonthReq req);

        Task<List<LogDistributeForSalepointModel>> GetLogDistributeForSalepoint(LogDistributeForSalepointReq req);

        Task<GetListForUpdateModel> GetListForUpdate(GetListForUpdateReq req);
        Task<ReturnMessage> UpdateORDeleteSalePointLog(UpdateORDeleteSalePointLogReq req);
        Task<ReturnMessage> UpdateReportLottery(UpdateReportLotteryReq req);
        Task<ReturnMessage> UpdateKpi(UpdateKpiReq req); 
        Task<ReturnMessage> UpdateIsSumKpi(UpdateIsSumKpiReq req);

        Task<List<GetFullTotalItemInMonthModel>> GetFullTotalItemInMonth(GetFullTotalItemInMonthReq req);
        Task<List<GetListTotalNumberOfTicketsOfEachManagerModel>> GetListTotalNumberOfTicketsOfEachManager(GetListTotalNumberOfTicketsOfEachManagerReq req);
        Task<List<SaleOfSalePointInMonthModel>> GetSaleOfSalePointInMonth(SaleOfSalePointInMonthReq req);

        Task<ReturnMessage> UpdateORDeleteItem(UpdateORDeleteItemReq req);

        Task<GetLotterySellInMonthModel> GetLotterySellInMonth(GetLotterySellInMonthReq req);

        Task<ReturnMessage> DeleteShiftTransfer(DeleteShiftTransferReq req);
        Task<List<GetSalaryInMonthOfUserModel>> GetSalaryInMonthOfUser(GetSalaryInMonthOfUserReq req);
        Task<List<TotalLotteryReceiveOfAllAgencyInDayModel>> TotalLotteryReceiveOfAllAgencyInDay(TotalLotteryReceiveOfAllAgencyInDayReq req);

        Task<ReturnMessage> UpdateReturnMoney(UpdateReturnMoneyReq req);

        Task<List<ReportLotteryInADayModel>> ReportLotteryInADay(ReportLotteryInADayReq req);

        Task<List<ReportRemainingLotteryModel>> ReportRemainingLottery(ReportRemainingLotteryReq req);

        Task<List<ReuseReportDataFinishShiftModel>> ReuseReportDataFinishShift(ReuseReportDataFinishShiftReq req);

    }

    public class ReportProvider : PostgreExecute, IReportProvider
    {
        public ReportProvider(IConfiguration configuration) : base(configuration, DBCommon.TANPHATCRMConnStr)
        {
        }

        public async Task<List<DataInventoryInDayOfAllSalePointModel>> GetDataInventoryInDayOfAllSalePoint(DataInventoryInDayOfAllSalePointReq req)
        {
            
            var obj = new
            {
                p_month = req.Month,
                p_sale_point_id = req.SalePointId
            };
            var res = (await base.ExecStoredProcAsync<DataInventoryInDayOfAllSalePointModel>("crm_get_inventory_inday_of_all_salepoint_v2", obj));
            return res;
        }

        public async Task<List<DataInventoryInMonthOfAllSalePointModel>> GetDataInventoryInMonthOfAllSalePoint(DataInventoryInMonthOfAllSalePointReq req)
        {
            var obj = new
            {
                p_month = req.InventoryMonth
            };
            var res = (await base.ExecStoredProcAsync<DataInventoryInMonthOfAllSalePointModel>("crm_get_inventory_inmonth_of_all_salepoint", obj));
            return res;
        }

        public async Task<List<UserShiftReportModel>> GetTotalShiftOfUserBySalePointInMonth(ReportRequestModel req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = (await base.ExecStoredProcAsync<UserShiftReportModel>("crm_report_get_total_shift_of_all_user_in_month_v3", obj));
            return res;
        }

        public async Task<List<UserShiftReportModel>> GetTotalShiftOfUserInMonth(ReportRequestModel req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_salePointId = req.SalePoint
            };
            var res = (await base.ExecStoredProcAsync<UserShiftReportModel>("crm_report_get_total_shift_of_all_user_in_month_of_salepoint", obj));
            return res;
        }

        public async Task<List<TotalLotterySellOfUserToCurrentInMonthModel>> GetTotalLotterySellOfUserToCurrentInMonth(TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_userId =0,
                p_lottery_type = req.LotteryTypeId
            };
            var res = (await base.ExecStoredProcAsync<TotalLotterySellOfUserToCurrentInMonthModel>("crm_report_total_lottery_sell_of_user_to_current_date_v2", obj));
            return res;
        }

        public async Task<List<TotalLotterySellOfUserInMonth>> GetTotalLotterySellOfUserInMonth(TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_userId = 0,
                p_lottery_type = req.LotteryTypeId
            };
            var res = (await base.ExecStoredProcAsync<TotalLotterySellOfUserInMonth>("crm_report_total_lottery_sell_of_user_to_current_date_v3", obj));
            return res;
        }

        public async Task<List<TotalLotteryReceiveOfAllAgencyInMonthModel>> GetTotalLotteryReceiveOfAllAgencyInMonth(ReportRequestModel req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = (await base.ExecStoredProcAsync<TotalLotteryReceiveOfAllAgencyInMonthModel>("crm_report_get_total_lottery_of_all_agency_in_month", obj));
            return res;
        }

        public async Task<List<TotalLotteryReturnOfAllSalePointInMonthModel>> GetTotalLotteryReturnOfAllSalePointInMonth(ReportRequestModel req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_sale_point_id = req.SalePoint
            };
            var res = (await base.ExecStoredProcAsync<TotalLotteryReturnOfAllSalePointInMonthModel>("crm_report_get_total_lottery_return_in_month_v2", obj));
            return res;
        }
        //Đã chỉnh cho trưởng nhóm
        public async Task<List<TotalWinningOfSalePointInMonthModel>> GetTotalWinningOfSalePointInMonth(ReportRequestModel req)
        {
            var obj = new
            {
                p_user_role = req.UserRoleId,
                p_salepoint_id = req.SalePoint,
                p_month = req.Month
            };
            var res = (await base.ExecStoredProcAsync<TotalWinningOfSalePointInMonthModel>("crm_report_get_data_winner_card_by_salepoint_v2", obj));
            return res;
        }

        public async Task<List<TotalRemainOfSalePointModel>> GetTotalRemainOfSalePoint(ReportRequestModel req)
        {
            var obj = new
            {
                p_salepoint_id = req.SalePoint,
                p_month = req.Month
            };
            var res = (await base.ExecStoredProcAsync<TotalRemainOfSalePointModel>("crm_report_get_remain_of_salepoint_in_date", obj));
            return res;
        }

        public async Task<List<DataShiftTransFerModel>> GetDataShiftTransFer(ReportRequestModel req)
        {
            var obj = new
            {
                p_user_role = req.UserRoleId,
                p_shift_dis_id = req.ShiftDistributeId
            };
            var res = (await base.ExecStoredProcAsync<DataShiftTransFerModel>("crm_report_data_finish_shift_v5", obj));
            return res;
        }

        public async Task<List<TotalRemainingOfAllSalePointInDateModel>> GetTotalRemainingOfAllSalePointInDate(ReportRequestModel req)
        {
            var obj = new Object();
            var res = await base.ExecStoredProcAsync<TotalRemainingOfAllSalePointInDateModel>("crm_report_get_remain_of_all_salepoint_in_date", obj);
            return res;
        }
        //Đã chỉnh cho trưởng nhóm
        public async Task<List<DataQuantityInteractLotteryByDateModel>> GetDataQuantityInteractLotteryByDate(ReportRequestModel req)
        {
            var obj = new
            {
                p_user_role = req.UserRoleId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<DataQuantityInteractLotteryByDateModel>("crm_report_get_data_shift_transfer_by_date_v2", obj);
            return res;
        }
        //Đã chỉnh cho trưởng nhóm
        public async Task<List<DataQuantityInteractLotteryByMonthModel>> GetDataQuantityInteractLotteryByMonth(ReportRequestModel req)
        {
            var obj = new 
            {
                p_user_role = req.UserRoleId,
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<DataQuantityInteractLotteryByMonthModel>("crm_report_get_data_shift_transfer_by_month_v2", obj);
            return res;
        }

        public async Task<ReportManagerOverallModel> GetReportManagerOverall(ReportManagerOverallReq req)
        {
            var obj = new
            {
                p_user_role_id = req.UserRoleId,
                p_lottery_date = req.LotteryDate,
                p_sale_point_id = req.SalePointId
            };
            var res = (await base.ExecStoredProcAsync<ReportManagerOverallModel>("crm_report_manager_overall_v5", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<TotalLotteryNotSellOfAllSalePointModel>> GetTotalLotteryNotSellOfAllSalePoint(ReportRequestModel req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<TotalLotteryNotSellOfAllSalePointModel>("crm_report_get_total_lottery_not_sell_by_date", obj);
            return res;
        }
        


        // Đã chỉnh cho trưởng nhóm
        public async Task<List<TotalLotterySoldOfSalePointThatYouManageModel>> GetTotalLotterySoldOfSalePointThatYouManage(ReportRequestModel req)
        {
            var obj = new
            {
                p_user_role = req.UserRoleId,
                p_date = req.Date,
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<TotalLotterySoldOfSalePointThatYouManageModel>("crm_report_get_total_lottery_sell_of_some_salepoint_is_managed", obj);
            return res;
        }

        public async Task<List<AverageLotterySellOfUserModel>> GetAverageLotterySellOfUser(TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_userId = 0, //ban đầu là req.UserId
                p_lottery_type = req.LotteryTypeId
            };
            var res = (await base.ExecStoredProcAsync<AverageLotterySellOfUserModel>("crm_report_average_lottery_sell_of_user_to_current_date", obj));
            return res;
        }

        public async Task<List<LogDistributeForSalepointModel>> GetLogDistributeForSalepoint(LogDistributeForSalepointReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_sale_point_id = req.SalePointId
            };
            var res = (await base.ExecStoredProcAsync<LogDistributeForSalepointModel>("crm_report_get_log_distribute_for_salepoint_v4", obj));
            return res;
        }

        public async Task<GetListForUpdateModel> GetListForUpdate(GetListForUpdateReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_sale_point_id = req.SalepointId,
                p_shift_id = req.ShiftId
            };
            var res = (await base.ExecStoredProcAsync<GetListForUpdateModel>("crm_report_get_list_sale_for_update", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateORDeleteSalePointLog(UpdateORDeleteSalePointLogReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_distributeId  = req.DistributeId,
                p_sale_point_id = req.SalePointId,
                p_update_data = req.UpdateData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_report_update_salepoint_by_distributeid", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetFullTotalItemInMonthModel>> GetFullTotalItemInMonth(GetFullTotalItemInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<GetFullTotalItemInMonthModel>("crm_report_get_data_item_in_month_v5", obj));
            return res;
        }

        public async Task<ReturnMessage> UpdateORDeleteItem(UpdateORDeleteItemReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_item_create_or_update", obj)).FirstOrDefault();
            return res;
        }

        public async Task<GetLotterySellInMonthModel> GetLotterySellInMonth(GetLotterySellInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = (await base.ExecStoredProcAsync<GetLotterySellInMonthModel>("crm_report_get_lottery_sell_in_month", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DeleteShiftTransfer(DeleteShiftTransferReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_shift_distribute_id = req.ShiftDistributeId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_report_delete_shift_transfer", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<SaleOfSalePointInMonthModel>> GetSaleOfSalePointInMonth(SaleOfSalePointInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<SaleOfSalePointInMonthModel>("crm_report_sale_of_salepoint_in_month_v5", obj));
            return res;
        }

        public async Task<List<GetTransitonTypeOffsetModel>> GetTransitonTypeOffset(GetTransitonTypeOffsetReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<GetTransitonTypeOffsetModel>("crm_report_get_transiton_type_offset_v4", obj));
            return res;
        }

        public async Task<List<GetSalaryInMonthOfUserModel>> GetSalaryInMonthOfUser(GetSalaryInMonthOfUserReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<GetSalaryInMonthOfUserModel>("crm_report_get_salary_of_user", obj));
            return res;
        }

        public async Task<List<TotalLotteryReceiveOfAllAgencyInDayModel>> TotalLotteryReceiveOfAllAgencyInDay(TotalLotteryReceiveOfAllAgencyInDayReq req)
        {
            var obj = new
            {
                p_agency_id = req.AgencyId,
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<TotalLotteryReceiveOfAllAgencyInDayModel>("crm_report_get_total_lottery_of_all_agency_in_day", obj));
            return res;
        }
        
        public async Task<ReturnMessage> UpdateReturnMoney(UpdateReturnMoneyReq req)
        {
            var obj = new
            {
                p_return_money_id = req.ReturnMoneyId,
                p_return_money = req.ReturnMoney
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_report_update_return_money", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateReportLottery(UpdateReportLotteryReq req)
        {
            var obj = new
            {
                p_shift_id = req.ShiftId,
                p_sale_point_id = req.SalePointId,
                p_lotteryChannel_id = req.LotteryChannelId,
                p_lottery_type_id = req.LotteryTypeId,
                p_report_type = req.LotteryTypeId,
                p_received = req.Received,
                p_transfer = req.Transfer,
                p_sold_retail = req.SoldRetail,
                p_sold_wholesale = req.SoldWholeSale,
                p_sold_retail_money = req.SoldRetailMoney,
                p_sold_wholesale_money = req.SoldWholeSaleMoney,
                p_split_tickets = req.SplitTickets,
                p_lottery_date = req.LotteryDate
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_report_update_report_lottery", obj))
                .FirstOrDefault();
            return res;
        }

        public async Task<List<ReportLotteryInADayModel>> ReportLotteryInADay(ReportLotteryInADayReq req)
        {
            var obj = new
            {
                p_sale_point_id = req.SalePointId,
                p_date = req.Date,
                p_shift_id = req.ShiftId
            };

            var res = (await base.ExecStoredProcAsync<ReportLotteryInADayModel>("crm_report_lottery_in_a_day", obj));

            return res;
        }

        public async Task<List<ReportRemainingLotteryModel>> ReportRemainingLottery(ReportRemainingLotteryReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<ReportRemainingLotteryModel>("crm_report_remaining_lottery", obj));
            return res;
        }
        public async Task<List<ReuseReportDataFinishShiftModel>> ReuseReportDataFinishShift(ReuseReportDataFinishShiftReq req)
        {
            var obj = new
            {
                p_user_role = req.UserRole,
                p_shift_dis_id = req.ShiftDistributeId
            };

            var res = (await base.ExecStoredProcAsync<ReuseReportDataFinishShiftModel>("crm_report_data_finish_shift_v5_reuse", obj));
            return res;
        }

        public async Task<List<GetListUnsoldLotteryTicketModel>> GetListUnsoldLotteryTicket(GetListUnsoldLotteryTicketReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<GetListUnsoldLotteryTicketModel>("crm_report_get_list_unsold_lottery_ticket", obj));
            return res;
        }

        public async Task<ReturnMessage> UpdateKpi(UpdateKpiReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_note = req.Note,
                p_kpi_log_id = req.KPILogId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_report_update_kpi", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetListTotalNumberOfTicketsOfEachManagerModel>> GetListTotalNumberOfTicketsOfEachManager(GetListTotalNumberOfTicketsOfEachManagerReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<GetListTotalNumberOfTicketsOfEachManagerModel>("crm_report_get_list_total_number_of_tickets_of_each_manager", obj));
            return res;
        }

        public async Task<ReturnMessage> UpdateIsSumKpi(UpdateIsSumKpiReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
                p_week_id = req.WeekId,
                p_month = req.Month,
                p_is_deleted = req.IsDeleted
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_report_update_is_sum_kpi", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetListExemptKpiModel>> GetListExemptKpi(GetListExemptKpiReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };

            var res = (await base.ExecStoredProcAsync<GetListExemptKpiModel>("crm_report_get_list_exempt_kpi", obj));
            return res;
        }
    }
}
