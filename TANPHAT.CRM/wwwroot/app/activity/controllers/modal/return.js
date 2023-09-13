(function () {
    app.controller('Activity.return', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel','activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel,activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;

            vm.saveData = {
                ShiftDistributeId:$rootScope.sessionInfo.ShiftDistributeId,
                TransTypeId:3,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,

            }
            vm.save = function () {
                vm.isSaving = true;
                if(!vm.saveData.ManagerId){
                    notificationService.error("Chưa chọn quản lý lấy vé");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                }else{
                    var temp = [];
                    if(vm.data.toDay && vm.data.toDay.newLottery.length){
                        vm.data.toDay.newLottery.forEach(e=>{
                            temp.push(
                                {
                                    "LotteryDate": vm.data.toDay.dayBK,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.type==1?e.inputReturn:0,
                                    "TotalTransDup": e.type==2?e.inputReturn:0
                                }
                            )
                        })
                    }

                    if(vm.data.nextDay && vm.data.nextDay.newLottery.length){
                        vm.data.nextDay.newLottery.forEach(e=>{
                            temp.push(
                                {
                                    "LotteryDate": vm.data.nextDay.dayBK,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.type==1?e.inputReturn:0,
                                    "TotalTransDup": e.type==2?e.inputReturn:0
                                }
                            )
                        })
                    }
                    temp = temp.filter(e=>e.TotalTrans !=0 || e.TotalTransDup != 0)
                    vm.saveData.TransData =  JSON.stringify(temp)

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
                                    inputReturn: 0,
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
                                    inputReturn: 0,
                                })
                            }
                        })
                    }

                })
                vm.data.toDay.newLottery = temp;



                try {
                    var temp = [];

                    vm.data.nextDay.lottery.forEach(function (item) {
                        if (item.TotalRemaining != 0) {
                            temp.push({
                                channel: item.channel,
                                channelId: item.channelId,
                                remaining: item.TotalRemaining,
                                type: 1,
                                inputReturn: 0,
                            })
                        }

                        if (item.TotalDupRemaining != 0) {
                            temp.push({
                                channel: item.channel,
                                channelId: item.channelId,
                                remaining: item.TotalDupRemaining,
                                type: 2,
                                inputReturn: 0,
                            })
                        }
                    })
                    vm.data.nextDay.newLottery = temp;
                } catch (err) {

                }

            }

            vm.initData();
            vm.ChangeValueReturn = function (channel, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    channel.inputReturn = 0;
                    channel.remaining += oldValue;
                } else {
                    if (channel.remaining - (newValue - oldValue) >= 0) {
                        channel.remaining = channel.remaining - (newValue - oldValue);
                    } else {
                        channel.inputReturn = oldValue;
                    }
                }
                
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
