(function () {
    app.controller('Activity.createScratchcard', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';

            vm.isSaving = false;
            vm.params.day = moment(vm.params.day, formatDate).format('DD-MM-YYYY');
            vm.dayDisplay = dayOfWeekVN[moment(moment(vm.params.day, formatDate)).day()].Name + ", " + vm.params.day;
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);

            vm.saveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')'
            }
            //Submit Search
            vm.isShowSave = function () {
                return moment().format("YYYY-MM-DD") == moment(vm.params.day, formatDate).format("YYYY-MM-DD")
            }

            vm.changeDate = function () {
                $state.go($state.current, { day: moment(vm.params.day, formatDate).format(outputDate) }, { reload: true, notify: true });
            }

            vm.clickToday = function (days = 0) {
                vm.params.day = moment().add(days, 'days').format("YYYY-MM-DD");
                vm.changeDate();
            }

            vm.onClick = function (index, pindex) {
                document.getElementById("quantity_" + index + '_' + pindex).focus();
            }

            ///

            vm.init = function () {
                //Modify

                vm.listScratchcard = vm.listLotteryDDL.filter(x => x.IsScratchcard == true);

                vm.listAgency.forEach(function (item) {
                    //Modify
                    item.listScratchcard = angular.copy(vm.listScratchcard);

                    item.listScratchcard.forEach(function (ele) {
                        ele.InputData = 0;
                        var temp = vm.listData.filter(function (res) {
                            return res.AgencyId == item.Id && res.LotteryChannelId == ele.Id;
                        })
                        if (temp && temp.length > 0) {
                            ele.RemainingData = temp[0].TotalReceived
                        } else {
                            ele.RemainingData = 0;
                        }
                    })

                    //OLD

                    //item.InputData = 0;
                    //var temp = vm.listData.filter(function (ele) {
                    //    return ele.AgencyId == item.Id;
                    //})
                    //if (temp && temp.length > 0) {
                    //    item.RemainingData = temp[0].TotalReceived
                    //} else {
                    //    item.RemainingData = 0;
                    //}
                })
            }
            vm.init()


            vm.onChangeData = function (model, newData, oldData , index, pindex ) {
                newData = parseInt(newData);
                if (newData && newData != oldData) {
                    model.isChange = true;
                    if (0 >= newData) {
                        model["InputData" ] = 0;
                    } else {
                        model["InputData" ] = parseInt(newData);
                    }
                } else {
                    if (!newData) {
                        model["InputData"] = 0;
                    }
                }
                document.getElementById("quantity_" + index + '_' + pindex).value = model["InputData"];
            }

            //Save Data

            vm.getSavingData = function () {
                var temp = []
                vm.listAgency.forEach(function (daily) {
                    //Modifys
                    daily.listScratchcard.forEach(function (vecao) {
                        if (vecao.InputData > 0) {
                            temp.push({
                                AgencyId: daily.Id,
                                TotalReceived: vecao.InputData,
                                LotteryChannelId: vecao.Id
                            })
                        }
                    })

                    //OLD

                    //if (daily.InputData > 0) {
                    //    temp.push({
                    //        AgencyId: daily.Id,
                    //        TotalReceived: daily.InputData
                    //    })
                    //}
                })
                return temp;
            }
 
            vm.save = function () {
                vm.isSaving = true;
                var data = vm.getSavingData();
                if (!data || data.length == 0) {
                    
                    notificationService.warning("Không có dữ liệu để lưu");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving); 
                    }, 1000)
                } else {
                   
                    vm.saveInfo.ReceiveData = JSON.stringify(data);
                    activityService.receiveScratchcardFromAgency(vm.saveInfo).then(function (res) {
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
            }

        }]);
})();