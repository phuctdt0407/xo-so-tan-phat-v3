(function () {
    app.controller('Report.updateReturnMoney', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;

            console.log("data: ", vm.data)
            console.log("shiftId: ", vm.shiftId)


            vm.save = function () {
                if (vm.shiftId == 1 && vm.money == vm.data.shift1 || vm.shiftId == 2 && vm.money == vm.data.shift2) {
                    notificationService.warning("Dữ liệu không thay đổi!");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else {
                    if (!vm.money) {
                        notificationService.error("Dữ liệu không được trống!");
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 1000)
                    } else {
                       var dataSave = {
                            ReturnMoneyId: vm.shiftId==1?vm.data.shift1Id:vm.data.shift2Id,
                            ReturnMoney: vm.money
                        }
                        vm.isSaving = true;
                        reportService.updateReturnMoney(dataSave).then(function (res) {
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
