(function () {
    app.controller('Salepoint.addNewGuest', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'salepointService', 'notificationService', 'dayOfWeekVN', '$uibModalInstance',
        function ($scope, $rootScope, $state, viewModel, sortIcon, salepointService, notificationService, dayOfWeekVN, $uibModalInstance) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.saving = {
                ActionType: 1,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName
            }

            vm.listPriceNormal = vm.listPrice.filter(x => x.LotteryTypeIds.includes('1') && x.LotteryPriceId != 6)
            vm.listPriceDup = vm.listPrice.filter(x => x.LotteryTypeIds.includes('2') && x.LotteryPriceId != 6)
            vm.listPriceScratchCard = vm.listPrice.filter(x => x.LotteryTypeIds.includes('3') && x.LotteryPriceId != 6)
            console.log("lisst", vm.listPrice)
            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.findDebtGuest = function () {
                var temp = vm.listDebtGuest.find(x => x.Phone == vm.saveData.Phone)
                if (temp) {
                    vm.saveData = temp;
                    vm.saveData.ScratchPriceId = null
                    vm.saveData.WholesalePriceId = null
                    vm.saving.ActionType = 2
                }
            }
            vm.formatCurrency = function () {
                if (vm.saveData.WholesalePriceId) {
                    vm.saveData.WholesalePriceId = vm.saveData.WholesalePriceId.toLocaleString();
                
                }
            };
            vm.formatCurrency2 = function () {
                if (vm.saveData.ScratchPriceId) {
                    vm.saveData.ScratchPriceId = vm.saveData.ScratchPriceId.toLocaleString();

                }
            };
           
            vm.save = function () {
             
                vm.isSaving = true;
                var check = true
                if (!vm.saveData.FullName) {
                    check = false
                    notificationService.error("Chưa nhập tên khách hàng");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (!vm.saveData.Phone) {
                    check = false
                    notificationService.error("Chưa nhập số điện thoại khách hàng");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (!vm.saveData.SalePointId) {
                    check = false
                    notificationService.error("Chưa chọn điểm bán cho khách hàng");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (vm.typeGuest == 1) {
                    if (!vm.saveData.WholesalePriceId) {
                        check = false
                        notificationService.error("Chưa chọn giá vé thường");
                        console.log("WholesalePriceId",vm.saveData.WholesalePriceId)
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 1000)
                    } else if (!vm.saveData.ScratchPriceId) {
                        check = false
                        notificationService.error("Chưa chọn giá vé cào");
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 1000)
                    }
                }
                if (check == true) {
                    vm.saving.Data = JSON.stringify({
                        GuestId: vm.saveData.GuestId,
                        FullName: vm.saveData.FullName,
                        Phone: vm.saveData.Phone,
                        SalePointId: vm.saveData.SalePointId,
                        WholesalePriceId: vm.saveData.WholesalePriceId.replaceAll(",", ''),
                        ScratchPriceId: vm.saveData.ScratchPriceId.replaceAll(",", '')
                    })
                    console.log(vm.saving.Data)
                    salepointService.updateOrCreateGuest(vm.saving).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            setTimeout(function () {
                                notificationService.error(res.Message);
                                vm.isSaving = false;
                                $rootScope.$apply(vm.isSaving);
                            }, 1000)
                        }
                    })
                }
            }

        }]);
})();