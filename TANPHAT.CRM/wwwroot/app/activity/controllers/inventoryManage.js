(function () {
    app.controller('Activity.InventoryManage', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', '$uibModal', 'dayOfWeek', 'userService', 'notificationService','dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, sortIcon, $uibModal, dayOfWeek, userService, notificationService, dayOfWeekVN ) {
            var vm = angular.extend(this, viewModel);
            var arrSortIcon = sortIcon;
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';
            vm.params.day = moment(vm.params.day, formatDate).format('DD-MM-YYYY');

            vm.dayDisplay = dayOfWeekVN[moment(moment(vm.params.day, formatDate)).day()].Name + ", " + vm.params.day;
            vm.changeDate = function () {
                $state.go($state.current, { day: moment(vm.params.day, formatDate).format(outputDate) }, { reload: true, notify: true });
            }


            vm.init = function () {

                vm.TotalDataChart = [];

                var tempGrpBy = $rootScope.GrpBy(vm.listInventory, "LotteryChannelName");
                var listKey = Object.keys(tempGrpBy);
                var listValue = Object.values(tempGrpBy)

                vm.dataDaiBan = [];

                vm.listInventory = Enumerable.From(vm.listInventory)
                    .GroupBy(function (item) { return item.SalePointId; })
                    .Select(function (item, i) {
                        var receive = 0;
                        var transfer = 0;
                        var tempData = item.source;
                        var templistLog = JSON.parse(item.source[0].TransitionLog);

                        if (templistLog && templistLog.length > 0) {
                            try {
                                templistLog.forEach(function (ele) {

                                    var target = tempData.findIndex(x => x.LotteryChannelId == ele.LotteryChannelId);
                                    if (!tempData[target].listLog) {
                                        tempData[target].listLog = []
                                    }
                                    if (ele.TransitionTypeId == 1) {
                                        transfer += ele.TotalTrans;
                                        transfer += ele.TotalTransDup;
                                    } if (ele.TransitionTypeId == 2) {
                                        receive += ele.TotalTrans;
                                        receive += ele.TotalTransDup;
                                    }
                                    tempData[target].listLog.unshift(ele);
                                })
                            } catch (err) {
                                console.log(err)
                            }

                        }


                        //Modify
                        if (templistLog && templistLog.length > 0) {
                            vm.TotalDataChart.unshift.apply(vm.TotalDataChart, templistLog);
                        }
                        //
                        return {
                            "SalePointId": item.source[0].SalePointId,
                            "SalePointName": item.source[0].SalePointName,
                            "Data": tempData,
                            "ListLogData": templistLog,
                            "Transfer": transfer,
                            "Receive": receive,
                            "isExpand": false
                        };
                    })
                    .ToArray();

                vm.saveIndex = -1;

                for (var i = 0; i < listKey.length; i++) {
                    if (listKey[i] != "null") {
                        vm.dataDaiBan.push({
                            name: listKey[i],
                            //data: listValue[i],
                            receive: 0,
                            trans: 0,
                            total: 0
                        })
                    }
                }


                vm.listInventory.forEach(function (item) {
                    item.dataDaiBan = angular.copy(vm.dataDaiBan);
                })

                vm.listInventory.forEach(function (item) {
                    item.TotalSum=0
                    item.dataDaiBan.forEach(function (daiban) {
                        if (item.ListLogData && item.ListLogData.length > 0) {
                            try {
                                item.ListLogData.forEach(function (ele) {

                                    if (ele.LotteryChannelName == daiban.name) {
                                        if (ele.TransitionTypeId == 1) {
                                            daiban.trans += ele.TotalTrans;
                                            daiban.trans += ele.TotalTransDup;
                                        } if (ele.TransitionTypeId == 2) {
                                            daiban.receive += ele.TotalTrans;
                                            daiban.receive += ele.TotalTransDup;
                                        }
                                    }
                                })
                            } catch (err) {
                                console.log(err);
                            }
                        }
                        daiban.total = daiban.trans - daiban.receive;
                        item.TotalSum += daiban.trans - daiban.receive;
                    }
                    )
                })
                vm.TotalSum = 0;
                vm.dataDaiBan.forEach(function (item) {
                    vm.listInventory.forEach(function (ite) {
                        ite.dataDaiBan.forEach(function (ele) {
                            if (item.name == ele.name) {
                                item.total += ele.total;
                                vm.TotalSum += ele.total;
                            }
                        })
                    })
                })

                //init chart
                if (vm.TotalDataChart && vm.TotalDataChart.length > 0) {
                    vm.TotalDataChart.sort(function (a, b) {
                        if (moment(a.TransitionDate) < moment(b.TransitionDate)) {
                            return -1;
                        }
                        if (moment(a.TransitionDate) > moment(b.TransitionDate)) {
                            return 1;
                        }
                        return 0;
                    })

                    vm.ChartGrp = $rootScope.GrpBy(vm.TotalDataChart, 'LotteryChannelName');
                    vm.tempChart=[]

                    if (vm.ChartGrp) {
                        Object.keys(vm.ChartGrp).forEach(function (key) {
                            var temp = {
                                Title: key
                            };

                            var listTime = [
                                moment(vm.ChartGrp[key][0].LotteryDate).add(7, 'hours').format("YYYY-MM-DD 00:00:00")
                            ];
                            var listCustom = [
                                [""],
                                [""]
                            ]

                            var listTranfer = [
                                null
                            ]
                            var listReceive = [
                                null
                            ]

                            var tranfer = 0;
                            var receive = 0;
                            vm.ChartGrp[key].forEach(function (item) {
                                if (item.TransitionTypeId == 1) {
                                    tranfer += item.TotalTrans + item.TotalTransDup;

                                    //listCustom[0].push(item.FromSalePointName + ": " + (item.TotalTrans + item.TotalTransDup))

                                    listCustom[0].push(item.TotalTrans)

                                    listCustom[1].push("");
                                    listTime.push(moment(item.TransitionDate).add(7, 'hours').format("YYYY-MM-DD HH:mm:ss"))
                                    listTranfer.push(tranfer);
                                    listReceive.push(receive);
                                }

                                if (item.TransitionTypeId == 2) {
                                    receive += item.TotalTrans + item.TotalTransDup;
                                    listCustom[1].push(item.ToSalePointName + ": " + (item.TotalTrans + item.TotalTransDup))
                                    listCustom[0].push("");
                                    listTime.push(moment(item.TransitionDate).add(7, 'hours').format("YYYY-MM-DD HH:mm:ss"))
                                    listTranfer.push(tranfer);
                                    listReceive.push(receive);
                                }
                            })

                            listTime.push(moment(vm.ChartGrp[key][0].LotteryDate).add(7, 'hours').format("YYYY-MM-DD 23:59:59"))

                            temp.listReceive = listReceive;
                            temp.listTranfer = listTranfer;
                            temp.listCustom = listCustom;
                            temp.listTime = listTime;
                            vm.tempChart.push(temp);
                        });
                    }

                }

            }

            vm.openDetail = function (detail, salePoint) {
                if (detail.length > 0) {
                    var viewPath = baseAppPath + '/activity/views/modal/';
                    var modalTransfer = $uibModal.open({
                        params: {
                            day: {
                                value: '',
                                squash: true
                            }
                        },
                        templateUrl: viewPath + 'transferDetail.html' + versionTemplate,
                        controller: 'Activity.transferDetail as $vm',
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
                                            listLottery: res[0],
                                            listData: detail,
                                            salePoint: salePoint
                                        };
                                        deferred.resolve(result);
                                    });
                                    return deferred.promise;
                                }]
                        },
                    });
                    modalTransfer.opened.then(function (res) {
                        $(document).ready(function () {

                        });
                    });

                    modalTransfer.result.then(function (data) {
                    }, function (data) {
                        if (typeof (data) == 'object') {
                        }
                    });
                }
            }

            vm.showHide = function (index) {
                if (vm.listInventory[index].ListLogData.length > 0) {
                    if (vm.saveIndex == index) {
                        vm.listInventory[index].isExpand = vm.listInventory[index].isExpand == false ? true : false;
                    } else {
                        vm.listInventory[vm.saveIndex < 0 ? 0 : vm.saveIndex].isExpand = false;
                        vm.listInventory[index].isExpand = true;
                        vm.saveIndex = index;

                    }
                }
            }

            vm.init();

            vm.clickToday = function (days = 0) {
                vm.params.day = moment().add(days, 'days').format("YYYY-MM-DD");
                vm.changeDate();
            }

        }]);
})();