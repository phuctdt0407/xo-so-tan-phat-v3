using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TANPHAT.CRM.Client;
using TANPHAT.CRM.Domain.Models.BaseDDL;

namespace TANPHAT.CRM.Controllers.Api
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class BaseDDLController : ControllerBase
    {
        private IBaseDDLClient _baseDDLClient;

        public BaseDDLController(IBaseDDLClient baseDDLClient)
        {
            _baseDDLClient = baseDDLClient;
        }

        [HttpGet("LotteryChannelDDL")]
        public async Task<object> LotteryChannelDDL(int regionId, DateTime? lotteryDate)
        {
            var obj = new LotteryChannelDDLReq
            {
                RegionId = regionId,
                LotteryDate = lotteryDate ?? null
            };
            var res = await _baseDDLClient.LotteryChannelDDL(obj);
            return res;
        }

        [HttpGet("AgencyDDL")]
        public async Task<object> AgencyDDL()
        {
            var res = await _baseDDLClient.AgencyDDL();
            return res;
        }

        [HttpGet("SalePointDDL")]
        public async Task<object> SalePointDDL()
        {
            var res = await _baseDDLClient.SalePointDDL();
            return res;
        }

        [HttpGet("UserByTitleDDL")]
        public async Task<object> UserByTitleDDL(int userTitleId)
        {
            var obj = new UserByeTitleDDLReq
            {
                UserTitleId = userTitleId
            };
            var res = await _baseDDLClient.UserByTitleDDL(obj);
            return res;
        }

        [HttpGet("UserTitleDDL")]
        public async Task<object> UserTitleDDL(bool? isGetFull)
        {
            var obj = new UserByeTitleDDLReq
            {
                IsGetFull = isGetFull ?? false
            };
            var res = await _baseDDLClient.UserTitleDDL(obj);
            return res;
        }

        [HttpGet("LotteryTypeDDL")]
        public async Task<object> LotteryTypeDDL()
        {
            var res = await _baseDDLClient.LotteryTypeDDL();
            return res;
        }

        [HttpGet("LotteryPriceDDL")]
        public async Task<object> LotteryPriceDDL(int? lotteryTypeId = 0)
        {
            var obj = new LotteryPriceDDLReq
            {
                LotteryTypeId = lotteryTypeId ?? 0
            };
            var res = await _baseDDLClient.LotteryPriceDDL(obj);
            return res;
        }
        
        [HttpGet("WinningTypeDDL")]
        public async Task<object> WinningTypeDDL()
        {
            var res = await _baseDDLClient.WinningTypeDDL();
            return res;
        }

        [HttpGet("GetItemDDL")]
        public async Task<object> GetItemDDL(int? itemId = 0)
        {
            var obj = new ItemDDLReq
            {
                ItemId = itemId ?? 0
            };
            var res = await _baseDDLClient.GetItemDDL(obj);
            return res;
        }

        [HttpGet("GetUnitDDL")]
        public async Task<object> GetUnitDDL(int? unitId = 0)
        {
            var obj = new UnitDDLReq
            {
                UnitId = unitId ?? 0
            };
            var res = await _baseDDLClient.GetUnitDDL(obj);
            return res;
        }
        [HttpGet("GetGuestDDL")]
        public async Task<object> GetGuestDDL(int? salePointId = 0, int? guestId = 0)
        {
            var obj = new GuestDDLReq
            {
                SalePointId = salePointId ?? 0,
                GuestId = guestId ?? 0
            };
            var res = await _baseDDLClient.GetGuestDDL(obj);
            return res;
        }

        [HttpGet("GetTypeOfItemDDL")]
        public async Task<object> GetTypeOfItemDDL()
        {
            var res = await _baseDDLClient.GetTypeOfItemDDL();
            return res;
        }

        [HttpGet("GetTypeNameDDL")]
        public async Task<object> GetTypeNameDDL(int? transactionTypeId = 0)
        {
            var obj = new TypeNameDDLReq
            {
                TransactionTypeId = transactionTypeId ?? 0
            };
            var res = await _baseDDLClient.GetTypeNameDDL(obj);
            return res;
        }

        [HttpGet("GetUserDDL")]
        public async Task<object> GetUserDDL(int userTitleId, DateTime? date = null)
        {
            var obj = new UserDDLReq
            {
                UserTitleId = userTitleId,
                Date = date ?? DateTime.Now,
            };
            var res = await _baseDDLClient.GetUserDDL(obj);
            return res;
        }

        [HttpGet("GetCriteriaDDL")]
        public async Task<object> GetCriteriaDDL(int? userTitleId = 0)
        {
            var obj = new CriteriaDDLReq
            {
                UserTitleId = userTitleId ?? 0
            };
            var res = await _baseDDLClient.GetCriteriaDDL(obj);
            return res;
        }

        [HttpGet("ReportWinningTypeDDL")]
        public async Task<object> ReportWinningTypeDDL()
        {
            var res = await _baseDDLClient.ReportWinningTypeDDL();
            return res;
        }
        [HttpGet("InternByTitleDDL")]
        public async Task<object> InternByTitleDDL()
        {
            var obj = new InternByTitleDDLReq
            {
            };
            var res = await _baseDDLClient.InternByTitleDDL(obj);
            return res;
        }
        [HttpGet("SubAgencyDDL")]
        public async Task<object> SubAgencyDDL()
        {
            var obj = new SubAgencyDDLReq
            {
            };
            var res = await _baseDDLClient.SubAgencyDDL(obj);
            return res;
        }
    }
}
