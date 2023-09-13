using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using KTHub.Core.Client;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report;
using TANPHAT.CRM.Domain.Models.Report.Enum;

namespace TANPHAT.CRM.Client
{
    public interface IReportClient
    {
        Task<ApiResponse<List<UserShiftReportModel>>> GetTotalShiftOfUserInMonth(ReportRequestModel req);
        Task<ApiResponse<List<GetTransitonTypeOffsetModel>>> GetTransitonTypeOffset(GetTransitonTypeOffsetReq req);

        Task<ApiResponse<List<UserShiftReportModel>>> GetTotalShiftOfUserBySalePointInMonth(ReportRequestModel req);

        Task<ApiResponse<List<DataInventoryInDayOfAllSalePointModel>>> GetDataInventoryInDayOfAllSalePoint(
            DataInventoryInDayOfAllSalePointReq req);

        Task<ApiResponse<List<TotalLotterySellOfUserToCurrentInMonthModel>>> GetTotalLotterySellOfUserToCurrentInMonth(
            TotalLotterySellOfUserToCurrentInMonthReq req);

        Task<ApiResponse<List<DataInventoryInMonthOfAllSalePointModel>>> GetDataInventoryInMonthOfAllSalePoint(
            DataInventoryInMonthOfAllSalePointReq req);

        Task<ApiResponse<List<TotalLotteryReceiveOfAllAgencyInMonthModel>>> GetTotalLotteryReceiveOfAllAgencyInMonth(
            ReportRequestModel req);

        Task<ApiResponse<List<TotalLotteryReturnOfAllSalePointInMonthModel>>>
            GetTotalLotteryReturnOfAllSalePointInMonth(ReportRequestModel req);

        Task<ApiResponse<List<TotalWinningOfSalePointInMonthModel>>> GetTotalWinningOfSalePointInMonth(
            ReportRequestModel req);

        Task<ApiResponse<List<TotalRemainOfSalePointModel>>> GetTotalRemainOfSalePoint(ReportRequestModel req);

        Task<ApiResponse<List<DataShiftTransFerModel>>> GetDataShiftTransFer(ReportRequestModel req);

        Task<ApiResponse<List<TotalRemainingOfAllSalePointInDateModel>>> GetTotalRemainingOfAllSalePointInDate(
            ReportRequestModel req);

        Task<ApiResponse<List<DataQuantityInteractLotteryByMonthModel>>> GetDataQuantityInteractLotteryByMonth(
            ReportRequestModel req);

        Task<ApiResponse<List<DataQuantityInteractLotteryByDateModel>>> GetDataQuantityInteractLotteryByDate(
            ReportRequestModel req);

        Task<ApiResponse<ReportManagerOverallModel>> GetReportManagerOverall(ReportManagerOverallReq req);

        Task<ApiResponse<List<TotalLotteryNotSellOfAllSalePointModel>>> GetTotalLotteryNotSellOfAllSalePoint(
            ReportRequestModel req);

        Task<ApiResponse<List<TotalLotterySoldOfSalePointThatYouManageModel>>>
            GetTotalLotterySoldOfSalePointThatYouManage(ReportRequestModel req);

        Task<ApiResponse<List<AverageLotterySellOfUserModel>>> GetAverageLotterySellOfUser(
            TotalLotterySellOfUserToCurrentInMonthReq req);

        Task<ApiResponse<List<LogDistributeForSalepointModel>>> GetLogDistributeForSalepoint(
            LogDistributeForSalepointReq req);

        Task<ApiResponse<GetListForUpdateModel>> GetListForUpdate(GetListForUpdateReq req);

        Task<ApiResponse<ReturnMessage>> UpdateORDeleteSalePointLog(UpdateORDeleteSalePointLogReq req);
        Task<ApiResponse<List<GetFullTotalItemInMonthModel>>> GetFullTotalItemInMonth(GetFullTotalItemInMonthReq req);
        Task<ApiResponse<List<GetListTotalNumberOfTicketsOfEachManagerModel>>> GetListTotalNumberOfTicketsOfEachManager(GetListTotalNumberOfTicketsOfEachManagerReq req);
        
