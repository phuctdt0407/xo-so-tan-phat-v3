using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using KTHub.Core.DBConnection;
using Microsoft.Extensions.Configuration;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.SalePoint;
using System;

namespace TANPHAT.CRM.Provider
{
    public interface ISalePointProvider
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

    public class SalePointProvider : PostgreExecute, ISalePointProvider
    {
        public SalePointProvider(IConfiguration configuration) : base(configuration, DBCommon.TANPHATCRMConnStr)
        {
        }

        public async Task<List<GetListFeeOutsiteModel>> GetListFeeOutsite(GetListFeeOutsiteReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_salepoint_id = req.SalePointId,
                p_shift_dis_id = req.ShiftDistributeId
            };
            var res = await base.ExecStoredProcAsync<GetListFeeOutsiteModel>("crm_sale_point_get_list_fee_outsite", obj);
            return res;
        }

        public async Task<List<GetListItemConfirmModel>> GetListItemConfirm(GetListItemConfirmReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_sale_point_id= req.SalePointId,
                p_confirm_for_type_id =req.ConfirmForTypeId 
            };
            var res = (await base.ExecStoredProcAsync<GetListItemConfirmModel>("crm_item_get_list_confirm_v1", obj));
            return res;
        }

        public async Task<List<GetListSalePointModel>> GetListSalePoint(GetListSalePointReq req)
        {
            var obj = new
            {
                p_id = req.Id
            };
            var res = await base.ExecStoredProcAsync<GetListSalePointModel>("crm_get_list_sale_point_v2", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateFeeOutSite(UpdateFeeOutSiteReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_action_type = req.ActionType
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_sale_point_insert_or_update_fee_outsite", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateItemInSalePoint(UpdateItemInSalePointReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_type_action_id = req.TypeAction,
                p_data = req.Data,
                p_confirm_log_id = req.ItemConfirmLogId ?? 0,
                p_confirm_type = req.ConfirmTypeId ?? 1,
                p_confirm_for = req.ConfirmFor ?? 1,
                p_data_info = req.DataInfo,
                p_guest_id = req.GuestId
            };

            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_update_cornfirm_item_v3", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateOrCreateGuest(UpdateOrCreateGuestReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_create_or_update_guest", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateSalePoint(UpdateSalePointReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_sale_point_id = req.SalePointId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_sale_point_update_info_v2", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateOrCreateGuestAction(UpdateOrCreateGuestActionReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_order_id = req.OrderId,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_update_guest_action_v2", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> CreateListConfirmPayment(CreateListConfirmPaymentReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_guest_id = req.GuestId,
                p_lottery_data = req.LotteryData,
                p_lottery_data_info = req.LotteryDataInfo,
                p_payment_data = req.PaymentData,
                p_order_id = req.OrderId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_create_list_confirm_payment_v2", obj)).FirstOrDefault();
            return res;
        }


        public async Task<List<GetListConfirmPaymentModel>> GetListConfirmPayment(GetListConfirmPaymentReq req)
        {
            var obj = new
            {
                p_sale_point_id = req.SalePointId,
                p_guest_id = req.GuestId,
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber
            };
            var res = (await base.ExecStoredProcAsync<GetListConfirmPaymentModel>("crm_salepoint_get_list_confirm_payment", obj));
             return res;
        }
        public async Task<List<ListComissionModel>> GetListComission(ListCommissionReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<ListComissionModel>("crm_salepoint_get_commision_of_all_user_in_month", obj);
            return res;
        }

        public async Task<ReturnMessage> ConfirmListPayment(ConfirmListPaymentReq req)
        {         
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_confirm_type = req.ConfirmTypeId,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_confirm_list_payment_v2", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateCommission(UpdateCommissionReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_update_commission", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateHistoryOrder(UpdateHistoryOrderReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_update_history_order", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<ListHistoryOrderModel>> GetListHistoryOrder(ListHistoryOrderReq req)
        {
            var obj = new
            {
                p_page_size= req.PageSize,
                p_page_number = req.PageNumber,
                p_date = req.Date,
                p_sale_point_id = req.SalePointId,
                p_shift_distribute_id = req.ShiftDistributeId
            };
            var res = await base.ExecStoredProcAsync<ListHistoryOrderModel>("crm_salepoint_get_list_history_order_v1", obj);
            return res;
        }
        /*
         * SaleOfVietlott TransactionTypeId = 2
         * SaleOfLoto TransactionTypeId = 3
         * PunishUser TransactionTypeId = 4
         * AdvanceSalary TransactionTypeId = 5
         * OvertimeForUser TransactionTypeId = 6
         * RewardForUser TransactionTypeId = 7
         * DebtForUser TransactionTypeId = 8
         * PayVietlott TransactionTypeId = 9
         * SaleOfVietlottForCheck TransactionTypeId = 10
         * PayFundOfUserInsurance TransactionTypeId = 11
         * UseUnion TransactionTypeId = 12
         * PayFundOfUserCommission TransactionTypeId = 13
         */
        public async Task<ReturnMessage> InsertUpdateTransaction(InsertUpdateTransactionReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_transaction_type_id = req.TransactionTypeId,
                p_data = req.Data,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_insert_update_transaction", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<ListUserByDateAndSalePointModel>> GetListUserByDateAndSalePoint(ListUserByDateAndSalePointReq req)
        {
            var obj = new
            {
                p_sale_point_id = req.SalePointId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<ListUserByDateAndSalePointModel>("crm_salepoint_get_user_by_date_and_salepoint", obj);
            return res;
        }

        public async Task<List<DataForGuestReturnModel>> GetDataForGuestReturn(DataForGuestReturnReq req)
        {
            var obj = new
            {
                p_guest_id = req.GuestId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<DataForGuestReturnModel>("crm_salepoint_get_history_lottery_of_guest", obj);
            return res;
        }

        public async Task<List<GuestForConfirmModel>> GetListGuestForConfirm(GuestForConfirmReq req)
        {
            var obj = new
            {
                p_sale_point_id = req.SalePointId
            };
            var res = await base.ExecStoredProcAsync<GuestForConfirmModel>("crm_salepoint_get_list_guest_for_confirm", obj);
            return res;
        }

        public async Task<List<FeeOfCommissionModel>> GetListFeeOfCommission(FeeOfCommissionReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<FeeOfCommissionModel>("crm_salepoint_get_list_fee_of_commission", obj);
            return res;
        }

        public async Task<List<TransactionModel>> GetListTransaction(TransactionReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_user_id = req.UserId,
                p_type = req.Type
            };
            var res = await base.ExecStoredProcAsync<TransactionModel>("crm_salepoint_get_list_transaction", obj);
            return res;
        }

        public async Task<List<PaymentForConfirmModel>> GetListPaymentForConfirm(PaymentForConfirmReq req)
        {
            var obj = new
            {
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber,
                p_salepoint_id = req.SalePointId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<PaymentForConfirmModel>("crm_get_list_payment_for_confirm", obj);
            return res;
        }

        public async Task<List<SalePointOfLeaderModel>> GetListSalePointOfLeader(SalePointOfLeaderReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<SalePointOfLeaderModel>("crm_get_list_salepoint_of_leader", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateDateOffOfLeader(UpdateDateOffOfLeaderReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_data = req.Data,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_update_date_off_of_leader_v2", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<ListAttendentOfLeaderModel>> GetListAttendentOfLeader(ListAttendentOfLeaderReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<ListAttendentOfLeaderModel>("crm_salepoint_get_list_leader_attendent", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateLeaderAttendent(UpdateLeaderAttendentReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_update_leader_attendent", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<ListSaleOfVietLottInDateModel>> GetListSaleOfVietLottInDate(ListSaleOfVietLottInDateReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<ListSaleOfVietLottInDateModel>("crm_salepoint_get_list_sale_of_vietlott_in_date", obj);
            return res;
        } 

        public async Task<List<ListSaleOfVietLottInMonthModel>> GetListSaleOfVietLottInMonth(ListSaleOfVietLottInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_sale_point_id = req.SalePointId
            };
            var res = await base.ExecStoredProcAsync<ListSaleOfVietLottInMonthModel>("crm_salepoint_get_sale_vietlott_in_date", obj);
            return res;
        }

        public async Task<List<ListSaleOfLotoInMonthModel>> GetListSaleOfLotoInMonth(ListSaleOfLotoInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_sale_point_id = req.SalePointId,
                p_transaction_type = req.TransactionType
            };
            var res = await base.ExecStoredProcAsync<ListSaleOfLotoInMonthModel>("crm_salepoint_get_sale_loto_in_date_v1", obj);
            return res;
        }

        public async Task<List<ListFeeOutSiteInMonthModel>> GetListFeeOutSiteInMonth(ListFeeOutSiteInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_user_id = req.UserId
            };
            var res = await base.ExecStoredProcAsync<ListFeeOutSiteInMonthModel>("crm_salepoint_get_fee_outsite_in_month", obj);
            return res;
        }

        public async Task<ListUnionInYearModel> GetListUnionInYear(ListUnionInYearReq req)
        {
            var obj = new
            {
                p_year = req.Year,
            };
            var res = (await base.ExecStoredProcAsync<ListUnionInYearModel>("crm_salepoint_get_list_union_in_year", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<ListHistoryOfGuestModel>> GetListHistoryOfGuest(ListHistoryOfGuestReq req)
        {
            var obj = new
            {
                p_guest_id = req.GuestId,
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber
            };
            var res = await base.ExecStoredProcAsync<ListHistoryOfGuestModel>("crm_salepoint_get_list_history_of_guest", obj);
            return res;
        }

        public async Task<List<ListPayVietlottModel>> GetListPayVietlott(ListPayVietlottReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<ListPayVietlottModel>("crm_salpoint_get_list_pay_vietlott", obj);
            return res;
        }

        public async Task<List<ListSalePointPercentModel>> GetListSalePointPercent(ListSalePointPercentReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<ListSalePointPercentModel>("crm_salepoint_get_percent", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdatePercent(UpdatePercentReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_update_percent", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<ListLotteryAwardExpectedModel>> GetListLotteryAwardExpected(ListLotteryAwardExpectedReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_salepoint_id = req.SalePointId
            };
            var res = await base.ExecStoredProcAsync<ListLotteryAwardExpectedModel>("crm_salepoint_get_list_lottery_award_expected", obj);
            return res;
        }
        public async Task<List<GetListOtherFeesModel>> GetListOtherFees(GetListOtherFeesReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_sale_point_id = req.SalePointId,
            };
            var res = await base.ExecStoredProcAsync<GetListOtherFeesModel>("crm_activity_get_list_other_fees", obj);
            return res;
        }

        public async Task<List<GetTotalCommisionAndFeeModel>> GetTotalCommisionAndFee(GetTotalCommisionAndFeeReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_salepoint_id = req.SalePointId,
            };
            var res = await base.ExecStoredProcAsync<GetTotalCommisionAndFeeModel>("crm_salepoint_get_total_commision", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateCommisionAndFee(UpdateCommisionAndFeeReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_commissionid = req.CommisionId,
                p_commision = req.Commision,
                p_fee = req.Fee
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_update_total_commision_and_fee", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DeleteStaffInCommissionWining(DeleteStaffInCommissionWiningReq req)
        {
            var obj = new
            {
                p_commissionId = req.CommissionId,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_salepoint_delete_staff_in_commission_winning", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> CreateSubAgency(CreateSubAgencyReq req)
        {
            var obj = new
            {
                p_agency_name = req.SubAgencyName,
                p_price = req.Price,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_create_sub_agency", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetAllStaticFeeModel>> GetAllStaticFee(GetAllStaticFeeReq req)
        {
            var obj = new
            {
            };
            var res = await base.ExecStoredProcAsync<GetAllStaticFeeModel>("crm_salepoint_get_static_fee", obj);
            return res;
        }
    }
}
