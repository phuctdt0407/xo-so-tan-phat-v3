(function () {
    app.service('reportService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/Report';

            this.getTotalShiftOfUserInMonth = function (params) {
                var url = baseUrl + '/GetTotalShiftOfUserInMonth';
                return baseService.getData(url, params);
            };
            this.getTotalShiftOfUserBySalePointInMonth = function (params) {
                var url = baseUrl + '/GetTotalShiftOfUserBySalePointInMonth';
                return baseService.getData(url, params);
            };
            this.getTransitonTypeOffset = function (params) {
                var url = baseUrl + '/GetTransitonTypeOffset';
                return baseService.getData(url, params);
            };
            
            this.getDataInventoryInDayOfAllSalePoint = function (params) {
                var url = baseUrl + '/GetDataInventoryInDayOfAllSalePoint';
                return baseService.getData(url, params);
            };
            this.getTotalLotterySellOfUserToCurrentInMonth = function (params) {
                var url = baseUrl + '/GetTotalLotterySellOfUserToCurrentInMonth';
                return baseService.getData(url, params);
            };
            this.getDataInventoryInMonthOfAllSalePoint = function (params) {
                var url = baseUrl + '/GetDataInventoryInMonthOfAllSalePoint';
                return baseService.getData(url, params);
            };
            this.getTotalLotteryReceiveOfAllAgencyInMonth = function (params) {
                var url = baseUrl + '/GetTotalLotteryReceiveOfAllAgencyInMonth';
                return baseService.getData(url, params);
            };
            this.getTotalLotteryReturnOfAllSalePointInMonth = function (params) {
                var url = baseUrl + '/GetTotalLotteryReturnOfAllSalePointInMonth';
                return baseService.getData(url, params);
            };
            this.getTotalWinningOfSalePointInMonth = function (params) {
                var url = baseUrl + '/GetTotalWinningOfSalePointInMonth';
                return baseService.getData(url, params);
            };
            this.getTotalRemainOfSalePoint = function (params) {
                var url = baseUrl + '/GetTotalRemainOfSalePoint';
                return baseService.getData(url, params);
            };
            this.getDataShiftTransFer = function (params) {
                var url = baseUrl + '/GetDataShiftTransFer';
                return baseService.getData(url, params);
            };
            this.getTotalRemainingOfAllSalePointInDate = function (params) {
                var url = baseUrl + '/GetTotalRemainingOfAllSalePointInDate';
                return baseService.getData(url, params);
            };
            this.getDataQuantityInteractLotteryByDate = function (params) {
                var url = baseUrl + '/GetDataQuantityInteractLotteryByDate';
                return baseService.getData(url, params);
            };
            this.getDataQuantityInteractLotteryByMonth = function (params) {
                var url = baseUrl + '/GetDataQuantityInteractLotteryByMonth';
                return baseService.getData(url, params);
            };
            this.getReportManagerOverall = function (params) {
                var url = baseUrl + '/GetReportManagerOverall';
                return baseService.getData(url, params);
            };
            this.getTotalLotteryNotSellOfAllSalePoint = function (params) {
                var url = baseUrl + '/GetTotalLotteryNotSellOfAllSalePoint';
                return baseService.getData(url, params);
            };
            this.getTotalLotterySoldOfSalePointThatYouManage = function (params) {
                var url = baseUrl + '/GetTotalLotterySoldOfSalePointThatYouManage';
                return baseService.getData(url, params);
            };
            this.getAverageLotterySellOfUser = function (params) {
                var url = baseUrl + '/GetAverageLotterySellOfUser';
                return baseService.getData(url, params);
            };
            this.getLogDistributeForSalepoint = function (params) {
                var url = baseUrl + '/GetLogDistributeForSalepoint';
                return baseService.getData(url, params);
            };
            this.getListForUpdate = function (params) {
                var url = baseUrl + '/getListForUpdate';
                return baseService.getData(url, params);
            };
            this.updateORDeleteSalePointLog = function (params) {
                var url = baseUrl + '/UpdateORDeleteSalePointLog';
                return baseService.postData(url, params);
            };
            this.updateReportLottery = function (params) {
                var url = baseUrl + '/UpdateReportLottery';
                return baseService.postData(url, params);
            }; 
            this.getFullTotalItemInMonth = function (params) {
                var url = baseUrl + '/GetFullTotalItemInMonth';
                return baseService.getData(url, params);
            };
            this.getListUnsoldLotteryTicket = function (params) {
                var url = baseUrl + '/GetListUnsoldLotteryTicket';
                return baseService.getData(url, params);
            };
            this.getListTotalNumberOfTicketsOfEachManager = function (params) {
                var url = baseUrl + '/GetListTotalNumberOfTicketsOfEachManager';
                return baseService.getData(url, params);
            };
            this.updateKpi = function (params) {
                var url = baseUrl + '/UpdateKpi';
                return baseService.postData(url, params);
            };
            this.updateORDeleteItem = function (params) {
                var url = baseUrl + '/UpdateORDeleteItem';
                return baseService.postData(url, params);
            };
            this.updateIsSumKpi = function (params) {
                var url = baseUrl + '/UpdateIsSumKpi';
                return baseService.postData(url, params);
            }; 
            this.getListExemptKpi = function (params) {
                var url = baseUrl + '/GetListExemptKpi';
                return baseService.getData(url, params);
            };
            
            this.getLotterySellInMonth = function (params) {
                var url = baseUrl + '/GetLotterySellInMonth';
                return baseService.getData(url, params);
            };
            this.deleteShiftTransfer = function (params) {
                var url = baseUrl + '/DeleteShiftTransfer';
                return baseService.postData(url, params);
            };
            this.getSaleOfSalePointInMonth = function (params) {
                var url = baseUrl + '/GetSaleOfSalePointInMonth';
                return baseService.getData(url, params);
            };
            this.getSalaryInMonthOfUser = function (params) {
                var url = baseUrl + '/GetSalaryInMonthOfUser';
                return baseService.getData(url, params);
            }; 

            this.getSaleOfSalePointInMonth = function (params) {
                var url = baseUrl + '/GetSaleOfSalePointInMonth';
                return baseService.getData(url, params);
            };
            this.totalLotteryReceiveOfAllAgencyInDay = function (params) {
                var url = baseUrl + '/TotalLotteryReceiveOfAllAgencyInDay';
                return baseService.getData(url, params);
            };

            this.updateReturnMoney = function (params) {
                var url = baseUrl + '/UpdateReturnMoney';
                return baseService.postData(url, params);
            };
            
            this.reportLotteryInADay = function (params) {
                var url = baseUrl + '/ReportLotteryInADay';
                return baseService.getData(url, params);

            };
            this.reportRemainingLottery = function (params) {
                var url = baseUrl + '/ReportRemainingLottery';
                return baseService.getData(url, params);
            };
            this.reuseReportDataFinishShift = function (params) {
                var url = baseUrl + '/ReuseReportDataFinishShift';
                return baseService.getData(url, params);
            };
        }]);
})(); 