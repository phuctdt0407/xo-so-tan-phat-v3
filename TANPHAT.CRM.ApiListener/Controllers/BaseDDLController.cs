using System.Threading.Tasks;
using KTHub.Core.Listener.Cotroller;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Business;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.BaseDDL;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.ApiListener.Controllers
{
    [ApiExplorerSettings(IgnoreApi = false)]
    [Route(UrlCommon.T_BaseDDL)]
    public class BaseDDLController : BaseApiController
    {
        private IBaseDDLBusiness _baseDDLBusiness;

        public BaseDDLController(ConsumerConfigs consumerConfigs, IBaseDDLBusiness baseDDLBusiness) : base(consumerConfigs)
        {
            _baseDDLBusiness = baseDDLBusiness;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var requestType = GetRequestType<BaseDDLGetType>();
            switch (requestType)
            {
                case BaseDDLGetType.AgencyDDL:
                    {
                        var result = await _baseDDLBusiness.AgencyDDL();
                        return OkResult(result);
                    }
                case BaseDDLGetType.LotteryChannelDDL:
                    {
                        var reqModel = GetRequestData<LotteryChannelDDLReq>();
                        var result = await _baseDDLBusiness.LotteryChannelDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.SalePointDDL:
                    {
                        var result = await _baseDDLBusiness.SalePointDDL();
                        return OkResult(result);
                    }
                case BaseDDLGetType.UserByTitleDDL:
                    {
                        var reqModel = GetRequestData<UserByeTitleDDLReq>();
                        var result = await _baseDDLBusiness.UserByTitleDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.UserTitleDDL:
                    {
                        var reqModel = GetRequestData<UserByeTitleDDLReq>();
                        var result = await _baseDDLBusiness.UserTitleDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.LotteryTypeDDL:
                    {
                        var result = await _baseDDLBusiness.LotteryTypeDDL();
                        return OkResult(result);
                    }
                case BaseDDLGetType.LotteryPriceDDL:
                    {
                        var reqModel = GetRequestData<LotteryPriceDDLReq>();
                        var result = await _baseDDLBusiness.LotteryPriceDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.WinningTypeDDL:
                    {
                        var result = await _baseDDLBusiness.WinningTypeDDL();
                        return OkResult(result);
                    }
                case BaseDDLGetType.ItemDDL:
                    {
                        var reqModel = GetRequestData<ItemDDLReq>();
                        var result = await _baseDDLBusiness.GetItemDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.UnitDDL:
                    {
                        var reqModel = GetRequestData<UnitDDLReq>();
                        var result = await _baseDDLBusiness.GetUnitDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.GuestDDL:
                    {
                        var reqModel = GetRequestData<GuestDDLReq>();
                        var result = await _baseDDLBusiness.GetGuestDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.TypeOfItemDDL:
                    {
                        var result = await _baseDDLBusiness.GetTypeOfItemDDL();
                        return OkResult(result);
                    }
                case BaseDDLGetType.TypeNameDDL:
                    {
                        var reqModel = GetRequestData<TypeNameDDLReq>();
                        var result = await _baseDDLBusiness.GetTypeNameDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.UserDDL:
                    {
                        var reqModel = GetRequestData<UserDDLReq>();
                        var result = await _baseDDLBusiness.GetUserDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.CriteriaDDL:
                    {
                        var reqModel = GetRequestData<CriteriaDDLReq>();
                        var result = await _baseDDLBusiness.GetCriteriaDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.ReportWinningTypeDDL:
                    {
                        var result = await _baseDDLBusiness.ReportWinningTypeDDL();
                        return OkResult(result);
                    }
                case BaseDDLGetType.InternByTitleDDL:
                    {
                        var reqModel = GetRequestData<InternByTitleDDLReq>();
                        var result = await _baseDDLBusiness.InternByTitleDDL(reqModel);
                        return OkResult(result);
                    }
                case BaseDDLGetType.SubAgencyDDL:
                    {
                        var reqModel = GetRequestData<SubAgencyDDLReq>();
                        var result = await _baseDDLBusiness.SubAgencyDDL(reqModel);
                        return OkResult(result);
                    }
                default: break;
            }
            return NotFound();
        }
    }
}
