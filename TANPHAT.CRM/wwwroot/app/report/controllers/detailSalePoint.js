(function () {
    app.controller('Report.detailSalePoint', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'shiftStatus',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, shiftStatus) {
            var vm = angular.extend(this, viewModel);
            vm.totalRow = vm.listUser && vm.listUser.length > 0 ? vm.listUser[0].TotalCount : 0;

            vm.month = vm.params.month;

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.initData = function () {
                vm.listSalePoint.forEach(function (item) {
                    var temp2 = angular.copy(vm.listStaff);
                    item.arrayQuantity = [];
                    item.arrayName = [];
                    item.listStaff = temp2;
                })

                vm.listTotalShift.forEach(function (item) {
                    var target = vm.listStaff.findIndex(x => x.Id == item.UserId);
                    var targetSalePoint = vm.listSalePoint.findIndex(x => x.Id == item.SalePointId);
                    try {
                        var temp = vm.listSalePoint[targetSalePoint].listStaff[target];
                        temp["TotalRemaining_" + item.ShiftTypeId] = item.Quantity;
                    } catch (err) {

                    }
                   
                })

                vm.listStaff.forEach(function (item) {
                    item.Quantity = 0;
                    vm.listTotalShift.forEach(function (item1) {
                        if (item.Id == item1.UserId) {
                            item.Quantity += item1.Quantity;
                        }
                    });
                })
            }
            vm.initData();

            vm.listChartDetail = Enumerable.From(vm.listTotalShift)
            .GroupBy(function (item) { return item.SalePointId; })
            .Select(function (item, i) {
                return {
                        UserId: item.source[0].UserId,
                        FullName: item.source[0].FullName,
                        Quantity: item.source[0].Quantity,
                        SalePointId: item.source[0].SalePointId,
                        SalePointName: item.source[0].SalePointName,
                    }
            })
            .ToArray();


            vm.init = function () {
                var labelsStaff = [];
                var seriesStaff = [];
                vm.listStaff.forEach(function (item) {
                    if (item.Quantity != 0) {
                        labelsStaff.push(item.Name);
                        seriesStaff.push(item.Quantity);
                    }
                })
                const sum = seriesStaff.reduce((partialSum, a) => partialSum + a, 0);

                var options = {
                    series: seriesStaff,
                    chart: {
                        width: 400,
                        type: 'pie',
                    },
                    stacked: true,
                    labels: labelsStaff,
                    responsive: [{
                        breakpoint: 200,
                        options: {
                            chart: {
                                width: 300,
                            },
                            legend: {
                                enabled: 'top'
                            }
                        }
                    }],
                    legend: {
                        position: 'bottom',
                    },
                    dataLabels: {
                        enabled: true,
                        style: {
                            colors: ['#fff'],
                            fontSize: '24px',
                            fontWeight: 'bold',
                        },
                        formatter: function (val) {
                            return Math.floor(val * sum / 100)
                        },
                    },
                    plotOptions: {
                        pie: {
                            expandOnClick: false
                        }
                    }

                };

                var chart = new ApexCharts(document.querySelector("#chart"), options);
                chart.render();
            }

            vm.init()
            
           
        }]);
})();