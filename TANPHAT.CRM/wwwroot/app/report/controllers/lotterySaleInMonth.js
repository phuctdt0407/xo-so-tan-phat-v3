(function () {
	app.controller('Report.lotterySaleInMonth', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', '$uibModal', 'ddlService',
		function ($scope, $rootScope, $state, viewModel, notificationService, reportService, $uibModal, ddlService) {
			var vm = angular.extend(this, viewModel);

			vm.listDataBK = {}
			vm.listDataBK.VT = vm.listData.VT ? JSON.parse(vm.listData.VT) : [];
			vm.listDataBK.VC = vm.listData.VC ? JSON.parse(vm.listData.VC) : [];
            vm.listDataBK.VTr = vm.listData.VTr ? JSON.parse(vm.listData.VTr) : [];
            vm.listDataBK.Lotto = vm.listData.Lotto ? JSON.parse(vm.listData.Lotto) : [];
            vm.listDataBK.Vietlot = vm.listData.Vietlot ? JSON.parse(vm.listData.Vietlot) : [];
			vm.listDataBK.SUM = vm.listData.SUM ? JSON.parse(vm.listData.SUM) : [];
            vm.listDataBK.SUMF = vm.listData.SUMF ? JSON.parse(vm.listData.SUMF) : [];

			vm.month = vm.params.month;
			vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");

			vm.loadData = function () {
				vm.params.month = moment(vm.month).format('YYYY-MM');
				$state.go($state.current, vm.params, { reload: false, notify: true })
            }

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            var { startDate, endDate } = getDayFunction(vm.month);
            var currentDate = startDate;
            vm.getDaysArray = function (year, month) {

                var monthIndex = month - 1;
                var names = ['(CN)', '(T2)', '(T3)', '(T4)', '(T5)', '(T6)', '(T7)'];
                var date = new Date(year, monthIndex, 1);
                var result = [];
                while (date.getMonth() == monthIndex) {
                    result.push(date.getDate() + ' ' + names[date.getDay()]);
                    date.setDate(date.getDate() + 1);
                }

                while (moment(currentDate) <= moment(endDate)) {
                    const temp = moment(currentDate).format('YYYY-MM-DD');
                    const dateNumber = parseInt(temp.slice(8));
                    const objectDate = {
                        date: temp,
                        time: result[dateNumber - 1],
                        quantity: 0
                    };
                    vm.listDate.push(objectDate);
                    currentDate = moment(currentDate).add(1, 'day');
                }
            }


            vm.listDate = [];
            vm.listVT = [];
            vm.listVTr = [];
            vm.listVC = [];
            vm.listLotto = [];
            vm.listVietlot = [];
            vm.listSUM = [];
            vm.listMonth = [];

            vm.initData = function () {
                vm.groupById = [];

                var { startDate, endDate } = getDayFunction(vm.month);
                var currentDate = startDate;

                while (moment(currentDate) <= moment(endDate)) {
                    var temp = moment(currentDate).format('YYYY-MM-DD');
                    vm.listMonth.push({
                        date: temp,
                        quantity: 0
                    })
                    currentDate = moment(currentDate).add(1, 'day');
                }

                vm.listMonth.forEach(function (item, index) {
                    /*vm.listDate.push(index + 1);*/
                    var temp1 = vm.listDataBK.VT.filter(x1 => x1.ActionDate == item.date)
                    var temp2 = vm.listDataBK.VTr.filter(x2 => x2.ActionDate == item.date)
                    var temp3 = vm.listDataBK.VC.filter(x3 => x3.ActionDate == item.date)
                    var temp4 = vm.listDataBK.Lotto.filter(x4 => x4.ActionDate == item.date)
                    var temp5 = vm.listDataBK.Vietlot.filter(x5 => x5.ActionDate == item.date)
                    var tempSum = vm.listDataBK.SUM.filter(x6 => x6.ActionDate == item.date)
                    if (temp1 && temp1.length > 0) {
                        var sum1 = 0;
                        temp1.forEach(x1 => sum1 += x1.TotalValue)
                        vm.listVT.push(sum1)
                    } else {
                        vm.listVT.push(0)
                    }
                    if (temp2 && temp2.length > 0) {
                        var sum2 = 0;
                        temp2.forEach(x2 => sum2 += x2.TotalValue)
                        vm.listVTr.push(sum2)
                    } else {
                        vm.listVTr.push(0)
                    }
                    if (temp3 && temp3.length > 0) {
                        var sum3 = 0;
                        temp3.forEach(x3 => sum3 += x3.TotalValue)
                        vm.listVC.push(sum3)
                    } else {
                        vm.listVC.push(0)
                    }
                    if (temp4 && temp4.length > 0) {
                        var sum4 = 0;
                        temp4.forEach(x4 => sum4 += x4.TotalValue)
                        vm.listLotto.push(sum4)
                    } else {
                        vm.listLotto.push(0)
                    }
                    if (temp5 && temp5.length > 0) {
                        var sum5 = 0;
                        temp5.forEach(x5 => sum5 += x5.TotalValue)
                        vm.listVietlot.push(sum5)
                    } else {
                        vm.listVietlot.push(0)
                    }
                    if (tempSum && tempSum.length > 0) {
                        // lotto
                        var sum4 = 0;
                        temp4.forEach(x4 => sum4 += x4.TotalValue)
                        // vietlot
                        var sum5 = 0;
                        temp5.forEach(x5 => sum5 += x5.TotalValue)
                        var sum6 = 0;
                        tempSum.forEach(x6 => sum6 += x6.TotalValue)
                        vm.listSUM.push(sum6 + sum4 + sum5)
                    } else {
                        // lotto
                        var sum4 = 0;
                        temp4.forEach(x4 => sum4 += x4.TotalValue)
                        // vietlot
                        var sum5 = 0;
                        temp5.forEach(x5 => sum5 += x5.TotalValue)
                        var sum6 = 0;
                        tempSum.forEach(x6 => sum6 += x6.TotalValue)
                        vm.listSUM.push(sum4 + sum5)
                    }
                })

                vm.listSalePoint.forEach(function (item) {
                    var temp = vm.listDataBK.SUMF.find(x => x.SalePointId == item.Id)
                    // Lotto
                    var temp4 = vm.listDataBK.Lotto.find(x4 => x4.SalePointId == item.id) ? temp4 : 0
                    // Vietlot
                    var temp5 = vm.listDataBK.Vietlot.find(x5 => x5.SalePointId == item.id) ? temp5 : 0
                    if (temp) {
                        item.TotalValue = temp.TotalValue + temp4 + temp5;
                    } else {
                        item.TotalValue = 0 + temp4 + temp5;
                    }
                })

                var month = vm.month ? moment(vm.month).format('MM') : moment().format('MM');
                var year = vm.month ? moment(vm.month).format('YYYY') : moment().format('YYYY');
                vm.getDaysArray(year, month)

            }

            vm.initData('vm.listSalePoint:', vm.listSalePoint);

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            var colorArray = ['#FF1700', '#CC6600', '#CF6DFA', '#FE6D03', '#FCD600',
                '#EDFC00', '#A4FC00', '#58FC00', '#1C9C03', '#04C35E',
                '#04C392', '#04C3B8', '#049BC3', '#0266D6', '#03257F',
                '#03257F', '#FE6D03', '#99045E', '#CC00FF', '#BD8656',
                '#836665', '#C68ECF', '#9EA640', '#cc00ff', '#95928A']
            var optionColunm = {
                series: [{
                    name: 'Vé bán:',
                    data: vm.listSUM,
                }],
                chart: {
                    height: 500,
                    type: 'bar',
                    events: {
                        click: function (chart, w, e) {
                        }
                    }
                },
                colors: colorArray,
                plotOptions: {
                    bar: {
                        columnWidth: '50%',
                        distributed: true,
                        dataLabels: {
                            position: 'top'
                        }
                    }
                },
                dataLabels: {
                    enabled: false,
                    style: {
                        fontSize: ['12px'],
                        fontWeight: ['bold'],
                        colors: ['#000']
                    }
                },
                legend: {
                    show: false,
                },
                xaxis: {
                    categories: vm.listSalePoint.map(item => item.Name),
                    labels: {
                        style: {
                            colors: '#000',
                            fontSize: '14px'
                        }
                    }
                }
            };

            var chart = new ApexCharts(document.querySelector("#chartColunm"), optionColunm);
            chart.render();
		}]);
})();