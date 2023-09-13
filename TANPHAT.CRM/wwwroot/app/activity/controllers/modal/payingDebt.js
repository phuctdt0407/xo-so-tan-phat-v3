(function () {
    app.controller('Activity.payingDebt', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;

            vm.userInfo = {
                UserId: $rootScope.sessionInfo.UserId
            };
            vm.saveData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                SalePointId: vm.data.SalePointId,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                CustomerName: "",
                Note: "",
            }
            vm.save = function () {
                vm.isSaving = true;
                if (!vm.saveData.CustomerName) {
                    notificationService.error("Chưa nhập tên khách trả");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (!vm.saveData.Amount || parseInt(vm.saveData.Amount) === 0) {
                    notificationService.error("Số tiền không hợp lệ");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else {
                    vm.saveData.Amount = vm.saveData.Amount.replace(/[^0-9]/g, '');
                    activityService.insertRepayment(vm.saveData).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            vm.isSaving = false;
                        }
                    })
                }
            };
            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
