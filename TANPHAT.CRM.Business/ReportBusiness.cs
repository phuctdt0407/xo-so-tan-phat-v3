using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TANPHAT.CRM.Domain.Commons;
using TANPHAT.CRM.Domain.Models.Report;
using TANPHAT.CRM.Provider;
using System.Linq;

namespace TANPHAT.CRM.Business
{
    public interface IReportBusiness
    {
        Task<List<UserShiftReportModel>> GetTotalShiftOfUserInMonth(ReportRequestModel req);
        Task<List<GetListUnsoldLotteryTicketModel>> GetListUnsoldLotteryTicket(GetListUnsoldLotteryTicketReq req);
        
        Task<List<UserShiftReportModel>> GetTotalShiftOfUserBySalePointInMonth(ReportRequestModel req);
        
        Task<List<GetTransitonTypeOffsetModel>> GetTransitonTypeOffset(GetTransitonTypeOffsetReq req);
        Task<List<DataInventoryInDayOfAllSalePointModel>> GetDataInventoryInDayOfAllSalePoint(DataInventoryInDayOfAllSalePointReq req);

        Task<List<DataInventoryInMonthOfAllSalePointModel>> GetDataInventoryInMonthOfAllSalePoint(DataInventoryInMonthOfAllSalePointReq req);

        Task<List<TotalLotterySellOfUserToCurrentInMonthModel>> GetTotalLotterySellOfUserToCurrentInMonth(TotalLotterySellOfUserToCurrentInMonthReq req);
        Task<List<TotalLotterySellOfUserInMonth>> GetTotalLotterySellOfUserInMonth(TotalLotterySellOfUserToCurrentInMonthReq req);

        Task<List<TotalLotteryReceiveOfAllAgencyInMonthModel>> GetTotalLotteryReceiveOfAllAgencyInMonth(ReportRequestModel req);

        Task<List<TotalLotteryReturnOfAllSalePointInMonthModel>> GetTotalLotteryReturnOfAllSalePointInMonth(ReportRequestModel req);

        Task<List<TotalWinningOfSalePointInMonthModel>> GetTotalWinningOfSalePointInMonth(ReportRequestModel req);

        Task<List<TotalRemainOfSalePointModel>> GetTotalRemainOfSalePoint(ReportRequestModel req);

        Task<List<DataShiftTransFerModel>> GetDataShiftTransFer(ReportRequestModel req);

        Task<List<TotalRemainingOfAllSalePointInDateModel>> GetTotalRemainingOfAllSalePointInDate(ReportRequestModel req);

        Task<List<DataQuantityInteractLotteryByDateModel>> GetDataQuantityInteractLotteryByDate(ReportRequestModel req);

        Task<List<DataQuantityInteractLotteryByMonthModel>> GetDataQuantityInteractLotteryByMonth(ReportRequestModel req);

        Task<ReportManagerOverallModel> GetReportManagerOverall(ReportManagerOverallReq req);

        Task<List<TotalLotteryNotSellOfAllSalePointModel>> GetTotalLotteryNotSellOfAllSalePoint(ReportRequestModel req);

        Task<List<TotalLotterySoldOfSalePointThatYouManageModel>> GetTotalLotterySoldOfSalePointThatYouManage(ReportRequestModel req);

        Task<List<AverageLotterySellOfUserModel>> GetAverageLotterySellOfUser(TotalLotterySellOfUserToCurrentInMonthReq req);

        Task<List<LogDistributeForSalepointModel>> GetLogDistributeForSalepoint(LogDistributeForSalepointReq req);

        Task<GetListForUpdateModel> GetListForUpdate(GetListForUpdateReq req);
        Task<ReturnMessage> UpdateORDeleteSalePointLog(UpdateORDeleteSalePointLogReq req);
        Task<List<GetListTotalNumberOfTicketsOfEachManagerModel>> GetListTotalNumberOfTicketsOfEachManager(GetListTotalNumberOfTicketsOfEachManagerReq req);
        Task<List<GetFullTotalItemInMonthModel>> GetFullTotalItemInMonth(GetFullTotalItemInMonthReq req);

        Task<List<SaleOfSalePointInMonthModel>> GetSaleOfSalePointInMonth(SaleOfSalePointInMonthReq req);

        Task<ReturnMessage> UpdateORDeleteItem(UpdateORDeleteItemReq req); 
        Task<ReturnMessage> UpdateReportLottery(UpdateReportLotteryReq req);
        Task<GetLotterySellInMonthModel> GetLotterySellInMonth(GetLotterySellInMonthReq req);

