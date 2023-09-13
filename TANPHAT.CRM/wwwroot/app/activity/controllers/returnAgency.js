(function () {
    app.controller('Activity.returnAgency', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService','dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';

            vm.isSaving = false;
            vm.params.day = moment(vm.params.day, formatDate).format('DD-MM-YYYY');

            vm.dayDisplay = dayOfWeekVN[moment(moment(vm.params.day, formatDate)).day()].Name + ", " + vm.params.day;
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);

            vm.lotteryDate = moment(vm.params.day, formatDate).format('YYYY-MM-DD');
            vm.TypeLottery = [
                { Name: 'listLottery', Type: "" },
                { Name: 'listScratchCard', Type: "Vé Cào" }
            ]

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

            vm.getHaveReturned = function (typeName, index=-1) {
                var sum = 0;
                //Total
                if (index < 0) {
                    vm[typeName].forEach(function (lottery) {
                        lottery.listAgency.forEach(function (agency) {
                            sum += agency.TotalHaveReturned
                        })
                    })
                } else {
                    vm[typeName][index].listAgency.forEach(function (agency) {
                        sum += agency.TotalHaveReturned
                    })
                }
                return sum;
            }

            vm.getSumAgency = function (typeName, sumName, agencyIndex=-1 ) {
                var sum = 0;
                if (agencyIndex < 0) {
                    vm[typeName].forEach(function (item) {
                        sum += item[sumName];
                    })
                } else {
                    vm[typeName].forEach(function (item) {
                        sum += item.listAgency[agencyIndex][sumName];
                    })
                }
                return sum;
            }

            vm.OnChangeValue = function (typeChannel, indexLottery, indexAgency) {
                //Sum = vm[typeChannel][indexLottery].Sum
                //
                var sum = vm[typeChannel][indexLottery].Sum;
                var model = vm[typeChannel][indexLottery].listAgency[indexAgency].Receiced;
                var modelDisplay = vm[typeChannel][indexLottery].listAgency[indexAgency].ReceicedDisplay;
                var canReturn = vm[typeChannel][indexLottery].listAgency[indexAgency].TotalCanReturn;

                var tmp = parseInt(modelDisplay.replace(/,/g, ''));

                if (sum - (tmp - model) < 0 || canReturn - (tmp - model) <0) {
                    modelDisplay = model.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
                } else {
                    canReturn = canReturn - (tmp - model);
                    sum = sum - (tmp - model);
                    model = tmp;
                }
                vm[typeChannel][indexLottery].Sum = sum;
                vm[typeChannel][indexLottery].listAgency[indexAgency].Receiced = model;
                vm[typeChannel][indexLottery].listAgency[indexAgency].ReceicedDisplay = modelDisplay;
                vm[typeChannel][indexLottery].listAgency[indexAgency].TotalCanReturn = canReturn;

                //
            }

            vm.intiDataLottery = function (name) {
                vm[name].forEach(function (lottery) {
                    //lottery.Id == LotteryChannelId
                    lottery.listAgency = angular.copy(vm.listAgency);
                    lottery.listAgency.forEach(function (agency) {
                        //agency.Id = AgencyId
                        var tmp = vm.listData.DataReceived.filter(x => x.AgencyId == agency.Id && x.LotteryChannelId == lottery.Id)
                        //THEM vm.listData.DataForReturn
                        agency.ReceicedDisplay = 0;
                        agency.Receiced = 0;

                        if (tmp && tmp[0]) {
                            agency.TotalReceiced = tmp[0].TotalReceived
                            agency.TotalHaveReturned = tmp[0].TotalHaveReturned
                            agency.TotalCanReturn = tmp[0].TotalCanReturn
                                
                        } else {
                            agency.TotalReceiced = 0
                            agency.TotalHaveReturned = 0
                            agency.TotalCanReturn=0
                        }
                    })

                    //THEM vm.listData.DataForReturn
                    if (vm.listData.DataForReturn && vm.listData.DataForReturn.length > 0) {
                        var tmpReturn = vm.listData.DataForReturn.filter(x => x.LotteryChannelId == lottery.Id)
                        if (tmpReturn && tmpReturn[0]) {
                            lottery.TotalTrans = tmpReturn[0].TotalTrans;
                            lottery.TotalTransDup = tmpReturn[0].TotalTransDup;
                            lottery.Sum = lottery.TotalTrans + lottery.TotalTransDup;
                        } else {
                            lottery.TotalTrans = 0;
                            lottery.TotalTransDup = 0;
                            lottery.Sum = 0;
                        }
                    }
                })
            }

            vm.init = function () {
                vm.listScratchCard = vm.listScratchCard.filter(x => x.IsScratchcard == true);
                try {
                    vm.listData.DataForReturn = JSON.parse(vm.listData[0].DataForReturn);
                } catch (err) { vm.listData.DataForReturn = [] };

                try {
                    vm.listData.DataReceived = JSON.parse(vm.listData[0].DataReceived);
                } catch (err) { vm.listData.DataReceived=[]}

                vm.TypeLottery.forEach(x => vm.intiDataLottery(x.Name))
                

                console.log("vm.listScratchCard", vm.listScratchCard);
                console.log("vm.listAgency", vm.listAgency);
                console.log("vm.listLottery", vm.listLottery);
                console.log("vm.listData", vm.listData);
  
            }
            vm.init();

            vm.getSaveData = function () {
                var tmp = []
                vm.TypeLottery.forEach(function (typeName) {
                    vm[typeName.Name].forEach(function (lottery) {
                        var totalTransDup = lottery.TotalTransDup;
                        lottery.listAgency.forEach(function (agency) {
                            if (agency.Receiced > 0) {
                                var trans = agency.Receiced;
                                var transDup = 0;
                                if (totalTransDup - agency.Receiced >= 0) {
                                    trans = 0;
                                    transDup = agency.Receiced;

                                    totalTransDup = totalTransDup - agency.Receiced;
                                } else if (totalTransDup>0) {
                                    transDup = totalTransDup;
                                    trans = agency.Receiced - totalTransDup;

                                    totalTransDup = 0;
                                }
                                tmp.push({
                                    LotteryDate: vm.lotteryDate,
                                    LotteryChannelId: lottery.Id,
                                    FromSalePointId: 0,
                                    ToAgencyId: agency.Id,
                                    TotalTrans: trans,
                                    TotalTransDup: transDup,
                                    IsScratchcard: lottery.IsScratchcard
                                })
                            }
                        })
                    })
                })

                return tmp;
            }

            vm.saveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                ActionType: 1,
                Date: moment().format('YYYY-MM-DD')
            }

            vm.save = function () {
                vm.isSaving = true;
                var data = vm.getSaveData();
                if (data == []) {
                    notificationService.warning("Không có thông tin để lưu");
                    vm.isSaving = false;
                } else {
                    vm.saveInfo.Data = JSON.stringify(data)
                    activityService.returnLottery(vm.saveInfo).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            notificationService.warning(res.Message);
                            vm.isSaving = false;
                        }
                    })
                }
               
            }
        }]);
})();