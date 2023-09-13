using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Domain.Models.User;

namespace TANPHAT.CRM.Controllers.Api
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private IUserClient _userClient;

        public UserController(IUserClient userClient)
        {
            _userClient = userClient;
        }

        [HttpPost("DistributeShift")]
        public async Task<object> DistributeShift(DistributeShiftReq model)
        {
            var res = await _userClient.DistributeShift(model);
            return res;
        }

        [HttpGet("GetDataDistributeShift")]
        public async Task<object> GetDataDistributeShift(string distributeMonth, int salePointId, bool isActive)
        {
            var obj = new DataDistributeShiftReq
            {
                DistributeMonth = distributeMonth,
                SalePointId = salePointId,
                IsActive = isActive
            };
            var res = await _userClient.GetDataDistributeShift(obj);
            return res;
        }
        [HttpGet("GetHistoryScratchCardFullLog")]
        public async Task<object> GetHistoryScratchCardFullLog(int ps = 10, int p =1, string date ="" )
        {
            var obj = new GetHistoryScratchCardFullLogReq
            {
                PageSize = ps,
                PageNumber=p,
                Date = date
            };
            var res = await _userClient.GetHistoryScratchCardFullLog(obj);
            return res;
        }
        [HttpGet("GetHistoryScratchCardLog")]
        public async Task<object> GetHistoryScratchCardLog(int ps = 10, int p = 1, string date = "")
        {
            var obj = new GetHistoryScratchCardLogReq
            {
                PageSize = ps,
                PageNumber = p,
                Date = date
            };
            var res = await _userClient.GetHistoryScratchCardLog(obj);
            return res;
        }
        
        [HttpPost("UpdateTotalFirst")]
        public async Task<object> UpdateTotalFirst(UpdateTotalFirstReq model)
        {
            var res = await _userClient.UpdateTotalFirst(model);
            return res;
        }


        [HttpPost("UpdateShift")]
        public async Task<object> UpdateShift(UpdateShiftReq model)
        {
            var res = await _userClient.UpdateShift(model);
            return res;
        }

        [HttpGet("GetListUser")]
        public async Task<object> GetListUser(int? userTitleId, int p = 1, int ps = 20,int qj=0)
        {
            var obj = new ListUserReq
            {
                PageNumber = p,
                PageSize = ps,
                UserTitleId = userTitleId ?? 0,
                QuitJob=qj
            };
            var res = await _userClient.GetListUser(obj);
            return res;
        }

        [HttpGet("GetSalePointManage")]
        public async Task<object> GetSalePointManage(DateTime date)
        {
            var obj = new SalePointManageReq
            {
                Date = date
            };
            var res = await _userClient.GetSalePointManage(obj);
            return res;
        }

        [HttpGet("GetPermissionByTitle")]
        public async Task<object> GetPermissionByTitle(int userTitleId)
        {
            var obj = new PermissionByTitleReq
            {
                UserTitleId = userTitleId
            };
            var result = await _userClient.GetPermissionByTitle(obj);
            return result;
        }
        [HttpPost("UpdateTransaction")]
        public async Task<object> UpdateTransaction(UpdateTransactionReq model)
        {
            var result = await _userClient.UpdateTransaction(model);
            return result;
        }

        [HttpPost("UpdatePermissionRole")]
        public async Task<object> UpdatePermissionRole(UpdatePermissionRoleReq model)
        {
            var result = await _userClient.UpdatePermissionRole(model);
            return result;
        }
        

        [HttpPost("DistributeShiftMonth")]
        public async Task<object> DistributeShiftMonth(DistributeShiftMonthReq model)
        {
            var result = await _userClient.DistributeShiftMonth(model);
            return result;
        }

        [HttpGet("GetDataDistributeShiftMonth")]
        public async Task<object> GetDataDistributeShiftMonth(string distributeMonth)
        {
            var obj = new DataDistributeShiftReq
            {
                DistributeMonth = distributeMonth
            };
            var result = await _userClient.GetDataDistributeShiftMonth(obj);
            return result;
        }

        [HttpGet("GetAllShiftInMonthOfOneUser")]
        public async Task<object> GetAllShiftInMonthOfOneUser(int UserRole, string month)
        {
            var obj = new AllShiftInMonthOfOneUserReq
            {
                UserRoleId = UserRole,
                Month = month
            };
            var result = await _userClient.GetAllShiftInMonthOfOneUser(obj);
            return result;
        }

        [HttpPost("CreateUser")]
        public async Task<object> CreateUser(CreateUserReq model)
        {
            var result = await _userClient.CreateUser(model);
            return result;
        }
        [HttpPost("UpdateScratchcardFullLog")]
        public async Task<object> UpdateScratchcardFullLog(UpdateScratchcardFullLogReq model)
        {
            var result = await _userClient.UpdateScratchcardFullLog(model);
            return result;
        }
        [HttpPost("UpdateScratchcardLog")]
        public async Task<object> UpdateScratchcardLog(UpdateScratchcardLogReq model)
        {
            var result = await _userClient.UpdateScratchcardLog(model);
            return result;
        }

        [HttpPost("UpdateUserInfo")]
        public async Task<object> UpdateUserInfo(UpdateUserInfoReq model)
        {
            var result = await _userClient.UpdateUserInfo(model);
            return result;
        }
        [HttpGet("GetListEventDate")]
        public async Task<object> GetListEventDate(int year, int? month = 0)
        {
            var obj = new ListEventDateReq
            {
                Month = month ?? 0,
                Year = year
            };
            var res = await _userClient.GetListEventDate(obj);
            return res;
        }
        [HttpPost("UpdateListEventDate")]
        public async Task<object> UpdateListEventDate(UpdateListEventDateReq model)
        {
            var result = await _userClient.UpdateListEventDate(model);
            return result;
        }
        [HttpGet("GetListTarget")]
        public async Task<object> GetListTarget()
        {
            var obj = new ListTargetReq{};
            var res = await _userClient.GetListTarget(obj);
            return res;
        }
        [HttpPost("UpdateListTarget")]
        public async Task<object> UpdateListTarget(UpdateListTargetReq model)
        {
            var result = await _userClient.UpdateListTarget(model);
            return result;
        }
        [HttpPost("UpdateListKPI")]
        public async Task<object> UpdateListKPI(UpdateListKPIReq model)
        {
            var result = await _userClient.UpdateListKPI(model);
            return result;
        }
        [HttpGet("GetListKPIOfUser")]
        public async Task<object> GetListKPIOfUser(string month, int? userId = 0)
        {
            var obj = new ListKPIOfUserReq
            { 
                Month = month,
                UserId = userId ?? 0
            };
            var res = await _userClient.GetListKPIOfUser(obj);
            return res;
        }

        [HttpGet("GetListSalePointInDate")]
        public async Task<object> GetListSalePointInDate( int userId, DateTime date)
        {
            var obj = new SalePointInDateReq
            {
                UserId = userId,
                Date = date
            };
            var res = await _userClient.GetListSalePointInDate(obj);
            return res;
        }

        [HttpGet("GetListAverageKPI")]
        public async Task<object> GetListAverageKPI(string month, int? userId = 0)
        {
            var obj = new AverageKPIReq
            {
                UserId = userId ?? 0,
                Month = month                  
            };
            var res = await _userClient.GetListAverageKPI(obj);
            return res;
        }

        [HttpGet("GetListSalary")]
        public async Task<object> GetListSalary(string month,int userId)
        {
            var obj = new ListSalaryReq
            {      
                Month = month,
                UserId = userId
            };
            var res = await _userClient.GetListSalary(obj);
            return res;
        }

        [HttpGet("GetListOffOfLeader")]
        public async Task<object> GetListOffOfLeader(string month)
        {
            var obj = new ListOffOfLeaderReq
            {
                Month = month
            };
            var res = await _userClient.GetListOffOfLeader(obj);
            return res;
        }

        [HttpGet("GetListTargetMaster")]
        public async Task<object> GetListTargetMaster(int? userTitleId = 0)
        {
            var obj = new ListTargetMasterReq
            {
                UserTitleId = userTitleId ?? 0
            };
            var res = await _userClient.GetListTargetMaster(obj);
            return res;
        }

        [HttpPost("ConfirmSalary")]
        public async Task<object> ConfirmSalary(ConfirmSalaryReq model)
        {
            var result = await _userClient.ConfirmSalary(model);
            return result;
        }

        [HttpGet("GetListFundInYear")]
        public async Task<object> GetListFundInYear(int year)
        {
            var obj = new ListFundInYearReq
            {
                Year = year
            };
            var res = await _userClient.GetListFundInYear(obj);
            return res;
        }

        [HttpPost("InsertUpdateBorrow")]
        public async Task<object> InsertUpdateBorrow(InsertUpdateBorrowReq model)
        {
            var result = await _userClient.InsertUpdateBorrow(model);
            return result;
        }

        [HttpGet("GetListBorrowForConfirm")]
        public async Task<object> GetListBorrowForConfirm(int? userId = 0, DateTime? date = null, int? ps = 100, int? p = 1)
        {
            var obj = new ListBorrowForConfirmReq
            {
                PageNumber = p ?? 1,
                PageSize = ps ?? 100,
                UserId = userId ?? 0,
                Date = date ?? DateTime.Now
            };
            var res = await _userClient.GetListBorrowForConfirm(obj);
            return res;
        }

        [HttpPost("PayBorrow")]
        public async Task<object> PayBorrow(PayBorrowReq model)
        {
            var result = await _userClient.PayBorrow(model);
            return result;
        }
        [HttpGet("GetListBorrowInMonth")]
        public async Task<object> GetListBorrowInMonth(string month , int? userId = 0)
        {
            var obj = new ListBorrowInMonthReq
            {
                UserId = userId ?? 0,
                Month = month ,
            };
            var res = await _userClient.GetListBorrowInMonth(obj);
            return res;
        }
        [HttpPost("CreateManager")]
        public async Task<object> CreateManager(CreateManagerReq model)
        {
            var result = await _userClient.CreateManager(model);
            return result;
        }
        [HttpGet("GetShiftDistributeOfIntern")]
        public async Task<object> GetShiftDistributeOfIntern(string distributeMonth, int salePointId, bool isActive)
        {
            var obj = new GetShiftDistributeOfInternReq
            {
                DistributeMonth = distributeMonth,
                SalePointId = salePointId,
                IsActive = isActive
            };
            var res = await _userClient.GetShiftDistributeOfIntern(obj);
            return res;
        }
        [HttpPost("UpdateShiftDistributeForIntern")]
        public async Task<object> UpdateShiftDistributeForIntern(UpdateShiftDistributeForInternReq model)
        {
            var result = await _userClient.UpdateShiftDistributeForIntern(model);
            return result;
        }
        [HttpPost("UpdateActiveStatusForUser")]
        public async Task<object> UpdateActiveStatusForUser(UpdateActiveStatusForUserReq model)
        {
            var result = await _userClient.UpdateActiveStatusForUser(model);
            return result;
        }
        [HttpPost("DeleteDistributeForIntern")]
        public async Task<object> DeleteDistributeForIntern(DeleteDistributeForInternReq model)
        {
            var result = await _userClient.DeleteDistributeForIntern(model);
            return result;
        }
    }
}
