(function () {
    app.controller('System.updateSalePoint', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService','salepointService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService, salepointService) {
            var vm = angular.extend(this, viewModel);

            vm.update = angular.extend(vm.salePointInfo,
                {
                    ActionBy: $rootScope.sessionInfo.UserId,
                    ActionByName: $rootScope.sessionInfo.FullName,
                    SalePointId: vm.salePointInfo.Id
                }
            )
            vm.save = function () {
                if ($scope.formCreate.$valid && !vm.isSaving) {
                    vm.isSaving = true;
                    var temp = {
                        FullAddress: vm.update.FullAddress,
                        IsActive: vm.update.IsActive,
                        SalePointName: vm.update.Name,
                        Note: vm.update.Note,
                    }
                    vm.update.Data = JSON.stringify(temp);
                    salepointService.updateSalePoint(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            vm.isSaving = true;
                        }
                    })
                }

            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();