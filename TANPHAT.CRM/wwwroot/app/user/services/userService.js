(function () {
    app.service('userService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/User';

            this.distributeShift = function (params) {
                var url = baseUrl + '/DistributeShift';
                return baseService.postData(url, params);
            };
            this.getDataDistributeShift = function (params) {
                var url = baseUrl + '/GetDataDistributeShift';
                return baseService.getData(url, params);
            };
            this.getHistoryScratchCardFullLog = function (params) {
                var url = baseUrl + '/GetHistoryScratchCardFullLog';
                return baseService.getData(url, params);
            }; 
            this.getHistoryScratchCardLog = function (params) {
                var url = baseUrl + '/GetHistoryScratchCardLog';
                return baseService.getData(url, params);
            }; 
            this.updateShift = function (params) {
                var url = baseUrl + '/UpdateShift';
                return baseService.postData(url, params);
            };
            this.updateTotalFirst = function (params) {
                var url = baseUrl + '/UpdateTotalFirst';
               
                return baseService.postData(url, params);
            };
            this.getListUser = function (params) {
          
                var url = baseUrl + '/GetListUser';
                return baseService.getData(url, params);
            };
            this.getSalePointManage = function (params) {
                var url = baseUrl + '/GetSalePointManage';
                return baseService.getData(url, params);
            };
            this.getPermissionByTitle = function (params) {
                var url = baseUrl + '/GetPermissionByTitle';
                return baseService.getData(url, params);
            };
            this.updatePermissionRole = function (params) {
                var url = baseUrl + '/UpdatePermissionRole';
                return baseService.postData(url, params);
            };
            this.updateTransaction = function (params) {
                var url = baseUrl + '/UpdateTransaction';
                return baseService.postData(url, params);
            };
            this.distributeShiftMonth = function (params) {
                var url = baseUrl + '/DistributeShiftMonth';
                return baseService.postData(url, params);
            }; 
            this.getDataDistributeShiftMonth = function (params) {
                var url = baseUrl + '/GetDataDistributeShiftMonth';
                return baseService.getData(url, params);
            };
            this.getAllShiftInMonthOfOneUser = function (params) {
                var url = baseUrl + '/GetAllShiftInMonthOfOneUser';
                return baseService.getData(url, params);
            };
            this.createUser = function (params) {
                var url = baseUrl + '/CreateUser';
                return baseService.postData(url, params);
            };

            this.updateUserInfo = function (params) {
                var url = baseUrl + '/UpdateUserInfo';
                return baseService.postData(url, params);
            };
            this.getListEventDate = function (params) {
                var url = baseUrl + '/GetListEventDate';
                return baseService.getData(url, params);
            };
            this.updateListEventDate = function (params) {
                var url = baseUrl + '/UpdateListEventDate';
                return baseService.postData(url, params);
            };
            this.getListTarget = function (params) {
                var url = baseUrl + '/GetListTarget';
                return baseService.getData(url, params);
            };
            this.updateListTarget = function (params) {
                var url = baseUrl + '/UpdateListTarget';
                return baseService.postData(url, params);
            };
            this.updateListKPI = function (params) {
                var url = baseUrl + '/UpdateListKPI';
                return baseService.postData(url, params);
            }; 
            this.updateScratchcardFullLog = function (params) {
                var url = baseUrl + '/UpdateScratchcardFullLog';
                return baseService.postData(url, params);
            };
            this.updateScratchcardLog = function (params) {
                var url = baseUrl + '/UpdateScratchcardLog';
                return baseService.postData(url, params);
            };
            this.getListKPIOfUser = function (params) {
                var url = baseUrl + '/GetListKPIOfUser';
                return baseService.getData(url, params);
            };
            this.getListSalePointInDate = function (params) {
                var url = baseUrl + '/GetListSalePointInDate';
                return baseService.getData(url, params);
            };
            this.getListAverageKPI = function (params) {
                var url = baseUrl + '/GetListAverageKPI';
                return baseService.getData(url, params);
            };
            this.getListSalary = function (params) {
                var url = baseUrl + '/GetListSalary';
                return baseService.getData(url, params);
            };
            this.getListOffOfLeader = function (params) {
                var url = baseUrl + '/GetListOffOfLeader';
                return baseService.getData(url, params);
            };
            this.getListTargetMaster = function (params) {
                var url = baseUrl + '/GetListTargetMaster';
                return baseService.getData(url, params);
            };
            this.confirmSalary = function (params) {
                var url = baseUrl + '/ConfirmSalary';
                return baseService.postData(url, params);
            };
            this.getListFundInYear = function (params) {
                var url = baseUrl + '/GetListFundInYear';
                return baseService.getData(url, params);
            };
            this.insertUpdateBorrow = function (params) {
                var url = baseUrl + '/InsertUpdateBorrow';
                return baseService.postData(url, params);
            };
            this.getListBorrowForConfirm = function (params) {
                var url = baseUrl + '/GetListBorrowForConfirm';
                return baseService.getData(url, params);
            };
            this.payBorrow = function (params) {
                var url = baseUrl + '/PayBorrow';
                return baseService.postData(url, params);
            };
            this.getListBorrowInMonth = function (params) {
                var url = baseUrl + '/GetListBorrowInMonth';
                return baseService.getData(url, params);
            };
            this.createManager = function (params) {
                var url = baseUrl + '/CreateManager';
                return baseService.postData(url, params);
            };
            this.getShiftDistributeOfIntern = function (params) {
                var url = baseUrl + '/GetShiftDistributeOfIntern';
                return baseService.getData(url, params);
            };
            this.updateShiftDistributeForIntern = function (params) {
                var url = baseUrl + '/UpdateShiftDistributeForIntern';
                return baseService.postData(url, params);
            };
            this.updateActiveStatusForUser = function (params) {
                var url = baseUrl + '/UpdateActiveStatusForUser';
                return baseService.postData(url, params);
            };
            this.deleteDistributeForIntern = function (params) {
                var url = baseUrl + '/DeleteDistributeForIntern';
                return baseService.postData(url, params);
            };
            this.UpdateListTarget = function (params) {
                var url = baseUrl + '/UpdateListTarget';
                return baseService.postData(url, params);
            };
        }]);
})(); 