        Task<ApiResponse<List<SaleOfSalePointInMonthModel>>> GetSaleOfSalePointInMonth(SaleOfSalePointInMonthReq req);
        Task<ApiResponse<List<GetListUnsoldLotteryTicketModel>>> GetListUnsoldLotteryTicket(GetListUnsoldLotteryTicketReq req);
        Task<ApiResponse<ReturnMessage>> UpdateIsSumKpi(UpdateIsSumKpiReq req);
        Task<ApiResponse<ReturnMessage>> UpdateKpi(UpdateKpiReq req);
        Task<ApiResponse<ReturnMessage>> UpdateORDeleteItem(UpdateORDeleteItemReq req);
        Task<ApiResponse<ReturnMessage>> UpdateReportLottery(UpdateReportLotteryReq req);
        Task<ApiResponse<GetLotterySellInMonthModel>> GetLotterySellInMonth(GetLotterySellInMonthReq req);

        Task<ApiResponse<ReturnMessage>> DeleteShiftTransfer(DeleteShiftTransferReq req);
        Task<ApiResponse<List<GetSalaryInMonthOfUserModel>>> GetSalaryInMonthOfUser(GetSalaryInMonthOfUserReq req);

        Task<ApiResponse<List<ReportRemainingLotteryModel>>> ReportRemainingLottery(ReportRemainingLotteryReq req);
        Task<ApiResponse<List<ReuseReportDataFinishShiftModel>>> ReuseReportDataFinishShift(ReuseReportDataFinishShiftReq req);
        Task<ApiResponse<List<GetListExemptKpiModel>>> GetListExemptKpi(GetListExemptKpiReq req);
        
        Task<ApiResponse<List<TotalLotteryReceiveOfAllAgencyInDayModel>>> TotalLotteryReceiveOfAllAgencyInDay(
            TotalLotteryReceiveOfAllAgencyInDayReq req);

        Task<ApiResponse<ReturnMessage>> UpdateReturnMoney(UpdateReturnMoneyReq req);

        Task<ApiResponse<List<ReportLotteryInADayModel>>> ReportLotteryInADay(ReportLotteryInADayReq req);
    }

    public class ReportClient : BaseApiClient, IReportClient
    {
        private string urlSend { get; set; }

        public ReportClient(ApiConfigs configs) : base(configs)
        {
            urlSend = base.GetUrlSend(UrlCommon.T_Report);
        }

