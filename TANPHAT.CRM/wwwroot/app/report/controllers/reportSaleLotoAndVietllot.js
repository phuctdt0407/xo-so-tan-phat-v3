(function () {
    app.controller('Report.reportSaleLotoAndVietllot', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService', '$uibModal', 'dayOfWeekVN', '$q',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService, $uibModal, dayOfWeekVN, $q) {
            var vm = angular.extend(this, viewModel);

            vm.classItem0 = vm.params.transactionType && vm.params.transactionType == 3 ?'nav-link active' : 'nav-link';
            vm.classItem1 = vm.params.transactionType && vm.params.transactionType == 2 ? 'nav-link active' : 'nav-link';
            vm.checkShowVietlott = vm.params.transactionType && vm.params.transactionType == 2 ? true : false

            vm.changeTab = function (tabId) {
                if (tabId === 1) {
                    vm.params.transactionType = 3
                    vm.params.month = moment().format("YYYY-MM")
                    vm.params.salePointId = 0
                    $state.go($state.current, vm.params, { reload: false, notify: true });
                }
                if (tabId === 2) {
                    vm.params.transactionType = 2
                    vm.params.month = moment().format("YYYY-MM")
                    vm.params.salePointId = 0
                    $state.go($state.current, vm.params, { reload: false, notify: true });
                }
                
            };

            vm.getWinningListByMonth = function () {
                var deferred = $q.defer();
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $q.all([
                    activityService.getWinningListByMonth({ month: vm.params.month }),
                ]).then(function (res) {
                    var result = {
                        data: res[0],
                    };
                    deferred.resolve(result);
                });
                return deferred.promise;
            }

            var tongChiThuong = [];

            vm.getTongChiThuong = function () {
                vm.getWinningListByMonth().then(function (res) {
                    tongChiThuong = [];
                    var dataChiThuong = res.data;
                    vm.listSalePoint.forEach(salePoint => {
                        var total = 0;
                        var temp = {};
                        temp.Name = salePoint.Name;
                        temp.Data = 0;
                        dataChiThuong.forEach(ele => {
                            if (ele.SalePointId == salePoint.Id && vm.params.transactionType == 3 && ele.WinningTypeId == 6) {
                                total += ele.WinningPrice;
                            }
                            if (ele.SalePointId == salePoint.Id && vm.params.transactionType == 2 && ele.WinningTypeId == 5) {
                                total += ele.WinningPrice;
                            }
                        })
                        temp.Data = total;
                        tongChiThuong.push(temp);
                    })
                })

            }

            vm.listSalePoint.unshift({
                Id: 0,
                Name: 'Tất cả',
                Email: null
            })

            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);

            vm.checkCurrentDate = function (dateId) {
                var curentDate = moment().format("YYYY-MM-DD");
                var indexCurentDate = parseInt(curentDate.slice(8)) - 1;
                var currentMonthYear = curentDate.slice(0, 7);
                if (dateId == indexCurentDate && vm.month == currentMonthYear)
                    return true;
                else
                    return false;
            }

            vm.month = vm.params.month;

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.init = function () {
                

                vm.data = Enumerable.From(vm.listData)
                    .GroupBy(function (item) { return item.SalePointId; })
                    .Select(function (item) {
                        return {
                            SalePointId: item.source[0].SalePointId,
                            SalePointName: vm.listSalePoint.find(x => x.Id == item.source[0].SalePointId).Name,
                            Data: item.source
                        }
                    }).ToArray()
                console.log("vm.data", vm.data);
                vm.listMonth = [];
                var { startDate, endDate } = getDayFunction(vm.month);

                while (moment(startDate) <= moment(endDate)) {
                    vm.listMonth.push({
                        Date: startDate,
                        Display: moment(startDate).format('DD/MM/YYYY'),
                        DateName: vm.dayOfWeekVN[moment(startDate).day()].SName,
                        IsWeekEnd: moment(startDate).day() == 0,
                    })
                    startDate = moment(startDate).add(1, 'day');
                }
                vm.getTongChiThuong();
            }

            vm.init()
            // Thêm phương thức tính tổng trong controller
            vm.getTotal = function (data) {
                var total = 0;
                angular.forEach(data, function (ele) {
                    total += ele.AllTotalPrice;
                });
                return total;
            };
            vm.getTotalLottoOrVietLot = function (salePointName) {
                return tongChiThuong.filter(x => x.Name == salePointName)[0].Data;
            }

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.openModalDetail = function (model, salePointName) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'detailSaleLoto.html' + versionTemplate,
                    controller: 'Report.detailSaleLoto as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
                            function ($q, $uibModal, reportService, ddlService) {
                                var deferred = $q.defer();

                                $q.all([

                                ]).then(function (res) {
                                    var result = {
                                        salePointName: salePointName,
                                        model: model,
                                        type: vm.params.transactionType
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

                    }
                })
            }
           

        }]);
})();