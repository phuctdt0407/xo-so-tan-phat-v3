using System.Collections.Generic;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User;
using TANPHAT.CRM.Provider;

namespace TANPHAT.CRM.Business
{
    public interface IUserBusiness
    {
        Task<UserModel> GetUserSessionInfo(UserDetailReq req);
        
        Task<ReturnMessage> UpdateTotalFirst(UpdateTotalFirstReq req);
        Task<ReturnMessage> DistributeShift(DistributeShiftReq req);
        Task<ReturnMessage> UpdateTransaction(UpdateTransactionReq req);
        Task<List<DataDistributeShiftModel>> GetDataDistributeShift(DataDistributeShiftReq req);
        
        Task<List<GetHistoryScratchCardLogModel>> GetHistoryScratchCardLog(GetHistoryScratchCardLogReq req);
        Task<List<GetHistoryScratchCardFullLogModel>> GetHistoryScratchCardFullLog(GetHistoryScratchCardFullLogReq req);
        Task<ReturnMessage> UpdateShift(UpdateShiftReq req);
        Task<ReturnMessage> UpdateScratchcardFullLog(UpdateScratchcardFullLogReq req);
        Task<ReturnMessage> UpdateScratchcardLog(UpdateScratchcardLogReq req);

        Task<List<ListUserModel>> GetListUser(ListUserReq req);

        Task<List<SalePointManageModel>> GetSalePointManage(SalePointManageReq req);

        Task<List<PermissionByTitleModel>> GetPermissionByTitle(PermissionByTitleReq req);

        Task<ReturnMessage> UpdatePermissionRole(UpdatePermissionRoleReq req);

        Task<ReturnMessage> DistributeShiftMonth(DistributeShiftMonthReq req);

        Task<List<DataDistributeShiftModel>> GetDataDistributeShiftMonth(DataDistributeShiftReq req);

        Task<List<AllShiftInMonthOfOneUserModel>> GetAllShiftInMonthOfOneUser(AllShiftInMonthOfOneUserReq req);

        Task<List<ListKPIOfUserModel>> GetListKPIOfUser(ListKPIOfUserReq req);

        Task<List<ListEventDateModel>> GetListEventDate(ListEventDateReq req);

        Task<List<SalePointInDateModel>> GetListSalePointInDate(SalePointInDateReq req);

        Task<List<AverageKPIModel>> GetListAverageKPI(AverageKPIReq req);

        Task<List<ListSalaryModel>> GetListSalary(ListSalaryReq req);

        Task<List<ListOffOfLeaderModel>> GetListOffOfLeader(ListOffOfLeaderReq req);

        Task<List<ListFundInYearModel>> GetListFundInYear(ListFundInYearReq req);

        Task<List<ListBorrowForConfirmModel>> GetListBorrowForConfirm(ListBorrowForConfirmReq req);

        Task<List<ListBorrowInMonthModel>> GetListBorrowInMonth(ListBorrowInMonthReq req);

        Task<ReturnMessage> CreateUser(CreateUserReq req);

        Task<ReturnMessage> UpdateUserInfo(UpdateUserInfoReq req);

        Task<ReturnMessage> UpdateListEventDate(UpdateListEventDateReq req);

        Task<ReturnMessage> UpdateListTarget(UpdateListTargetReq req);
        Task<ReturnMessage> UpdateListTargetnew(UpdateListTargetReq req);

        Task<ReturnMessage> UpdateListKPI(UpdateListKPIReq req);

        Task<ReturnMessage> ConfirmSalary(ConfirmSalaryReq req);

        Task<ReturnMessage> InsertUpdateBorrow(InsertUpdateBorrowReq req);

        Task<ReturnMessage> PayBorrow(PayBorrowReq req);

        Task<ListTargetModel> GetListTarget(ListTargetReq req);

