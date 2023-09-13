(function () {
    app.controller('Activity.create', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';

            vm.isSaving = false;
            vm.params.day = moment(vm.params.day, formatDate).format('DD-MM-YYYY');

            vm.dayDisplay = dayOfWeekVN[moment(moment(vm.params.day, formatDate)).day()].Name + ", " + vm.params.day;
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);

            vm.isCanChangeData = currentEvi != 'pro' ? true : $rootScope.sessionInfo.UserTitleId == 3

            vm.saveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')'
            }

            vm.sumListAgency = function () {
                vm.listAgency.forEach(function (item) {
                    item.Total = 0;
                    vm.listLottery.forEach(function (item1) {
                        item1.InfoDiemBan.forEach(function (item2) {
                            if (item.Id === item2.AgencyId && item2.TotalReceived) {
                                item.Total += item2.TotalReceived;
                            }
                        })
                    })
                })
            }

            vm.sumListLottery = function () {
                vm.listTotalLottery.forEach(function (item) {
                    item.Total = 0;
                    vm.listLottery.forEach(function (item1) {
                        item1.InfoDiemBan.forEach(function (item2) {
                            if (item.Id === item2.LotteryChannelId && item2.TotalReceived) {
                                item.Total += item2.TotalReceived;
                            }
                        })
                    })
                })


                vm.listLottery.forEach(function (item) {
                    item.Total = 0;
                    item.InfoDiemBan.forEach(function (item1) {
                        if (!item1.TotalReceived) {
                            item1.TotalReceived = 0;
                        }
                
                    })
                    vm.listTotalLottery.forEach(function (item2) {
                        if (item.Id == item2.Id) {
                            item.Total = item2.Total;
                        }
                    })
                })

                vm.listLottery.forEach(function (ele) {
                    ele.sum = 0;
                    vm.listTotalLottery.forEach(function (item1) {
                        ele.sum += item1.Total;
                    });
                });
            }
            
            vm.init = function (date) {
                vm.listLottery.forEach(function (item) {
                    item.InfoDiemBan = angular.copy(vm.listAgency.filter(function (agency) {
                        return agency.IsActive === true;
                    }));
                    item.InfoDiemBan.forEach(function (diemban) {
                        diemban.LotteryChannelId = item.Id;
                        diemban.AgencyId = diemban.Id;
                        diemban.LotteryDate = moment(date, formatDate).format(outputDate);
                        try {
                            var temp01 = vm.listTotal.filter(x => x.LotteryChannelId == item.Id && x.AgencyId == diemban.Id)[0];
                            diemban.TotalReceived = temp01.TotalReceived;
                            diemban.checkNum = temp01.TotalReceived - temp01.TotalRemaining;
                        } catch (err) {
                            diemban.checkNum = 0;
                        }
                    })
                })
                vm.listTotalLottery = angular.copy(vm.listLottery);

                vm.sumListAgency();

                vm.sumListLottery();

            }

            vm.init(vm.params.day);
        
            vm.changeDate = function () {
                $state.go($state.current, { day: moment(vm.params.day, formatDate).format(outputDate) }, { reload: true, notify: true });
            }

            vm.clickToday = function (days = 0) {
                vm.params.day = moment().add(days, 'days').format("YYYY-MM-DD");
                vm.changeDate();
            }

            vm.onChangeData = function (model, newData, oldData, parent, index, diemban) {
                oldData = oldData ? oldData : 0;
                
                newData = $rootScope.reg.test(newData) ? Math.floor(newData) : (!newData ? 0 : oldData)

                //newData = parseInt(newData);
                var totalLottery = vm.listAgency.filter(x => x.LotteryChannelId == newData.LotteryChannelId && x.AgencyId == newData.AgencyId)[index];

                if (newData) {
                    model.isChange = true;
                    if (model.checkNum >= newData) {
                        model.TotalReceived = parseInt(model.checkNum);
                        vm.sumListAgency();
                        vm.sumListLottery();
                    } else if (totalLottery.Total + (newData - oldData) >= 0) {
                        model.TotalReceived = parseInt(newData);
                        vm.sumListAgency();
                        vm.sumListLottery();
                    }
                }
                else  {

                        model.isChange = true;
                        vm.sumListAgency();
                        vm.sumListLottery();
                        newData = 0;
                 }
                
               
                document.getElementById("quantity_" + parent + "_" + index).value = model.TotalReceived;
            }

            vm.onClick = function (parent, index) {
                document.getElementById("quantity_"+parent+"_"+index).focus();
            }

            vm.getSavingData = function () {
                var temp = []
                vm.listLottery.forEach(function (daily) {
                    daily.InfoDiemBan.forEach(function (diemban) {
                        if (diemban.isChange == true) {
                            temp.push(diemban)
                        }
                    })
                })
                return temp;
            }

            vm.save = function () {
                vm.isSaving = true;
                vm.saveInfo.LotteryDate = moment(vm.params.day, formatDate).format(outputDate);
                vm.saveInfo.ReceiveData = JSON.stringify(vm.getSavingData());

                activityService.receiveLotteryFromAgency(vm.saveInfo).then(function (res) {
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

        }]);
})();