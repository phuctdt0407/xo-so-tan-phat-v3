(function () {
    app.controller('Activity.salesActivity', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'activityService', 'dashboardService', 'authService', '$uibModal', 'dayOfWeekVN', 'ddlService', 'reportService', 'ddlService', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, notificationService, activityService, dashboardService, authService, $uibModal, dayOfWeekVN, ddlService, reportService, ddlService, salepointService) {
            var vm = angular.extend(this, viewModel);
            $scope.isLoading = false;
            //-----------------------------Init func-----------------------------
            vm.isSaving = false;
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', 'DD-MM-YYYY'];
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.checkShow = false;
            vm.showLD = 'overlay-hide';
            vm.checkButtonTT = vm.params.clientType && vm.params.clientType != 1 ? false : true;

            vm.typeOfLottery = [
                { Id: 1, JSName: 'toDay', ApiName: 'TodayData', ListPrice:"Normal" },
                { Id: 2, JSName: 'nextDay', ApiName: 'TomorrowData', ListPrice: "Dup" },
                { Id: 3, JSName: 'scratchCardData', ApiName: 'ScratchcardData', ListPrice: "ScratchCard" }
            ]

            //
            vm.typeOfPrice = [
                { Id: 1, Name: 'mainLotteryTypeId' },
                { Id: 2, Name: 'mainLotteryDupTypeId' },
                { Id: 3, Name: 'mainScratchCardTypeId' }
            ]

            //Tách loại vé 
            vm.listPriceNormal = vm.listTypeSelect.filter(x => x.LotteryTypeIds.includes('1') && x.LotteryPriceId != 6)
            vm.listPriceDup = vm.listTypeSelect.filter(x => x.LotteryTypeIds.includes('2') && x.LotteryPriceId != 6)
            vm.listPriceScratchCard = vm.listTypeSelect.filter(x => x.LotteryTypeIds.includes('3') && x.LotteryPriceId != 6)
           
            //Khach le
            vm.mainLotteryTypeId = vm.listPriceNormal[0];
            vm.mainScratchCardTypeId = vm.listPriceScratchCard[0];
            vm.mainLotteryDupTypeId = vm.listTypeSelect.filter(x => x.LotteryPriceId == 6)[0];

            //console.log("vm.mainLotteryTypeId: ", vm.mainLotteryTypeId)
            //console.log("vm.mainScratchCardTypeId: ", vm.mainScratchCardTypeId)
            console.log("vm.listPriceScratchCard ", vm.listPriceScratchCard)

            //
            //

            if (!vm.listSellData.TodayData && !vm.listSellData.TomorrowData) {
                vm.noData = true;
            }

            //-----------------------------Single func---------------------------



            //SIGNR
            vm.isChangeValue = false;

            $rootScope.connection.on("ReceiveMessage", function (user, message) {
                if (user == ('SellActivitySalepoint' + vm.data.SalePointId) && message) {
                    var temp = JSON.parse(message);
                    if (temp.IsConfirm == true) {
                        var isSum = temp.TransitionTypeId == 2;
                        var data = JSON.parse(temp.Data);

                        data.forEach(function (item) {
                            vm.addData('toDay', item, isSum)

                            vm.addData('nextDay', item, isSum)
                        })
                    } else {
                        setTimeout(function () {
                            notificationService.warning("Trưởng nhóm vừa huỷ yêu cầu")
                        }, 500)
                    }
                } else if (user == ('addLotteryManage') && message) {
                    var temp = JSON.parse(message);

                    var info = temp.filter(x => x.SalePointId == vm.data.SalePointId);
                    if (info.length > 0) {
                        info.forEach(function (item) {
                            if (item.isTypeScratch) {
                                vm.addData('', item, true, true);
                            } else {
                                vm.addData('toDay', item, true)
                                vm.addData('nextDay', item, true)
                            }
                        })
                        vm.isChangeValue = true;
                        setTimeout(function () {
                            notificationService.success("Bạn vừa nhận thêm vé thêm từ người chia vé")
                        }, 500)
                    }
                }
            });

            vm.addData = function (targetName, data, isSum, isScratchCard = false) {
                try {
                    if (isScratchCard) {
                        var index = vm.data.ScratchCardData.findIndex(x => x.LotteryChannelId == data.LotteryChannelId);

                        if (index < 0) {
                            vm.isChangeValue = true;
                        } else {
                            if (isSum) {
                                vm.data.ScratchCardData[index].TotalRemaining += data.TotalTrans;
                            } else {
                                vm.data.ScratchCardData[index].TotalRemaining -= data.TotalTrans;
                            }
                            setTimeout(function () {
                                notificationService.success("Bạn vừa nhận thêm vé cào từ trưởng nhóm")
                                $rootScope.$apply(vm.data);
                            }, 500)
                        }
                    } else
                    if (vm.data[targetName] && vm.data[targetName].dayBK == data.LotteryDate) {
                        var tempLottery = vm.data[targetName].lottery.filter(x => x.LotteryChannelId == data.LotteryChannelId)[0];
                        var index = vm.data[targetName].lottery.findIndex(x => x.LotteryChannelId == data.LotteryChannelId);
                        if (index < 0) {
                            vm.isChangeValue = true;
                        }
                        else {
                            if (isSum) {
                                tempLottery.remaining += data.TotalTrans;
                                tempLottery.remainingBK += data.TotalTrans;
                                tempLottery.TotalRemaining += data.TotalTrans;
                                try {
                                    tempLottery.remainingDupBK += data.TotalTransDup;
                                    tempLottery.TotalDupRemaining += data.TotalTransDup;
                                    vm.isChangeValue = true;
                                } catch (err) { }

                            } else {
                                tempLottery.remaining -= data.TotalTrans;
                                tempLottery.remainingBK -= data.TotalTrans;
                                tempLottery.TotalRemaining -= data.TotalTrans;

                                try {
                                    tempLottery.remainingDupBK -= data.TotalTransDup;
                                    tempLottery.TotalDupRemaining -= data.TotalTransDup;
                                    vm.isChangeValue = true;
                                } catch (err) { }
                            }
                            vm.data[targetName].lottery[index] = tempLottery;
                        }

                        $rootScope.$apply(vm.data);
                        vm.getTotal();

                        setTimeout(function () {
                            notificationService.success("Trưởng nhóm vừa xác nhận yêu cầu")
                        }, 500)
                    }
                }
                catch (err) {
                    vm.isChangeValue = true;
                }
            }

            //SAVING
            vm.saving = {
                ShiftDistributeId: $rootScope.sessionInfo.ShiftDistributeId,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
            }

            //-----------------------------Muti func---------------------------

            vm.changeTab = function (tabId) {
                $rootScope.closeKeyBoard()
                vm.params.clientType = tabId
                $state.go($state.current, vm.params, { reload: false, notify: true, inherit: false });
            };

            vm.today = moment().format("YYYY-MM-DD");
            /// Data
            vm.initSubData = function (model) {
                var temp1 = JSON.parse(model);
                var isShowDup = false;
                var isScratchCard = false;
                //VE CAO KHONG CO NGAY XO
                if (!temp1[0].LotteryDate || temp1[0].LotteryDate.length == 0) {

                    temp1[0].Day = "Vé Cào";
                    isScratchCard = true;
                }
                else {
                    temp1[0].Day = vm.dayOfWeekVN[moment(temp1[0].LotteryDate).day()].Name + ", " + moment(temp1[0].LotteryDate).format('DD-MM-YYYY')
                }
                temp1.forEach(function (ele) {
                    //ShortName=> VE CAO
                    //LotteryChannelName=> VE TRUYEN THONG
                    ele.channel = ele.LotteryChannelName ? ele.LotteryChannelName : ele.ShortName;
                    ele.channelId = ele.LotteryChannelId;
                    ele.remaining = ele.TotalRemaining;
                    if (ele.TotalDupRemaining > 0) {
                        isShowDup = true;
                    }
                    ele.remainingBK = ele.TotalRemaining;
                    ele.remainingDupBK = ele.TotalDupRemaining;
                    ele["inputTemp"] = 0;
                    ele["inputSale_0"] = 0;
                    ele["inputSale_1"] = 0;
                    ele["inputSale_2"] = 0;
                    ele.isScratchCard = isScratchCard;
                    //Temp. INPUT cho 0 
                    //0. Ve 10 tang 1
                    //1. Ve trung
                    //2. Ve thuong
                })

                var temp = {
                    dayBK: temp1[0].LotteryDate ,
                    day: temp1[0].Day,
                    lottery: temp1,
                    isShowDup: isShowDup
                }
                return temp;
            }
            ///

            vm.getTotal = function () {
                vm.typeOfLottery.forEach(function (ele) {
                    var name = ele.JSName;
                    try {
                        if (vm.data[name].lottery && vm.data[name].lottery.length > 0) {
                            var sumData = {
                                Total: 0,
                                TotalMoney: 0,
                            }

                            vm.data[name].lottery.forEach(function (item) {
                                sumData.Total += (item.TotalRemaining ? item.TotalRemaining : 0) + (item.TotalDupRemaining ? item.TotalDupRemaining:0);
                                sumData.TotalMoney += (item.Sum ? item.Sum : 0);
                                item.totalRemainingBK = !item.totalRemainingBK ? item.remaining : item.totalRemainingBK;
                                item.TotalDupRemainingBK = !item.TotalDupRemainingBK ? item.TotalDupRemaining : item.TotalDupRemainingBK;
                                /*if (item.TotalDupRemaining == 0 && item.TotalRemaining == 0) {
                                    delete vm.data[name].lottery[item]
                                 
                                }*/

                            });

                            //SUM FULL 
                            vm['typeData' + ele.Id] = sumData
                            setTimeout(function () {
                                $rootScope.$apply([vm.typeData1, vm.typeData2, vm.typeData3])
                            }, 200)
                        }
                    } catch (err) { }

                })
            }
          
            vm.initData = function () {
                var temp = {
                    SalePointId: 0,
                    SalePointName: "Không tìm thấy ca trực",
                    ShiftDistributeId: 0
                }

                var list = vm.listSellData;

                if (list) {
                    temp.SalePointId = list.SalePointId;
                    temp.SalePointName = list.SalePointName;
                    temp.ShiftDistributeId = list.ShiftDistributeId

                    vm.typeOfLottery.forEach(function (item) {
                        if (list[item.ApiName]) {
                            temp[item.JSName] = vm.initSubData(list[item.ApiName]);
                        }
                    })
                }
                temp.soldData = JSON.parse(list.SoldData);
                vm.data = temp;
                vm.getTotal();

            }

            vm.initData();
            console.log("vm.listSellData.ManagerName", vm.listSellData);
            vm.getSum = function (model) {
                console.log("model", model);
                
           
                var getType = model.isScratchCard ? 2 : 0;

                console.log("getType", getType);
                model.Sum = 0;
                for (let i = 0; i <= 2; i++) {
                    try {
                        if (i == 0) {

                            var getName = vm.typeOfPrice[1].Name;
                            console.log("vm", vm);

                            var getPrice = vm[getName].Price;
                            //var getPrice = vm.wholesaleData.WholesalePrice;
                            console.log("getName", getName);
                            if (9090.9 == getPrice) {
                                model.Sum += Math.ceil(model["inputSale_" + i] * 10000 / 11 * 10)
                                console.log("vào đây", model.Sum);
                            }
                        } else {


                            var getName = vm.typeOfPrice[getType].Name;
                            var getPrice=0
                            if (model.ShortName == 'Vé Bóc' || model.ShortName == 'Cào XO' ) {
                                getPrice = 5000;
                            } else if ( model.ShortName == 'Cào ĐN') {
                                getPrice = 10000;
                            }
                            else if (model.ShortName == 'Cào XO 2k') {
                                getPrice = 2000;
                            } else if (model.ShortName == 'Cào TP') {
                                if (vm.wholesaleData != null) {
                                  
                                    getPrice = vm.wholesaleData.ScratchPrice;

                                }
                                else {
                         
                                    getPrice = vm[getName].Price;
                                }
                               
                            } else { 
                                
                                if (vm.wholesaleData != null) {
                              
                                    getPrice = vm.wholesaleData.WholesalePrice;

                                }
                                else {
                                    console.log("Vào đây2");
                                    getPrice = vm[getName].Price;
                                }
                            }

                            model.Sum += Math.ceil(getPrice * model["inputSale_" + i])
                        }
                    } catch (err) {
                        notificationService.warning("Error");
                    }
                }
                // model.Sum = (model.Sum).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
            }

            //
            vm.ChangeValueSaleModify = function (channel, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    channel["inputTemp"] = 0;
                    channel.TotalDupRemaining += oldValue * 11;
                } else {
                    if (channel.TotalDupRemaining - (newValue - oldValue) * 11 >= 0) {
                        channel.TotalDupRemaining -= (newValue - oldValue) * 11;
                    } else {
                        channel["inputTemp"] = oldValue;
                    }
                }
                channel["inputSale_0"] = channel["inputTemp"] * 11;
                vm.getSum(channel);
                vm.getTotal();
                if (vm.params.clientType == 3) {
                    vm.getTotalBuy();

                }
               
            }
          
            /// Change value 
            vm.ChangeValueSale = function (channel, typePrice, type, newValue = 0, oldValue = 0) {
                vm.mainLotteryTypeId = vm.listPriceNormal[0];
                vm.mainScratchCardTypeId = vm.listPriceScratchCard[0];
                vm.mainLotteryDupTypeId = vm.listTypeSelect.filter(x => x.LotteryPriceId == 6)[0];

                /*console.log("vm.mainLotteryTypeId4444: ", vm["mainLotteryTypeId"])
                console.log("channel", channel)
                console.log("typePrice",typePrice)
                console.log("type", type)*/
                //typePrice
                //0. GIA SI hoac GIA LE
                //1. GIA VE 10 TANG 1
                //2. GIA VE CAO

                //type
                //0. VE COC 10 TANG 1
                //1. VE TRUNG
                //2. VE THUONG
                console.log("channel", channel)
                console.log("typePrice", typePrice)
                if (newValue == null) {
                    channel["inputSale_" + type] = 0;
                    channel.remaining += oldValue;
                    if (type < 2) {
                        channel.TotalDupRemaining += oldValue;
                    } else {
                        channel.TotalRemaining += oldValue;
                    }
                }
                else {
                    var getName = vm.typeOfPrice[typePrice].Name;
                    console.log("getName1: ", String(getName))
                    
                    var step = vm[String(getName)].Step;

                    console.log("step: ", step)
                    

                    if (newValue % step != 0) {
                        if (newValue < oldValue) {
                            newValue = newValue - newValue % step;
                            channel["inputSale_" + type] = newValue;
                        } else {
                            newValue = newValue + (step - newValue % step);
                            channel["inputSale_" + type] = newValue;
                        }
                    }
                    if (type < 2 && channel.TotalDupRemaining - (newValue - oldValue) >= 0) {
                        channel.TotalDupRemaining -= (newValue - oldValue);
                    } else {
                        if (type == 2 && channel.remaining - (newValue - oldValue) >= 0) {
                            channel.remaining = channel.remaining - (newValue - oldValue);
                            channel.TotalRemaining -= (newValue - oldValue);
                        } else {
                            channel["inputSale_" + type] = oldValue;
                        }
                    }
                }
                setTimeout(function () {
                    $rootScope.$apply(channel)
                },200)

                vm.getSum(channel);
                vm.getTotal();
                if (vm.wholesaleData) {
                    vm.getTotalBuy()
                    console.log("Vào ddaaay1111112 ");
                }
                console.log("Vào ddaaay ");
            }

            /// Open Modal
            vm.openModalTransfer = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalTransfer = $uibModal.open({
                    params: {
                        day: {
                            value: '',
                            squash: true
                        }
                    },
                    templateUrl: viewPath + 'transfer.html' + versionTemplate,
                    controller: 'Activity.transfer as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService',
                            function ($q, $stateParams, ddlService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                                $q.all([
                                    ddlService.lotteryChannelDDL({
                                        regionId: 2,
                                        lotteryDate: params.day
                                    }),
                                ]).then(function (res) {
                                    var result = {
                                        ManagerId:vm.listSellData.ManagerId,
                                        ManagerName:vm.listSellData.ManagerName,
                                        listLottery: res[0],
                                        data: angular.copy(vm.data)
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });
                modalTransfer.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                    });
                });

                modalTransfer.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                    }
                });
            }

            vm.openModalReceiving = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalReceiving = $uibModal.open({
                    params: {
                        day: {
                            value: '',
                            squash: true
                        }
                    },
                    templateUrl: viewPath + 'receiving.html' + versionTemplate,
                    controller: 'Activity.receiving as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'activityService',
                            function ($q, $stateParams, ddlService, activityService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);

                                var nextDay = moment(vm.today).add(1,'days').format('YYYY-MM-DD')

                                $q.all([
                                    activityService.getDataInventory({
                                        date: vm.today
                                    }),
                                    ddlService.lotteryChannelDDL({
                                        regionId: 2,
                                        lotteryDate: vm.today
                                    }),
                                    ddlService.lotteryChannelDDL({
                                        regionId: 2,
                                        lotteryDate: nextDay
                                    }),
                                ]).then(function (res) {
                                    var result = {
                                        ManagerId:vm.listSellData.ManagerId,
                                        ManagerName:vm.listSellData.ManagerName,
                                        dataInventory: res[0],
                                        listLotteryToday: res[1],
                                        listLotteryNextDay: res[2],
                                        data: angular.copy(vm.data)
                                    };

                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalReceiving.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                    });
                });

                modalReceiving.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.openModalReturn = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalReturn = $uibModal.open({
                    params: {
                        day: {
                            value: '',
                            squash: true
                        }
                    },
                    templateUrl: viewPath + 'return.html' + versionTemplate,
                    controller: 'Activity.return as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService',
                            function ($q, $stateParams, ddlService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                                $q.all([
                                    ddlService.userByTitleDDL({
                                        UserTitleId: 4
                                    }),
                                    ddlService.lotteryChannelDDL({
                                        regionId: 2,
                                        lotteryDate: params.day
                                    }),
                                ]).then(function (res) {
                                    var result = {
                                        managerList: res[0],
                                        listLottery: res[1],
                                        data: angular.copy(vm.data)
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalReturn.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                    });
                });

                modalReturn.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.openModalPayingDebt = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalPayingDebt = $uibModal.open({
                    templateUrl: viewPath + 'payingDebt.html' + versionTemplate,
                    controller: 'Activity.payingDebt as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: {
                            data: vm.data
                        }
                    }
                });

                modalPayingDebt.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                    });
                });

                modalPayingDebt.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.openModalActivityLog = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalActivityLog = $uibModal.open({
                    params: {
                        day: {
                            value: '',
                            squash: true
                        },
                        p: {
                            value: '1',
                            squash: true
                        },
                        ps: {
                            value: '99999',
                            squash: true
                        },
                    },
                    templateUrl: viewPath + 'activityLog.html' + versionTemplate,
                    controller: 'Activity.activityLog1 as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'reportService', 'salepointService', 'ddlService',
                            function ($q, $stateParams, userService, activityService, reportService, salepointService, ddlService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                                params.p = !parseInt(params.p) || parseInt(params.p) < 1 ? 1 : params.p;
                                params.ps = !parseInt(params.ps) || parseInt(params.ps) < 1 ? 99999 : params.ps;


                                $q.all([
                                    activityService.getSalePointLog({
                                        UserRoleId: $rootScope.sessionInfo.UserRoleId,
                                        ShiftDistributeId: vm.data.ShiftDistributeId,
                                        SalePointId: vm.data.SalePointId,
                                        Date: moment(vm.data.toDay.dayBK).format("YYYY-MM-DD")
                                    }),
                                    activityService.getRepaymentLog({
                                        UserRoleId: $rootScope.sessionInfo.UserRoleId,
                                        ShiftDistributeId: vm.data.ShiftDistributeId,
                                        SalePointId: vm.data.SalePointId,
                                        Date: moment(vm.data.toDay.dayBK).format("YYYY-MM-DD")
                                    }),
                                    activityService.getWinningList({

                                        shiftDistributeId: vm.data.ShiftDistributeId,
                                        //UserRoleId:$rootScope.sessionInfo.UserRoleId,
                                        salePointId: vm.data.SalePointId,
                                        date: moment(vm.data.toDay.dayBK).format("YYYY-MM-DD")
                                    }),
                                    activityService.getSoldLogDetail({
                                        UserRoleId: $rootScope.sessionInfo.UserRoleId,
                                        ShiftDistributeId: vm.data.ShiftDistributeId,
                                    }),

                                    activityService.getTransLogDetail({
                                        ShiftDistributeId: vm.data.ShiftDistributeId,
                                    }),
                                    ddlService.lotteryChannelDDL({
                                        regionId: 2,
                                        lotteryDate: params.day
                                    }),

                                    salepointService.getListHistoryOrder({ shiftDistributeId: vm.data.ShiftDistributeId, p: params.p, ps: params.ps })
                                ]).then(function (res) {
                                    let listSales = res[0].filter(ele => ele.TransitionTypeId == 0)
                                    let listTransfer = res[0].filter(ele => ele.TransitionTypeId != 0)
                                    var result = {
                                        params: params,
                                        listSalePointLog: listSales,
                                        listTransferLog: listTransfer ,
                                        listPayingDebtLog: res[1],
                                        listWinning: res[2],
                                        listSold: res[6],
                                        listTrans: res[4],
                                        listLottery: res[5],
                                        data: vm.data,
                                        listSellData:vm.listSellData,
                                    };

                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalActivityLog.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalActivityLog.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.openModalWinningLottery = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var WinningLottery = $uibModal.open({
                    templateUrl: viewPath + 'winningLottery.html' + versionTemplate,
                    controller: 'Activity.winningLottery as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                    ddlService.winningTypeDDL(),
                                    ddlService.lotteryChannelDDL({
                                        RegionId: 2,
                                        LotteryDate: null
                                    }),
                                    ddlService.salePointDDL()
                                ]).then(function (res) {
                                    var result = {
                                        winningTypeDDL: res[0],
                                        channels: res[1],
                                        salePoints: res[2],
                                        data: vm.data
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                WinningLottery.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                    });
                });

                WinningLottery.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.openModalSummary = function (flag) {
                var spiner = document.getElementById("showSpiner");
                spiner.style.display = "inline-block"
                vm.showLD = "overlay"
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalSummary = $uibModal.open({
                    params: {
                        day: {
                            value: '',
                            squash: true
                        }
                    },
                    templateUrl: viewPath + 'summary.html' + versionTemplate,
                    controller: 'Activity.summary as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService','activityService',
                            function ($q, $stateParams, ddlService, reportService, activityService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                                $q.all([
                                    reportService.reuseReportDataFinishShift({
                                        UserRole: $rootScope.sessionInfo.UserRoleId,
                                        shiftDistributeId: vm.data.ShiftDistributeId
                                    }),
                                    ddlService.lotteryChannelDDL({
                                        regionId: 2,
                                        lotteryDate: params.day
                                    }),
                                    activityService.getTransLogDetail({
                                        ShiftDistributeId: vm.data.ShiftDistributeId,
                                    }),
                                    reportService.reportLotteryInADay({
                                        SalePointId : vm.data.SalePointId,
                                        Date : moment().format('YYYY-MM-DD'),
                                        ShiftId : vm.params.shiftId
                                    })


                                ]).then(function (res) {
                                    console.log("res3",res[3])
                                    var result = {
                                        flag: flag,
                                        dataSummary: res[0],
                                        listLottery: res[1],
                                        listTrans:res[2],
                                        listReportLottery:res[3],
                                        data: vm.data,
                                        ShiftDistributeId: vm.params.shiftDistributeId
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalSummary.opened.then(function (res) {
                    spiner.style.display = "none"
                    vm.showLD = "overlay-hide"
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '70%')
                    });
                });

                modalSummary.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.openModalInput4LastNum = function (model, day, index) {
                if (!model.ListDetail) {
                    model.ListDetail = []
                }
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalInput4LastNum = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'input4LastNum.html' + versionTemplate,
                    controller: 'Activity.input4LastNum as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService',
                            function ($q, $stateParams, ddlService, reportService, activityService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        model: model,
                                        mainLotteryTypeId: vm.mainLotteryTypeId,
                                        mainScratchCardTypeId: vm.mainScratchCardTypeId,
                                        mainLotteryDupTypeId: vm.mainLotteryDupTypeId,
                                        typeOfPrice: vm.typeOfPrice,
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });

                modalInput4LastNum.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalInput4LastNum.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                        setTimeout(function () {
                            $rootScope.$apply(model);
                        }, 20)
                        vm.data[day].lottery[index] = data
                        vm.getSum(model)
                        vm.getTotal();
                        if (vm.wholesaleData) {
                            vm.getTotalBuy()
                        }
                    }
                });
            }

            vm.openModalFeeOutside = function (shiftDistributeId) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalFeeOutside = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'feeOutsideOfSalePoint.html' + versionTemplate,
                    controller: 'Activity.feeOutsideOfSalePoint as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService','salepointService',
                            function ($q, $stateParams, ddlService, reportService, activityService, salepointService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                $q.all([
                                    ddlService.getTypeNameDDL({
                                        transactionTypeId: 1,
                                    }),
                                    salepointService.getListFeeOutsite({
                                        shiftDistributeId: shiftDistributeId,
                                    }),
                                    ddlService.salePointDDL()
                                ]).then(function (res) {
                                    var result = {
                                        data: vm.data,
                                        listTypeOfFee: res[0],
                                        listFee: res[1],
                                        listSalePoint: res[2],
                                        ShiftDistributeId: vm.params.shiftDistributeId
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalFeeOutside.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalFeeOutside.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.openModalPurchaseHistory = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalFeeOutside = $uibModal.open({
                    params: {
                        p: {
                            value: '1',
                            squash: true
                        },
                        ps: {
                            value: '100',
                            squash: true
                        },
                        guestId: {
                            value: vm.wholesaleData.GuestId,
                            squash: true
                        }
                    },
                    templateUrl: viewPath + 'purchaseHistory.html' + versionTemplate,
                    controller: 'Activity.purchaseHistory as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService', 'salepointService',
                            function ($q, $stateParams, ddlService, reportService, activityService, salepointService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                params.p = params.p ? params.p : '1'
                                params.ps = params.ps ? params.ps : '100'
                                $q.all([
                                    salepointService.getListHistoryOfGuest({
                                        p: params.p,
                                        ps: params.ps,
                                        guestId: vm.wholesaleData.GuestId
                                    })
                                ]).then(function (res) {
                                    var result = {
                                        params: params,
                                        data: vm.data,
                                        historyLog: res[0],
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalFeeOutside.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalFeeOutside.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.getSaveData = function (model) {
                var temp = [];
                model.forEach(function (item) {
                    for (let i = 0; i <= 2; i++) {
                        if (i == 0) {
                            if (item["inputSale_0"] > 0) {
                                var temp1 = {
                                    LotteryDate: item.LotteryDate == "VE_CAO" ? null : item.LotteryDate,
                                    IsScratchcard: item.isScratchCard,
                                    LotteryChannelId: item.LotteryChannelId,
                                    Quantity: item["inputSale_0"],
                                    LotteryTypeId: 2,
                                    LotteryPriceId: 6,
                                };
                                temp.push(temp1);
                            }
                        } else if (i == 2 && !item.isScratchCard) {
                            if (item["inputSale_" + i] > 0) {
                                var getType = item.isScratchCard ? 2 : 0;
                                item.ListDetail.forEach(function (ele) {
                                    var temp1 = {
                                        LotteryDate: item.LotteryDate == "VE_CAO" ? null : item.LotteryDate,
                                        IsScratchcard: item.isScratchCard,
                                        LotteryChannelId: item.LotteryChannelId,
                                        Quantity: ele.input,
                                        FourLastNumber: ele.fourLastNumber,
                                        LotteryTypeId: i == 1 ? 2 : (item.isScratchCard ? 3 : 1),
                                        LotteryPriceId: (item.LotteryChannelId==1002||item.LotteryChannelId==1003)?10:(item.LotteryChannelId==1004)?11:vm[vm.typeOfPrice[getType].Name].LotteryPriceId
                                    }
                                    temp.push(temp1);
                                })
                            }
                        } else if (item["inputSale_" + i] > 0) {

                            var getType = item.isScratchCard ? 2 : 0;
                            console.log("check",vm[vm.typeOfPrice[getType].Name].LotteryPriceId)
                            var temp1 = {
                                LotteryDate: item.LotteryDate == "VE_CAO" ? null : item.LotteryDate,
                                IsScratchcard: item.isScratchCard,
                                LotteryChannelId: item.LotteryChannelId,
                                Quantity: item["inputSale_" + i],
                                LotteryTypeId: i == 1 ? 2 : (item.isScratchCard? 3:1),
                                LotteryPriceId: (item.LotteryChannelId==1002||item.LotteryChannelId==1003)?10:(item.LotteryChannelId==1004)?11:vm[vm.typeOfPrice[getType].Name].LotteryPriceId
                            };
                            temp.push(temp1);
                        }
                    }
                })
                return temp;
            }

            vm.save = function () {
                vm.isSaving = true

                vm.saving.Data = []

                vm.typeOfLottery.forEach(function (ele) {
                    if (vm.data[ele.JSName]) {
                        vm.saving.Data = vm.saving.Data.concat(vm.getSaveData(vm.data[ele.JSName].lottery));
                    }
                })

                var saveBill = {
                    FullAddress: vm.listSellData.SalePointAddress,
                    SalePoint: vm.listSellData.SalePointName,
                    DatePrint: moment().format('DD/MM/YYYY'),
                    ShiftName: vm.params.shiftId == 1 ? "Ca Sáng" : "Ca Chiều",
                    DateTime: moment().format('HH:mm:ss'),
                    ActionName: $rootScope.sessionInfo.FullName,
                    CustomerName: "Khách lẻ",
                    ListInfo: [],
                    TotalQuatity: 0,
                    Sum: 0,
                    CustomerGive: 0,
                    TotalDebt: 0,
                    OldDebt: 0,
                    NewDebt: 0,
                    PromotionCode:'',
                    ChannelName:'',
                }

                vm.saving.Data.forEach(function (item) {
                    var temp = {
                        LotteryName: vm.listLottery.find(x => x.Id == item.LotteryChannelId).ShortName,
                        Quantity: item.Quantity,
                        FourLastNumber: item.FourLastNumber ? ('-->' + item.FourLastNumber) : '',
                        Price: (item.LotteryChannelId==1002||item.LotteryChannelId==1003)?(item.Quantity*5000):(item.LotteryChannelId==1004)?(item.Quantity*2000):(item.LotteryPriceId != 6) ? (item.Quantity * vm.listTypeSelect.find(x => x.LotteryPriceId == item.LotteryPriceId).Price) : (item.Quantity*10000/11*10)
                    }
                    saveBill.ListInfo.push(temp)
                    saveBill.TotalQuatity += temp.Quantity;
                    saveBill.Sum += temp.Price;
                    console.log("temp", temp);
                })

                var resultCompareChannel = [
                    {
                        dayId:0 ,
                        name: 'Kon Tum'
                    },
                    {
                        dayId:1 ,
                        name: 'Thừa Thiên Huế'
                    },

                    {
                        dayId:2 ,
                        name: 'Đăk Lăk'
                    },
                    {
                        dayId:3 ,
                        name: 'Đà Nẵng'
                    },
                    {
                        dayId:4 ,
                        name: 'Quảng Trị'
                    },
                    {
                        dayId:5 ,
                        name: 'Ninh Thuận'
                    },
                    {
                        dayId:6 ,
                        name: 'Quảng Ngãi'
                    },

                ]


                saveBill.CustomerGive = saveBill.Sum
                saveBill.TotalDebt = 0

                if (vm.saving.Data.length == 0) {
                    notificationService.warning("Không có gì để lưu");
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)

                    }, 400)
                } else {
                    
                    var temp =   vm.saving.Data.filter(ele=>ele.IsScratchcard == false );

                    var listDate = temp.map(function(ele) {
                        return ele.LotteryDate;
                    })

                    console.log("listDate",listDate)
                    var maxDate = moment.max(listDate.map(function(date) {
                        return moment(date,'YYYY-MM-DD');
                    }));
                    var minDate = moment.min(listDate.map(function(date) {
                        return moment(date,'YYYY-MM-DD');
                    }));
                    console.log(minDate)
                    console.log(maxDate)
                    // var date = 
                    if(temp.find(ele=>moment(ele.LotteryDate,'YYYY-MM-DD').day() != moment().day()) ){
                        ///trong đơn hàng có vé ngày hôm khác 
                        console.log("case 1 - trong đơn hàng có vé ngày hôm khác ")
                        if(moment().day() == 6){
                            console.log("case 1.1")
                            saveBill.ChannelName = resultCompareChannel.find(ele=>ele.dayId == 0).name + ' ' + moment(maxDate).format('DD/MM/YYYY')
                            
                        }else{
                            console.log("case 1.2")
                            saveBill.ChannelName = resultCompareChannel.find(ele=>(ele.dayId == moment().day() + 1)).name + ' ' + moment(maxDate).format('DD/MM/YYYY')
                        }
                    }else{
                        ///trong đơn hàng chỉ có vé ngày hôm nay 
                        console.log("case 2 - trong đơn hàng chỉ có vé ngày hôm nay ")
                        saveBill.ChannelName = resultCompareChannel.find(ele=>(ele.dayId == moment().day())).name + ' ' + moment(minDate).format('DD/MM/YYYY')
                    
                    }
                    vm.saving.Data = JSON.stringify(vm.saving.Data);

                    activityService.sellLottery(vm.saving).then(async function (res) {
                        if(res.PromotionCode==null && res.PromotionCode == undefined){
                            saveBill.PromotionCode = ""
                            saveBill.ChannelName = ""
                        }else{
                            saveBill.PromotionCode = res.PromotionCode.substring(1,res.PromotionCode.length-1).split(',').join(' | \n')


                        }
                        
                        vm.isSaving = false
                        if (res && res.Id > 0) {
                            vm.data.toDay.lottery.forEach(function (res) {
                                res.totalRemainingBK = res.remaining;
                                res.TotalDupRemainingBK = res.TotalDupRemaining;
                            });
                            saveBill.BillNumber = $rootScope.createBillNumber(res.OrderId)
                            vm.typeOfLottery.forEach(function (ele) {
                                if (vm.data[ele.JSName]) {
                                    vm.data[ele.JSName].lottery.forEach(e => {
                                        vm.data.soldData[0].TotalRetailQuantity += e.inputSale_0;
                                        vm.data.soldData[0].TotalRetailPrice += Math.ceil(e.inputSale_0 * vm.mainLotteryDupTypeId.Price);

                                        var getNum = e.isScratchcard ? 2 : 0;
                                        for (let i = 1; i <= 2; i++) {
                                            var detail = vm[vm.typeOfPrice[getNum].Name]
                                            // vm[vm.typeOfPrice[getNum].Name]~ vm.mainLotteryDupTypeId
                                            if (detail.LotteryPriceId == 1) {
                                                vm.data.soldData[0].TotalRetailQuantity += e['inputSale_' + i];
                                                vm.data.soldData[0].TotalRetailPrice += e['inputSale_' + i] * detail.Price;
                                            } else {
                                                vm.data.soldData[0].TotalWholesaleQuantity += e['inputSale_' + i];
                                                vm.data.soldData[0].TotalWholesalePrice += e['inputSale_' + i] * detail.Price;
                                            }
                                        }
                                        e.ListDetail = []
                                        e.inputSale_0 = 0
                                        e.inputSale_1 = 0
                                        e.inputSale_2 = 0
                                        e.inputTemp = 0
                                        e.Sum = 0
                                    })
                                }
                            })

                            vm.getTotal();

                            notificationService.success("Thao tác thành công");
                            $rootScope.connection.invoke("SendMessage", "ChangeRemain", "Change").catch(function (err) {
                                return console.error(err.toString());
                            });
                            $rootScope.printBill(saveBill, 1);
                        }
                    })
                }
            }

            //Bán sỉ:
            vm.returnLottery = 1;
            vm.returnData = {
                data: [],
                totalReturn: 0
            }
            vm.totalBuy = 0;

            vm.PaymentData = [
                {
                    TotalPrice: 0,
                    FormPaymentId: 1,
                },
                {
                    TotalPrice: 0,
                    FormPaymentId: 2,
                    Note: ''
                }
            ]

            vm.changeReturnTab = function (tab) {
                vm.returnLottery = tab
            }
            vm.listWholesaleGuest = null;
            vm.wholesaleData = null

            //Lấy danh sách khách sỉ: CanBuyWholesale = true
            if (vm.params.clientType == 2) {
                ddlService.getGuestDDL({ salePointId: vm.data.SalePointId }).then(async function (res) {
                    vm.listWholesaleGuest = res.filter(x => x.CanBuyWholesale);
                })
            }
           
            //Lấy danh sách khách nợ: CanBuyWholesale = false
            if (vm.params.clientType == 3) {
                ddlService.getGuestDDL({ salePointId: vm.data.SalePointId }).then(async function (res) {
                    vm.listWholesaleGuest = res.filter(x => !x.CanBuyWholesale);
                })
            }

            //Lấy data khách sỉ/khách nợ
            vm.loadWholesaleData = function (selected) {
                vm.wholesaleData = selected
                if (selected.CanBuyWholesale) {
                    vm.mainLotteryTypeId = vm.listPriceNormal.filter(x => x.LotteryPriceId == selected.WholesalePriceId)[0];
                    vm.mainScratchCardTypeId = vm.listPriceScratchCard.filter(x => x.LotteryPriceId == selected.ScratchPriceId)[0];
                }
                vm.newDebt = vm.wholesaleData.Debt;
                vm.returnForGuest = {
                    Debt: vm.wholesaleData.Debt < 0 ? (0 - vm.wholesaleData.Debt) : 0,
                    Input: 0
                }
                salepointService.getDataForGuestReturn({ date: moment().format('YYYY-MM-DD'), guestId: selected.GuestId }).then(function (res) {
                    vm.returnData.data = res
                    vm.returnData.data.forEach(function (item) {
                        item.LotteryName = vm.listLottery.find(x => x.Id == item.LotteryChannelId).ShortName
                        item.InputReturn = 0;
                        item.SumReturn = 0;
                        item.Day = item.IsScratchcard ? '' : moment().format('DD/MM/YYYY');
                    })
                })
            }


            /*Nhập số tiền thanh toán*/
            vm.changeValuePayment = function (payment, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    payment.TotalPrice = 0
                    vm.newDebt += oldValue
                } else {
                    if (vm.newDebt - (newValue - oldValue) >= 0) {
                        vm.newDebt -= (newValue - oldValue)
                    } else {
                        payment.TotalPrice = oldValue;
                    }
                }
            }

            vm.changeInputReturnForGuest = function (model, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    vm.returnForGuest.Input = 0
                    vm.returnForGuest.Debt += oldValue
                } else {
                    if (vm.returnForGuest.Debt - (newValue - oldValue) >= 0) {
                        vm.returnForGuest.Debt -= (newValue - oldValue)
                    } else {
                        vm.returnForGuest.Input = oldValue;
                    }
                }

            }

            //Check xem có mã thanh toán hay chưa
            vm.checkCode = function () {
                return vm.PaymentData[1].TotalPrice > 0
            }

            //Tổng tiền mua mới
            vm.getTotalBuy = function () {
                vm.totalBuy = 0;
                for (var i = 1; i <= 3; i++) {
                    if (vm['typeData' + i] && vm['typeData' + i].TotalMoney) {
                        vm.totalBuy += vm['typeData' + i].TotalMoney
                    }
                }
                vm.getNewDebt();
            }
      
            // Nợ mới
            vm.getNewDebt = function () {
                vm.newDebt = vm.wholesaleData.Debt - vm.returnData.totalReturn + vm.totalBuy - (vm.PaymentData[0].TotalPrice + vm.PaymentData[1].TotalPrice);
                vm.returnForGuest.Debt = vm.newDebt < 0 ? (0 - vm.newDebt) : 0
            }

            //
            vm.changeInputReturn = function (model, newValue = 0, oldValue = 0) {
                if (newValue == null) {
                    model.InputReturn = 0
                    model.TotalCanReturn += oldValue
                } else {
                    if (model.TotalCanReturn - (newValue - oldValue) >= 0) {
                        model.TotalCanReturn -= (newValue - oldValue)
                    } else {
                        model.InputReturn = oldValue;
                    }
                }
                vm.getSumReturn(model);
                vm.getTotalReturn();
            }

            vm.getSumReturn = function (model) {
                if (model.IsScratchcard) {
                    model.SumReturn = Math.ceil(model.InputReturn * vm.mainScratchCardTypeId.Price)
                } else {
                    model.SumReturn = Math.ceil(model.InputReturn * vm.mainLotteryTypeId.Price)
                }
            }

            vm.getTotalReturn = function () {
                vm.returnData.totalReturn = 0;
                vm.returnData.data.forEach(function (item) {
                    vm.returnData.totalReturn += item.SumReturn;
                })
                vm.getNewDebt();
            }

            vm.openModalSellToWholesale = function () {
                $rootScope.closeKeyBoard()
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalSellToWholeSale = $uibModal.open({
                    templateUrl: viewPath + 'sellToWholesaleDetail.html' + versionTemplate,
                    controller: 'Activity.sellToWholesaleDetail as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService', 'salepointService',
                            function ($q, ddlService, salepointService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        params: vm.params,
                                        listSellData: vm.listSellData,
                                        wholesaleData: vm.wholesaleData,
                                        typeOfLottery: vm.typeOfLottery,
                                        listLottery: vm.listLottery,
                                        typeOfPrice: vm.typeOfPrice,
                                        listTypeSelect: vm.listTypeSelect,
                                        PaymentData: vm.PaymentData,
                                        returnForGuest: vm.returnForGuest,
                                        saving: vm.saving,
                                        data: vm.data,
                                        returnData: vm.returnData,
                                        mainLotteryTypeId: vm.mainLotteryTypeId,
                                        mainScratchCardTypeId: vm.mainScratchCardTypeId,
                                        mainLotteryDupTypeId: vm.mainLotteryDupTypeId,
                                        totalBuy: vm.totalBuy,
                                        newDebt: vm.newDebt
                                    };
                                    deferred.resolve(result);
                                });
                               
                                return deferred.promise;
                            }]
                    },
                });
                modalSellToWholeSale.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalSellToWholeSale.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                    }
                });
            }
            console.log("vm.data: ", vm.data);


            //$('.header_title').text('Bán hàng: '+vm.data.SalePointName +' - '+ (vm.params.shiftId == 1 ? "Ca 1" : "Ca 2"))

            /*setTimeout(function () {
                 $rootScope.headerTitle = 'Bán hàng: ' + vm.data.SalePointName + ' - ' +( vm.params.shiftId == 1 ? "Ca 1" : "Ca 2")
                 $rootScope.$apply($rootScope.headerTitle)
             }, 500)*/
            
            
            
            
        }]);
})();