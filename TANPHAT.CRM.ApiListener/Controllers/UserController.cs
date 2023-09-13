using System.Threading.Tasks;
using KTHub.Core.Listener.Cotroller;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Business;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.User;
using TANPHAT.CRM.Domain.Models.User.Enum;

namespace TANPHAT.CRM.ApiListener.Controllers
{
    [ApiExplorerSettings(IgnoreApi = false)]
    [Route(UrlCommon.T_User)]
    public class UserController : BaseApiController
    {
        private IUserBusiness _userBusiness;

        public UserController(ConsumerConfigs consumerConfigs, IUserBusiness userBusiness) : base(consumerConfigs)
        {
            _userBusiness = userBusiness;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var requestType = GetRequestType<UserGetType>();
            switch (requestType)
            {
                case UserGetType.GetUserSessionInfo:
                    {
                        var reqModel = GetRequestData<UserDetailReq>();
                        var result = await _userBusiness.GetUserSessionInfo(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetHistoryScratchCardFullLog:
                    {
                        var reqModel = GetRequestData<GetHistoryScratchCardFullLogReq>();
                        var result = await _userBusiness.GetHistoryScratchCardFullLog(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetHistoryScratchCardLog:
                    {
                        var reqModel = GetRequestData<GetHistoryScratchCardLogReq>();
                        var result = await _userBusiness.GetHistoryScratchCardLog(reqModel);
                        return OkResult(result);
                    }
                    
                case UserGetType.GetDataDistributeShift:
                    {
                        var reqModel = GetRequestData<DataDistributeShiftReq>();
                        var result = await _userBusiness.GetDataDistributeShift(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListUser:
                    {
                        var reqModel = GetRequestData<ListUserReq>();
                        var result = await _userBusiness.GetListUser(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetSalePointManage:
                    {
                        var reqModel = GetRequestData<SalePointManageReq>();
                        var result = await _userBusiness.GetSalePointManage(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetPermissionByTitle:
                    {
                        var reqModel = GetRequestData<PermissionByTitleReq>();
                        var result = await _userBusiness.GetPermissionByTitle(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetDataDistributeShiftMonth:
                    {
                        var reqModel = GetRequestData<DataDistributeShiftReq>();
                        var result = await _userBusiness.GetDataDistributeShiftMonth(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetAllShiftInMonthOfOneUser:
                    {
                        var reqModel = GetRequestData<AllShiftInMonthOfOneUserReq>();
                        var result = await _userBusiness.GetAllShiftInMonthOfOneUser(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListEventDate:
                    {
                        var reqModel = GetRequestData<ListEventDateReq>();
                        var result = await _userBusiness.GetListEventDate(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListTarget:
                    {
                        var reqModel = GetRequestData<ListTargetReq>();
                        var result = await _userBusiness.GetListTarget(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListKPIOfUser:
                    {
                        var reqModel = GetRequestData<ListKPIOfUserReq>();
                        var result = await _userBusiness.GetListKPIOfUser(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListSalePointInDate:
                    {
                        var reqModel = GetRequestData<SalePointInDateReq>();
                        var result = await _userBusiness.GetListSalePointInDate(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListAverageKPI:
                    {
                        var reqModel = GetRequestData<AverageKPIReq>();
                        var result = await _userBusiness.GetListAverageKPI(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListSalary:
                    {
                        var reqModel = GetRequestData<ListSalaryReq>();
                        var result = await _userBusiness.GetListSalary(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListOffOfLeader:
                    {
                        var reqModel = GetRequestData<ListOffOfLeaderReq>();
                        var result = await _userBusiness.GetListOffOfLeader(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListTargetMaster:
                    {
                        var reqModel = GetRequestData<ListTargetMasterReq>();
                        var result = await _userBusiness.GetListTargetMaster(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListFundInYear:
                    {
                        var reqModel = GetRequestData<ListFundInYearReq>();
                        var result = await _userBusiness.GetListFundInYear(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListBorrowForConfirm:
                    {
                        var reqModel = GetRequestData<ListBorrowForConfirmReq>();
                        var result = await _userBusiness.GetListBorrowForConfirm(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetListBorrowInMonth:
                    {
                        var reqModel = GetRequestData<ListBorrowInMonthReq>();
                        var result = await _userBusiness.GetListBorrowInMonth(reqModel);
                        return OkResult(result);
                    }
                case UserGetType.GetShiftDistributeOfIntern:
                    {
                        var reqModel = GetRequestData<GetShiftDistributeOfInternReq>();
                        var result = await _userBusiness.GetShiftDistributeOfIntern(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }

        [HttpPost]
        public async Task<IActionResult> Post()
        {
            var requestType = GetRequestType<UserPostType>();
            switch (requestType)
            {
                case UserPostType.DistributeShift:
                    {
                        var reqModel = GetRequestData<DistributeShiftReq>();
                        var result = await _userBusiness.DistributeShift(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateShift:
                    {
                        var reqModel = GetRequestData<UpdateShiftReq>();
                        var result = await _userBusiness.UpdateShift(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdatePermissionRole:
                    {
                        var reqModel = GetRequestData<UpdatePermissionRoleReq>();
                        var result = await _userBusiness.UpdatePermissionRole(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.DistributeShiftMonth:
                    {
                        var reqModel = GetRequestData<DistributeShiftMonthReq>();
                        var result = await _userBusiness.DistributeShiftMonth(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateScratchcardFullLog:
                    {
                        var reqModel = GetRequestData<UpdateScratchcardFullLogReq>();
                        var result = await _userBusiness.UpdateScratchcardFullLog(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateScratchcardLog:
                    {
                        var reqModel = GetRequestData<UpdateScratchcardLogReq>();
                        var result = await _userBusiness.UpdateScratchcardLog(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.CreateUser:
                    {
                        var reqModel = GetRequestData<CreateUserReq>();
                        var result = await _userBusiness.CreateUser(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateUserInfo:
                    {
                        var reqModel = GetRequestData<UpdateUserInfoReq>();
                        var result = await _userBusiness.UpdateUserInfo(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateListEventDate:
                    {
                        var reqModel = GetRequestData<UpdateListEventDateReq>();
                        var result = await _userBusiness.UpdateListEventDate(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateListTarget:
                    {
                        var reqModel = GetRequestData<UpdateListTargetReq>();
                        var result = await _userBusiness.UpdateListTarget(reqModel);
                        return OkResult(result);
                    }

                case UserPostType.UpdateListTargetnew:
                    {
                        var reqModel = GetRequestData<UpdateListTargetReq>();
                        var result = await _userBusiness.UpdateListTargetnew(reqModel);
                        return OkResult(result);
                    }

                case UserPostType.UpdateListKPI:
                    {
                        var reqModel = GetRequestData<UpdateListKPIReq>();
                        var result = await _userBusiness.UpdateListKPI(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.ConfirmSalary:
                    {
                        var reqModel = GetRequestData<ConfirmSalaryReq>();
                        var result = await _userBusiness.ConfirmSalary(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.InsertUpdateBorrow:
                    {
                        var reqModel = GetRequestData<InsertUpdateBorrowReq>();
                        var result = await _userBusiness.InsertUpdateBorrow(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.PayBorrow:
                    {
                        var reqModel = GetRequestData<PayBorrowReq>();
                        var result = await _userBusiness.PayBorrow(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.CreateManager:
                    {
                        var reqModel = GetRequestData<CreateManagerReq>();
                        var result = await _userBusiness.CreateManager(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateTransaction:
                    {
                        var reqModel = GetRequestData<UpdateTransactionReq>();
                        var result = await _userBusiness.UpdateTransaction(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateShiftDistributeForIntern:
                    {
                        var reqModel = GetRequestData<UpdateShiftDistributeForInternReq>();
                        var result = await _userBusiness.UpdateShiftDistributeForIntern(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.DeleteDistributeForIntern:
                    {
                        var reqModel = GetRequestData<DeleteDistributeForInternReq>();
                        var result = await _userBusiness.DeleteDistributeForIntern(reqModel);
                        return OkResult(result);
                    }
                case UserPostType.UpdateTotalFirst:
                    {
                        var reqModel = GetRequestData<UpdateTotalFirstReq>();
                        var result = await _userBusiness.UpdateTotalFirst(reqModel);
                        return OkResult(result);
                    }
                    
                default: break;
            }
            return NotFound();
        }
    }
}
