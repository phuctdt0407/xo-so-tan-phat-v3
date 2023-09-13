using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using KTHub.Core.DBConnection;
using Microsoft.Extensions.Configuration;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User;
using System;

namespace TANPHAT.CRM.Provider
{
    public interface IUserProvider
    {
        Task<UserModel> GetUserSessionInfo(UserDetailReq req);
        Task<ReturnMessage> UpdateTotalFirst(UpdateTotalFirstReq req);
        Task<ReturnMessage> DistributeShift(DistributeShiftReq req);
        Task<ReturnMessage> UpdateTransaction(UpdateTransactionReq req);
        Task<ReturnMessage> UpdateScratchcardFullLog(UpdateScratchcardFullLogReq req);
        Task<List<DataDistributeShiftModel>> GetDataDistributeShift(DataDistributeShiftReq req); 
        Task<List<GetHistoryScratchCardLogModel>> GetHistoryScratchCardLog(GetHistoryScratchCardLogReq req);
        Task<List<GetHistoryScratchCardFullLogModel>> GetHistoryScratchCardFullLog(GetHistoryScratchCardFullLogReq req);
        Task<ReturnMessage> UpdateShift(UpdateShiftReq req);
        Task<ReturnMessage> UpdateScratchcardLog(UpdateScratchcardLogReq req);
        Task<List<ListUserModel>> GetListUser(ListUserReq req);
        Task<List<SalePointManageModel>> GetSalePointManage(SalePointManageReq req);

        Task<List<PermissionByTitleModel>> GetPermissionByTitle(PermissionByTitleReq req);

        Task<ReturnMessage> UpdatePermissionRole(UpdatePermissionRoleReq req);
        
        Task<ReturnMessage> DistributeShiftMonth(DistributeShiftMonthReq req);

        Task<List<DataDistributeShiftModel>> GetDataDistributeShiftMonth(DataDistributeShiftReq req);

        Task<List<AllShiftInMonthOfOneUserModel>> GetAllShiftInMonthOfOneUser(AllShiftInMonthOfOneUserReq req);

        Task<List<ListEventDateModel>> GetListEventDate(ListEventDateReq req);

        Task<List<ListKPIOfUserModel>> GetListKPIOfUser(ListKPIOfUserReq req);

        Task<List<SalePointInDateModel>> GetListSalePointInDate(SalePointInDateReq req);

        Task<List<AverageKPIModel>> GetListAverageKPI(AverageKPIReq req);

        Task<List<ListSalaryModel>> GetListSalary(ListSalaryReq req);

        Task<List<ListOffOfLeaderModel>> GetListOffOfLeader(ListOffOfLeaderReq req);

        Task<List<ListFundInYearModel>> GetListFundInYear(ListFundInYearReq req);

        Task<List<ListBorrowForConfirmModel>> GetListBorrowForConfirm(ListBorrowForConfirmReq req);

        Task<List<ListBorrowInMonthModel>> GetListBorrowInMonth(ListBorrowInMonthReq req);

        Task<ListTargetModel> GetListTarget(ListTargetReq req);

        Task<ListTargetMasterModel> GetListTargetMaster(ListTargetMasterReq req);

        Task<ReturnMessage> CreateUser(CreateUserReq req);

        Task<ReturnMessage> UpdateUserInfo(UpdateUserInfoReq req);

        Task<ReturnMessage> UpdateListEventDate(UpdateListEventDateReq req);

        Task<ReturnMessage> UpdateListTarget(UpdateListTargetReq req);

        Task<ReturnMessage> UpdateListTargetnew(UpdateListTargetReq req);

        Task<ReturnMessage> UpdateListKPI(UpdateListKPIReq req);

        Task<ReturnMessage> ConfirmSalary(ConfirmSalaryReq req);

        Task<ReturnMessage> InsertUpdateBorrow(InsertUpdateBorrowReq req);

