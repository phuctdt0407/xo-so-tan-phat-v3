(function () {
    app.controller('Report.newDebt', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService', '$uibModal',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.cash = {
                value: 0
            };

            vm.isSaving = false;
            vm.dataSave = [];


            vm.addRequest = function () {
                if (vm.cash.value) {
                    var money = vm.cash.value;
                    money = money.replace(/,/g, '');
                    money = parseInt(money, 10)

                    dataSave = {
                        UserId: vm.data.UserId,
                        PayedDebt: vm.data.PayedDebt,
                        Month: vm.month,
                        SalePointId: vm.data.SalePointId,
                        TotalDebt: money,
                        Flag: true
                    }
                    vm.isSaving = true;
                    activityService.updateDebt(dataSave).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            setTimeout(function () {
                                notificationService.error(res.Message)
                                vm.isSaving = false;
                                $rootScope.$apply(vm.isSaving)
                            }, 1000)
                        }
                    })
                }
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }
        }]);
})();
