(function () {
    app.controller('Report.updateItem', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.listData = angular.copy(vm.model.data)

            vm.input = 0;

            vm.ImportBK = angular.copy(vm.model.Import)
           
            vm.index = 0;
       
            vm.init = function () {
                vm.listData.forEach(function (item) {
                    item.input = 0;
                    try {
                        var temp = item.SalePoint.find(x => x.SalePointId == vm.model.Id)
                        item.TotalRemainingInSalePoint = temp.TotalRemaining > 0 ? temp.TotalRemaining : 0
                        item.AVGPriceInSalePoint = temp.AVGPrice ? temp.AVGPrice : item.AVGPrice 
                    } catch (err) {
                        item.TotalRemainingInSalePoint = 0
                        item.AVGPriceInSalePoint = item.AVGPrice
                    }
                    item.TotalRemainingBK = angular.copy(item.TotalRemaining)
                    item.TotalRemainingInSalePointBK = angular.copy(item.TotalRemainingInSalePoint)
                })
            }

            vm.init();

            vm.cancel = function () {
                $uibModalInstance.close()
            }
            
            vm.sum = 0;
          
            vm.ChangeValueInput = function (item, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    item.input = 0;
                    if (vm.typeOfTransfer == 1||vm.typeOfTransfer == 4) {
                        item.TotalRemaining += oldValue;
                    } else {
                        item.TotalRemainingInSalePoint +=oldValue
                    }
                } else {
                    if (vm.typeOfTransfer == 1||vm.typeOfTransfer == 4) {
                        if (item.TotalRemaining - (newValue - oldValue) >= 0) {
                            item.TotalRemaining = item.TotalRemaining - (newValue - oldValue);
                        } else {
                            item.input = oldValue;
                        }
                    } else {
                        if (item.TotalRemainingInSalePoint - (newValue - oldValue) >= 0) {
                            item.TotalRemainingInSalePoint = item.TotalRemainingInSalePoint - (newValue - oldValue);
                        } else {
                            item.input = oldValue;
                        }
                    }
                    
                }
                vm.getSum()
            }

            vm.getSum = function () {
                vm.sum = 0
                vm.listData.forEach(function (ele) {
                    if (vm.typeOfTransfer == 1) {
                        ele.TotalRemainingInSalePoint = ele.TotalRemainingInSalePointBK + ele.input
                        vm.sum += ele.AVGPrice * ele.input
                    } else {
                        ele.TotalRemaining = ele.TotalRemainingBK + ele.input
                        vm.sum += ele.AVGPriceInSalePoint * ele.input
                    }
                    
                })
            }

            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                TypeAction: vm.typeOfTransfer,
            };

            
            vm.save = function () {
                vm.IsCheck = true;
                vm.temp=[]
                vm.listData.forEach(function (item) {
                    vm.tmp = {
                        ItemId: item.ItemId,
                        Quantity: item.input,
                        SalePointId: vm.model.Id,
                        SalePointName: vm.model.Name,
                        TypeOfItemId: item.TypeOfItemId,
                        Month: vm.month
                    }
                    if (vm.tmp.Quantity > 0) {
                        vm.temp.push(vm.tmp)
                    }
                })
                /*if (vm.input && vm.input != 0) {
                    vm.isSaving =true*/
                    
                /*}*/
                if (!vm.temp || vm.temp.length == 0) {
                    vm.isSaving = false;
                    setTimeout(function () {
                        notificationService.warning('Không có dữ liệu!');
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else {
                    vm.update.Data = JSON.stringify(vm.temp);
                    console.log("data",vm.update)
                    salepointService.updateItemInSalePoint(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            vm.isSaving = false;
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                $rootScope.$apply(vm.isSaving)
                            }, 200)

                        } else {
                            vm.isSaving = true;
                        }
                    })
                }
                
            }



        }]);
})();