        Task<ReturnMessage> DeleteShiftTransfer(DeleteShiftTransferReq req);
        Task<List<GetSalaryInMonthOfUserModel>> GetSalaryInMonthOfUser(GetSalaryInMonthOfUserReq req);
        Task<List<TotalLotteryReceiveOfAllAgencyInDayModel>> TotalLotteryReceiveOfAllAgencyInDay(TotalLotteryReceiveOfAllAgencyInDayReq req);
        Task<ReturnMessage> UpdateReturnMoney(UpdateReturnMoneyReq req);
        Task<ReturnMessage> UpdateKpi(UpdateKpiReq req); 
        Task<ReturnMessage> UpdateIsSumKpi(UpdateIsSumKpiReq req);
        Task<List<ReportLotteryInADayModel>> ReportLotteryInADay(ReportLotteryInADayReq req);
        Task<List<GetListExemptKpiModel>> GetListExemptKpi(GetListExemptKpiReq req);
        
        Task<List<ReportRemainingLotteryModel>> ReportRemainingLottery(ReportRemainingLotteryReq req);
        Task<List<ReuseReportDataFinishShiftModel>> ReuseReportDataFinishShift(ReuseReportDataFinishShiftReq req);

    }

    public class ReportBusiness : IReportBusiness
    {
        private IReportProvider _reportProvider;

        public ReportBusiness(IReportProvider reportProvider)
        {
            _reportProvider = reportProvider;
        }

        public async Task<List<UserShiftReportModel>> GetTotalShiftOfUserBySalePointInMonth(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalShiftOfUserBySalePointInMonth(req);
            var listMainTP = from _listMainTP in res
                             where _listMainTP.SalePointId == _listMainTP.MainSalePointId
                             select _listMainTP;
            listMainTP = listMainTP.ToList();
            int totalDaysInMonth = DateTime.DaysInMonth(req.Date.Year, req.Date.Month);
            int index;
            int totalshift = 0;
            int subShift = 0;
            int dk = 0;
            var listAdd = new List<UserShiftReportModel>() { };
            for (int i = 0; i < listMainTP.Count(); i++)
            {

                // neu so ca trong mainsalepoint > tong so ngay trong thang - 2
                if (listMainTP.ElementAt(i).Sum > totalDaysInMonth - 2)
                {
                    if (listMainTP.ElementAt(i).Quantity > totalDaysInMonth)
                    {
                        // ca du ra chuyen thanh tang ca
                        var addUserShiftReportModel = new UserShiftReportModel()
                        {
                            UserId = listMainTP.ElementAt(i).UserId,
                            SalePointId = listMainTP.ElementAt(i).SalePointId,
                            FullName = listMainTP.ElementAt(i).FullName,
                            MainSalePointId = listMainTP.ElementAt(i).MainSalePointId,
                            Quantity = listMainTP.ElementAt(i).Quantity - totalDaysInMonth,
                            Sum = listMainTP.ElementAt(i).Sum,
                            ShiftTypeId = 3,
                            ShiftTypeName = "Tăng ca"
                        };
                        res.Add(addUserShiftReportModel);
                        // ca goc = tong ngay trong thang
                        index = res.IndexOf(listMainTP.ElementAt(i));
                        res.ElementAt(index).Quantity = totalDaysInMonth;
                        listMainTP.ElementAt(i).Quantity = totalDaysInMonth;
                    }
                    index = res.IndexOf(listMainTP.ElementAt(i));

                    // cong them 1 cong thuong
                    res.ElementAt(index).Quantity += 1;


                }
                // chuyen tat ca cong trong mainsalepoint ve ca goc
                index = res.IndexOf(listMainTP.ElementAt(i));
                res.ElementAt(index).ShiftTypeName = "Ca gốc";
                res.ElementAt(index).ShiftTypeId = 1;

            }
            res = res.OrderBy(u => u.UserId).ToList();
            for (int i = 0; i < listMainTP.Count(); i++)
            {
                totalshift = listMainTP.ElementAt(i).Quantity;
                for (int j = 0; j < res.Count(); j++)
                {
                    if (totalshift >= totalDaysInMonth - 2 && res[j].SalePointId != res[j].MainSalePointId && listMainTP.ElementAt(i).UserId == res[j].UserId)
                    {
                        totalshift += res[j].Quantity;
                        res[j].ShiftTypeName = "Tăng ca";
                        res[j].ShiftTypeId = 3;
                    }
                    else if (dk == 0 && (totalshift + res[j].Quantity) > totalDaysInMonth + 1 && res[j].SalePointId != res[j].MainSalePointId && listMainTP.ElementAt(i).UserId == res[j].UserId)
                    {
                        totalshift += res[j].Quantity;
                        subShift = totalshift - totalDaysInMonth - 1;
                        var addUserShiftReportModel = new UserShiftReportModel()
                        {
                            UserId = res.ElementAt(j).UserId,
                            SalePointId = res.ElementAt(j).SalePointId,
                            FullName = res.ElementAt(j).FullName,
                            MainSalePointId = res.ElementAt(j).MainSalePointId,
                            Quantity = subShift,
                            Sum = res.ElementAt(j).Sum,
                            ShiftTypeId = 3,
                            ShiftTypeName = "Tăng ca"
                        };
                        listAdd.Add(addUserShiftReportModel);
                        res[j].Quantity -= subShift;
                        res[j].ShiftTypeName = "Ca gốc";
                        res[j].ShiftTypeId = 1;
                        dk = 1;
                    }
                    else if (res[j].SalePointId != res[j].MainSalePointId && listMainTP.ElementAt(i).UserId == res[j].UserId)
                    {
                        totalshift += res[j].Quantity;
                        res[j].ShiftTypeName = "Ca gốc";
                        res[j].ShiftTypeId = 1;

                    }

                }

            }
            for (int i = 0; i < listAdd.Count(); i++)
            {
                res.Add(listAdd[i]);
            }

            return res;
        }

