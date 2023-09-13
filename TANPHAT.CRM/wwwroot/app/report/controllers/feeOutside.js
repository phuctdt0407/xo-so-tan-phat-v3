(function () {
    app.controller('Report.feeOutside', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'shiftStatus', 'dayOfWeekVN','$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, shiftStatus, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);

            //declare

            vm.listMonth = [];
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.month = vm.params.month

            //func

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
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

            vm.clickMonth = function (month) {
                vm.month = moment().add(month, 'month').format('YYYY-MM');
                vm.loadData();
            }

            vm.getSum = function (index=-1) {
                var Sum = 0;
                if (index == -1) {
                    vm.listSalePoint.forEach(function (salepoint) {
                            Sum += salepoint.Sum;
                    })
                } else {
                    vm.listSalePoint[index].listMonth.forEach(function (date) {
                        Sum += date.Shift1.TotalPrice ? date.Shift1.TotalPrice : 0;
                        Sum += date.Shift2.TotalPrice ? date.Shift2.TotalPrice : 0;
                    })
                }
                return Sum;
            }
           

            vm.init = function () {
                // INIT MONTH
                var { startDate, endDate } = getDayFunction(vm.params.month);

                while (moment(startDate) <= moment(endDate)) {
                    vm.listMonth.push({
                        Date: startDate,
                        Display : moment(startDate).format('DD/MM/YYYY'),
                        DateName: vm.dayOfWeekVN[moment(startDate).day()].SName,
                        IsWeekEnd: moment(startDate).day() == 0,
                    })
                    startDate = moment(startDate, "YYYY-MM-DD").add(1, 'day').format("YYYY-MM-DD");
                }

                ///
                vm.listSalePoint = [];
                if (vm.listData && vm.listData.length > 0) {
                    Enumerable.From(vm.listData)
                        .GroupBy(function (item) { return item.SalePointId; })
                        .Select(function (item) {
                            vm.listSalePoint.push({
                                SalePointId: item.source[0].SalePointId,
                                SalePointName: item.source[0].SalePointName,
                                Id: item.source[0].SalePointId,
                                Name: item.source[0].SalePointName
                            })
                            return {
                                item
                            }
                        })
                        .ToArray();

                    vm.listSalePoint.forEach(function (salepoint, index) {
                        salepoint.listMonth = angular.copy(vm.listMonth);
                        salepoint.listMonth.forEach(function (date) {
                            date.Shift1 = {};
                            date.Shift2 = {};
                            date.SalePointId = salepoint.SalePointId;
                            date.SalePointName = salepoint.SalePointName;

                            var temp = vm.listData.filter(x => x.SalePointId == salepoint.SalePointId && moment(x.Date).format('YYYY-MM-DD') == date.Date)
                            if (temp && temp.length > 0) {
                                temp.forEach(function (data) {
                                    date['Shift' + data.ShiftId] = data;
                                    if (date['Shift' + data.ShiftId].Data) {
                                       date['Shift' + data.ShiftId].Data = JSON.parse(data.Data);
                                    }
                                })
                            }

                        })
                        salepoint.Sum = vm.getSum(index);
                    })
                }

            }

            vm.init();

            vm.showInfo = function (model) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'viewFeeOutside.html' + versionTemplate,
                    controller: 'Report.viewFeeOutside as $vm',
                    backdrop: 'static',
                    size: 'lg',
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
                    $(".table-responsive").animate({ scrollLeft: (parseInt(moment().format('DD')) - 1) * $(window).width() * 0.11 }, 400);
                }, 500)
            });


        }]);
})();
