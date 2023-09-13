using System.Collections.Generic;
using System.Threading.Tasks;
using KTHub.Core.Client;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User;
using TANPHAT.CRM.Domain.Models.User.Enum;
using System;

namespace TANPHAT.CRM.Client
{
    public interface IUserClient
    {
        Task<ApiResponse<UserModel>> GetUserSessionInfo(UserDetailReq req);
        Task<ApiResponse<ReturnMessage>> UpdateTotalFirst(UpdateTotalFirstReq req);
        Task<ApiResponse<ReturnMessage>> UpdateTransaction(UpdateTransactionReq req);
        Task<ApiResponse<ReturnMessage>> UpdateScratchcardFullLog(UpdateScratchcardFullLogReq req);
        Task<ApiResponse<ReturnMessage>> UpdateScratchcardLog(UpdateScratchcardLogReq req);
        Task<ApiResponse<ReturnMessage>> DistributeShift(DistributeShiftReq req);

        Task<ApiResponse<List<DataDistributeShiftModel>>> GetDataDistributeShift(DataDistributeShiftReq req);
        Task<ApiResponse<List<GetHistoryScratchCardFullLogModel>>> GetHistoryScratchCardFullLog(GetHistoryScratchCardFullLogReq req);
        Task<ApiResponse<ReturnMessage>> UpdateShift(UpdateShiftReq req);

        Task<ApiResponse<List<ListUserModel>>> GetListUser(ListUserReq req);
        
        Task<ApiResponse<List<GetHistoryScratchCardLogModel>>> GetHistoryScratchCardLog(GetHistoryScratchCardLogReq req);
        Task<ApiResponse<List<SalePointManageModel>>> GetSalePointManage(SalePointManageReq req);

        Task<ApiResponse<List<PermissionByTitleModel>>> GetPermissionByTitle(PermissionByTitleReq req);

        Task<ApiResponse<ReturnMessage>> UpdatePermissionRole(UpdatePermissionRoleReq req);

        Task<ApiResponse<ReturnMessage>> DistributeShiftMonth(DistributeShiftMonthReq req);

        Task<ApiResponse<List<DataDistributeShiftModel>>> GetDataDistributeShiftMonth(DataDistributeShiftReq req);

        Task<ApiResponse<List<AllShiftInMonthOfOneUserModel>>> GetAllShiftInMonthOfOneUser(AllShiftInMonthOfOneUserReq req);

        Task<ApiResponse<ReturnMessage>> CreateUser(CreateUserReq req);

        Task<ApiResponse<ReturnMessage>> UpdateUserInfo(UpdateUserInfoReq req);

        Task<ApiResponse<ReturnMessage>> UpdateListEventDate(UpdateListEventDateReq req);

        Task<ApiResponse<ReturnMessage>> UpdateListTarget(UpdateListTargetReq req);

        Task<ApiResponse<ReturnMessage>> UpdateListKPI(UpdateListKPIReq req);

        Task<ApiResponse<ReturnMessage>> ConfirmSalary(ConfirmSalaryReq req);

        Task<ApiResponse<ReturnMessage>> InsertUpdateBorrow(InsertUpdateBorrowReq req);

        Task<ApiResponse<ReturnMessage>> PayBorrow(PayBorrowReq req);

        Task<ApiResponse<ListTargetModel>> GetListTarget(ListTargetReq req);

        Task<ApiResponse<ListTargetMasterModel>> GetListTargetMaster(ListTargetMasterReq req);

        Task<ApiResponse<List<ListEventDateModel>>> GetListEventDate(ListEventDateReq req);

        Task<ApiResponse<List<ListKPIOfUserModel>>> GetListKPIOfUser(ListKPIOfUserReq req);

        Task<ApiResponse<List<SalePointInDateModel>>> GetListSalePointInDate(SalePointInDateReq req);

        Task<ApiResponse<List<AverageKPIModel>>> GetListAverageKPI(AverageKPIReq req);

        Task<ApiResponse<List<ListSalaryModel>>> GetListSalary(ListSalaryReq req);

        Task<ApiResponse<List<ListOffOfLeaderModel>>> GetListOffOfLeader(ListOffOfLeaderReq req);

        Task<ApiResponse<List<ListFundInYearModel>>> GetListFundInYear(ListFundInYearReq req);

        Task<ApiResponse<List<ListBorrowForConfirmModel>>> GetListBorrowForConfirm(ListBorrowForConfirmReq req);

        Task<ApiResponse<List<ListBorrowInMonthModel>>> GetListBorrowInMonth(ListBorrowInMonthReq req);
        Task<ApiResponse<ReturnMessage>> CreateManager(CreateManagerReq req);
        Task<ApiResponse<List<GetShiftDistributeOfInternModel>>> GetShiftDistributeOfIntern(GetShiftDistributeOfInternReq req);
        Task<ApiResponse<ReturnMessage>> UpdateShiftDistributeForIntern(UpdateShiftDistributeForInternReq req);
        Task<ApiResponse<ReturnMessage>> UpdateActiveStatusForUser(UpdateActiveStatusForUserReq req);
        Task<ApiResponse<ReturnMessage>> DeleteDistributeForIntern(DeleteDistributeForInternReq req);
    }

