(function () {
    app.service('ddlService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/BaseDDL';

            this.lotteryChannelDDL = function (params) {
                var url = baseUrl + '/LotteryChannelDDL';
                return baseService.getData(url, params);
            };

            this.agencyDDL = function () {
                var url = baseUrl + '/AgencyDDL';
                return baseService.getData(url);
            };

            this.salePointDDL = function () {
                var url = baseUrl + '/SalePointDDL';
                return baseService.getData(url);
            };
            
            this.userByTitleDDL = function (params) {
                var url = baseUrl + '/UserByTitleDDL';
                return baseService.getData(url, params);
            };
            
            this.userTitleDDL = function (params) {
                var url = baseUrl + '/UserTitleDDL';
                return baseService.getData(url, params);
            };

            this.getUserTitleDDL = function () {
                var url = baseUrl + '/GetUserTitleDDL';
                return baseService.getData(url);
            };
            
            this.lotteryTypeDDL = function () {
                var url = baseUrl + '/LotteryTypeDDL';
                return baseService.getData(url);
            };
            
            this.lotteryPriceDDL = function (params) {
                var url = baseUrl + '/LotteryPriceDDL';
                return baseService.getData(url, params);
            };
            
            this.winningTypeDDL = function () {
                var url = baseUrl + '/WinningTypeDDL';
                return baseService.getData(url);
            };

            this.getItemDDL = function () {
                var url = baseUrl + '/GetItemDDL';
                return baseService.getData(url);
            };

            this.getUnitDDL = function () {
                var url = baseUrl + '/GetUnitDDL';
                return baseService.getData(url);
            };

            this.getGuestDDL = function (params) {
                var url = baseUrl + '/GetGuestDDL';
                return baseService.getData(url, params);
            };
            this.getTypeOfItemDDL = function () {
                var url = baseUrl + '/GetTypeOfItemDDL';
                return baseService.getData(url);
            };
            
            this.getTypeNameDDL = function (params) {
                var url = baseUrl + '/GetTypeNameDDL';
                return baseService.getData(url, params);
            };

            this.getUserDDL = function (params) {
                var url = baseUrl + '/GetUserDDL';
                return baseService.getData(url, params);
            };

            this.getCriteriaDDL = function (params) {
                var url = baseUrl + '/GetCriteriaDDL';
                return baseService.getData(url, params);
            };
            this.reportWinningTypeDDL = function () {
                var url = baseUrl + '/ReportWinningTypeDDL';
                return baseService.getData(url);
            };
            this.internByTitleDDL = function (params) {
                var url = baseUrl + '/InternByTitleDDL';
                return baseService.getData(url, params);
            };
            this.subAgencyDDL = function (params) {
                var url = baseUrl + '/SubAgencyDDL';
                return baseService.getData(url, params);
            };
        }]);
})(); 