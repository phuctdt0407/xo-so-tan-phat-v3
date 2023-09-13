(function () {
    app.controller('Activity.purchaseHistory', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'salepointService', 'notificationService', 'dayOfWeekVN', '$uibModal', '$uibModalInstance',
        function ($scope, $rootScope, $state, viewModel, sortIcon, salepointService, notificationService, dayOfWeekVN, $uibModal, $uibModalInstance) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;

            vm.historyLog.forEach(function (item) {
                item.Detail = []
                item.Data = item.Data ? JSON.parse(item.Data) : null
                if (item.Data) {
                    item.Data.LastData = item.Data.LastData ? JSON.parse(item.Data.LastData) : null
                }

                if (!item.Data.SalePointLogData || item.Data.SalePointLogData.length == 0) {
                    var temp = {}
                    try {
                        temp.Cash = item.Data.GuestActionData.find(x => x.FormPaymentId == 1 && x.GuestActionTypeId == 2).TotalPrice
                    } catch (err) {
                        temp.Cash = 0
                    }
                    try {
                        temp.Transfer = item.Data.GuestActionData.find(x => x.FormPaymentId == 2 && x.GuestActionTypeId == 2).TotalPrice
                    } catch (err) {
                        temp.Transfer = 0
                    }
                    try {
                        temp.PayForGuest = item.Data.GuestActionData.find(x => x.FormPaymentId == 1 && x.GuestActionTypeId == 3).TotalPrice
                    } catch (err) {
                        temp.PayForGuest = 0
                    }
                    item.Detail.push(temp)
                } else {
                    item.Data.SalePointLogData.forEach(function (ele) {
                        try {
                            ele.Cash = item.Data.GuestActionData.find(x => x.FormPaymentId == 1 && x.GuestActionTypeId == 2).TotalPrice
                        } catch (err) {
                            ele.Cash = 0
                        }
                        try {
                            ele.Transfer = item.Data.GuestActionData.find(x => x.FormPaymentId == 2 && x.GuestActionTypeId == 2).TotalPrice
                        } catch (err) {
                            ele.Transfer = 0
                        }
                        try {
                            ele.PayForGuest = item.Data.GuestActionData.find(x => x.FormPaymentId == 1 && x.GuestActionTypeId == 3).TotalPrice
                        } catch (err) {
                            ele.PayForGuest = 0
                        }
                        item.Detail.push(ele)
                    })
                    
                }

            })


            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                Data:[]
            }

            vm.save = function () {
            }
        }]);
})();