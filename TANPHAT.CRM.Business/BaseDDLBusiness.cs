using System.Collections.Generic;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.BaseDDL;
using TANPHAT.CRM.Provider;

namespace TANPHAT.CRM.Business
{
    public interface IBaseDDLBusiness
    {
        Task<List<LotteryChannelDDLModel>> LotteryChannelDDL(LotteryChannelDDLReq req);

        Task<List<BaseDropDownModel>> AgencyDDL();

        Task<List<BaseDropDownModel>> SalePointDDL();

        Task<List<BaseDropDownModel>> UserByTitleDDL(UserByeTitleDDLReq req);

        Task<List<BaseDropDownModel>> UserTitleDDL(UserByeTitleDDLReq req);

        Task<List<BaseDropDownModel>> LotteryTypeDDL();

        Task<List<LotteryPriceDDLModel>> LotteryPriceDDL(LotteryPriceDDLReq req);

        Task<List<BaseDropDownModel>> WinningTypeDDL();

        Task<List<ItemDDLModel>> GetItemDDL(ItemDDLReq req);

        Task<List<UnitDDLModel>> GetUnitDDL(UnitDDLReq req);

        Task<List<GuestDDLModel>> GetGuestDDL(GuestDDLReq req);

        Task<List<TypeNameDDLModel>> GetTypeNameDDL(TypeNameDDLReq req);

        Task<List<UserDDLModel>> GetUserDDL(UserDDLReq req);

        Task<List<CriteriaDDLModel>> GetCriteriaDDL(CriteriaDDLReq req);

        Task<List<TypeOfItemDDLModel>> GetTypeOfItemDDL();

        Task<List<ReportWinningTypeDDLModel>> ReportWinningTypeDDL();
        Task<List<InternByTitleDDLModel>> InternByTitleDDL(InternByTitleDDLReq req);
        Task<List<SubAgencyDDLModel>> SubAgencyDDL(SubAgencyDDLReq req);
    }

    public class BaseDDLBusiness : IBaseDDLBusiness
    {
        private IBaseDDLProvider _baseDDLProvider;

        public BaseDDLBusiness(IBaseDDLProvider baseDDLProvider)
        {
            _baseDDLProvider = baseDDLProvider;
        }

        public async Task<List<BaseDropDownModel>> AgencyDDL()
        {
            var res = await _baseDDLProvider.AgencyDDL();
            return res;
        }

        public async Task<List<ItemDDLModel>> GetItemDDL(ItemDDLReq req)
        {
            var res = await _baseDDLProvider.GetItemDDL(req);
            return res;
        }

        public async Task<List<UnitDDLModel>> GetUnitDDL(UnitDDLReq req)
        {
            var res = await _baseDDLProvider.GetUnitDDL(req);
            return res;
        }

        public async Task<List<GuestDDLModel>> GetGuestDDL(GuestDDLReq req)
        {
            var res = await _baseDDLProvider.GetGuestDDL(req);
            return res;
        }

        public async Task<List<LotteryChannelDDLModel>> LotteryChannelDDL(LotteryChannelDDLReq req)
        {
            var res = await _baseDDLProvider.LotteryChannelDDL(req);
            return res;
        }

        public async Task<List<LotteryPriceDDLModel>> LotteryPriceDDL(LotteryPriceDDLReq req)
        {
            var res = await _baseDDLProvider.LotteryPriceDDL(req);
            return res;
        }

        public async Task<List<BaseDropDownModel>> LotteryTypeDDL()
        {
            var res = await _baseDDLProvider.LotteryTypeDDL();
            return res;
        }

        public async Task<List<BaseDropDownModel>> SalePointDDL()
        {
            var res = await _baseDDLProvider.SalePointDDL();
            return res;
        }

        public async Task<List<BaseDropDownModel>> UserByTitleDDL(UserByeTitleDDLReq req)
        {
            var res = await _baseDDLProvider.UserByTitleDDL(req);
            return res;
        }

        public async Task<List<BaseDropDownModel>> UserTitleDDL(UserByeTitleDDLReq req)
        {
            var res = await _baseDDLProvider.UserTitleDDL(req);
            return res;
        }

        public async Task<List<BaseDropDownModel>> WinningTypeDDL()
        {
            var res = await _baseDDLProvider.WinningTypeDDL();
            return res;
        }

        public async Task<List<TypeOfItemDDLModel>> GetTypeOfItemDDL()
        {
            var res = await _baseDDLProvider.GetTypeOfItemDDL();
            return res;
        }

        public async Task<List<TypeNameDDLModel>> GetTypeNameDDL(TypeNameDDLReq req)
        {
            var res = await _baseDDLProvider.GetTypeNameDDL(req);
            return res;
        }

        public async Task<List<UserDDLModel>> GetUserDDL(UserDDLReq req)
        {
            var res = await _baseDDLProvider.GetUserDDL(req);
            return res;
        }

        public async Task<List<CriteriaDDLModel>> GetCriteriaDDL(CriteriaDDLReq req)
        {
            var res = await _baseDDLProvider.GetCriteriaDDL(req);
            return res;
        }

        public async Task<List<ReportWinningTypeDDLModel>> ReportWinningTypeDDL()
        {
            var res = await _baseDDLProvider.ReportWinningTypeDDL();
            return res;
        }

        public async Task<List<InternByTitleDDLModel>> InternByTitleDDL(InternByTitleDDLReq req)
        {
            var res = await _baseDDLProvider.InternByTitleDDL(req);
            return res;
        }

        public async Task<List<SubAgencyDDLModel>> SubAgencyDDL(SubAgencyDDLReq req)
        {
            var res = await _baseDDLProvider.SubAgencyDDL(req);
            return res;
        }
    }
}