        public async Task<ApiResponse<List<UserShiftReportModel>>> GetTotalShiftOfUserInMonth(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalShiftOfUserInMonth;
            return await GetAsync<List<UserShiftReportModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<UserShiftReportModel>>> GetTotalShiftOfUserBySalePointInMonth(
            ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalShiftOfUserBySalePointInMonth;
            return await GetAsync<List<UserShiftReportModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataInventoryInDayOfAllSalePointModel>>> GetDataInventoryInDayOfAllSalePoint(
            DataInventoryInDayOfAllSalePointReq req)
        {
            req.TypeName = ReportGetType.GetDataInventoryInDayOfAllSalePoint;
            return await GetAsync<List<DataInventoryInDayOfAllSalePointModel>, DataInventoryInDayOfAllSalePointReq>(
                urlSend, req);
        }

        public async Task<ApiResponse<List<TotalLotterySellOfUserToCurrentInMonthModel>>>
            GetTotalLotterySellOfUserToCurrentInMonth(TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            req.TypeName = ReportGetType.GetTotalLotterySellOfUserToCurrentInMonth;
            return await GetAsync<List<TotalLotterySellOfUserToCurrentInMonthModel>,
                TotalLotterySellOfUserToCurrentInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataInventoryInMonthOfAllSalePointModel>>>
            GetDataInventoryInMonthOfAllSalePoint(DataInventoryInMonthOfAllSalePointReq req)
        {
            req.TypeName = ReportGetType.GetDataInventoryInMonthOfAllSalePoint;
            return await GetAsync<List<DataInventoryInMonthOfAllSalePointModel>, DataInventoryInMonthOfAllSalePointReq>(
                urlSend, req);
        }

        public async Task<ApiResponse<List<TotalLotteryReceiveOfAllAgencyInMonthModel>>>
            GetTotalLotteryReceiveOfAllAgencyInMonth(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalLotteryReceiveOfAllAgencyInMonth;
            return await GetAsync<List<TotalLotteryReceiveOfAllAgencyInMonthModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<TotalLotteryReturnOfAllSalePointInMonthModel>>>
            GetTotalLotteryReturnOfAllSalePointInMonth(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalLotteryReturnOfAllSalePointInMonth;
            return await GetAsync<List<TotalLotteryReturnOfAllSalePointInMonthModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<TotalWinningOfSalePointInMonthModel>>> GetTotalWinningOfSalePointInMonth(
            ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalWinningOfSalePointInMonth;
            return await GetAsync<List<TotalWinningOfSalePointInMonthModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<TotalRemainOfSalePointModel>>> GetTotalRemainOfSalePoint(
            ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalRemainOfSalePoint;
            return await GetAsync<List<TotalRemainOfSalePointModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataShiftTransFerModel>>> GetDataShiftTransFer(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetDataShiftTransFer;
            return await GetAsync<List<DataShiftTransFerModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<TotalRemainingOfAllSalePointInDateModel>>>
            GetTotalRemainingOfAllSalePointInDate(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalRemainingOfAllSalePointInDate;
            return await GetAsync<List<TotalRemainingOfAllSalePointInDateModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataQuantityInteractLotteryByMonthModel>>>
            GetDataQuantityInteractLotteryByMonth(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetDataQuantityInteractLotteryByMonth;
            return await GetAsync<List<DataQuantityInteractLotteryByMonthModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<DataQuantityInteractLotteryByDateModel>>>
            GetDataQuantityInteractLotteryByDate(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetDataQuantityInteractLotteryByDate;
            return await GetAsync<List<DataQuantityInteractLotteryByDateModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<ReportManagerOverallModel>> GetReportManagerOverall(ReportManagerOverallReq req)
        {
            req.TypeName = ReportGetType.GetReportManagerOverall;
            return await GetAsync<ReportManagerOverallModel, ReportManagerOverallReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<TotalLotteryNotSellOfAllSalePointModel>>>
            GetTotalLotteryNotSellOfAllSalePoint(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalLotteryNotSellOfAllSalePoint;
            return await GetAsync<List<TotalLotteryNotSellOfAllSalePointModel>, ReportRequestModel>(urlSend, req);
        }

        public async Task<ApiResponse<List<TotalLotterySoldOfSalePointThatYouManageModel>>>
            GetTotalLotterySoldOfSalePointThatYouManage(ReportRequestModel req)
        {
            req.TypeName = ReportGetType.GetTotalLotterySoldOfSalePointThatYouManage;
            return await GetAsync<List<TotalLotterySoldOfSalePointThatYouManageModel>, ReportRequestModel>(urlSend,
                req);
        }

        public async Task<ApiResponse<List<AverageLotterySellOfUserModel>>> GetAverageLotterySellOfUser(
            TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            req.TypeName = ReportGetType.GetAverageLotterySellOfUser;
            return await GetAsync<List<AverageLotterySellOfUserModel>, TotalLotterySellOfUserToCurrentInMonthReq>(
                urlSend, req);
        }

        public async Task<ApiResponse<List<LogDistributeForSalepointModel>>> GetLogDistributeForSalepoint(
            LogDistributeForSalepointReq req)
        {
            req.TypeName = ReportGetType.GetLogDistributeForSalepoint;
            return await GetAsync<List<LogDistributeForSalepointModel>, LogDistributeForSalepointReq>(urlSend, req);
        }

        public async Task<ApiResponse<GetListForUpdateModel>> GetListForUpdate(GetListForUpdateReq req)
        {
            req.TypeName = ReportGetType.GetListForUpdate;
            return await GetAsync<GetListForUpdateModel, GetListForUpdateReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateORDeleteSalePointLog(UpdateORDeleteSalePointLogReq req)
        {
            req.TypeName = ReportPostType.UpdateORDeleteSalePointLog;
            return await PostAsync<ReturnMessage, UpdateORDeleteSalePointLogReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetFullTotalItemInMonthModel>>> GetFullTotalItemInMonth(
            GetFullTotalItemInMonthReq req)
        {
            req.TypeName = ReportGetType.GetFullTotalItemInMonth;
            return await GetAsync<List<GetFullTotalItemInMonthModel>, GetFullTotalItemInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateORDeleteItem(UpdateORDeleteItemReq req)
        {
            req.TypeName = ReportPostType.UpdateORDeleteItem;
            return await PostAsync<ReturnMessage, UpdateORDeleteItemReq>(urlSend, req);
        }

        public async Task<ApiResponse<GetLotterySellInMonthModel>> GetLotterySellInMonth(GetLotterySellInMonthReq req)
        {
            req.TypeName = ReportGetType.GetLotterySellInMonth;
            return await GetAsync<GetLotterySellInMonthModel, GetLotterySellInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> DeleteShiftTransfer(DeleteShiftTransferReq req)
        {
            req.TypeName = ReportPostType.DeleteShiftTransfer;
            return await PostAsync<ReturnMessage, DeleteShiftTransferReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<SaleOfSalePointInMonthModel>>> GetSaleOfSalePointInMonth(
            SaleOfSalePointInMonthReq req)
        {
            req.TypeName = ReportGetType.GetSaleOfSalePointInMonth;
            return await GetAsync<List<SaleOfSalePointInMonthModel>, SaleOfSalePointInMonthReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetTransitonTypeOffsetModel>>> GetTransitonTypeOffset(
            GetTransitonTypeOffsetReq req)
        {
            req.TypeName = ReportGetType.GetTransitonTypeOffset;
            return await GetAsync<List<GetTransitonTypeOffsetModel>, GetTransitonTypeOffsetReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetSalaryInMonthOfUserModel>>> GetSalaryInMonthOfUser(
            GetSalaryInMonthOfUserReq req)
        {
            req.TypeName = ReportGetType.GetSalaryInMonthOfUser;
            return await GetAsync<List<GetSalaryInMonthOfUserModel>, GetSalaryInMonthOfUserReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<TotalLotteryReceiveOfAllAgencyInDayModel>>>
            TotalLotteryReceiveOfAllAgencyInDay(TotalLotteryReceiveOfAllAgencyInDayReq req)
        {
            req.TypeName = ReportGetType.TotalLotteryReceiveOfAllAgencyInDay;
            return await GetAsync<List<TotalLotteryReceiveOfAllAgencyInDayModel>,
                TotalLotteryReceiveOfAllAgencyInDayReq>(urlSend, req);
        }


        public async Task<ApiResponse<ReturnMessage>> UpdateReturnMoney(UpdateReturnMoneyReq req)
        {
            req.TypeName = ReportPostType.UpdateReturnMoney;
            return await PostAsync<ReturnMessage, UpdateReturnMoneyReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateReportLottery(UpdateReportLotteryReq req)
        {
            req.TypeName = ReportPostType.UpdateReportLottery;
            return await PostAsync<ReturnMessage, UpdateReportLotteryReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ReportLotteryInADayModel>>> ReportLotteryInADay(ReportLotteryInADayReq req)
        {
            req.TypeName = ReportGetType.ReportLotteryInADay;
            return await GetAsync<List<ReportLotteryInADayModel>, ReportLotteryInADayReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ReportRemainingLotteryModel>>> ReportRemainingLottery(ReportRemainingLotteryReq req)
        {
            req.TypeName = ReportGetType.ReportRemainingLottery;
            return await GetAsync<List<ReportRemainingLotteryModel>, ReportRemainingLotteryReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<ReuseReportDataFinishShiftModel>>> ReuseReportDataFinishShift(ReuseReportDataFinishShiftReq req)
        {
            req.TypeName = ReportGetType.ReuseReportDataFinishShift;
            return await GetAsync<List<ReuseReportDataFinishShiftModel>, ReuseReportDataFinishShiftReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListUnsoldLotteryTicketModel>>> GetListUnsoldLotteryTicket(GetListUnsoldLotteryTicketReq req)
        {
            req.TypeName = ReportGetType.GetListUnsoldLotteryTicket;
            return await GetAsync<List<GetListUnsoldLotteryTicketModel>, GetListUnsoldLotteryTicketReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateKpi(UpdateKpiReq req)
        {
            req.TypeName = ReportPostType.UpdateKpi;
            return await PostAsync<ReturnMessage, UpdateKpiReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListTotalNumberOfTicketsOfEachManagerModel>>> GetListTotalNumberOfTicketsOfEachManager(GetListTotalNumberOfTicketsOfEachManagerReq req)
        {
            req.TypeName = ReportGetType.GetListTotalNumberOfTicketsOfEachManager;
            return await GetAsync<List<GetListTotalNumberOfTicketsOfEachManagerModel>, GetListTotalNumberOfTicketsOfEachManagerReq>(urlSend, req);
        }

        public async Task<ApiResponse<ReturnMessage>> UpdateIsSumKpi(UpdateIsSumKpiReq req)
        {
            req.TypeName = ReportPostType.UpdateIsSumKpi;
            return await PostAsync<ReturnMessage, UpdateIsSumKpiReq>(urlSend, req);
        }

        public async Task<ApiResponse<List<GetListExemptKpiModel>>> GetListExemptKpi(GetListExemptKpiReq req)
        {
            req.TypeName = ReportGetType.GetListExemptKpi;
            return await GetAsync<List<GetListExemptKpiModel>, GetListExemptKpiReq>(urlSend, req);
        }
    }
}