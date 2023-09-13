(function () {
    app.controller('Salepoint.commissionWinning', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService', '$uibModal', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, notificationService, userService, $uibModal, salepointService) {
            var vm = angular.extend(this, viewModel);

            vm.month = vm.params.month;
            vm.listDateOfMonth = [];
            vm.modifiedData = [];
            vm.listStaff = vm.listUser.filter(ele => ele.UserTitleId == 5)
            vm.listManager = vm.listUser.filter(ele => ele.UserTitleId == 4)
            vm.tabId = 1
            vm.checkStaff = $rootScope.sessionInfo.IsStaff ? true : false;
            vm.staffId = $rootScope.sessionInfo.IsStaff ? $rootScope.sessionInfo.UserId : 0;

            vm.listTotalComissionAndFee.forEach(function (ele) {
                ele.Users = ""
                if (ele.User) {
                    ele.User = JSON.parse(ele.User)
                   
                    ele.Users = ele.User.map(e => e.UserName).join(',')
                }

            })
            console.log("vm.listTotalComissionAndFee", vm.listTotalComissionAndFee);
            vm.listSalePoint.unshift({
                Id: 0,
                Name: 'Tất cả',
                Email: null
            })

            vm.classItem0 = vm.tabId && vm.tabId == 1 ? 'nav-link active' : 'nav-link';
            vm.classItem1 = vm.tabId && vm.tabId == 2 ? 'nav-link active' : 'nav-link';

            vm.changeTab = function (tabId) {
                if (tabId === 1) {
                    vm.tabId = 1
                }
                if (tabId === 2) {
                    vm.tabId = 2
                }

            };

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return {startDate, endDate};
            }

            vm.changeSalePoint = function () {
               /* console.log("vm.salePointId: ", vm.salePointId)*/
            }

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, {reload: true, notify: true})
            }
            vm.clickMonth = function (month) {
                vm.month = moment().add(month, 'month').format('YYYY-MM');
                vm.loadData();
            }

            vm.initData = function () {
                var {startDate, endDate} = getDayFunction(vm.params.month);
                var currentDate = startDate;
                /// init listMonth
                while (moment(currentDate) <= moment(endDate)) {
                    var temp = moment(currentDate).format('YYYY-MM-DD');
                    vm.listDateOfMonth.push({
                        Date: temp,
                        IsWeekEnd: moment(temp).day() == 0,
                    })
                    currentDate = moment(currentDate).add(1, 'day');
                }
                vm.listCommission = vm.listCommission.filter(e => e.UserTitleId != 2)

                /// Get Staff & Manager Commission
                var temp = Enumerable.From(vm.listCommission)
                    .GroupBy(function (item) {
                        return item.UserId;
                    })
                    .Select(function (ele, i) {
                        var temp2 = Enumerable.From(ele.source).GroupBy(function (item2) {
                            return item2.Date
                        })
                            .Select(function (ele2, i) {
                                let total = 0
                                ele2.source.forEach(e => {
                                    total += e.TotalCommision

                                })
                                return {
                                    commission: Math.round(total / 1000),
                                    date: ele2.source[0].Date
                                }
                            }).ToArray()
                        let temp3 = {}

                        temp2.forEach(e => {

                            var dayId = moment(e.date).date()

                            temp3[dayId + ""] = e.commission
                        })
                        let totalCommission = 0;
                        ele.source.forEach(e => {
                            totalCommission += e.TotalCommision
                        })
                        return {
                            "UserId": ele.source[0].UserId,
                            "FullName": ele.source[0].FullName,
                            "Commission": temp3,
                            "TotalCommission": totalCommission
                        };
                    })
                    .ToArray();
                vm.listStaff.forEach(e => {
                    var a = temp.find(f => f.UserId == e.UserId)
                    e.Commission = a && a.Commission || {}
                    e.TotalCommission = a && a.TotalCommission || 0
                })

                vm.listStaff = vm.listStaff.filter(x => x.SalePointId != 0)
                vm.listStaffGrpBySalePoint = Enumerable.From(vm.listStaff)
                    .GroupBy(function (item) {
                        return item.SalePointId;
                    })
                    .Select(function (ele, i) {
                        return {
                            SalePointId: ele.source[0].SalePointId,
                            SalePointName: vm.listSalePoint.filter(x => x.Id == ele.source[0].SalePointId)[0].Name,
                            Data: ele.source,
                        }
                    })
                    .ToArray();
                vm.listManager.forEach(e => {
                    var a = temp.find(f => f.UserId == e.UserId)
                    e.Commission = a && a.Commission || {}
                    e.TotalCommission = a && a.TotalCommission || 0
                })

                /// Get Admin Commission Group By SalePoint
                var adminCommissionList = vm.listCommission.filter(ele => ele.UserId == 0)
                vm.adminCommission = Enumerable.From(adminCommissionList)
                    .GroupBy(function (item) {
                        return item.SalePointId;
                    })
                    .Select(function (ele, i) {
                        var temp2 = Enumerable.From(ele.source).GroupBy(function (item2) {
                            return item2.Date
                        })
                            .Select(function (ele2, i) {
                                let total = 0
                                ele2.source.forEach(e => {
                                    total += e.TotalCommision
                                })
                                return {
                                    commission: Math.round(total / 1000),
                                    date: ele2.source[0].Date
                                }
                            }).ToArray()
                        let temp3 = {}
                        temp2.forEach(e => {
                            var dayId = moment(e.date).date()
                            temp3[dayId + ""] = e.commission
                        })
                        let totalCommission = 0
                        ele.source.forEach(e => {
                            totalCommission += e.TotalCommision
                        })
                        var salePointCur = ''
                        if (vm.listSalePoint && vm.listSalePoint.length > 0)
                            salePointCur = vm.listSalePoint.find(e => e.Id == ele.source[0].SalePointId)
                        return {
                            "SalePointName": salePointCur ? salePointCur.Name : '',
                            "SalePointId": ele.source[0].SalePointId,
                            "Commission": temp3,
                            "TotalCommission": totalCommission
                        };

                    })
                    .ToArray();
                vm.adminCommission.forEach(ele => {
                    ele.TotalCommissionBySalepoint = 0;
                    for (let commission of Object.values(ele.Commission)) {
                        ele.TotalCommissionBySalepoint += commission
                    }
                })

                ///Get Admin Commission Group By Date
                var temp3 = Enumerable.From(adminCommissionList)
                    .GroupBy(function (item) {
                        return item.Date;
                    })
                    .Select(function (ele, i) {
                        var totalCommission = 0
                        ele.source.forEach(e => {
                            totalCommission += e.TotalCommision
                        })


                        var dayId = moment(ele.source[0].Date).date()

                        let obj = {}
                        obj[dayId + ""] = Math.round(totalCommission / 1000)


                        return obj;

                    })
                    .ToArray()

                vm.adminCommissionGroupByDate = {}
                temp3.forEach(e => {
                    Object.assign(vm.adminCommissionGroupByDate, e)
                })
                vm.SumAdminCommission = 0
                for (let commission of Object.values(vm.adminCommissionGroupByDate)) {
                    vm.SumAdminCommission += commission * 1000
                }
                ///Fee
                var temp4 = Enumerable.From(vm.listFee)
                    .GroupBy(function (item) {
                        return item.Date;
                    })
                    .Select(function (ele, i) {
                        var totalFee = 0
                        ele.source.forEach(e => {
                            totalFee += e.Fee
                        })
                        var dayId = moment(ele.source[0].Date).date()
                        let obj = {}
                        obj[dayId + ""] = Math.round(totalFee / 1000)
                        return obj;

                    })
                    .ToArray()
                vm.totalFeeByDate = {}
                temp4.forEach(e => {
                    Object.assign(vm.totalFeeByDate, e)
                })

                vm.SumFee = 0
                for (let commission of Object.values(vm.totalFeeByDate)) {
                    vm.SumFee += commission * 1000
                }


                ///Total Commission Group By Day

                var temp5 = Enumerable.From(vm.listCommission)
                    .GroupBy(function (item) {
                        return item.Date;
                    })
                    .Select(function (ele, i) {
                       
                        var totalCommission = 0
                        console.log("ele.source", ele.source);
                        ele.source.forEach(e => {
                            //if (e.SalePointId == '5') {
                            //    console.log("ele.source", e);
                            //}
                            totalCommission += e.TotalCommision
                            //if (e.Date == "2023-08-10T00:00:00") {
                            //    console.log("ele", ele);
                            //    console.log("e.TotalCommision", e.TotalCommision);
                            //    console.log("totalCommission", totalCommission);
                            //}
                        })
                       
                        var dayId = moment(ele.source[0].Date).date()
                        let obj = {}
                        obj[dayId + ""] = Math.round(totalCommission / 1000)
                    
                        if (vm.totalFeeByDate[dayId + ""]) {
                            obj[dayId + ""] += vm.totalFeeByDate[dayId + ""]
                            console.log("vm.totalFeeByDate", vm.totalFeeByDate);
                        }
                        console.log("obj", obj);
                        return obj;

                    })
                    .ToArray()

                vm.totalCommissionByDate = {}
                temp5.forEach(e => {
                    Object.assign(vm.totalCommissionByDate, e)
                })
                vm.SumCommission = 0
                for (let commission of Object.values(vm.totalCommissionByDate)) {
                    vm.SumCommission += commission * 1000
                }
                console.log("temp5", temp5);
            }
            vm.initData();
          
            console.log("vm.totalCommissionByDate", vm.totalCommissionByDate);
            vm.openModalAddCommission = function () {
                var viewPath = baseAppPath + '/salepoint/views/modal/';
                var modalTransfer = $uibModal.open({
                    templateUrl: viewPath + 'addCommission.html' + versionTemplate,
                    controller: 'Salepoint.addCommission as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService',
                            function ($q, $stateParams, ddlService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                params.date = moment().format("YYYY-MM-DD")

                                $q.all([
                                    ddlService.salePointDDL(),
                                ]).then(function (res) {
                                    var result = {
                                        params: params,
                                        listStaff: vm.listStaff,
                                        listSalePoint: res[0]
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

            vm.updateCommissionWinning = function (model) {
                var viewPath = baseAppPath + '/salepoint/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'updateCommissionWinning.html' + versionTemplate,
                    controller: 'Salepoint.updateCommissionWinning as $vm',
                    backdrop: 'static',
                    size: 'sm',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService', 'ddlService',
                            function ($q, $uibModal, userService, ddlService) {
                                var deferred = $q.defer();

                                $q.all([]).then(function (res) {
                                    var result = {
                                        model: model
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    }
                });

                request.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-footer').addClass('remove-modal-footer');
                    });
                });

                request.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {
                        $state.reload();
                    }
                });
            }


            vm.deleteCommissionWining = function (model) {
                var message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xoá</strong>hoa hồng đst?'
                var dialog = bootbox.confirm({
                    message,
                    buttons: {
                        confirm: {
                            label: 'Đồng ý',
                            className: 'btn-success',
                        },
                        cancel: {
                            label: 'Huỷ',
                            className: 'btn-secondary'
                        }
                    },
                    callback: function (res) {
                        setTimeout(function () {
                            $('.modal-lg').css('display', 'block');
                        }, 500);


                        if (res) {

                            salepointService.deleteStaffInCommissionWining({
                                commissionId: model.CommissionId
                            }).then(res => {
                                if(res&&res.Id==1){
                                    vm.listTotalComissionAndFee = vm.listTotalComissionAndFee.filter(ele=>ele.CommissionId != model.CommissionId)
                                    notificationService.success("Xoá thành công")
                                }
                            })
                            console.log("XOA HH DST", model)
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').removeClass("modal-body")
                        $('.modal-lg').css('display', 'none')
                    }, 0);
                });
            }
        }]);
})();