(function () {
    app.service('salepointService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/SalePoint';

            this.updateSalePoint = function (params) {
                var url = baseUrl + '/UpdateSalePoint';
                return baseService.postData(url, params);
            };
            this.getListSalePoint = function (params) {
                var url = baseUrl + '/GetListSalePoint';
                return baseService.getData(url, params);
            };
            this.updateItemInSalePoint = function (params) {
                var url = baseUrl + '/UpdateItemInSalePoint';
                return baseService.postData(url, params);
            };
            this.getListFeeOutsite = function (params) {
                var url = baseUrl + '/GetListFeeOutsite';
                return baseService.getData(url, params);
            };
            this.updateFeeOutSite = function (params) {
                var url = baseUrl + '/UpdateFeeOutSite';
                return baseService.postData(url, params);
            };
            this.updateOrCreateGuest = function (params) {
                var url = baseUrl + '/UpdateOrCreateGuest';
                return baseService.postData(url, params);
            };
            
            this.getListItemConfirm = function (params) {
                var url = baseUrl + '/GetListItemConfirm';
                return baseService.getData(url, params);
            };

            this.updateOrCreateGuestAction = function (params) {
                var url = baseUrl + '/UpdateOrCreateGuestAction';
                return baseService.postData(url, params);
            };

            this.createListConfirmPayment = function (params) {
                var url = baseUrl + '/CreateListConfirmPayment';
                return baseService.postData(url, params);
            };

            this.getListConfirmPayment = function (params) {
                var url = baseUrl + '/GetListConfirmPayment';
                return baseService.getData(url, params);
            };
            this.getListComission = function (params) {
                var url = baseUrl + '/GetListComission';
                return baseService.getData(url, params);
            };

            this.confirmListPayment = function (params) {
                var url = baseUrl + '/ConfirmListPayment';
                return baseService.postData(url, params);
            };

            this.updateCommission = function (params) {
                var url = baseUrl + '/UpdateCommission';
                return baseService.postData(url, params);
            };

            this.updateHistoryOrder = function (params) {
                var url = baseUrl + '/UpdateHistoryOrder';
                return baseService.postData(url, params);
            };

            this.getListHistoryOrder = function (params) {
                var url = baseUrl + '/GetListHistoryOrder';
                return baseService.getData(url, params);
            };

            this.insertUpdateTransaction = function (params) {
                var url = baseUrl + '/InsertUpdateTransaction';
                return baseService.postData(url, params);
            };

            this.getListUserByDateAndSalePoint = function (params) {
                var url = baseUrl + '/GetListUserByDateAndSalePoint';
                return baseService.getData(url, params);
            };

            this.rewardForUser = function (params) {
                var url = baseUrl + '/RewardForUser';
                return baseService.postData(url, params);
            };

            this.punishUser = function (params) {
                var url = baseUrl + '/PunishUser';
                return baseService.postData(url, params);
            };

            this.saleOfVietlott = function (params) {
                var url = baseUrl + '/SaleOfVietlott';
                return baseService.postData(url, params);
            };

            this.advanceSalary = function (params) {
                var url = baseUrl + '/AdvanceSalary ';
                return baseService.postData(url, params);
            };

            this.getDataForGuestReturn = function (params) {
                var url = baseUrl + '/GetDataForGuestReturn';
                return baseService.getData(url, params);
            };

            this.getListGuestForConfirm = function (params) {
                var url = baseUrl + '/GetListGuestForConfirm';
                return baseService.getData(url, params);
            };

            this.saleOfLoto = function (params) {
                var url = baseUrl + '/SaleOfLoto';
                return baseService.postData(url, params);
            };

            this.getListFeeOfCommission = function (params) {
                var url = baseUrl + '/GetListFeeOfCommission';
                return baseService.getData(url, params);
            };
   
            this.getListTransaction = function (params) {
                var url = baseUrl + '/GetListTransaction';
                return baseService.getData(url, params);
            };

            this.getListPaymentForConfirm = function (params) {
                var url = baseUrl + '/GetListPaymentForConfirm';
                return baseService.getData(url, params);
            };

            this.debtForUser = function (params) {
                var url = baseUrl + '/DebtForUser';
                return baseService.postData(url, params);
            };  

            this.payFundOfUser = function (params) {
                var url = baseUrl + '/PayFundOfUser';
                return baseService.postData(url, params);
            };

            this.getListSalePointOfLeader = function (params) {
                var url = baseUrl + '/GetListSalePointOfLeader';
                return baseService.getData(url, params);
            }; 

            this.updateDateOffOfLeader = function (params) {
                var url = baseUrl + '/UpdateDateOffOfLeader';
                return baseService.postData(url, params);
            };

            this.getListAttendentOfLeader = function (params) {
                var url = baseUrl + '/GetListAttendentOfLeader';
                return baseService.getData(url, params);
            };

            this.updateLeaderAttendent = function (params) {
                var url = baseUrl + '/UpdateLeaderAttendent';
                return baseService.postData(url, params);
            };
            
            this.useUnion = function (params) {
                var url = baseUrl + '/UseUnion';
                return baseService.postData(url, params);
            };

            this.payVietlott = function (params) {
                var url = baseUrl + '/PayVietlott';
                return baseService.postData(url, params);
            };

            this.saleOfVietlottForCheck = function (params) {
                var url = baseUrl + '/SaleOfVietlottForCheck';
                return baseService.postData(url, params);
            };

            this.getListSaleOfVietLottInDate = function (params) {
                var url = baseUrl + '/GetListSaleOfVietLottInDate';
                return baseService.getData(url, params);
            };

            this.getListSaleOfVietLottInMonth = function (params) {
                var url = baseUrl + '/GetListSaleOfVietLottInMonth';
                return baseService.getData(url, params);
            };

            this.getListSaleOfLotoInMonth = function (params) {
                var url = baseUrl + '/GetListSaleOfLotoInMonth';
                return baseService.getData(url, params);
            };

            this.getListFeeOutSiteInMonth = function (params) {
                var url = baseUrl + '/GetListFeeOutSiteInMonth';
                return baseService.getData(url, params);
            };

            this.getListUnionInYear = function (params) {
                var url = baseUrl + '/GetListUnionInYear';
                return baseService.getData(url, params);
            };

            this.getListHistoryOfGuest = function (params) {
                var url = baseUrl + '/GetListHistoryOfGuest';
                return baseService.getData(url, params);
            };

            this.getListPayVietlott = function (params) {
                var url = baseUrl + '/GetListPayVietlott';
                return baseService.getData(url, params);
            };

            this.getListSalePointPercent = function (params) {
                var url = baseUrl + '/GetListSalePointPercent';
                return baseService.getData(url, params);
            };

            this.updatePercent = function (params) {
                var url = baseUrl + '/UpdatePercent';
                return baseService.postData(url, params);
            };

            this.getListLotteryAwardExpected = function (params) {
                var url = baseUrl + '/GetListLotteryAwardExpected';
                return baseService.getData(url, params);
            };
            this.getListOtherFees = function (params) {
                var url = baseUrl + '/GetListOtherFees';
                return baseService.getData(url, params);
            };
            this.getTotalCommisionAndFee = function (params) {
                var url = baseUrl + '/GetTotalCommisionAndFee';
                return baseService.getData(url, params);
            };
            this.updateCommisionAndFee = function (params) {
                var url = baseUrl + '/UpdateCommisionAndFee';
                return baseService.postData(url, params);
            };
            this.deleteStaffInCommissionWining = function (params) {
                var url = baseUrl + '/DeleteStaffInCommissionWining';
                return baseService.postData(url, params);
            };
            this.createSubAgency = function (params) {
                var url = baseUrl + '/CreateSubAgency';
                return baseService.postData(url, params);
            };
            this.getAllStaticFee = function (params) {
                var url = baseUrl + '/GetAllStaticFee';
                return baseService.getData(url, params);
            };

          

        }]);
})(); 