        public async Task<List<UserShiftReportModel>> GetTotalShiftOfUserInMonth(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalShiftOfUserInMonth(req);
            return res;
        }
        public async Task<List<DataInventoryInDayOfAllSalePointModel>> GetDataInventoryInDayOfAllSalePoint(DataInventoryInDayOfAllSalePointReq req)
        {
            var res = await _reportProvider.GetDataInventoryInDayOfAllSalePoint(req);
            return res;
        }

        public async Task<List<DataInventoryInMonthOfAllSalePointModel>> GetDataInventoryInMonthOfAllSalePoint(DataInventoryInMonthOfAllSalePointReq req)
        {
            var res = await _reportProvider.GetDataInventoryInMonthOfAllSalePoint(req);
            return res;
        }

        public async Task<List<TotalLotterySellOfUserToCurrentInMonthModel>> GetTotalLotterySellOfUserToCurrentInMonth(TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            var res = await _reportProvider.GetTotalLotterySellOfUserToCurrentInMonth(req);
            return res;
        }

        public async Task<List<TotalLotterySellOfUserInMonth>> GetTotalLotterySellOfUserInMonth(TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            var res = await _reportProvider.GetTotalLotterySellOfUserInMonth(req);
            return res;
        }

        public async Task<List<TotalLotteryReceiveOfAllAgencyInMonthModel>> GetTotalLotteryReceiveOfAllAgencyInMonth(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalLotteryReceiveOfAllAgencyInMonth(req);
            return res;
        }

        public async Task<List<TotalLotteryReturnOfAllSalePointInMonthModel>> GetTotalLotteryReturnOfAllSalePointInMonth(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalLotteryReturnOfAllSalePointInMonth(req);
            return res;
        }
        public async Task<List<TotalWinningOfSalePointInMonthModel>> GetTotalWinningOfSalePointInMonth(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalWinningOfSalePointInMonth(req);
            return res;
        }

        public async Task<List<TotalRemainOfSalePointModel>> GetTotalRemainOfSalePoint(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalRemainOfSalePoint(req);
            return res;
        }

        public async Task<List<DataShiftTransFerModel>> GetDataShiftTransFer(ReportRequestModel req)
        {
            var res = await _reportProvider.GetDataShiftTransFer(req);
            return res;
        }

        public async Task<List<TotalRemainingOfAllSalePointInDateModel>> GetTotalRemainingOfAllSalePointInDate(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalRemainingOfAllSalePointInDate(req);
            return res;
        }

        public async Task<List<DataQuantityInteractLotteryByDateModel>> GetDataQuantityInteractLotteryByDate(ReportRequestModel req)
        {
            var res = await _reportProvider.GetDataQuantityInteractLotteryByDate(req);
            return res;
        }

        public async Task<List<DataQuantityInteractLotteryByMonthModel>> GetDataQuantityInteractLotteryByMonth(ReportRequestModel req)
        {
            var res = await _reportProvider.GetDataQuantityInteractLotteryByMonth(req);
            return res;
        }

        public async Task<ReportManagerOverallModel> GetReportManagerOverall(ReportManagerOverallReq req)
        {
            var res = await _reportProvider.GetReportManagerOverall(req);
            return res;
        }

        public async Task<List<TotalLotteryNotSellOfAllSalePointModel>> GetTotalLotteryNotSellOfAllSalePoint(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalLotteryNotSellOfAllSalePoint(req);
            return res;
        }

        public async Task<List<TotalLotterySoldOfSalePointThatYouManageModel>> GetTotalLotterySoldOfSalePointThatYouManage(ReportRequestModel req)
        {
            var res = await _reportProvider.GetTotalLotterySoldOfSalePointThatYouManage(req);
            return res;
        }

