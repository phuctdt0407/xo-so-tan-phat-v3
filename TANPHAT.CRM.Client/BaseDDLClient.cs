using System.Collections.Generic;
using System.Threading.Tasks;
using KTHub.Core.Client;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.BaseDDL;
using TANPHAT.CRM.Domain.Models.BaseDDL.Enum;

namespace TANPHAT.CRM.Client
{
    public interface IBaseDDLClient
    {
        Task<ApiResponse<List<LotteryChannelDDLModel>>> LotteryChannelDDL(LotteryChannelDDLReq req);

        Task<ApiResponse<List<BaseDropDownModel>>> AgencyDDL();

        Task<ApiResponse<List<BaseDropDownModel>>> SalePointDDL();

        Task<ApiResponse<List<BaseDropDownModel>>> UserByTitleDDL(UserByeTitleDDLReq req);

        Task<ApiResponse<List<BaseDropDownModel>>> UserTitleDDL(UserByeTitleDDLReq req);

        Task<ApiResponse<List<BaseDropDownModel>>> LotteryTypeDDL();

        Task<ApiResponse<List<LotteryPriceDDLModel>>> LotteryPriceDDL(LotteryPriceDDLReq req);

        Task<ApiResponse<List<BaseDropDownModel>>> WinningTypeDDL();

        Task<ApiResponse<List<ItemDDLModel>>> GetItemDDL(ItemDDLReq req);

        Task<ApiResponse<List<UnitDDLModel>>> GetUnitDDL(UnitDDLReq req);

        Task<ApiResponse<List<GuestDDLModel>>> GetGuestDDL(GuestDDLReq req);

        Task<ApiResponse<List<TypeOfItemDDLModel>>> GetTypeOfItemDDL();

        Task<ApiResponse<List<TypeNameDDLModel>>> GetTypeNameDDL(TypeNameDDLReq req);

        Task<ApiResponse<List<UserDDLModel>>> GetUserDDL(UserDDLReq req);

        Task<ApiResponse<List<CriteriaDDLModel>>> GetCriteriaDDL(CriteriaDDLReq req);

        Task<ApiResponse<List<ReportWinningTypeDDLModel>>> ReportWinningTypeDDL();
        Task<ApiResponse<List<InternByTitleDDLModel>>> InternByTitleDDL(InternByTitleDDLReq req);
        Task<ApiResponse<List<SubAgencyDDLModel>>> SubAgencyDDL(SubAgencyDDLReq req);

    }

    public class BaseDDLClient : BaseApiClient, IBaseDDLClient
    {
        private string urlSend { get; set; }

        public BaseDDLClient(ApiConfigs configs) : base(configs)
        {
            urlSend = base.GetUrlSend(UrlCommon.T_BaseDDL);
        }

        public async Task<ApiResponse<List<LotteryChannelDDLModel>>> LotteryChannelDDL(LotteryChannelDDLReq req)
        {
            req.TypeName = BaseDDLGetType.LotteryChannelDDL;
            return await GetAsync<List<LotteryChannelDDLModel>, LotteryChannelDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<BaseDropDownModel>>> AgencyDDL()
        {
            return await GetAsync<List<BaseDropDownModel>, BaseDDLGetType>(urlSend, BaseDDLGetType.AgencyDDL);
        }

        public async Task<ApiResponse<List<BaseDropDownModel>>> SalePointDDL()
        {
            return await GetAsync<List<BaseDropDownModel>, BaseDDLGetType>(urlSend, BaseDDLGetType.SalePointDDL);
        }

        public async Task<ApiResponse<List<BaseDropDownModel>>> UserByTitleDDL(UserByeTitleDDLReq req)
        {
            req.TypeName = BaseDDLGetType.UserByTitleDDL;
            return await GetAsync<List<BaseDropDownModel>, UserByeTitleDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<BaseDropDownModel>>> UserTitleDDL(UserByeTitleDDLReq req)
        {
            req.TypeName = BaseDDLGetType.UserTitleDDL;
            return await GetAsync<List<BaseDropDownModel>, UserByeTitleDDLReq>(urlSend,req);
        }

        public async Task<ApiResponse<List<BaseDropDownModel>>> LotteryTypeDDL()
        {
            return await GetAsync<List<BaseDropDownModel>, BaseDDLGetType>(urlSend, BaseDDLGetType.LotteryTypeDDL);
        }

        public async Task<ApiResponse<List<LotteryPriceDDLModel>>> LotteryPriceDDL(LotteryPriceDDLReq req)
        {
            req.TypeName = BaseDDLGetType.LotteryPriceDDL;
            return await GetAsync<List<LotteryPriceDDLModel>, LotteryPriceDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<BaseDropDownModel>>> WinningTypeDDL()
        {
            return await GetAsync<List<BaseDropDownModel>, BaseDDLGetType>(urlSend, BaseDDLGetType.WinningTypeDDL);
        }

        public async Task<ApiResponse<List<ItemDDLModel>>> GetItemDDL(ItemDDLReq req)
        {
            req.TypeName = BaseDDLGetType.ItemDDL;
            return await GetAsync<List<ItemDDLModel>, ItemDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<UnitDDLModel>>> GetUnitDDL(UnitDDLReq req)
        {
            req.TypeName = BaseDDLGetType.UnitDDL;
            return await GetAsync<List<UnitDDLModel>, UnitDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GuestDDLModel>>> GetGuestDDL(GuestDDLReq req)
        {
            req.TypeName = BaseDDLGetType.GuestDDL;
            return await GetAsync<List<GuestDDLModel>, GuestDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<TypeOfItemDDLModel>>> GetTypeOfItemDDL()
        {
            return await GetAsync<List<TypeOfItemDDLModel>, BaseDDLGetType>(urlSend, BaseDDLGetType.TypeOfItemDDL);
        }

        public async Task<ApiResponse<List<TypeNameDDLModel>>> GetTypeNameDDL(TypeNameDDLReq req)
        {
            req.TypeName = BaseDDLGetType.TypeNameDDL;
            return await GetAsync<List<TypeNameDDLModel>, TypeNameDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<UserDDLModel>>> GetUserDDL(UserDDLReq req)
        {
            req.TypeName = BaseDDLGetType.UserDDL;
            return await GetAsync<List<UserDDLModel>, UserDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<CriteriaDDLModel>>> GetCriteriaDDL(CriteriaDDLReq req)
        {
            req.TypeName = BaseDDLGetType.CriteriaDDL;
            return await GetAsync<List<CriteriaDDLModel>, CriteriaDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ReportWinningTypeDDLModel>>> ReportWinningTypeDDL()
        {
            return await GetAsync<List<ReportWinningTypeDDLModel>, BaseDDLGetType>(urlSend, BaseDDLGetType.ReportWinningTypeDDL);
        }

        public async Task<ApiResponse<List<InternByTitleDDLModel>>> InternByTitleDDL(InternByTitleDDLReq req)
        {
            req.TypeName = BaseDDLGetType.InternByTitleDDL;
            return await GetAsync<List<InternByTitleDDLModel>, InternByTitleDDLReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<SubAgencyDDLModel>>> SubAgencyDDL(SubAgencyDDLReq req)
        {
            req.TypeName = BaseDDLGetType.SubAgencyDDL;
            return await GetAsync<List<SubAgencyDDLModel>, SubAgencyDDLReq>(urlSend, req);
        }
    }
}