        Task<ReturnMessage> PayBorrow(PayBorrowReq req);
        Task<ReturnMessage> CreateManager(CreateManagerReq req);
        Task<List<GetShiftDistributeOfInternModel>> GetShiftDistributeOfIntern(GetShiftDistributeOfInternReq req);
        Task<ReturnMessage> UpdateShiftDistributeForIntern(UpdateShiftDistributeForInternReq req);
        Task<ReturnMessage> UpdateActiveStatusForUser(UpdateActiveStatusForUserReq req);
        Task<ReturnMessage> DeleteDistributeForIntern(DeleteDistributeForInternReq req);
    }

    public class UserProvider : PostgreExecute, IUserProvider
    {
        public UserProvider(IConfiguration configuration) : base(configuration, DBCommon.TANPHATCRMConnStr)
        {
        }

        public async Task<ReturnMessage> DistributeShift(DistributeShiftReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_sale_point_id = req.SalePointId,
                p_data = req.DistributeData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_distribute_shift", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<DataDistributeShiftModel>> GetDataDistributeShift(DataDistributeShiftReq req)
        {
            var obj = new
            {
                p_distribute_month = req.DistributeMonth,
                p_sale_point_id = req.SalePointId,
                p_is_active = req.IsActive

            };
            var res = await base.ExecStoredProcAsync<DataDistributeShiftModel>("crm_user_get_data_distribute_shift_v2", obj);
            return res;
        }

        public async Task<List<ListUserModel>> GetListUser(ListUserReq req)
        {
            var obj = new
            {
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber,
                p_usertitle_id = req.UserTitleId
            };
            if (req.QuitJob == 1)
            {
                var res = await base.ExecStoredProcAsync<ListUserModel>("crm_user_get_list_quitJob", obj);
                return res;
            }
            else
            {
                var res = await base.ExecStoredProcAsync<ListUserModel>("crm_user_get_list", obj);
                return res;
            }
            
        }

        public async Task<List<PermissionByTitleModel>> GetPermissionByTitle(PermissionByTitleReq req)
        {
            var obj = new
            {
                p_title = req.UserTitleId
            };
            var res = await base.ExecStoredProcAsync<PermissionByTitleModel>("crm_permission_get_by_title", obj);
            return res;
        }

        public async Task<List<SalePointManageModel>> GetSalePointManage(SalePointManageReq req)
        {
            var obj = new
            {
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<SalePointManageModel>("crm_sale_point_manage_v2", obj);
            return res;
        }

        public async Task<UserModel> GetUserSessionInfo(UserDetailReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId
            };
            var res = (await base.ExecStoredProcAsync<UserModel>("crm_user_get_session_info", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateShift(UpdateShiftReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_distribute_date = req.DistributeDate,
                p_sale_point_id = req.SalePointId,
                p_shift_id = req.ShiftId,
                p_user_id = req.UserId,
                p_shift_type_id = req.ShiftTypeId,
                p_note = req.Note
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_shift", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdatePermissionRole(UpdatePermissionRoleReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_title = req.UserTitleId,
                p_list_role = req.ListRole
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_permission_update_title_role", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DistributeShiftMonth(DistributeShiftMonthReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_month = req.Month,
                p_distribute_data = req.DistributeData,
                p_attendance_data = req.AttendanceData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_shift_distribute_month_v2", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<DataDistributeShiftModel>> GetDataDistributeShiftMonth(DataDistributeShiftReq req)
        {
            var obj = new
            {
                p_distribute_month = req.DistributeMonth

            };
            var res = await base.ExecStoredProcAsync<DataDistributeShiftModel>("crm_user_get_data_distribute_month", obj);
            return res;
        }

        public async Task<List<AllShiftInMonthOfOneUserModel>> GetAllShiftInMonthOfOneUser(AllShiftInMonthOfOneUserReq req)
        {
            var obj = new
            {
                p_user_role = req.UserRoleId,
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<AllShiftInMonthOfOneUserModel>("crm_get_all_shift_of_one_employee", obj);
            return res;
        }

        public async Task<ReturnMessage> CreateUser(CreateUserReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_create", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateUserInfo(UpdateUserInfoReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_user_id = req.UserId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_info", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<ListEventDateModel>> GetListEventDate(ListEventDateReq req)
        {
            var obj = new
            {
                p_year = req.Year,
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<ListEventDateModel>("crm_user_get_list_event_date", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateListEventDate(UpdateListEventDateReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_event_date", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<ListTargetModel> GetListTarget(ListTargetReq req)
        {
            var obj = new
            {
             
            };
            var res = (await base.ExecStoredProcAsync<ListTargetModel>("crm_user_get_list_target", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<ReturnMessage> UpdateListTarget(UpdateListTargetReq req)
        {
            var obj = new
            {
                //p_action_by = req.ActionBy,
                //p_action_by_name = req.ActionByName,
                //p_target_type_id = req.TargetTypeId,
                p_data = req.Data
            };
            //var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_target", obj)).FirstOrDefault();
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_target_new", obj)).FirstOrDefault();
            return res; ;
        }
        public async Task<ReturnMessage> UpdateListTargetnew(UpdateListTargetReq req)
        {
            var obj = new
            {
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_target_new", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<ReturnMessage> UpdateListKPI(UpdateListKPIReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_kpi_of_user", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<List<ListKPIOfUserModel>> GetListKPIOfUser(ListKPIOfUserReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_user_id = req.UserId
            };
            var res = await base.ExecStoredProcAsync<ListKPIOfUserModel>("crm_user_get_list_KPI_of_user_by_month", obj);
            return res;
        }

        public async Task<List<SalePointInDateModel>> GetListSalePointInDate(SalePointInDateReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<SalePointInDateModel>("crm_user_get_list_salepoint_in_date", obj);
            return res;
        }

        public async Task<List<AverageKPIModel>> GetListAverageKPI(AverageKPIReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_user_id = req.UserId
            };
            var res = await base.ExecStoredProcAsync<AverageKPIModel>("crm_user_get_average_KPI_of_user_by_month", obj);
            return res;
        }

        public async Task<List<ListSalaryModel>> GetListSalary(ListSalaryReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_user_id = req.UserId
            };
            var res = await base.ExecStoredProcAsync<ListSalaryModel>("crm_get_salary_of_user_by_month_v10", obj);
            return res;
        }

        public async Task<List<ListOffOfLeaderModel>> GetListOffOfLeader(ListOffOfLeaderReq req)
        {
            var obj = new
            {
                p_month = req.Month
            };
            var res = await base.ExecStoredProcAsync<ListOffOfLeaderModel>("crm_user_get_list_off_of_leader", obj);
            return res;
        }

        public async Task<ListTargetMasterModel> GetListTargetMaster(ListTargetMasterReq req)
        {
            var obj = new
            {
                p_user_title_id = req.UserTitleId
            };
            var res = (await base.ExecStoredProcAsync<ListTargetMasterModel>("crm_user_get_target_master", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<ReturnMessage> ConfirmSalary(ConfirmSalaryReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data,
                p_action_type = req.ActionType
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_confirm_salary", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<List<ListFundInYearModel>> GetListFundInYear(ListFundInYearReq req)
        {
            var obj = new
            {
                p_year = req.Year
            };
            var res = await base.ExecStoredProcAsync<ListFundInYearModel>("crm_user_get_fund_of_user", obj);
            return res;
        }

        public async Task<ReturnMessage> InsertUpdateBorrow(InsertUpdateBorrowReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_insert_update_confirm_for_manager_borrow", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<List<ListBorrowForConfirmModel>> GetListBorrowForConfirm(ListBorrowForConfirmReq req)
        {
            var obj = new
            {
                p_user_id = req.UserId,
                p_date = req.Date,
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber
            };
            var res = await base.ExecStoredProcAsync<ListBorrowForConfirmModel>("crm_user_get_list_manager_borrow_for_confirm", obj);
            return res;
        }

        public async Task<ReturnMessage> PayBorrow(PayBorrowReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_action_type = req.ActionType,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_pay_for_borrow", obj)).FirstOrDefault();
            return res; ;
        }

        public async Task<List<ListBorrowInMonthModel>> GetListBorrowInMonth(ListBorrowInMonthReq req)
        {
            var obj = new
            {
                p_month = req.Month,
                p_user_id = req.UserId
            };
            var res = await base.ExecStoredProcAsync<ListBorrowInMonthModel>("crm_user_get_list_borrow_in_date", obj);
            return res;
        }

        public async Task<List<GetHistoryScratchCardFullLogModel>> GetHistoryScratchCardFullLog(GetHistoryScratchCardFullLogReq req)
        {
            var obj = new
            {
                p_date=req.Date,
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber,

            };
            var res = await base.ExecStoredProcAsync<GetHistoryScratchCardFullLogModel>("crm_user_get_history_scratch_card_full_log", obj);
            return res;
        }

        public async Task<List<GetHistoryScratchCardLogModel>> GetHistoryScratchCardLog(GetHistoryScratchCardLogReq req)
        {
            var obj = new
            {
                p_date = req.Date,
                p_page_size = req.PageSize,
                p_page_number = req.PageNumber,

            };
            var res = await base.ExecStoredProcAsync<GetHistoryScratchCardLogModel>("crm_user_get_history_scratch_card_log", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateScratchcardFullLog(UpdateScratchcardFullLogReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_scratchcard_full_log_id = req.ScratchcardFullLogId,
                p_revision_number = req.RevisionNumber,
                p_is_deleted = req.IsDeleted
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_scratchcard_full_log", obj)).FirstOrDefault();
            return res; 
        }

        public async Task<ReturnMessage> UpdateScratchcardLog(UpdateScratchcardLogReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_scratchcard_log_id = req.ScratchcardLogId,
                p_revision_number = req.RevisionNumber,
                //p_is_deleted = req.IsDeleted
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_scratchcard_log", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> CreateManager(CreateManagerReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_data = req.Data
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_create_v2", obj)).FirstOrDefault();
            return res;
        }
        public async Task<ReturnMessage> UpdateTransaction(UpdateTransactionReq req)
        {
            var obj = new
            {
                p_transaction_id = req.TransactionId,
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_quantity = req.Quantity,
                p_price = req.Price,
                p_total_price = req.TotalPrice,
                p_date = req.Date
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_sale_point_update_transaction", obj)).FirstOrDefault();
            return res;
        }

        public async Task<List<GetShiftDistributeOfInternModel>> GetShiftDistributeOfIntern(GetShiftDistributeOfInternReq req)
        {
            var obj = new
            {
                p_distribute_month = req.DistributeMonth

            };
            var res = await base.ExecStoredProcAsync<GetShiftDistributeOfInternModel>("crm_user_get_intern_data_distribute_month", obj);
            return res;
        }

        public async Task<ReturnMessage> UpdateShiftDistributeForIntern(UpdateShiftDistributeForInternReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_month = req.Month,
                p_distribute_data = req.DistributeData,
                p_attendance_data = req.AttendanceData
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_shift_distribute_month_intern", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateActiveStatusForUser(UpdateActiveStatusForUserReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_user_id = req.UserId,
                p_toggle = req.Toggle
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_update_status_active_of_staff", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> DeleteDistributeForIntern(DeleteDistributeForInternReq req)
        {
            var obj = new
            {
                p_shift_distribute_id = req.ShiftDistributeId
            };
            var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_delete_shift_of_intern", obj)).FirstOrDefault();
            return res;
        }

        public async Task<ReturnMessage> UpdateTotalFirst(UpdateTotalFirstReq req)
        {
            var obj = new
            {
                p_action_by = req.ActionBy,
                p_action_by_name = req.ActionByName,
                p_user_id = req.UserId,
                p_total_first = req.TotalFirst,
               
            };
            if (req.Insure == 1)
            {
                var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_insure1", obj)).FirstOrDefault();
                return res;
            }
            else
            {
                var res = (await base.ExecStoredProcAsync<ReturnMessage>("crm_user_update_total_first", obj)).FirstOrDefault();
                return res;
            }
            
            
        }
    }
}