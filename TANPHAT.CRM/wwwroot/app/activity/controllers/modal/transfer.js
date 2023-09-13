(function () {
    app.controller('Activity.transfer', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;

            vm.saveData = {
                ShiftDistributeId: $rootScope.sessionInfo.ShiftDistributeId,
                TransTypeId: 1,
                ManagerId: vm.ManagerId,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,

            }
            vm.save = function () {
                vm.isSaving = true;
                console.log("CHECK",vm.data)
                var temp = [];
                if(!vm.saveData.ManagerId){
                    notificationService.error("Chưa chọn quản lý lấy vé");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                }else{
                    if (vm.data.toDay && vm.data.toDay.newLottery.length) {
                        vm.data.toDay.newLottery.forEach(e => {
                            temp.push(
                                {
                                    "LotteryDate": vm.data.toDay.dayBK,
                                    "IsScratchcard": false,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.type == 1 ? e.inputTransfer : 0,
                                    "TotalTransDup": e.type == 2 ? e.inputTransfer : 0
                                }
                            )
                        })
                    }

                    if (vm.data.nextDay && vm.data.nextDay.newLottery.length) {
                        vm.data.nextDay.newLottery.forEach(e => {
                            temp.push(
                                {
                                    "LotteryDate": vm.data.nextDay.dayBK,
                                    "IsScratchcard": false,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.type == 1 ? e.inputTransfer : 0,
                                    "TotalTransDup": e.type == 2 ? e.inputTransfer : 0
                                }
                            )
                        })
                    }
                    if (vm.data.scratchCardData && vm.data.scratchCardData.lottery && vm.data.scratchCardData.lottery.length) {
                        vm.data.scratchCardData.newLottery.forEach(e => {
                            temp.push(
                                {
                                    "LotteryDate": null,
                                    "IsScratchcard": true,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.inputTransfer
                                }
                            )
                        })
                    }
                    temp = temp.filter(e => e.TotalTrans > 0 || e.TotalTransDup > 0)
                    console.log("temp", temp)
                    vm.saveData.TransData = JSON.stringify(temp)

                    activityService.insertTransitionLog(vm.saveData).then(function (res) {
                        $rootScope.connection.invoke("SendMessage", "checkTransferReload", "" + vm.saveData.ManagerId).catch(function (err) {
                            return console.error(err.toString());
                        })

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


            vm.initData = function () {
                var temp = [];
                console.log("check data",vm.data)
               if(vm.data.toDay){
                   vm.data.toDay.lottery.forEach(function (item) {

                       if (item.TotalRemaining >= 0) {
                           vm.listLottery.forEach(function (item1) {
                               if (item.channelId == item1.Id) {
                                   temp.push({
                                       ShortName: item1.ShortName,
                                       channel: item.channel,
                                       channelId: item.channelId,
                                       remaining: item.TotalRemaining,
                                       type: 1,
                                       inputTransfer: 0,
                                   })
                               }
                           })
                       }

                       if (item.TotalDupRemaining != 0) {
                           vm.listLottery.forEach(function (item1) {
                               if (item.channelId == item1.Id) {
                                   temp.push({
                                       ShortName: item1.ShortName,
                                       channel: item.channel,
                                       channelId: item.channelId,
                                       remaining: item.TotalDupRemaining,
                                       type: 2,
                                       inputTransfer: 0,
                                   })
                               }
                           })
                       }
                   })
                   vm.data.toDay.newLottery = temp;
               }
               


                try {
                    var temp = [];

                  if(vm.data.nextDay){
                      vm.data.nextDay.lottery.forEach(function (item) {
                          if (item.TotalRemaining != 0) {
                              temp.push({
                                  channel: item.channel,
                                  channelId: item.channelId,
                                  remaining: item.TotalRemaining,
                                  type: 1,
                                  inputTransfer: 0,
                              })
                          }

                          if (item.TotalDupRemaining != 0) {
                              temp.push({
                                  channel: item.channel,
                                  channelId: item.channelId,
                                  remaining: item.TotalDupRemaining,
                                  type: 2,
                                  inputTransfer: 0,
                              })
                          }
                      })
                      vm.data.nextDay.newLottery = temp;
                  }
                } catch (err) {

                }
                try {
                    var temp = [];

                    vm.data.scratchCardData.lottery.forEach(function (item) {
                        if (item.TotalRemaining > 0) {
                            temp.push({
                                channel: item.ShortName,
                                channelId: item.LotteryChannelId,
                                remaining: item.TotalRemaining,
                                type: 3,
                                inputTransfer: 0,
                            })
                        }
                    })
                    vm.data.scratchCardData.newLottery = temp;
                } catch (err) {

                }
                console.log('data: ', vm.data);

            }

            vm.initData();

            vm.ChangeValueTransfer = function (channel, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    channel.inputTransfer = 0;
                    channel.remaining += oldValue;
                } else {
                    if (channel.remaining - (newValue - oldValue) >= 0) {
                        channel.remaining = channel.remaining - (newValue - oldValue);
                    } else {
                        channel.inputTransfer = oldValue;
                    }
                }
            }

           /* vm.ChangeValueTransferScratchCard = function (channel, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    channel.input = 0;
                    channel.TotalRemaining += oldValue;
                } else {
                    if (channel.TotalRemaining - (newValue - oldValue) >= 0) {
                        channel.TotalRemaining = channel.TotalRemaining - (newValue - oldValue);
                    } else {
                        channel.input = oldValue;
                    }
                }
            }*/

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
