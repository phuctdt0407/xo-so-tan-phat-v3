(function () {
    app.controller('Salepoint.updateStaticFee', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'salepointService', 'activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, salepointService, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.dataFee = [];
            vm.isSaving = false;
            vm.dataFee.fee = vm.fee;
            vm.backupFee = vm.fee;
            vm.Data = {
                SalePointId: vm.model.id,
                SalePointName: vm.model.name,
                Month: moment(vm.month).format("YYYY-MM")
            }
            vm.dataUpdate = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName
            }

            vm.save = function () {
                var feeForUpdate = 0;
                feeForUpdate = vm.dataFee.fee.replace(/,/g, '');
                feeForUpdate = parseInt(feeForUpdate);

                /*if (vm.model.data[0].isUpdate) {
                    vm.Data.Fee = feeForUpdate
                    vm.Data.Number = vm.index
                } else {
                    vm.model.data.forEach(function (item) {
                        if (item.id == vm.index) {
                            vm.Data.ElectronicFee = item.id == 1 ? feeForUpdate : 0
                            vm.Data.WaterFee = item.id == 2 ? feeForUpdate : 0
                            vm.Data.EstateFee = item.id == 3 ? feeForUpdate : 0
                            vm.Data.InternetFee = item.id == 4 ? feeForUpdate : 0
                        }
                    })
                }*/

                vm.Data.Value = feeForUpdate
                vm.Data.StaticFeeTypeId = vm.index

                vm.isSaving = true;
                if (vm.dataFee.fee == vm.backupFee) {
                    notificationService.warning('Không có gì để lưu');
                    vm.isSaving = false;
                } else {
                    vm.dataUpdate.Data = JSON.stringify(vm.Data);
                    activityService.updateStaticFee(vm.dataUpdate).then(function (res) {
                        if (res && res.Id > 0) {
                            notificationService.success(res.Message);
                            setTimeout(function () {
                                vm.isSaving = false;
                                $rootScope.$apply(vm.isSaving);
                                $state.reload()
                            }, 1500)
                        } else {
                            notificationService.warning(res.Message);
                            vm.isSaving = false;
                        }
                    })
                }
            }

            vm.test = function () {
                console.log("vm.dataFee.fee: ", vm.dataFee.fee)
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