        public async Task<List<AverageLotterySellOfUserModel>> GetAverageLotterySellOfUser(TotalLotterySellOfUserToCurrentInMonthReq req)
        {
            var res = await _reportProvider.GetAverageLotterySellOfUser(req);
            return res;
        }

        public async Task<List<LogDistributeForSalepointModel>> GetLogDistributeForSalepoint(LogDistributeForSalepointReq req)
        {
            var res = await _reportProvider.GetLogDistributeForSalepoint(req);
            return res;
        }

        public async Task<GetListForUpdateModel> GetListForUpdate(GetListForUpdateReq req)
        {
            var res = await _reportProvider.GetListForUpdate(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateORDeleteSalePointLog(UpdateORDeleteSalePointLogReq req)
        {
            var res = await _reportProvider.UpdateORDeleteSalePointLog(req);
            return res;
        }

        public async Task<List<GetFullTotalItemInMonthModel>> GetFullTotalItemInMonth(GetFullTotalItemInMonthReq req)
        {
            var res = await _reportProvider.GetFullTotalItemInMonth(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateORDeleteItem(UpdateORDeleteItemReq req)
        {
            var res = await _reportProvider.UpdateORDeleteItem(req);
            return res;
        }

        public async Task<GetLotterySellInMonthModel> GetLotterySellInMonth(GetLotterySellInMonthReq req)
        {
            var res = await _reportProvider.GetLotterySellInMonth(req);
            return res;
        }

        public async Task<ReturnMessage> DeleteShiftTransfer(DeleteShiftTransferReq req)
        {
            var res = await _reportProvider.DeleteShiftTransfer(req);
            return res;
        }

        public async Task<List<SaleOfSalePointInMonthModel>> GetSaleOfSalePointInMonth(SaleOfSalePointInMonthReq req)
        {
            var res = await _reportProvider.GetSaleOfSalePointInMonth(req);
            return res;
        }

        public async Task<List<GetTransitonTypeOffsetModel>> GetTransitonTypeOffset(GetTransitonTypeOffsetReq req)
        {
            var res = await _reportProvider.GetTransitonTypeOffset(req);
            return res;
        }

        public async Task<List<GetSalaryInMonthOfUserModel>> GetSalaryInMonthOfUser(GetSalaryInMonthOfUserReq req)
        {
            var res = await _reportProvider.GetSalaryInMonthOfUser(req);
            return res;
        }

        public async Task<List<TotalLotteryReceiveOfAllAgencyInDayModel>> TotalLotteryReceiveOfAllAgencyInDay(TotalLotteryReceiveOfAllAgencyInDayReq req)
        {
            var res = await _reportProvider.TotalLotteryReceiveOfAllAgencyInDay(req);
            return res;
        }


        public async Task<ReturnMessage> UpdateReturnMoney(UpdateReturnMoneyReq req)
        {
            var res = await _reportProvider.UpdateReturnMoney(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateReportLottery(UpdateReportLotteryReq req)
        {
            var res = await _reportProvider.UpdateReportLottery(req);
            return res;
        }

        public async Task<List<ReportLotteryInADayModel>> ReportLotteryInADay(ReportLotteryInADayReq req)
        {
            var res = await _reportProvider.ReportLotteryInADay(req);

            return res;
        }

        public async Task<List<ReportRemainingLotteryModel>> ReportRemainingLottery(ReportRemainingLotteryReq req)
        {
            var res = await _reportProvider.ReportRemainingLottery(req);
            return res;
        }

        public async Task<List<ReuseReportDataFinishShiftModel>> ReuseReportDataFinishShift(ReuseReportDataFinishShiftReq req)
        {
            var res = await _reportProvider.ReuseReportDataFinishShift(req);
            return res;
        }

        public async Task<List<GetListUnsoldLotteryTicketModel>> GetListUnsoldLotteryTicket(GetListUnsoldLotteryTicketReq req)
        {
            var res = await _reportProvider.GetListUnsoldLotteryTicket(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateKpi(UpdateKpiReq req)
        {
            var res = await _reportProvider.UpdateKpi(req);
            return res;
        }

        public async Task<List<GetListTotalNumberOfTicketsOfEachManagerModel>> GetListTotalNumberOfTicketsOfEachManager(GetListTotalNumberOfTicketsOfEachManagerReq req)
        {
            var res = await _reportProvider.GetListTotalNumberOfTicketsOfEachManager(req);
            return res;
        }

        public async Task<ReturnMessage> UpdateIsSumKpi(UpdateIsSumKpiReq req)
        {
            var res = await _reportProvider.UpdateIsSumKpi(req);
            return res;
        }

        public async Task<List<GetListExemptKpiModel>> GetListExemptKpi(GetListExemptKpiReq req)
        {
            var res = await _reportProvider.GetListExemptKpi(req);
            return res;
        }
    }
}
