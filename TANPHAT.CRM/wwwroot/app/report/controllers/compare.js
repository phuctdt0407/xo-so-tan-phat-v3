(function () {
    app.controller('Report.compare', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService', 'dayOfWeekVN', '$uibModal','salepointService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService, dayOfWeekVN, $uibModal, salepointService) {
            var vm = angular.extend(this, viewModel);
            //declare

            vm.listMonth = [];
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.month = vm.params.month

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.clickMonth = function (month) {
                vm.month = moment().add(month, 'month').format('YYYY-MM');
                vm.loadData();
            }

            vm.checkCurrentDate = function (dateId) {
                var curentDate = moment().format("YYYY-MM-DD");
                var indexCurentDate = parseInt(curentDate.slice(8)) - 1;
                var currentMonthYear = curentDate.slice(0, 7);
                if (dateId == indexCurentDate && vm.month == currentMonthYear)
                    return true;
                else
                    return false;
            }
            console.log(vm.checkCurrentDate)
            vm.getStatus = function (model) {
                if (moment(moment().format('YYYY-MM-DD')).diff(moment(model.Date)) >=0) {
                    switch (true) {
                        //Khong chia du ca truc trong diem ban
                        case (!model.Shift1.UserId || !model.Shift2.UserId):
                            return 1;
                            break;
                        //Chua nhap du so lieu
                        case (!model.Shift1.TotalPrice || !model.Shift2.TotalPrice || model.Shift1.TotalPrice == 0 || model.Shift2.TotalPrice == 0):
                            return 2
                            break;
                        case ($rootScope.ToInt(model.TotalPrice) != $rootScope.ToInt(model.Shift1.TotalPrice) + $rootScope.ToInt(model.Shift2.TotalPrice)):
                            return 3
                            break;
                        case ($rootScope.ToInt(model.TotalPrice) == $rootScope.ToInt(model.Shift1.TotalPrice) + $rootScope.ToInt(model.Shift2.TotalPrice)):
                            return 4
                            break;
                        default:
                            return '';
                            break;
                    }
                }
                else {
                    return '';
                }
            }

            vm.init = function () {
                // INIT MONTH
                var { startDate, endDate } = getDayFunction(vm.params.month);

                while (moment(startDate) <= moment(endDate)) {
                    vm.listMonth.push({
                        Date: startDate,
                        DateName: vm.dayOfWeekVN[moment(startDate).day()].SName,
                        IsWeekEnd: moment(startDate).day() == 0,
                        DataInfo: [],
                    })
                    startDate = moment(startDate, "YYYY-MM-DD").add(1, 'day').format("YYYY-MM-DD");
                }

                //INIT
                vm.listSalePoint.forEach(function (salepoint) {
                    salepoint.listMonth = angular.copy(vm.listMonth);
                    salepoint.listMonth.forEach(function (date) {
                        date.SalePointName = salepoint.Name;
                        date.Shift1 = {};
                        date.Shift2 = {};
                        date.Display = moment(date.Date).format('DD/MM/YYYY');
                        date.TotalPrice = 0;
                        date.TotalPriceTmp = 0;
                        var temp = [];

                        if (vm.listData && vm.listData.length>0) {
                            temp = vm.listData.filter(x => x.SalePointId == salepoint.Id && date.Date == moment(x.Date).format("YYYY-MM-DD"));
                        }
                        if (temp && temp.length > 0) {
                            temp.forEach(function (tmp) {
                                if (tmp.ShiftId && tmp.ShiftId > 0) {
                                    date['Shift' + tmp.ShiftId] = {
                                        TotalPrice: tmp.TotalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','),
                                        TotalPriceTmp: tmp.TotalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','),
                                        UserId: tmp.UserId,
                                        FullName: tmp.FullName,
                                        ShiftDistributeId: tmp.ShiftDistributeId
                                        //Add Field
                                    }

                                } else {
                                    date.TotalPrice = tmp.TotalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                                    date.TotalPriceTmp = tmp.TotalPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');

                                }
                            })
                        }
                    })
                })
            }

            vm.init();


            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                ActionType: 1,
            }

            vm.getDataForSave = function () {
                var temp = []
                vm.listSalePoint.forEach(function (salepoint) {
                    salepoint.listMonth.forEach(function (date) {
                        if ($rootScope.ToInt(date.TotalPrice) != $rootScope.ToInt(date.TotalPriceTmp)) {
                            temp.push({
                                Price: $rootScope.ToInt(date.TotalPrice),
                                SalePointId: salepoint.Id,
                                Date: date.Date
                            })
                        }
                    })
                })
                return temp;
            }

            vm.isSaving = false;
            vm.save = function () {
                vm.isSaving = true;
                var temp = vm.getDataForSave();
                if (temp == []) {
                    notificationService.warning("Không có gì để lưu");
                    vm.isSaving = false
                } else {
                    vm.update.Data = JSON.stringify(temp);
                    salepointService.saleOfVietlottForCheck(vm.update).then(function (res) {
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

            vm.showInfo = function (model) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'viewVietLott.html' + versionTemplate,
                    controller: 'Report.viewVietLott as $vm',
                    backdrop: 'static',
                    size: 'm',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService',
                            function ($q, $uibModal, userService) {
                                var deferred = $q.defer();
                                $q.all([
                                   
                                ]).then(function (res) {
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
                        $('.modal-body').addClass('modal-body-rm');
                    });
                });

                request.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {
                       
                    }
                });

            }

            $(document).ready(function () {
                setTimeout(function () {
                    $(".table-responsive").animate({ scrollLeft: (parseInt(moment().format('DD')) - 1) * $(window).width() * 0.11}, 400);
                }, 500)
            });


     }]);
}) ();
