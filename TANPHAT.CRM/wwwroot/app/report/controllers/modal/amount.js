(function () {
    app.controller('Report.amount', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService) {
            var vm = angular.extend(this, viewModel);

            vm.saveInfo = angular.extend({
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
            }, vm.sendData);
            vm.price = vm.listTypeSelect[0]
            vm.listDataBK = angular.copy(vm.listData)
            vm.listTypeSelectVer1= vm.listTypeSelect.filter(x => x.LotteryPriceId != 6)
            vm.initData = function () {
                vm.temp = [];
                vm.temp2 = [];
                if (vm.listData.TotalRemaining >= 0) {
                    vm.temp.push({
                        LotteryDate: vm.listData.LotteryDate,
                        ShortName: vm.listData.ShortName,
                        TotalRemaining: vm.listData.TotalRemaining,
                        inputTransfer: 0,
                        IsScratchcard: vm.listData.IsScratchcard,
                    })
                }
                if (vm.listData.TotalDupRemaining >= 0) {
                    vm.temp2.push({
                        LotteryDate: vm.listData.LotteryDate,
                        ShortName: vm.listData.ShortName,
                        TotalDupRemaining: vm.listData.TotalDupRemaining,
                        inputTransfer: 0,
                    })
                }
                vm.tempBk = angular.copy(vm.temp)
                vm.temp2Bk = angular.copy(vm.temp2)
            }
            vm.initData();
            vm.total1 = 0;
            vm.total2 = 0;
            vm.total = 0;
            vm.onChangePrice = function (select) {
                //change price
                vm.price = select;
                if (vm.price.LotteryPriceId == 6) {
                    vm.temp[0].inputTransfer = 0;
                    vm.temp[0].newValue1=0
                    vm.total1 = vm.price.Price * vm.temp[0].newValue1
                    vm.temp2[0].inputTransfer = 0;
                    vm.temp2[0].newValue1=0
                    vm.temp2[0].TotalDupRemaining = vm.temp2Bk[0].TotalDupRemaining
                    vm.total2 = vm.price.Price * vm.temp2[0].newValue1
                    vm.total = vm.total1 + vm.total2
                } else {
                    vm.temp[0].TotaRemaining = vm.tempBk[0].TotalRemaining - vm.temp[0].inputTransfer
                    vm.temp2[0].TotalDupRemaining = vm.temp2Bk[0].TotalDupRemaining - vm.temp2[0].inputTransfer
                    vm.total1 = vm.temp[0].newValue1 ? vm.price.Price * vm.temp[0].newValue1 : 0
                    vm.total2 = vm.temp2[0].newValue1 ? vm.price.Price * vm.temp2[0].newValue1 : 0
                    vm.total = vm.total1 + vm.total2
                }
            }
            //nomalcard
            var inputTransfer=0
            vm.ChangeValueTransfer = function (channel, newValue = 0, oldValue = 0) {
                newValue = newValue + '';

                newValue = newValue.replace(/\D+/g, '');
                newValue = parseInt(newValue);
                if (!newValue) {
                    channel.inputTransfer = 0;
                    channel.TotalRemaining += oldValue;
                } else {
                    if (channel.TotalRemaining - (newValue - oldValue) >= 0) {
                        channel.TotalRemaining = channel.TotalRemaining - (newValue - oldValue);
                        channel.inputTransfer = newValue;

                    } else {
                        channel.inputTransfer = oldValue;
                    }
                }
                vm.temp[0].newValue1 = channel.inputTransfer;
                vm.total1 = vm.price.Price * vm.temp[0].inputTransfer
                vm.total = vm.total1 + vm.total2
            }
            // scratchcard
            vm.ChangeValueTransfer2 = function (channel, newValue = 0, oldValue = 0) {
                newValue = newValue + '';
                newValue = newValue.replace(/\D+/g, '');
                newValue = parseInt(newValue);
                if (!newValue) {
                    channel.inputTransfer = 0;
                    channel.TotalDupRemaining += oldValue;
                } else {
                    if (channel.TotalDupRemaining - (newValue - oldValue) >= 0) {
                        channel.TotalDupRemaining = channel.TotalDupRemaining - (newValue - oldValue);
                        channel.inputTransfer = newValue;
                    } else {
                        channel.inputTransfer = oldValue;
                    }
                }
                vm.temp2[0].newValue1 = channel.inputTransfer;
                vm.total2 = vm.price.Price * vm.temp2[0].inputTransfer
                vm.total = vm.total1 + vm.total2

            }
            //10->1
            vm.ChangeValueTransferModify = function (channel, newValue = 0, oldValue = 0) {
                newValue = newValue + '';
                newValue = newValue.replace(/\D+/g, '');
                newValue = parseInt(newValue);
                if (!newValue) {
                    channel.inputTransfer = 0;
                    channel.TotalDupRemaining += oldValue*11;
                } else {
                    if (channel.TotalDupRemaining - (newValue - oldValue) * 11 >= 0) {
                        channel.TotalDupRemaining = channel.TotalDupRemaining - (newValue - oldValue) * 11;
                        channel.inputTransfer = newValue;
                    } else {
                        channel.inputTransfer = oldValue;
                    }
                }
                vm.temp2[0].newValue1 = channel.inputTransfer;
                vm.total2 = Math.round(vm.price.Price * (vm.temp2[0].inputTransfer * 11) / 1000) * 1000;
                vm.total = vm.total1 + vm.total2
            }
           
            vm.getSavingData = function () {
                var temp = [];
                if (vm.temp[0].newValue1 > 0) {
                    var tmp1 = {
                        Quantity: vm.temp[0].newValue1,
                        LotteryDate: vm.temp[0].LotteryDate,
                        LotteryChannelId: vm.listData.LotteryChannelId,
                        ShiftDistributeId: vm.saveInfo.ShiftDistributeId,
                        LotteryPriceId: vm.price.LotteryPriceId,
                        LotteryTypeId: vm.listData.IsScratchcard ? 3:1,
                    }
                    temp.push(tmp1)
                }
                if (vm.temp2[0].newValue1 > 0) {
                    var tmp2 = {
                        Quantity: vm.price.LotteryPriceId == 6 ? vm.temp2[0].newValue1 * 11 : vm.temp2[0].newValue1,
                        LotteryDate: vm.temp2[0].LotteryDate,
                        LotteryChannelId: vm.listData.LotteryChannelId,
                        ShiftDistributeId: vm.saveInfo.ShiftDistributeId,
                        LotteryPriceId: vm.price.LotteryPriceId,
                        LotteryTypeId: 2,
                    }
                    temp.push(tmp2)
                }

                return temp
            }

            vm.save = function () {
                vm.isSaving = true;
                vm.saveInfo.UpdateData = JSON.stringify(vm.getSavingData());
               reportService.updateORDeleteSalePointLog(vm.saveInfo).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            notificationService.success(res.Message);
                            $state.reload();
                            vm.isSaving = false;
                        }, 200)
                    } else {
                        vm.isSaving = false;
                    }
                })
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
