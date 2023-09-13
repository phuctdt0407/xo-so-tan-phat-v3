(function () {
    app.controller('Report.payFundOfUser', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService', '$uibModal',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, $uibModal ) {
            var vm = angular.extend(this, viewModel);
            vm.showForm = false
            vm.isSaving = false

            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                ActionType: 1,
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.showFormPayFund = function () {
                vm.maxPay = angular.copy(vm.data.TotalPriceRemain)
                vm.showForm = true
            }
            vm.closeForm = function () {
                vm.showForm = false
            }
           
            vm.getBootBox = function (item, index) {
                var message = ''
                if (item) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa trả thưởng?'
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
                        setTimeout(function () {
                            $('.modal-lg').css('display', 'block');
                        }, 500);

                        if (res) {
                            vm.deleteRow(item, index);
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').removeClass("modal-body")
                        $('.modal-lg').css('display', 'none')
                    }, 0);
                });

            }

            vm.updateData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                SalePointId: vm.data.SalePointId,
                UserId: vm.data.UserId 
            };

            vm.payFund = function () {
                vm.isSaving = true
                if (!vm.updateData.Price) {
                    notificationService.warning('Bạn chưa nhập số tiền trả thưởng!')
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else if (vm.updateData.Price > vm.data.TotalPriceRemain) {
                    notificationService.warning('Không thể trả thưởng lớn hơn số tiền thưởng còn lại!')
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else {
                    vm.showForm = false
                    vm.updateData.Date = moment().format('YYYY-MM-DD'),
                    vm.saving.ActionType = 1
                    vm.saving.Data = []
                    vm.saving.Data.push(vm.updateData)
                    vm.saving.Data = JSON.stringify(vm.saving.Data)
                    salepointService.payFundOfUser(vm.saving).then(function (res) {
                        if (res && res.Id > 0) {
                            notificationService.success(res.Message)
                            vm.data.TotalPriceRemain -= vm.updateData.Price
                            if (!vm.data.ListDataReturn) {
                                vm.data.ListDataReturn = []
                                vm.data.ListDataReturn.push({
                                    Date: moment().format('YYYY-MM-DD'),
                                    Note: vm.updateData.Note,
                                    Price: vm.updateData.Price,
                                    TransactionId: res.Id,
                                })
                            } else {
                                vm.data.ListDataReturn.push({
                                    Date: moment().format('YYYY-MM-DD'),
                                    Note: vm.updateData.Note,
                                    Price: vm.updateData.Price,
                                    TransactionId: res.Id,
                                })
                            }
                            setTimeout(function () {
                                vm.isSaving = false
                                vm.updateData.Price = null
                                vm.updateData.Note = null
                                $rootScope.$apply(vm.data.ListDataReturn, vm.isSaving)
                            }, 200)
                        } else {
                            notificationService.warning(res.Message)
                            setTimeout(function () {
                                vm.isSaving = false
                                $rootScope.$apply(vm.isSaving)
                            }, 200)
                        }
                    })
                }
            }

            vm.deleteRow = function (item, index) {
                vm.isSaving = true
                vm.updateData.Date = item.Date,
                vm.updateData.TransactionId = item.TransactionId,
                vm.updateData.Price = item.Price,
                vm.updateData.Note = item.Note
                vm.saving.ActionType = 3
                vm.saving.Data = []
                vm.saving.Data.push(vm.updateData)
                vm.saving.Data = JSON.stringify(vm.saving.Data)
                salepointService.payFundOfUser(vm.saving).then(function (res) {
                    if (res && res.Id > 0) {
                        notificationService.success(res.Message)
                        vm.data.TotalPriceRemain += vm.updateData.Price
                        vm.data.ListDataReturn.splice(index, 1)
                        setTimeout(function () {
                            vm.isSaving = false
                            vm.updateData.Price = null
                            vm.updateData.Note = null
                            $rootScope.$apply(vm.data.ListDataReturn, vm.isSaving)
                        }, 200)
                    } else {
                        notificationService.warning(res.Message)
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.isSaving)
                        }, 200)
                    }
                })
            }
        }]);
})();
