(function () {
    app.controller('Salepoint.updateCommissionWinning', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService, salepointService) {
            var vm = angular.extend(this, viewModel);
          vm.commission = angular.copy(vm.model)
            vm.isSaving = false;
            vm.save = function () {
                
                
                if (vm.commission.Fee != null && vm.commission.TotalCommision != null && !vm.isSaving) {
                    vm.isSaving = true;
                    salepointService.updateCommisionAndFee({
                        CommisionId:vm.commission.CommissionId,
                        Commision:vm.commission.TotalCommision,
                        Date:moment(vm.commission.Date,"DD-MM-YYYY").format('YYYY-MM-DD'),
                        Fee:vm.commission.Fee
                    }).then(function (res) {
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

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();