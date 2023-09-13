(function () {
    app.controller('Activity.receiving', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.saveData = {
                ManagerId:vm.ManagerId,
                ShiftDistributeId:$rootScope.sessionInfo.ShiftDistributeId,
                TransTypeId: 2,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
            }
            console.log("today check",vm.data.toDay)
            vm.save = function () {
                vm.isSaving = true;
                if (!vm.saveData.ManagerId) {
                    notificationService.error("Chưa chọn quản lý đưa vé");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else {
                    var temp = [];
                    if (vm.toDayRecevingData.length) {
                        vm.toDayRecevingData.forEach(e => {
                            temp.push(
                                {
                                    "LotteryDate": vm.data.toDay.dayBK,
                                    "IsScratchcard": false,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.type == 1 ? e.inputReceiving : 0,
                                    "TotalTransDup": e.type == 2 ? e.inputReceiving : 0
                                }
                            )
                        })
                    }
                    if (vm.nextDayReceivingData.length) {
                        var nextDay = moment(vm.data.toDay.dayBK).add(1,'days').format('YYYY-MM-DD')
                        vm.nextDayReceivingData.forEach(e => {
                            temp.push(
                                {
                                    "LotteryDate": nextDay,
                                    "IsScratchcard": false,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.type == 1 ? e.inputReceiving : 0,
                                    "TotalTransDup": e.type == 2 ? e.inputReceiving : 0
                                }
                            )
                        })
                    }
                    if (vm.scratchCardReceivingData.length) {
                        vm.scratchCardReceivingData.forEach(e => {
                            temp.push(
                                {
                                    "LotteryDate": null,
                                    "IsScratchcard": true,
                                    "LotteryChannelId": e.channelId,
                                    "TotalTrans": e.inputReceiving
                                }
                            )
                        })
                    }
                    temp = temp.filter(e => e.TotalTrans > 0 || e.TotalTransDup > 0)
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
            vm.toDayRecevingData = []
            vm.nextDayReceivingData = []
            vm.scratchCardReceivingData = []
            
            

            vm.initData = function () {
                var todayInventory = []
                var nextDayInventory = []
                var scratchCardInventory = []
                ///
                vm.listLotteryToday.forEach(e=>{
                    vm.toDayRecevingData.push(
                        {
                            ShortName: e.ShortName,
                            channel: e.Name,
                            channelId: e.Id,
                            remaining: 0,
                            type: 1,
                            inputReceiving: 0,
                            inventory: 0
                        }
                    )
                })
                vm.listLotteryNextDay.forEach(e=>{
                    vm.nextDayReceivingData.push(
                        {
                            ShortName: e.ShortName,
                            channel: e.Name,
                            channelId: e.Id,
                            remaining: 0,
                            type: 1,
                            inputReceiving: 0,
                            inventory: 0
                        }
                    )
                })
                
                
                
                ///
                if (vm.dataInventory.TodayData) {
                    todayInventory = JSON.parse(vm.dataInventory.TodayData)
                }
                if (vm.dataInventory.TomorrowData) {
                    nextDayInventory = JSON.parse(vm.dataInventory.TomorrowData)
                }
                if (vm.dataInventory.ScratchcardData) {
                    scratchCardInventory = JSON.parse(vm.dataInventory.ScratchcardData)
                }

                console.log("scratchCardInventory",scratchCardInventory)
                ///TODAY
                todayInventory.forEach(ele=>{
                    if(ele.TotalRemaining > 0){
                        vm.toDayRecevingData.find(item=>item.channelId == ele.LotteryChannelId).inventory = ele.TotalRemaining
                    }
                    if(ele.TotalDupRemaining > 0){
                        vm.toDayRecevingData.push({
                            ShortName: ele.ShortName,
                            channel: ele.LotteryChannelName,
                            channelId: ele.LotteryChannelId,
                            remaining: 0,
                            type: 2,
                            inputReceiving: 0,
                            inventory:ele.TotalDupRemaining
                        })
                    }
                })
               if(vm.data.toDay){
                   vm.data.toDay.lottery.forEach(ele=>{
                       if(ele.TotalRemaining>0){
                           vm.toDayRecevingData.find(item=>item.channelId == ele.LotteryChannelId).remaining = ele.TotalRemaining
                       }
                       if(ele.TotalDupRemaining>0){
                           if(vm.toDayRecevingData.find(item=>item.channelId == ele.LotteryChannelId && item.type ==2)!=undefined ){
                               vm.toDayRecevingData.find(item=>item.channelId == ele.LotteryChannelId&& item.type ==2).remaining = ele.TotalDupRemaining
                           }

                       }
                   })
               }
                ///END TODAY
                ///NEXTDAY
                nextDayInventory.forEach(ele=>{
                    if(ele.TotalRemaining > 0){
                        vm.nextDayReceivingData.find(item=>item.channelId == ele.LotteryChannelId).inventory = ele.TotalRemaining
                    }
                    if(ele.TotalDupRemaining > 0){
                        vm.nextDayReceivingData.push({
                            ShortName: ele.ShortName,
                            channel: ele.LotteryChannelName,
                            channelId: ele.LotteryChannelId,
                            remaining: 0,
                            type: 2,
                            inputReceiving: 0,
                            inventory:ele.TotalDupRemaining
                        })
                    }
                })
                if(vm.data.nextDay){
                    vm.data.nextDay.lottery.forEach(ele=>{
                        if(ele.TotalRemaining>0){
                            vm.nextDayReceivingData.find(item=>item.channelId == ele.LotteryChannelId).remaining = ele.TotalRemaining
                        }
                        if(ele.TotalDupRemaining>0){
                            if(vm.nextDayReceivingData.find(item=>item.channelId == ele.LotteryChannelId && item.type ==2)!=undefined ){
                                vm.nextDayReceivingData.find(item=>item.channelId == ele.LotteryChannelId&& item.type ==2).remaining = ele.TotalDupRemaining
                            }

                        }
                    })
                }
                ///END NEXTDAY
                // todayInventory.forEach(function (item) {
                //     vm.data.toDay.lottery.forEach(function (item1) {
                //         if (item.LotteryChannelId == item1.LotteryChannelId) {
                //             if(item.TotalRemaining>0){
                //                 vm.toDayRecevingData.push({
                //                     ShortName: item1.ShortName,
                //                     channel: item1.channel,
                //                     channelId: item1.channelId,
                //                     remaining: item1.TotalRemaining,
                //                     type: 1,
                //                     inputReceiving: 0,
                //                     inventory: item.TotalRemaining
                //                 })
                //             }
                //             if(item.TotalDupRemaining>0){
                //                 vm.toDayRecevingData.push({
                //                     ShortName: item1.ShortName,
                //                     channel: item1.channel,
                //                     channelId: item1.channelId,
                //                     remaining: item1.TotalDupRemaining,
                //                     type: 2,
                //                     inputReceiving: 0,
                //                     inventory: item.TotalDupRemaining
                //                 })
                //             }
                //         }
                //     })
                // })
                // nextDayInventory.forEach(function (item) {
                //     if(vm.data.nextDay){
                //         vm.data.nextDay.lottery.forEach(function (item1) {
                //             if (item.LotteryChannelId == item1.LotteryChannelId) {
                //                 if(item.TotalRemaining>0){
                //                     vm.nextDayReceivingData.push({
                //                         ShortName: item1.ShortName,
                //                         channel: item1.channel,
                //                         channelId: item1.channelId,
                //                         remaining: item1.TotalRemaining,
                //                         type: 1,
                //                         inputReceiving: 0,
                //                         inventory: item.TotalRemaining
                //                     })
                //                 }
                //                 if(item.TotalDupRemaining>0){
                //                     vm.nextDayReceivingData.push({
                //                         ShortName: item1.ShortName,
                //                         channel: item1.channel,
                //                         channelId: item1.channelId,
                //                         remaining: item1.TotalRemaining,
                //                         type: 2,
                //                         inputReceiving: 0,
                //                         inventory: item.TotalDupRemaining
                //                     })
                //                 }
                //             }
                //         })
                //     }else{
                //         if(item.TotalRemaining>0){
                //             vm.nextDayReceivingData.push({
                //                 ShortName: item.ShortName,
                //                 channel: item.channel,
                //                 channelId: item.channelId,
                //                 remaining: 0,
                //                 type: 1,
                //                 inputReceiving: 0,
                //                 inventory: item.TotalRemaining
                //             })
                //         }
                //         if(item.TotalDupRemaining>0){
                //             vm.nextDayReceivingData.push({
                //                 ShortName: item.ShortName,
                //                 channel: item.channel,
                //                 channelId: item.channelId,
                //                 remaining:0,
                //                 type: 2,
                //                 inputReceiving: 0,
                //                 inventory: item.TotalDupRemaining
                //             })
                //         }
                //     }
                //
                // })
                scratchCardInventory.forEach(function (item) {
                    console.log("vm.data.ScratchCardData",vm.data.ScratchCardData)
                    if (vm.data.scratchCardData) {
                        vm.data.scratchCardData.lottery.forEach(function (item1) {
                            if (item.LotteryChannelId == item1.LotteryChannelId) {
                                if (item.TotalRemaining > 0) {
                                    vm.scratchCardReceivingData.push({
                                        ShortName: item1.ShortName,
                                        channel: item.LotteryChannelName,
                                        channelId: item1.LotteryChannelId,
                                        remaining: item1.TotalRemaining,
                                        type: 3,
                                        inputReceiving: 0,
                                        inventory: item.TotalRemaining
                                    })
                                }
                            }
                        })
                    }
                })
            }

            vm.initData();
            vm.ChangeValueReceiving = function (channel, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    channel.inputReceiving = 0;
                    channel.inventory += oldValue
                    channel.remaining -= oldValue
                } else {

                    if (channel.inventory - (newValue - oldValue) >= 0) {
                        channel.inventory = channel.inventory - (newValue - oldValue);
                        channel.remaining = channel.remaining + newValue - oldValue

                    } else {
                        channel.inputReceiving = oldValue;
                    }
                }
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
