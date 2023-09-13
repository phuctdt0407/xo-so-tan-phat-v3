(function () {
    app.controller('Report.updateDebtInMonth', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService', 'userService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, userService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.dataSave = [];
            vm.dataSave.money = vm.money;
            console.log("vm.data: ", vm.data)
            console.log("vm.month: ", vm.month)


            vm.save = function () {
                if (vm.dataSave.money) {
                    vm.dataSave.money = vm.dataSave.money.replace(/,/g, '');
                    vm.dataSave.money = parseInt(vm.dataSave.money, 10)
                }
                if (vm.dataSave.money == vm.data.Data.TotalFirst) {
                    notificationService.warning("Dữ liệu không thay đổi!");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else {
                    if (!vm.dataSave.money) {
                        notificationService.error("Dữ liệu không được trống!");
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 1000)
                    } else {

                        dataSave = {
                            UserId: vm.data.Data.UserId,
                            PayedDebt: vm.dataSave.money,
                            Month: vm.month,
                            SalePointId: vm.data.Data.SalePointId,
                            TotalDebt: vm.data.Data.RemainDebt,
                            Flag: false
                        }
                        vm.isSaving = true;
                        activityService.updateDebt (dataSave).then(function (res) {
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
            }

            vm.close = function () {
                $uibModalInstance.close()
            }
        }]);
})();