        Task<ListTargetMasterModel> GetListTargetMaster(ListTargetMasterReq req);
        Task<ReturnMessage> CreateManager(CreateManagerReq req);
        Task<List<GetShiftDistributeOfInternModel>> GetShiftDistributeOfIntern(GetShiftDistributeOfInternReq req);
        Task<ReturnMessage> UpdateShiftDistributeForIntern(UpdateShiftDistributeForInternReq req);
        Task<ReturnMessage> UpdateActiveStatusForUser(UpdateActiveStatusForUserReq req);
        Task<ReturnMessage> DeleteDistributeForIntern(DeleteDistributeForInternReq req);
    }

    public class UserBusiness : IUserBusiness
    {
        private IUserProvider _userProvider;

        public UserBusiness(IUserProvider userProvider)
        {
            _userProvider = userProvider;
        }

        public async Task<ReturnMessage> ConfirmSalary(ConfirmSalaryReq req)
        {
            var res = await _userProvider.ConfirmSalary(req);
            return res;
        }

        public async Task<ReturnMessage> CreateManager(CreateManagerReq req)
        {
            var res = await _userProvider.CreateManager(req);
            return res;
        }

        public async Task<ReturnMessage> CreateUser(CreateUserReq req)
        {
            var res = await _userProvider.CreateUser(req);
            return res;
        }

        public async Task<ReturnMessage> DistributeShift(DistributeShiftReq req)
        {
            var res = await _userProvider.DistributeShift(req);
            return res;
        }

        public async Task<ReturnMessage> DistributeShiftMonth(DistributeShiftMonthReq req)
        {
            var res = await _userProvider.DistributeShiftMonth(req);
            return res;
        }

        public async Task<List<AllShiftInMonthOfOneUserModel>> GetAllShiftInMonthOfOneUser(AllShiftInMonthOfOneUserReq req)
        {
            var res = await _userProvider.GetAllShiftInMonthOfOneUser(req);
            return res;
        }

        public async Task<List<DataDistributeShiftModel>> GetDataDistributeShift(DataDistributeShiftReq req)
        {
            var res = await _userProvider.GetDataDistributeShift(req);
            return res;
        }

        public async Task<List<DataDistributeShiftModel>> GetDataDistributeShiftMonth(DataDistributeShiftReq req)
        {
            var res = await _userProvider.GetDataDistributeShiftMonth(req);
            return res;
        }

        public async Task<List<GetHistoryScratchCardFullLogModel>> GetHistoryScratchCardFullLog(GetHistoryScratchCardFullLogReq req)
        {
            var res = await _userProvider.GetHistoryScratchCardFullLog(req);
            return res;
        }

        public async Task<List<GetHistoryScratchCardLogModel>> GetHistoryScratchCardLog(GetHistoryScratchCardLogReq req)
        {
            var res = await _userProvider.GetHistoryScratchCardLog(req);
            return res;
        }

        public async Task<List<AverageKPIModel>> GetListAverageKPI(AverageKPIReq req)
        {
            var res = await _userProvider.GetListAverageKPI(req);
            return res;
        }

        public async Task<List<ListBorrowForConfirmModel>> GetListBorrowForConfirm(ListBorrowForConfirmReq req)
        {
            var res = await _userProvider.GetListBorrowForConfirm(req);
            return res;
        }

        public async Task<List<ListBorrowInMonthModel>> GetListBorrowInMonth(ListBorrowInMonthReq req)
        {
            var res = await _userProvider.GetListBorrowInMonth(req);
            return res;
        }

        public async Task<List<ListEventDateModel>> GetListEventDate(ListEventDateReq req)
        {
            var res = await _userProvider.GetListEventDate(req);
            return res;
        }

        public async Task<List<ListFundInYearModel>> GetListFundInYear(ListFundInYearReq req)
        {
            var res = await _userProvider.GetListFundInYear(req);
            return res;
        }

        public async Task<List<ListKPIOfUserModel>> GetListKPIOfUser(ListKPIOfUserReq req)
        {
            var res = await _userProvider.GetListKPIOfUser(req);
            return res;
        }

        public async Task<List<ListOffOfLeaderModel>> GetListOffOfLeader(ListOffOfLeaderReq req)
        {
            var res = await _userProvider.GetListOffOfLeader(req);
            return res;
        }

