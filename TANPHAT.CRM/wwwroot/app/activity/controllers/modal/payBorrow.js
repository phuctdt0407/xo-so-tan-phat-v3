(function () {
    app.controller('Activity.payBorrow', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'userService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, userService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.saveData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                ActionType: 1,
                Data: {
                    UserId: vm.data.UserId,
                    FormPaymentId: 1
                }
            }
            vm.save = function () {
                vm.isSaving = true;
                vm.saveData.Data.Price = vm.saveData.Data.Price.replace(/,/g, '');
                if (!vm.saveData.Data.Price) {
                    notificationService.error("Chưa nhập số tiền trả");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 100)
                } else  if (vm.saveData.Data.Price > vm.data.TotalRemaining) {
                    notificationService.error("Số tiền trả không lớn hơn số tiền còn nợ");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 100)
                } else {
                    vm.saveData.Data = JSON.stringify(vm.saveData.Data)
                    userService.payBorrow(vm.saveData).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                vm.isSaving = false;
                                $state.go($state.current, { tab: 2 }, { reload: true, notify: true });
                                //$state.reload();
                            }, 100)

                        } else {
                            notificationService.warning(res.Message);
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
