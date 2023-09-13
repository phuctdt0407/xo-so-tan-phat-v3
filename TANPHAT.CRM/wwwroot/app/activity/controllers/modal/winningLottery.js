(function () {
    app.controller('Activity.winningLottery', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.userInfo = {
                UserId: $rootScope.sessionInfo.UserId
            };
            vm.saveData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                SalePointId: vm.data.SalePointId,
            }
            vm.errorMsg = ""
            vm.save = function () {
                vm.isSaving = true;
                if (!vm.saveData.WinningTypeId) {
                    notificationService.error("Chưa chọn loại trả thưởng")
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (vm.selectedType.HasSalePoint && !vm.saveData.FromSalePointId) {
                    notificationService.error("Chưa chọn cửa hàng bán")
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (vm.selectedType.HasChannel && !vm.saveData.LotteryChannelId) {
                    notificationService.error("Chưa chọn đài xổ số")
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (!vm.saveData.WinningPrice || vm.saveData.WinningPrice == 0 || vm.saveData.WinningPrice == '') {
                    notificationService.error("Chưa nhập số tiền trả")
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (vm.selectedType.HasFourNumber && vm.saveData.Quantity==0 ) {
                    notificationService.error("Chưa nhập số lượng vé")
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                }
                else{
                    vm.saveData.WinningPrice = vm.saveData.WinningPrice.replace(/[^0-9]/g, '');
                    activityService.insertWinningLottery(vm.saveData).then(function (res) {
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

            vm.onSelected = function (model) {
                if (model) {
                    vm.saveData.WinningPrice = angular.copy(model.WinningPrize).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                    vm.selectedType = model;
                    vm.saveData.Quantity = 1;
                } else {
                    vm.saveData.WinningPrize = 0;
                    vm.saveData.Quantity = 1;
                    vm.selectedType = {
                        CanChangePrice: false,
                        HasChannel: false,
                        HasFourNumber: false,
                        HasSalePoint: false,
                    }
                }
            }
            vm.onSelected();

            vm.OnChangeQuantity = function (model) {
                if (model) {
                    vm.saveData.WinningPrice = (model * vm.selectedType.WinningPrize).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
                } else {
                    model = 0;
                    vm.saveData.WinningPrice = 0;
                }
            }

            $(function () {
                $("input[name='numonly']").on('input', function (e) {
                    $(this).val($(this).val().replace(/[^0-9]/g, ''));
                });
            });

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