    public class UserClient : BaseApiClient, IUserClient
    {
        private string urlSend { get; set; }

        public UserClient(ApiConfigs configs) : base(configs)
        {
            urlSend = base.GetUrlSend(UrlCommon.T_User);
        }

        public async Task<ApiResponse<UserModel>> GetUserSessionInfo(UserDetailReq req)
        {
            req.TypeName = UserGetType.GetUserSessionInfo;
            return await GetAsync<UserModel, UserDetailReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DistributeShift(DistributeShiftReq req)
        {
            req.TypeName = UserPostType.DistributeShift;
            return await PostAsync<ReturnMessage, DistributeShiftReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataDistributeShiftModel>>> GetDataDistributeShift(DataDistributeShiftReq req)
        {
            req.TypeName = UserGetType.GetDataDistributeShift;
            return await GetAsync<List<DataDistributeShiftModel>, DataDistributeShiftReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateShift(UpdateShiftReq req)
        {
            req.TypeName = UserPostType.UpdateShift;
            return await PostAsync<ReturnMessage, UpdateShiftReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListUserModel>>> GetListUser(ListUserReq req)
        {
            req.TypeName = UserGetType.GetListUser;
            return await GetAsync<List<ListUserModel>, ListUserReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<SalePointManageModel>>> GetSalePointManage(SalePointManageReq req)
        {
            req.TypeName = UserGetType.GetSalePointManage;
            return await GetAsync<List<SalePointManageModel>, SalePointManageReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<PermissionByTitleModel>>> GetPermissionByTitle(PermissionByTitleReq req)
        {
            req.TypeName = UserGetType.GetPermissionByTitle;
            return await GetAsync<List<PermissionByTitleModel>, PermissionByTitleReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdatePermissionRole(UpdatePermissionRoleReq req)
        {
            req.TypeName = UserPostType.UpdatePermissionRole;
            return await PostAsync<ReturnMessage, UpdatePermissionRoleReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DistributeShiftMonth(DistributeShiftMonthReq req)
        {
            req.TypeName = UserPostType.DistributeShiftMonth;
            return await PostAsync<ReturnMessage, DistributeShiftMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataDistributeShiftModel>>> GetDataDistributeShiftMonth(DataDistributeShiftReq req)
        {
            req.TypeName = UserGetType.GetDataDistributeShiftMonth;
            return await GetAsync<List<DataDistributeShiftModel>, DataDistributeShiftReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<AllShiftInMonthOfOneUserModel>>> GetAllShiftInMonthOfOneUser(AllShiftInMonthOfOneUserReq req)
        {
            req.TypeName = UserGetType.GetAllShiftInMonthOfOneUser;
            return await GetAsync<List<AllShiftInMonthOfOneUserModel>, AllShiftInMonthOfOneUserReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> CreateUser(CreateUserReq req)
        {
            req.TypeName = UserPostType.CreateUser;
            return await PostAsync<ReturnMessage, CreateUserReq>(urlSend, req);

        }

        public async Task<ApiResponse<ReturnMessage>> UpdateUserInfo(UpdateUserInfoReq req)
        {
            req.TypeName = UserPostType.UpdateUserInfo;
            return await PostAsync<ReturnMessage, UpdateUserInfoReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListEventDateModel>>> GetListEventDate(ListEventDateReq req)
        {
            req.TypeName = UserGetType.GetListEventDate;
            return await GetAsync<List<ListEventDateModel>, ListEventDateReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateListEventDate(UpdateListEventDateReq req)
        {
            req.TypeName = UserPostType.UpdateListEventDate;
            return await PostAsync<ReturnMessage, UpdateListEventDateReq>(urlSend, req);
        }

        public async Task<ApiResponse<ListTargetModel>> GetListTarget(ListTargetReq req)
        {
            req.TypeName = UserGetType.GetListTarget;
            return await GetAsync<ListTargetModel, ListTargetReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateListTarget(UpdateListTargetReq req)
        {
            req.TypeName = UserPostType.UpdateListTarget;
            return await PostAsync<ReturnMessage, UpdateListTargetReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateListKPI(UpdateListKPIReq req)
        {
            req.TypeName = UserPostType.UpdateListKPI;
            return await PostAsync<ReturnMessage, UpdateListKPIReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListKPIOfUserModel>>> GetListKPIOfUser(ListKPIOfUserReq req)
        {
            req.TypeName = UserGetType.GetListKPIOfUser;
            return await GetAsync<List<ListKPIOfUserModel>, ListKPIOfUserReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<SalePointInDateModel>>> GetListSalePointInDate(SalePointInDateReq req)
        {
            req.TypeName = UserGetType.GetListSalePointInDate;
            return await GetAsync<List<SalePointInDateModel>, SalePointInDateReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<AverageKPIModel>>> GetListAverageKPI(AverageKPIReq req)
        {
            req.TypeName = UserGetType.GetListAverageKPI;
            return await GetAsync<List<AverageKPIModel>, AverageKPIReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListSalaryModel>>> GetListSalary(ListSalaryReq req)
        {
            req.TypeName = UserGetType.GetListSalary;
            return await GetAsync<List<ListSalaryModel>, ListSalaryReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListOffOfLeaderModel>>> GetListOffOfLeader(ListOffOfLeaderReq req)
        {
            req.TypeName = UserGetType.GetListOffOfLeader;
            return await GetAsync<List<ListOffOfLeaderModel>, ListOffOfLeaderReq>(urlSend, req);
        }

        public async Task<ApiResponse<ListTargetMasterModel>> GetListTargetMaster(ListTargetMasterReq req)
        {
            req.TypeName = UserGetType.GetListTargetMaster;
            return await GetAsync<ListTargetMasterModel, ListTargetMasterReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> ConfirmSalary(ConfirmSalaryReq req)
        {
            req.TypeName = UserPostType.ConfirmSalary;
            return await PostAsync<ReturnMessage, ConfirmSalaryReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListFundInYearModel>>> GetListFundInYear(ListFundInYearReq req)
        {
            req.TypeName = UserGetType.GetListFundInYear;
            return await GetAsync<List<ListFundInYearModel>, ListFundInYearReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> InsertUpdateBorrow(InsertUpdateBorrowReq req)
        {
            req.TypeName = UserPostType.InsertUpdateBorrow;
            return await PostAsync<ReturnMessage, InsertUpdateBorrowReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListBorrowForConfirmModel>>> GetListBorrowForConfirm(ListBorrowForConfirmReq req)
        {
            req.TypeName = UserGetType.GetListBorrowForConfirm;
            return await GetAsync<List<ListBorrowForConfirmModel>, ListBorrowForConfirmReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> PayBorrow(PayBorrowReq req)
        {
            req.TypeName = UserPostType.PayBorrow;
            return await PostAsync<ReturnMessage, PayBorrowReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ListBorrowInMonthModel>>> GetListBorrowInMonth(ListBorrowInMonthReq req)
        {
            req.TypeName = UserGetType.GetListBorrowInMonth;
            return await GetAsync<List<ListBorrowInMonthModel>, ListBorrowInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetHistoryScratchCardFullLogModel>>> GetHistoryScratchCardFullLog(GetHistoryScratchCardFullLogReq req)
        {
            req.TypeName = UserGetType.GetHistoryScratchCardFullLog;
            return await GetAsync<List<GetHistoryScratchCardFullLogModel>, GetHistoryScratchCardFullLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetHistoryScratchCardLogModel>>> GetHistoryScratchCardLog(GetHistoryScratchCardLogReq req)
        {
            req.TypeName = UserGetType.GetHistoryScratchCardLog;
            return await GetAsync<List<GetHistoryScratchCardLogModel>, GetHistoryScratchCardLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateScratchcardFullLog(UpdateScratchcardFullLogReq req)
        {
            req.TypeName = UserPostType.UpdateScratchcardFullLog;
            return await PostAsync<ReturnMessage, UpdateScratchcardFullLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateScratchcardLog(UpdateScratchcardLogReq req)
        {
            req.TypeName = UserPostType.UpdateScratchcardLog;
            return await PostAsync<ReturnMessage, UpdateScratchcardLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> CreateManager(CreateManagerReq req)
        {
            req.TypeName = UserPostType.CreateManager;
            return await PostAsync<ReturnMessage, CreateManagerReq>(urlSend, req);
        }
        public async Task<ApiResponse<ReturnMessage>> UpdateTransaction(UpdateTransactionReq req)
        {
            req.TypeName = UserPostType.UpdateTransaction;
            return await PostAsync<ReturnMessage, UpdateTransactionReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetShiftDistributeOfInternModel>>> GetShiftDistributeOfIntern(GetShiftDistributeOfInternReq req)
        {
            req.TypeName = UserGetType.GetShiftDistributeOfIntern;
            return await GetAsync<List<GetShiftDistributeOfInternModel>, GetShiftDistributeOfInternReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateShiftDistributeForIntern(UpdateShiftDistributeForInternReq req)
        {
            req.TypeName = UserPostType.UpdateShiftDistributeForIntern;
            return await PostAsync<ReturnMessage, UpdateShiftDistributeForInternReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateActiveStatusForUser(UpdateActiveStatusForUserReq req)
        {
            req.TypeName = UserPostType.UpdateActiveStatusForUser;
            return await PostAsync<ReturnMessage, UpdateActiveStatusForUserReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DeleteDistributeForIntern(DeleteDistributeForInternReq req)
        {
            req.TypeName = UserPostType.DeleteDistributeForIntern;
            return await PostAsync<ReturnMessage, DeleteDistributeForInternReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateTotalFirst(UpdateTotalFirstReq req)
        {
            req.TypeName = UserPostType.UpdateTotalFirst;
            return await PostAsync<ReturnMessage, UpdateTotalFirstReq>(urlSend, req);
        }
    }
}
