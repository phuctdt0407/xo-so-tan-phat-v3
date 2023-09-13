
(function () {
    app.controller('Activity.input4LastNum', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'activityService', 'dashboardService', 'authService', '$uibModal', 'dayOfWeekVN', 'ddlService', 'reportService', 'ddlService', 'salepointService','$uibModalInstance',
        function ($scope, $rootScope, $state, viewModel, notificationService, activityService, dashboardService, authService, $uibModal, dayOfWeekVN, ddlService, reportService, ddlService, salepointService, $uibModalInstance) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false
            vm.check = false
            vm.data = angular.copy(vm.model)
            vm.LotteryDateDisplay = moment(vm.data.LotteryDate, 'YYYY-MM-DD').format('DD-MM-YYYY')
           
            vm.addRow = function () {
                vm.data.ListDetail.push({
                    input: 0,
                    fourLastNumber: null,
                    sum: 0
                })
            }

            vm.deleteRow = function (item, index) {
                vm.data.remaining += item.input
                vm.data.TotalRemaining += item.input
                vm.data.ListDetail.splice(index, 1)
                vm.getSum()
            }

            vm.ChangeValueSale = function (model, typePrice, type, newValue = 0, oldValue = 0) {
                //typePrice
                //0. GIA SI hoac GIA LE
                //1. GIA VE 10 TANG 1
                //2. GIA VE CAO

                //type
                //0. VE COC 10 TANG 1
                //1. VE TRUNG
                //2. VE THUONG
                if (newValue == null) {
                    model.input = 0;
                    vm.data.remaining += oldValue;
                    if (type < 2) {
                        vm.data.TotalDupRemaining += oldValue;
                    } else {
                        vm.data.TotalRemaining += oldValue;
                    }
                }
                else {
                    if (type < 2 && vm.data.TotalDupRemaining - (newValue - oldValue) >= 0) {
                        vm.data.TotalDupRemaining -= (newValue - oldValue);
                    } else {
                        if (type == 2 && vm.data.remaining - (newValue - oldValue) >= 0) {
                            vm.data.remaining = vm.data.remaining - (newValue - oldValue);
                            vm.data.TotalRemaining -= (newValue - oldValue);
                        } else {
                            model.input = oldValue;
                        }
                    }
                }
                setTimeout(function () {
                    $rootScope.$apply(vm.data)
                }, 200)

                vm.getSum()
            }

            vm.getSum = function () {
                var getType = vm.data.isScratchCard ? 2 : 0;
                vm.data.inputSale_2 = 0
                vm.data.Sum = 0;
                for (let i = 0; i <= 2; i++) {
                    try {
                        if (i == 0) {
                            var getName = vm.typeOfPrice[1].Name;
                            var getPrice = vm[getName].Price;
                            if (9090.9 == getPrice) {
                                vm.data.Sum += Math.ceil(vm.data["inputSale_" + i] * 10000 / 11 * 10)
                            }
                        } else {
                            var getName = vm.typeOfPrice[getType].Name;
                            var getPrice = vm[getName].Price;
                            if (i == 2) {
                                vm.data.ListDetail.forEach(function (item) {
                                    item.sum = getPrice * item.input;
                                    vm.data.inputSale_2 += item.input
                                })
                            }
                            vm.data.Sum += Math.ceil(getPrice * vm.data["inputSale_" + i])
                        }
                    } catch (err) {
                        notificationService.warning("Error");
                    }
                }
            }

            vm.save = function () {
                vm.data.ListDetail.forEach(function (item, index) {
                    if (item.input == 0) {
                        vm.data.ListDetail.splice(index, 1)
                    } 
                })

                vm.data.ListDetail.forEach(function (item, index) {
                    if (!item.fourLastNumber || item.fourLastNumber.length != 5) {
                        vm.check = false
                        setTimeout(function () {
                            notificationService.error('Tất cả các vé phải nhập đủ 5 số')
                        }, 100)
                    } else {
                        vm.check = true
                    }
                })

                if (vm.check || vm.data.ListDetail.length == 0) {
                    setTimeout(function () {
                        notificationService.success('Lưu thành công')
                    }, 100)
                    $uibModalInstance.dismiss(vm.data);
                }
            }
            vm.cancel = function () {
                $uibModalInstance.close()
            }
        }]);
})();