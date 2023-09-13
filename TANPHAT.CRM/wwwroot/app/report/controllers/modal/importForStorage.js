(function () {
    app.controller('Report.importForStorage', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService','typeOfItem',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, typeOfItem) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.listData = angular.copy(vm.model)
            vm.listData.TotalRemainingBK = angular.copy(vm.listData.TotalRemaining)
            vm.listData.ImportBK = angular.copy(vm.listData.Import)

            vm.CurrTypeOfItem = vm.typeOfItem.filter(x => x.Id == vm.typeOfItemId)[0];

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.ChangeValueInput = function (item) {
                if (item) {
                    vm.input = item;
                    vm.sum = item * parseInt(vm.listData.Price.replace(/,/g, ''))
                } else {
                    vm.sum = vm.input * parseInt(vm.listData.Price.replace(/,/g, ''))
                }
                //vm.listData.TotalRemaining = vm.listData.TotalRemainingBK + vm.input
                //vm.listData.Import = vm.listData.ImportBK + vm.input
            }

            vm.ChangeValueQuantity = function (item) {
                if (item) {
                    vm.input = item;
                    vm.sum = item * parseInt(vm.listData.Price.replace(/,/g, ''))
                } else {
                    vm.sum = vm.input * parseInt(vm.listData.Price.replace(/,/g, ''))
                }
                vm.listData.TotalRemaining = vm.listData.TotalRemainingBK + vm.input
                vm.listData.Import = vm.listData.ImportBK + vm.input
            }


            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                TypeAction: 1,
            };

            vm.save = function () {
                vm.isSaving = true;
                if (vm.input && vm.input>0 && vm.listData.Price && parseInt(vm.listData.Price.replace(/,/g,'')) > 0) {
                    if (vm.input && vm.input != 0) {
                        var temp = [{
                            ItemId: vm.model.ItemId,
                            SalePointId: 0,
                            Quantity: vm.input,
                            ItemName: vm.model.ItemName,
                            UnitName: vm.model.UnitName,
                            Price: parseInt(vm.listData.Price.replace(/,/g, '')),
                            SalePointName: 'Kho',
                            TypeOfItemId: vm.CurrTypeOfItem.Id,
                            Month: vm.month
                        }]
                    }

                    vm.update.Data = JSON.stringify(temp);
                    salepointService.updateItemInSalePoint(vm.update).then(function (res) {
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
                else {
                    notificationService.warning("Chưa nhập đơn giá");
                    vm.isSaving = false;
                }
            }
        }]);
})();
