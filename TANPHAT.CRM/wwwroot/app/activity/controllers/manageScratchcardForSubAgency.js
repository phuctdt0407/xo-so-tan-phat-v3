(function () {
    app.controller('Activity.manageScratchcardForSubAgency', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService', 'dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD-MM-YYYY', 'YYYY-MM-DD'];
            var outputDate = 'YYYY-MM-DD';

            vm.params.day = moment(vm.params.day, formatDate).format('DD-MM-YYYY');
            vm.dayDisplay = dayOfWeekVN[moment(moment(vm.params.day, formatDate)).day()].Name + ", " + vm.params.day;
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.isSaving = false;
            //INIT Data

            vm.TotalRemaining = JSON.parse(vm.totalScratchcard.Data);

            vm.init = function () {
                //Modify
                vm.listScratchcard = vm.listLotteryDDL.filter(x => x.IsScratchcard == true);

                vm.listSubAgency.forEach(function (item) {
                    item.listScratchcard = angular.copy(vm.listScratchcard);

                    item.listScratchcard.forEach(function (ele) {
                        ele.InputData = 0;
                        ele.InputDataBK = 0;
                 
                        var temp = vm.listData.filter(function (res) {
                            return res.AgencyId == item.AgencyId && res.LotteryChannelId == ele.Id;
                        })
                        if (temp && temp.length > 0) {
                            ele.RemainingData = temp[0].TotalRemaining
                        } else {
                            ele.RemainingData = 0;
                        }
                    })
                })
                // TotalRemaining
                vm.listScratchcard.forEach(function (item) {
                    var temp = vm.TotalRemaining.filter(x => x.LotteryChannelId == item.Id);
                    if (temp && temp.length > 0) {
                        item.TotalRemaining = temp[0].TotalRemaining
                    } else {
                        item.TotalRemaining = 0;
                    }
                })
            }
            vm.init();
            console.log("vm.listScratchcard", vm.listScratchcard);
            //Submit Search
            vm.onClick = function (index, pindex) {
                document.getElementById("quantity_" + index + '_' + pindex).focus();
            }

            vm.onChangeData = function (model, index, pindex) {
                var newData = model.InputData;
                var oldData = model.InputDataBK;

                if (newData && newData != oldData) {
                    model.isChange = true;
                    if (0 > (vm.listScratchcard[index].TotalRemaining - (newData - oldData))) {
                        model.InputData = model.InputDataBK;
                    } else {

                        vm.listScratchcard[index].TotalRemaining -= (newData - oldData);
                        model["InputDataBK"] = newData;
                    }
                } else {
                    if (!newData) {
                        vm.listScratchcard[index].TotalRemaining += oldData;
                        model["InputData"] = 0;

                        model.InputDataBK = model.InputData;
                    }
                }
                document.getElementById("quantity_" + index + '_' + pindex).value = model["InputData"];

            }

            ///Save Data
            vm.saveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')'
            }

            vm.getSavingData = function () {
                var temp = [];
                vm.sendData = [];
                vm.listSubAgency.forEach(function (daiban) {
                    daiban.listScratchcard.forEach(function (ele) {

                        if (ele.InputData > 0) {
                            temp.push({
                                SalePointId: daiban.AgencyId,
                                TotalReceived: ele.InputData,
                                LotteryChannelId: ele.Id
                            });

                            vm.sendData.push({
                                isTypeScratch: true,
                                SalePointId: daiban.AgencyId,
                                TotalTrans: ele.InputData,
                                LotteryChannelId: ele.Id
                            })
                        }
                    })
                })
                return temp;
            }

            vm.sendDataTL = function () {
                $rootScope.connection.invoke("SendMessage", "addLotteryManage", JSON.stringify(vm.sendData)).catch(function (err) {
                    return console.error(err.toString());
                });
            }
            console.log("vm.listSubAgency", vm.listSubAgency);
            vm.save = function () {
                vm.isSaving = true;
                console.log("có vào save");
                var data = vm.getSavingData();
                if (!data || data.length == 0) {
                    notificationService.warning("Không có dữ liệu để lưu");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else {
                    vm.saveInfo.ReceiveData = JSON.stringify(data);
                    activityService.distributeScratchForSubAgency(vm.saveInfo).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)
                            vm.sendDataTL();
                        } else {
                            vm.isSaving = false;
                        }
                    })
                }
            }

        }]);
})();