(function () {
    app.controller('Activity.requestNewOwnDebt', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal', '$uibModalInstance','userService',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN, $uibModal, $uibModalInstance, userService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false

            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                ActionType: 1,
                Data: {
                    UserId: $rootScope.sessionInfo.UserId,
                    DataForConfirm: []
                }
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }
            vm.addRequest = function () {
                if (!vm.cash.value && !vm.transfer) {
                    notificationService.warning('Chưa nhập số tiền')
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 100)
                } else {
                    if (vm.cash.value) {
                        vm.cash.value = vm.cash.value.replace(/,/g, '');
                        vm.cash.value = parseInt(vm.cash.value, 10)
                        vm.saving.Data.DataForConfirm.push({
                            FormPaymentId: 1,
                            Price: vm.cash.value
                        })
                    }
                    if (vm.transfer) {
                        vm.saving.Data.DataForConfirm.push({
                            FormPaymentId: 2,
                            Price: vm.transfer
                        })
                    }
                    vm.saving.Data = JSON.stringify(vm.saving.Data)
                    userService.insertUpdateBorrow(vm.saving).then(function (res) {
                        if (res && res.Id > 0) {
                            notificationService.success(res.Message)
                            setTimeout(function () {
                                vm.isSaving = false
                                $rootScope.$apply(vm.isSaving)
                                $state.reload()
                            }, 100)
                        } else {
                            notificationService.warning(res.Message)
                            setTimeout(function () {
                                vm.isSaving = false
                                $rootScope.$apply(vm.isSaving)
                            }, 100)
                        }
                    })
                }
            }

        }]);
})();