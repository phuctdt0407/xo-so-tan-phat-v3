(function () {
    app.controller('Activity.activityLog1', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'reportService', 'salepointService', 'activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, reportService, salepointService, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.userInfo = {
                UserId: $rootScope.sessionInfo.UserId
            };
            vm.totalRow = vm.listSold && vm.listSold.length > 0 ? vm.listSold[0].TotalCount : 0;

            vm.totalConfirming1 = 0;

            vm.init = function () {
                vm.listTrans.forEach(function (item) {
                    item.totalConfirming1 = 0;
                    item.detail = item.DetailData ? JSON.parse(item.DetailData) : []

                    if (item.ConfirmStatusId == 1) {
                        vm.totalConfirming1++;
                    }
                })

                /*vm.listSold.forEach(function (item) {
                    item.detail = item.DetailData ? JSON.parse(item.DetailData) : []

                    item.detail.forEach(function (item1) {
                        item1.ShortName = '';
                        vm.listLottery.forEach(function (item2) {
                            if (item1.LotteryChannelId == item2.Id) {
                                item1.ShortName = item2.ShortName;
                            }
                        })
                    })
                })*/

                vm.listSold.forEach(function (item) {
                    item.detail = item.Data ? JSON.parse(item.Data) : []
                })

                vm.listSold = vm.listSold.filter(x => x.detail.SalePointLogData && x.detail.SalePointLogData.length > 0)
                
                vm.listSold.forEach(function (item, index) {
                    item.TotalQuantity = 0
                    item.RowNumber = index+1
                    item.TotalPrice = 0
                    item.detail.SalePointLogData.forEach(function (item1) {
                        item1.ShortName = '';
                        vm.listLottery.forEach(function (item2) {
                            if (item1.LotteryChannelId == item2.Id) {
                                item1.ShortName = item2.ShortName;
                            }
                        })
                        item.TotalQuantity += item1.Quantity
                        item.TotalPrice += item1.TotalValue
                    })
                })

                vm.listTrans.forEach(function (item) {
                    item.detail.forEach(function (item1) {
                        item1.ShortName = '';
                        vm.listLottery.forEach(function (item2) {
                            if (item1.LotteryChannelId == item2.Id) {
                                item1.ShortName = item2.ShortName;
                            }
                        })
                    })
                })

                vm.listWinning.forEach(function (item) {
                    item.ShortName = '';
                    vm.listLottery.forEach(function (item2) {
                        if (item.LotteryChannelId == item2.Id) {
                            item.ShortName = item2.ShortName;
                        }
                    })
                })

            }
            vm.init();

            vm.getBootBox = function (model) {
                var message = ''
                if (confirm) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa vé?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> chuyển/nhận vé?'
                };

                var dialog = bootbox.confirm({
                    message,
                    size:"small",
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
                            // $('.modal-lg').css('display', 'block');
                        }, 500);


                        if (res) {
                            vm.deleteData(model);
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').css('height','')
                        // $('.modal-lg').css('display', 'none')
                    }, 0);
                });
            }

            vm.getBootBoxWinnning = function (model) {
                var message = '<i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa trả thưởng?'

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
                            // $('.modal-lg').css('display', 'block');
                        }, 500);

                        if (res) {
                            vm.deleteWinning(model);
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').css('height', '')
                        // $('.modal-lg').css('display', 'none')
                    }, 0);
                });
            }
            
            vm.deleteData = function (model) {
                vm.deleteRow = {
                    ActionBy: $rootScope.sessionInfo.UserId,
                    ActionByName: $rootScope.sessionInfo.FullName,
                    Data: JSON.stringify({
                        ActionType: 3,
                        HistoryOfOrderId: model.HistoryOfOrderId,
                    })
                }

                salepointService.updateHistoryOrder(vm.deleteRow).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            notificationService.success(res.Message);
                            $state.reload();
                            vm.isSaving = false;
                        }, 200)
                    } else {
                        vm.isSaving = true;
                    }
                })
            }

            vm.deleteWinning = function (model) {
                var deleteRow = {
                    ActionBy: $rootScope.sessionInfo.UserId,
                    ActionByName: $rootScope.sessionInfo.FullName,
                    WinningId: model.WinningId
                }
                activityService.deleteLogWinning(deleteRow).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            notificationService.success(res.Message);
                            $state.reload();
                            vm.isSaving = false;
                        }, 200)
                    } else {
                        vm.isSaving = true;
                    }
                })
            }
            vm.printBill = function (model) {
                var billData = {
                    FullAddress: vm.listSellData.SalePointAddress != null ? vm.listSellData.SalePointAddress : '',
                    SalePoint: vm.listSellData.SalePointName,
                    DatePrint: moment(model.CreatedDate).format('DD/MM/YYYY'),
                    ShiftName: vm.params.shiftId == 1 ? "Ca Sáng" : "Ca Chiều",
                    DateTime: moment().format('HH:mm:ss'),
                    BillNumber: $rootScope.createBillNumber(model.HistoryOfOrderId),
                    ActionName: $rootScope.sessionInfo.FullName,
                    CustomerName: model.detail.GuestData ? model.detail.GuestData.FullName : 'Khách lẻ',
                    ListInfo: [],
                    TotalQuatity: model.TotalQuantity,
                    Sum: model.TotalPrice,
                    CustomerGive: 0,
                    TotalDebt: 0,
                    OldDebt: model.LastData ? model.LastData.OldDebt : 0,
                    NewDebt: model.LastData ? model.LastData.NewDebt : 0
                }
                model.detail.SalePointLogData.forEach(function (item) {
                    billData.ListInfo.push({
                        LotteryName: item.ShortName,
                        Quantity: item.Quantity,
                        FourLastNumber: item.FourLastNumber ? (' --> ' + item.FourLastNumber) : '',
                        Price: item.TotalValue
                    })
                })
                if (model.detail.GuestActionData && model.detail.GuestActionData.length > 0) {
                    model.detail.GuestActionData.forEach(x => billData.CustomerGive += x.TotalPrice)
                } else {
                    billData.CustomerGive = billData.Sum
                }
                var typeGuest = model.detail.GuestData ? 2 : 1
                $rootScope.printBill(billData, typeGuest);
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.changeTab = function (tabName) {
                vm.view = tabName;
                tabName == "paying-debt-content" ? vm.showSaveChange = true : vm.showSaveChange = false;
               
            };
            vm.changeTab('activity-log-content');
            

        }]);
})();