        public async Task<List<ListSalaryModel>> GetListSalary(ListSalaryReq req)
        {
            var res = await _userProvider.GetListSalary(req);
            return res;
        }

        public async Task<List<SalePointInDateModel>> GetListSalePointInDate(SalePointInDateReq req)
        {
            var res = await _userProvider.GetListSalePointInDate(req);
            return res;
        }

        public async Task<ListTargetModel> GetListTarget(ListTargetReq req)
        {
            var res = await _userProvider.GetListTarget(req);
            return res;
        }

        public async Task<ListTargetMasterModel> GetListTargetMaster(ListTargetMasterReq req)
        {
            var res = await _userProvider.GetListTargetMaster(req);
            return res;
        }

        public async Task<List<ListUserModel>> GetListUser(ListUserReq req)
        {
            var res = await _userProvider.GetListUser(req);
            return res;
        }

        public async Task<List<PermissionByTitleModel>> GetPermissionByTitle(PermissionByTitleReq req)
        {
            var res = await _userProvider.GetPermissionByTitle(req);
            return res;
        }

        public async Task<List<SalePointManageModel>> GetSalePointManage(SalePointManageReq req)
        {
            var res = await _userProvider.GetSalePointManage(req);
            return res;
        }

        public async Task<UserModel> GetUserSessionInfo(UserDetailReq req)
        {
            var res = await _userProvider.GetUserSessionInfo(req);
            return res;
        }

        public async Task<ReturnMessage> InsertUpdateBorrow(InsertUpdateBorrowReq req)
        {
            var res = await _userProvider.InsertUpdateBorrow(req);
            return res;
        }

        public async Task<ReturnMessage> PayBorrow(PayBorrowReq req)
        {
            var res = await _userProvider.PayBorrow(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateListEventDate(UpdateListEventDateReq req)
        {
            var res = await _userProvider.UpdateListEventDate(req);
            return res; ;
        }

        public async Task<ReturnMessage> UpdateListKPI(UpdateListKPIReq req)
        {
            var res = await _userProvider.UpdateListKPI(req);
            return res; ;
        }

        public async Task<ReturnMessage> UpdateListTarget(UpdateListTargetReq req)
        {
            var res = await _userProvider.UpdateListTarget(req);
            return res; ;
        }

        public async Task<ReturnMessage> UpdateListTargetnew(UpdateListTargetReq req)
        {
            var res = await _userProvider.UpdateListTargetnew(req);
            return res; ;
        }
        public async Task<ReturnMessage> UpdatePermissionRole(UpdatePermissionRoleReq req)
        {
            var res = await _userProvider.UpdatePermissionRole(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateScratchcardFullLog(UpdateScratchcardFullLogReq req)
        {
            var res = await _userProvider.UpdateScratchcardFullLog(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateScratchcardLog(UpdateScratchcardLogReq req)
        {
            var res = await _userProvider.UpdateScratchcardLog(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateShift(UpdateShiftReq req)
        {
            var res = await _userProvider.UpdateShift(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateUserInfo(UpdateUserInfoReq req)
        {
            var res = await _userProvider.UpdateUserInfo(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateTransaction(UpdateTransactionReq req)
        {
            var res = await _userProvider.UpdateTransaction(req);
            return res;
        }

        public async Task<List<GetShiftDistributeOfInternModel>> GetShiftDistributeOfIntern(GetShiftDistributeOfInternReq req)
        {
            var res = await _userProvider.GetShiftDistributeOfIntern(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateShiftDistributeForIntern(UpdateShiftDistributeForInternReq req)
        {
            var res = await _userProvider.UpdateShiftDistributeForIntern(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateActiveStatusForUser(UpdateActiveStatusForUserReq req)
        {
           var res = await _userProvider.UpdateActiveStatusForUser(req);
            return res;
        }

        public async Task<ReturnMessage> DeleteDistributeForIntern(DeleteDistributeForInternReq req)
        {
            var res = await _userProvider.DeleteDistributeForIntern(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateTotalFirst(UpdateTotalFirstReq req)
        {
            var res = await _userProvider.UpdateTotalFirst(req);
            return res;
        }
    }
}