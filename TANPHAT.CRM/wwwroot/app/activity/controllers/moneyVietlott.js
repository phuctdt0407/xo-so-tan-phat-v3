(function () {
    app.controller('Activity.moneyVietlott', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal', 'userService', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN, $uibModal, userService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false
            vm.saving = {
                ActionType: 1,
                ActionBy: $rootScope.sessionInfo.UsserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                Data: []
            }
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';
            if (vm.listSalePoint) {
                vm.listSalePoint.unshift({
                    Id: 0,
                    Name: "Tất cả"
                })
            }
            vm.salepointId = 0
            vm.params.date = moment(vm.params.date, formatDate).format('DD-MM-YYYY');
            vm.listData = angular.copy(vm.listPayVietlott)

            vm.init = function () {
                vm.listData.forEach(function (item) {
                    item.ListHistory = item.ListHistory ? JSON.parse(item.ListHistory) : []
                })
            }
            
            vm.init()
            vm.tab = 1

            vm.changeTab = function (tabId) {
                vm.tab = tabId
            }

            vm.loadData = function () {
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }

            vm.save = function () {
                vm.isSaving = true
                if (!vm.saveData.Date) {
                    vm.isSaving = false
                    notificationService.error('Chưa chọn ngày!')
                } else  if (!vm.saveData.SalePointId) {
                    vm.isSaving = false
                    notificationService.error('Chưa chọn điểm bán!')
                } else  if (!vm.saveData.Price) {
                    vm.isSaving = false
                    notificationService.error('Chưa nhập số tiền nạp!')
                } else {
                    vm.saveData.Date = moment(vm.saveData.Date, "DD-MM-YYYY").format("YYYY-MM-DD")
                    vm.isSaving = false
                    vm.saving.Data.push(vm.saveData)
                    vm.saving.Data = JSON.stringify(vm.saving.Data)
                    salepointService.payVietlott(vm.saving).then(function (res) {
                        if (res && res.Id > 0) {
                            notificationService.success(res.Message)
                            setTimeout(function () {
                                $rootScope.$apply(vm.isSaving)
                            }, 200)
                            vm.params.month = moment().format("YYYY-MM")
                            $state.go($state.current, vm.params, { reload: true, notify: true });
                        } else {
                            notificationService.warning(res.Message)
                            setTimeout(function () {
                                $rootScope.$apply(vm.isSaving)
                            }, 200)
                        }
                    })
                }
            }

            vm.filterbySalePoint = () => {
                if (vm.salepointId == 0) {
                    vm.listData = angular.copy(vm.listPayVietlott)
                    vm.listData = vm.listData.filter(x => x.SalePointId != 0)
                } else {
                    vm.listData = angular.copy(vm.listPayVietlott)
                    vm.listData = vm.listData.filter(x => x.SalePointId == vm.salepointId)
                }
                vm.listData.forEach(function (item) {
                    item.ListHistory = item.ListHistory ? JSON.parse(item.ListHistory) : []
                })
            }

            vm.getBootBox = function (model) {
                var message = ''
                if (confirm) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa?'
                } else {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa?'
                };

                var dialog = bootbox.confirm({
                    message,
                    size: "small",
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
                            vm.deleteRow(model);
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').css('height', '')
                        $('.modal-lg').css('display', 'none')
                    }, 0);
                });
            }

            vm.getTotalAmount = function (listData, salePointId) {
                var totalAmount = 0;
                listData.forEach(function (item) {
                    if (item.SalePointId === salePointId && item.ListHistory) {
                        item.ListHistory.forEach(function (ele) {
                            totalAmount += ele.TotalPrice;
                        });
                    }
                });
                return totalAmount;
            };
            console.log("vm.getTotalAmount ", vm.getTotalAmount);
            vm.deleteRow = function (model) {
                vm.saveData = {
                    Date: model.Date,
                    TransactionId : model.TransactionId,
                    Note: model.Note,
                    Price: model.TotalPrice,
                    SalePointId: model.SalePointId,
                }
                vm.saving.ActionType = 3
                vm.saving.Data.push(vm.saveData)
                vm.saving.Data = JSON.stringify(vm.saving.Data)
                salepointService.payVietlott(vm.saving).then(function (res) {
                    if (res && res.Id > 0) {
                        notificationService.success(res.Message)
                        setTimeout(function () {
                            $rootScope.$apply(vm.isSaving)
                        }, 200)
                        $state.reload();
                    } else {
                        notificationService.warning(res.Message)
                        setTimeout(function () {
                            $rootScope.$apply(vm.isSaving)
                        }, 200)
                    }
                })
            }

        }]);
})();