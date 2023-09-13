(function () {
    app.controller('User.extraPaymentInfo', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService', 'extraPaymentType', 'ddlService', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService, extraPaymentType, ddlService, salepointService) {
            var vm = angular.extend(this, viewModel);

            vm.isSaving = false;

            vm.extraPaymentType = angular.copy(extraPaymentType);

            vm.updateData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                ActionType: 3,
                Data: JSON.stringify([{ TransactionId: vm.modelInfo.TransactionId}])
            }

            vm.save = function () {
                vm.isSaving = true;
                salepointService.insertUpdateTransaction(vm.updateData).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            notificationService.success(res.Message);
                            $uibModalInstance.dismiss({ TransactionId: vm.modelInfo.TransactionId });
                            vm.isSaving = false;
                        }, 1000)

                    } else {
                        vm.isSaving = false;
                    }
                })
            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();