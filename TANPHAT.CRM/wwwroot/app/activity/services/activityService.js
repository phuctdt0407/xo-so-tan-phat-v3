(function () {
    app.service('activityService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/Activity';

            this.receiveLotteryFromAgency = function (params) {
                var url = baseUrl + '/ReceiveLotteryFromAgency';
                return baseService.postData(url, params);
            };
            
            this.getDataReceivedFromAgency = function (params) {
                var url = baseUrl + '/GetDataReceivedFromAgency';
                return baseService.getData(url, params);
            };
            this.getTmpWinningTicket = function (params) {
                var url = baseUrl + '/GetTmpWinningTicket';
                return baseService.getData(url, params);
            }; 
            this.distributeForSalesPoint = function (params) {
                var url = baseUrl + '/DistributeForSalesPoint';
                return baseService.postData(url, params);
            };

            this.updateIsdeletedSalepointLog = function (params) {
                var url = baseUrl + '/UpdateIsdeletedSalepointLog';
                return baseService.postData(url, params);
            }; 
            this.updateActivityGuestAction = function (params) {
                var url = baseUrl + '/UpdateActivityGuestAction';
                return baseService.postData(url, params);
            };
            this.insertOrUpdateAgency = function (params) {
                var url = baseUrl + '/InsertOrUpdateAgency';
                return baseService.postData(url, params);
            }; 
            this.insertOrUpdateSubAgency = function (params) {
                var url = baseUrl + '/InsertOrUpdateSubAgency';
                return baseService.postData(url, params);
            };

            this.getDataDistributeForSalePoint = function (params) {
                var url = baseUrl + '/GetDataDistributeForSalePoint';
                return baseService.getData(url, params);
            };

           
            this.sellLottery = function (params) {
                var url = baseUrl + '/SellLottery';
                return baseService.postData(url, params);
            };
            
            this.getDataSell = function (params) {
                var url = baseUrl + '/GetDataSell';
                return baseService.getData(url, params);
            };
            this.getListSubAgency = function (params) {
                var url = baseUrl + '/GetListSubAgency';
                return baseService.getData(url, params);
            };
            
            this.insertTransitionLog = function (params) {
                var url = baseUrl + '/InsertTransitionLog';
                return baseService.postData(url, params);
            };
            
            this.getSalePointLog = function (params) {
                var url = baseUrl + '/GetSalePointLog';
                return baseService.getData(url, params);
            };
            this.getListLotteryPriceSubAgency = function (params) {
                var url = baseUrl + '/GetListLotteryPriceSubAgency';
                return baseService.getData(url, params);
            };
            
            this.insertRepayment = function (params) {
                var url = baseUrl + '/InsertRepayment';
                return baseService.postData(url, params);
            };
            
            this.getDataInventory = function (params) {
                var url = baseUrl + '/GetDataInventory';
                return baseService.getData(url, params);
            };

            this.getRepaymentLog = function (params) {
                var url = baseUrl + '/GetRepaymentLog';
                return baseService.getData(url, params);
            };
            
            this.getInventoryLog = function (params) {
                var url = baseUrl + '/GetInventoryLog';
                return baseService.getData(url, params);
            };

            this.getDataInventoryInMonthOfAllSalePoint = function (params) {
                var url = baseUrl + '/GetDataInventoryInMonthOfAllSalePoint';
                return baseService.getData(url, params);
            };

            this.insertWinningLottery = function (params) {
                var url = baseUrl + '/InsertWinningLottery';
                return baseService.postData(url, params);
            };
            
            this.shiftTransfer = function (params) {
                var url = baseUrl + '/ShiftTransfer';
                return baseService.postData(url, params);
            };
            
            this.receiveScratchcardFromAgency = function (params) {
                var url = baseUrl + '/ReceiveScratchcardFromAgency';
                return baseService.postData(url, params);
            };

            this.getDataScratchcardFromAgency = function (params) {
                var url = baseUrl + '/GetDataScratchcardFromAgency';
                return baseService.getData(url, params);
            };
            
            this.distributeScratchForSalesPoint = function (params) {
                var url = baseUrl + '/DistributeScratchForSalesPoint';
                return baseService.postData(url, params);
            };
            this.distributeScratchForSubAgency = function (params) {
                var url = baseUrl + '/DistributeScratchForSubAgency';
                return baseService.postData(url, params);
            };
            
            this.getDataDistributeScratchForSalePoint = function () {
                var url = baseUrl + '/GetDataDistributeScratchForSalePoint';
                return baseService.getData(url);
            };
            this.getDataDistributeScratchForSubAgency = function () {
                var url = baseUrl + '/GetDataDistributeScratchForSubAgency';
                return baseService.getData(url);
            };


            this.getScratchcardFull = function () {
                var url = baseUrl + '/GetScratchcardFull';
                return baseService.getData(url);
            };
            
            this.getWinningList = function (params) {
                var url = baseUrl + '/GetWinningList';
                return baseService.getData(url, params);
            };
            this.getWinningListByMonth = function (params) {
                var url = baseUrl + '/GetWinningListByMonth';
                return baseService.getData(url, params);
            };

            this.getTransitionListToConfirm = function (params) {
                var url = baseUrl + '/GetTransitionListToConfirm';
                return baseService.getData(url, params);
            };
            
            this.getShiftDistributeByDate = function (params) {
                var url = baseUrl + '/GetShiftDistributeByDate';
                return baseService.getData(url, params);
            };
            this.confirmTransition = function (params) {
                var url = baseUrl + '/ConfirmTransition';
                return baseService.postData(url, params);
            };
            
            this.getSoldLogDetail = function (params) {
                var url = baseUrl + '/GetSoldLogDetail';
                return baseService.getData(url, params);
            };
            
            this.getTransLogDetail = function (params) {
                var url = baseUrl + '/GetTransLogDetail';
                return baseService.getData(url, params);
            };
            
            this.getSalePointReturn = function (params) {
                var url = baseUrl + '/GetSalePointReturn';
                return baseService.getData(url, params);
            };

            this.createSalePoint = function (params) {
                var url = baseUrl + '/CreateSalePoint';
                return baseService.postData(url, params);
            };
            this.updateLotteryPriceAgency = function (params) {
                var url = baseUrl + '/UpdateLotteryPriceAgency';
                return baseService.postData(url, params);
            };
            this.updateLotteryPriceSubAgency = function (params) {
                var url = baseUrl + '/UpdateLotteryPriceSubAgency';
                return baseService.postData(url, params);
            };
            this.getLotteryPriceAgency = function (params) {
                var url = baseUrl + '/GetLotteryPriceAgency';
                return baseService.getData(url, params);
            };

            this.getListLotteryForReturn = function (params) {
                var url = baseUrl + '/GetListLotteryForReturn';
                return baseService.getData(url, params);
            };
            this.returnLottery = function (params) {
                var url = baseUrl + '/ReturnLottery';
                return baseService.postData(url, params);
            };
            this.updateConstantPrice = function (params) {
                var url = baseUrl + '/UpdateConstantPrice';
                return baseService.postData(url, params);
            };
            this.deleteLogWinning = function (params) {
                var url = baseUrl + '/DeleteLogWinning';
                return baseService.postData(url, params);
            };
            this.getListHistoryForManager = function (params) {
                var url = baseUrl + '/GetListHistoryForManager';
                return baseService.getData(url, params);
            };
            this.getListReportMoneyInADay = function (params) {
                var url = baseUrl + '/getListReportMoneyInADay';
                return baseService.getData(url, params);
            };
            this.updateReportMoneyInAShift = function (params) {
                var url = baseUrl + '/UpdateReportMoneyInAShift';
                return baseService.postData(url, params);
            };
            this.updatePriceForGuest = function (params) {
                var url = baseUrl + '/UpdatePriceForGuest';
                return baseService.postData(url, params);
            };
            this.deleteGuestAction = function (params) {
                var url = baseUrl + '/DeleteGuestAction';
                return baseService.postData(url, params);
            };
            this.distributeForSupAgency = function (params) {
                var url = baseUrl + '/DistributeForSubAgency';
                return baseService.postData(url, params);
            };
            this.getDataSupAgency = function (params) {
                var url = baseUrl + '/GetDataSubAgency';
                return baseService.getData(url, params);
            };
            this.updatePriceForSubAgency = function (params) {
                var url = baseUrl + '/UpdatePriceForSubAgency';
                return baseService.postData(url, params);
            };
            this.getStaticFee = function (params) {
                var url = baseUrl + '/GetStaticFee';
                return baseService.getData(url, params);
            };
            this.updateStaticFee = function (params) {
                var url = baseUrl + '/UpdateStaticFee';
                return baseService.postData(url, params);
            }
            this.distributeForSubAgency = function (params) {
                var url = baseUrl + '/DistributeForSubAgency';
                return baseService.postData(url, params);
            }
            this.getDebtOfStaff = function (params) {
                var url = baseUrl + '/GetDebtOfStaff';
                return baseService.getData(url, params);
            }
            this.updateDebt = function (params) {
                var url = baseUrl + '/UpdateDebt';
                return baseService.postData(url, params);
            }
            this.getPayedDebtAndNewDebtAllTime = function (params) {
                var url = baseUrl + '/GetPayedDebtAndNewDebtAllTime';
                return baseService.getData(url, params);
            }
        }]);
})(); 