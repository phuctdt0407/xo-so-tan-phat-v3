using System.Collections.Generic;
using System.Threading.Tasks;
using KTHub.Core.DBConnection;
using Microsoft.Extensions.Configuration;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.BaseDDL;

namespace TANPHAT.CRM.Provider
{
    public interface IBaseDDLProvider
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

        Task<List<TypeOfItemDDLModel>> GetTypeOfItemDDL();

        Task<List<TypeNameDDLModel>> GetTypeNameDDL(TypeNameDDLReq req);

        Task<List<UserDDLModel>> GetUserDDL(UserDDLReq req);

        Task<List<CriteriaDDLModel>> GetCriteriaDDL(CriteriaDDLReq req);

        Task<List<ReportWinningTypeDDLModel>> ReportWinningTypeDDL();
        Task<List<InternByTitleDDLModel>> InternByTitleDDL(InternByTitleDDLReq req);
        Task<List<SubAgencyDDLModel>> SubAgencyDDL(SubAgencyDDLReq req);
    }

    public class BaseDDLProvider : PostgreExecute, IBaseDDLProvider
    {
        public BaseDDLProvider(IConfiguration configuration) : base(configuration, DBCommon.TANPHATCRMConnStr)
        {
        }

        public async Task<List<BaseDropDownModel>> AgencyDDL()
        {
            var res = await base.ExecStoredProcAsync<BaseDropDownModel>("crm_agency_ddl");
            return res;
        }

        public async Task<List<ItemDDLModel>> GetItemDDL(ItemDDLReq req)
        {
            var obj = new
            {
                p_item_id = req.ItemId
            };
            var res = await base.ExecStoredProcAsync<ItemDDLModel>("crm_get_list_item_ddl", obj);
            return res;
        }

        public async Task<List<UnitDDLModel>> GetUnitDDL(UnitDDLReq req)
        {
            var obj = new
            {
                p_unit_id = req.UnitId
            };
            var res = await base.ExecStoredProcAsync<UnitDDLModel>("crm_get_list_unit_ddl", obj);
            return res;
        }

        public async Task<List<GuestDDLModel>> GetGuestDDL(GuestDDLReq req)
        {
            var obj = new
            {
                p_sale_point_id = req.SalePointId,
                p_guest_id = req.GuestId
            };
            var res = await base.ExecStoredProcAsync<GuestDDLModel>("crm_get_list_guest_ddl_v2", obj);
            return res;
        }

        public async Task<List<LotteryChannelDDLModel>> LotteryChannelDDL(LotteryChannelDDLReq req)
        {
            var obj = new
            {
                p_region_id = req.RegionId,
                p_date = req.LotteryDate
            };
            var res = await base.ExecStoredProcAsync<LotteryChannelDDLModel>("crm_lottery_channel_ddl", obj);
            return res;
        }

        public async Task<List<LotteryPriceDDLModel>> LotteryPriceDDL(LotteryPriceDDLReq req)
        {
            var obj = new
            {
                p_lottery_type_id = req.LotteryTypeId
            };
            var res = await base.ExecStoredProcAsync<LotteryPriceDDLModel>("crm_lottery_price_ddl_v2", obj);
            return res;
        }

        public async Task<List<BaseDropDownModel>> LotteryTypeDDL()
        {
            var res = await base.ExecStoredProcAsync<BaseDropDownModel>("crm_lottery_type_ddl");
            return res;
        }

        public async Task<List<BaseDropDownModel>> SalePointDDL()
        {
            var res = await base.ExecStoredProcAsync<BaseDropDownModel>("crm_sale_point_ddl");
            return res;
        }

        public async Task<List<BaseDropDownModel>> UserByTitleDDL(UserByeTitleDDLReq req)
        {
            var obj = new
            {
                p_usertitle_id = req.UserTitleId
            };
            var res = await base.ExecStoredProcAsync<BaseDropDownModel>("crm_user_by_title", obj);
            return res;
        }

        public async Task<List<BaseDropDownModel>> UserTitleDDL(UserByeTitleDDLReq req)
        {
            var obj = new
            {
                p_get_full = req.IsGetFull
            };
            var res = await base.ExecStoredProcAsync<BaseDropDownModel>("crm_user_usertitle_ddl", obj);
            return res;
        }

        public async Task<List<BaseDropDownModel>> WinningTypeDDL()
        {
            var res = await base.ExecStoredProcAsync<BaseDropDownModel>("crm_winning_type_ddl");
            return res;
        }

        public async Task<List<TypeOfItemDDLModel>> GetTypeOfItemDDL()
        {
            var res = await base.ExecStoredProcAsync<TypeOfItemDDLModel>("crm_type_of_item_ddl");
            return res;
        }

        public async Task<List<TypeNameDDLModel>> GetTypeNameDDL(TypeNameDDLReq req)
        {
            var obj = new
            {
                p_transaction_type_id = req.TransactionTypeId
            };
            var res = await base.ExecStoredProcAsync<TypeNameDDLModel>("crm_base_get_type_name_ddl", obj);
            return res;
        }

        public async Task<List<UserDDLModel>> GetUserDDL(UserDDLReq req)
        {
            var obj = new
            {
                p_usertitle_id = req.UserTitleId,
                p_date = req.Date
            };
            var res = await base.ExecStoredProcAsync<UserDDLModel>("crm_get_user_ddl", obj);
            return res;
        }

        public async Task<List<CriteriaDDLModel>> GetCriteriaDDL(CriteriaDDLReq req)
        {
            var obj = new
            {
                p_user_title_id = req.UserTitleId
            };
            var res = await base.ExecStoredProcAsync<CriteriaDDLModel>("crm_get_list_criteria_ddl", obj);
            return res;
        }

        public async Task<List<ReportWinningTypeDDLModel>> ReportWinningTypeDDL()
        {
            var res = await base.ExecStoredProcAsync<ReportWinningTypeDDLModel>("crm_report_winning_type_ddl");
            return res;
        }

        public async Task<List<InternByTitleDDLModel>> InternByTitleDDL(InternByTitleDDLReq req)
        {
            var res = await base.ExecStoredProcAsync<InternByTitleDDLModel>("crm_intern_by_title_v1");
            return res;
        }

        public async Task<List<SubAgencyDDLModel>> SubAgencyDDL(SubAgencyDDLReq req)
        {
            var res = await base.ExecStoredProcAsync<SubAgencyDDLModel>("crm_sub_agency_ddl");
            return res;
        }
    }
}
