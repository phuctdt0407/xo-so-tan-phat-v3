﻿(function () {
    app.controller('Activity.manage', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService','dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            $scope.$on('$locationChangeStart', function( event ) {
                var answer = confirm("Dữ liệu có thể mất nếu bạn chưa lưu lại!!!")
                if (!answer) {
                    event.preventDefault();
                }
            });
            vm.isSaving = false;
            var formatDate = ['DD-MM-YYYY', 'YYYY-MM-DD'];
            var outputDate = 'YYYY-MM-DD';
            vm.params.day = moment(vm.params.day, formatDate).format('DD-MM-YYYY');
            vm.dayDisplay = dayOfWeekVN[moment(moment(vm.params.day, formatDate)).day()].Name + ", " + vm.params.day;
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);

            vm.isCanChangeData = currentEvi != 'pro' ? true : $rootScope.sessionInfo.UserTitleId == 3

            vm.getSum = function () {
                vm.Total = 0;
                vm.listLotteryBk.forEach(function (daiban) {
                    var data = vm.listInitDaiBan1.filter(x => x.Id == daiban.Id);
                    var temp = 0;
                    data.forEach(function (item) {
                        temp += item.TotalRemaining
                    })
                    daiban.TotalRemaining = temp;
                    vm.Total += temp;
                });
            }

            vm.saveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')'
            }
            vm.changeDate = function () {
                $state.go($state.current, { day: moment(vm.params.day, formatDate).format(outputDate) }, { reload: true, notify: true });
            }

            vm.clickToday = function (days = 0) {
                vm.params.day = moment().add(days, 'days').format("YYYY-MM-DD");
                vm.changeDate();
            }

            vm.init = function () {
                vm.listInit1 = [];
                vm.listInitDaiBan1 = [];

                vm.listLottery.forEach(function (item) {
                    item.TotalRemaining = 0;
                })
                //Total
                vm.Total = 0;
                vm.listLotteryBk = angular.copy(vm.listLottery);

                vm.listAgency.forEach(function (item) {
                    item.InfoDaiBan = angular.copy(vm.listLottery);
                    item.InfoDaiBan.forEach(function (daiban, index) {
                        daiban.AgencyId = item.Id;
                        daiban.LotteryChannelId = daiban.Id;
                        try {
                            daiban.TotalRemaining = vm.listTotalAgency.filter(x => x.AgencyId == daiban.AgencyId && x.LotteryChannelId == daiban.LotteryChannelId)[0].TotalRemaining;
                        } catch (err) {
                            daiban.TotalRemaining = 0;
                        }
                        vm.listLotteryBk[index].TotalRemaining += daiban.TotalRemaining;
                        vm.Total += daiban.TotalRemaining;
                    })
                    vm.listInitDaiBan1 = vm.listInitDaiBan1.concat(angular.copy(item.InfoDaiBan));
                })
                vm.listSalePoint.forEach(function (diemban) {

                    diemban.InfoDaiLy = angular.copy(vm.listAgency);
                    diemban.SalePointId = diemban.Id;
                    diemban.InfoDaiLy.SalePointId = diemban.Id;
                    var temp = {
                        SalePointId: diemban.Id,
                        SalePointName: diemban.Name,
                        isClose: false
                    };

                    var temp1 = [];
                    var temp2 = 0;
                    var temp4 = 0;
                    var isCheckDupVal = false;
                    //INIT DATA FROM LIST MANAGE 
                    diemban.InfoDaiLy.forEach(function (daily) {
                        daily.InfoDaiBan.forEach(function (daiban) {
                            var temp3 = vm.listData.filter(x => x.AgencyId == daiban.AgencyId && x.SalePointId == diemban.SalePointId && x.LotteryChannelId == daiban.LotteryChannelId);
                            try {
                                daiban.SalePointId = diemban.SalePointId;
                                daiban.TotalRemaining = temp3[0].TotalReceived;
                                temp2 += temp3[0].TotalReceived;
                            } catch (err) {
                                daiban.TotalRemaining = 0;
                            }
                            try {
                                daiban.TotalDupRemaining = temp3[0].TotalDupReceived;
                                temp4 += temp3[0].TotalDupReceived;
                                if (daiban.TotalDupRemaining > 0) {
                                    isCheckDupVal = true;
                                } 
                            } catch (err) {
                                daiban.TotalDupRemaining = 0; 
                            }
                        })
                        temp1 = temp1.concat(daily.InfoDaiBan);
                    })

                    temp.Info = angular.copy(temp1);
                    temp.TotalRemaining = temp2;
                    temp.TotalDupRemaining = temp4;
                    temp.MainTotal = temp2 + temp4;
                    temp.isCheckDupVal = isCheckDupVal;
                    vm.listInit1.push(temp);
                })

                vm.listInit1.forEach(function (item) {
                    var detail = [];
                    vm.listLottery.forEach(function (ele) {
                        var lottery = {
                            Id: ele.Id,
                            Name: ele.Name,
                            ShortName: ele.ShortName,
                            total: 0
                        }
                        item.Info.forEach(function (ite) {
                            if (ite.Id == ele.Id) {
                                lottery.total += ite.TotalDupRemaining;
                                lottery.total += ite.TotalRemaining
                            }
                        })
                        detail.push(lottery)
                    })
                    item.detail = detail;
                })

                //Modify
                vm.listInit1Bk = angular.copy(vm.listInit1);
            }
            vm.init();

            vm.ChangeValueNumber1 = function (newValue, oldValue, diemban, parent_index, index) {
                //console.log(newValue, oldValue);
                newValue.TotalRemaining = $rootScope.reg.test(newValue.TotalRemaining) ? Math.floor(newValue.TotalRemaining) : (!newValue.TotalRemaining ? 0 : oldValue.TotalRemaining)
                if (newValue && newValue != oldValue) {
                    newValue.isChange = true;
                }

                

                var DaiBanTotal = vm.listInitDaiBan1.filter(x => x.LotteryChannelId == newValue.LotteryChannelId && x.AgencyId == newValue.AgencyId)[0];
                if (newValue.TotalRemaining == undefined) {
                    DaiBanTotal.TotalRemaining = DaiBanTotal.TotalRemaining + oldValue.TotalRemaining;
                    diemban.TotalRemaining = diemban.TotalRemaining - oldValue.TotalRemaining;
                    newValue.TotalRemaining = 0;
                    diemban.detail[index % diemban.detail.length].total = 0;
                    diemban.Info.forEach(function (item) {
                        if (item.Id == diemban.detail[index % diemban.detail.length].Id) {
                            diemban.detail[index % diemban.detail.length].total += item.TotalRemaining;
                            diemban.detail[index % diemban.detail.length].total += item.TotalDupRemaining;
                        }
                    })
                }
                else {
                    if (DaiBanTotal.TotalRemaining - (newValue.TotalRemaining - oldValue.TotalRemaining) >= 0) {
                        DaiBanTotal.TotalRemaining = DaiBanTotal.TotalRemaining - (newValue.TotalRemaining - oldValue.TotalRemaining);
                        diemban.TotalRemaining = diemban.TotalRemaining + (newValue.TotalRemaining - oldValue.TotalRemaining);
                        /*diemban.detail[index % 3].total = diemban.detail[index % 3].total - DaiBanTotal.TotalRemaining;*/
                        diemban.detail[index % diemban.detail.length].total = 0;
                        diemban.Info.forEach(function (item) {
                            if (item.Id == diemban.detail[index % diemban.detail.length].Id) {
                                diemban.detail[index % diemban.detail.length].total += item.TotalRemaining;
                                diemban.detail[index % diemban.detail.length].total += item.TotalDupRemaining;
                            }
                        })
                    } else {
                        newValue.TotalRemaining = oldValue.TotalRemaining;
                    }
                }
                vm.getSum();
                document.getElementById("quantity_" + parent_index + "_" + index).value = newValue.TotalRemaining;
            }
            vm.ChangeValueNumber2 = function (newValue, oldValue, diemban, parent_index, index) {
                diemban.isCheckDupVal = true;

                newValue.TotalDupRemaining = $rootScope.reg.test(newValue.TotalDupRemaining) ? Math.floor(newValue.TotalDupRemaining) : (!newValue.TotalDupRemaining ? 0 : oldValue.TotalDupRemaining)
                //trigger
                if (newValue && newValue != oldValue) {
                    newValue.isChange = true;
                }

                var DaiBanTotal = vm.listInitDaiBan1.filter(x => x.LotteryChannelId == newValue.LotteryChannelId && x.AgencyId == newValue.AgencyId)[0];
                if (newValue.TotalDupRemaining == undefined) {
                    DaiBanTotal.TotalRemaining = DaiBanTotal.TotalRemaining + oldValue.TotalDupRemaining;
                    diemban.TotalDupRemaining = diemban.TotalDupRemaining - oldValue.TotalDupRemaining;
                    newValue.TotalDupRemaining = 0;
                    diemban.detail[index % diemban.detail.length].total = 0;
                    diemban.Info.forEach(function (item) {
                        if (item.Id == diemban.detail[index % diemban.detail.length].Id) {
                            diemban.detail[index % diemban.detail.length].total += item.TotalRemaining;
                            diemban.detail[index % diemban.detail.length].total += item.TotalDupRemaining;
                        }
                    })
                }
                else {
                    if (DaiBanTotal.TotalRemaining - (newValue.TotalDupRemaining - oldValue.TotalDupRemaining) >= 0) {
                        DaiBanTotal.TotalRemaining = DaiBanTotal.TotalRemaining - (newValue.TotalDupRemaining - oldValue.TotalDupRemaining);
                        diemban.TotalDupRemaining = diemban.TotalDupRemaining + (newValue.TotalDupRemaining - oldValue.TotalDupRemaining);
                        diemban.detail[index % diemban.detail.length].total = 0;
                        diemban.Info.forEach(function (item) {
                            if (item.Id == diemban.detail[index % diemban.detail.length].Id) {
                                diemban.detail[index % diemban.detail.length].total += item.TotalRemaining;
                                diemban.detail[index % diemban.detail.length].total += item.TotalDupRemaining;
                            }
                        })
                    } else {
                        newValue.TotalDupRemaining = oldValue.TotalDupRemaining;
                    }
                }
                vm.getSum();
                document.getElementById("quantity_dup_" + parent_index + "_" + index).value = newValue.TotalDupRemaining;
            }
            vm.onClick = function (parent_index, index) {
                document.getElementById("quantity_" + parent_index + "_" + index).focus();
            }
            vm.onClickDup = function (parent_index, index) {
                document.getElementById("quantity_dup_" + parent_index + "_" + index).focus();
            }
            vm.getSavingData = function () {
                var temp = [];
                vm.listSendData = [];
                vm.listInit1.forEach(function (item, index1) {
                    item.Info.forEach(function (diemban, index2) {
                        if (diemban.isChange == true) {
                            var temp1 = {
                                LotteryChannelId: diemban.LotteryChannelId,
                                AgencyId: diemban.AgencyId,
                                TotalReceived: diemban.TotalRemaining,
                                TotalDupReceived: diemban.TotalDupRemaining,
                                SalePointId: diemban.SalePointId
                            }
                            //Modify
                            var temp2 = vm.listInit1Bk[index1].Info[index2];
                            var temp3 = {
                                AgencyId: temp2.AgencyId,
                                SalePointId: temp2.SalePointId,
                                LotteryChannelId: temp2.LotteryChannelId,
                                TotalTrans: diemban.TotalRemaining - temp2.TotalRemaining,
                                TotalTransDup: diemban.TotalDupRemaining - temp2.TotalDupRemaining,
                                LotteryDate: vm.saveInfo.LotteryDate 
                            }
                            vm.listSendData.push(temp3)
                            temp.push(temp1)
                        }
                    })
                })
                return temp
            }


            vm.sendDataTL = function () {
                $rootScope.connection.invoke("SendMessage", "addLotteryManage", JSON.stringify(vm.listSendData)).catch(function (err) {
                    return console.error(err.toString());
                });
            }

            vm.save = function () {
                vm.isSaving = true;
                vm.saveInfo.LotteryDate = moment(vm.params.day, formatDate).format(outputDate);
                vm.saveInfo.ReceiveData = JSON.stringify(vm.getSavingData());

                activityService.distributeForSalesPoint(vm.saveInfo).then(function (res) {
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

        }]);
})();