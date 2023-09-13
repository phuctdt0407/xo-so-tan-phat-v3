(function () {
    app.controller('Report.confirmItemDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.input = 0;
            vm.index = 0;

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            /*vm.total = function (value1, value2) {
                vm.sum += value1 * value2;
            }*/


            vm.sum = 0;
            vm.getBootBox = function (confirm) {
                var message = ''
                if (confirm) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> chuyển/nhận công cụ?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> chuyển/nhận công cụ?'
                };

                var dialog = bootbox.confirm({
                    message,
                    buttons: {
                        confirm: {
                            label: 'Đồng ý',
                            className: 'btn-success',
                        },
                        cancel: {
                            label: 'Huỷ',
                            className: 'btn-secondary'
                        }
                    },
                    callback: function (res) {
                        // setTimeout(function () {
                        //     $('.modal-lg').css('display', 'block');
                        // }, 500);


                        if (res) {
                            vm.update.ConfirmTypeId = confirm ? 2 : 3;
                            vm.isSaving = true;
                            vm.save(confirm);
                        }

                    }
                });
                
            }
           

            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                TypeAction: 1,
                ItemConfirmLogId: vm.model.ItemConfirmLogId,
                /*ConfirmType: */
            };
            vm.save = function () {
                vm.temp = []
                vm.model.NewData.forEach(function (item) {
                    vm.tmp = {
                        ItemId: item.ItemId,
                        Quantity: item.Quantity,
                        SalePointId: item.SalePointId,
                        Month: item.Month,
                    }
                    vm.temp.push(vm.tmp)
                })
                vm.update.Data = JSON.stringify(vm.temp);
                salepointService.updateItemInSalePoint(vm.update).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            $state.reload();
                            notificationService.success(res.Message);
                            $uibModalInstance.dismiss();
                           
                            vm.isSaving = false;
                        }, 0)

                    } else {
                        vm.isSaving = false;
                    }
                })

            }



        }]);
})();
