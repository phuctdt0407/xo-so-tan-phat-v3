(function () {
    app.controller('Report.agencyReport', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService) {
            var vm = angular.extend(this, viewModel);

            vm.month = vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];
            vm.listDateInWeek = [];

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
                var names = ['(Chủ nhật)', '(Thứ 2)', '(Thứ 3)', '(Thứ 4)', '(Thứ 5)', '(Thứ 6)', '(Thứ 7)',];
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
                    vm.listMonth.push(objectDate);
                    currentDate = moment(currentDate).add(1, 'day');
                }
                console.log("listMonth: ", vm.listMonth)
            }

            vm.init = function () {
                vm.listMonth = [];
                vm.listLabelLine = [];
                vm.listLabelColunm = [];
                vm.groupById = [];
                vm.dataLine = [];
                vm.dataTotal = [];
                vm.dataColunm = [];
                vm.listDate = [];

                var month = vm.month ? moment(vm.month).format('MM') : moment().format('MM');
                var year = vm.month ? moment(vm.month).format('YYYY') : moment().format('YYYY');
                vm.getDaysArray(year, month)

                vm.listLottery = vm.listTotalLottery && vm.listTotalLottery[0] ? JSON.parse(vm.listTotalLottery[0].Info) : null;

                if (vm.listLottery) {
                    vm.listLottery.forEach(function (item) {
                        var temp = [];
                        temp.push({
                            date: item.LotteryDate,
                            quantity: item.Quantity
                        })
                        vm.groupById.push({
                            id: item.LotteryId,
                            name: item.LotteryChannelName,
                            data: temp,
                        });
                    });

                }
                vm.labelsChart = [];
                vm.listMonth.forEach(function (item) {
                    var data = [];
                    var total = 0;
                    if (vm.listLottery) {

                        vm.listLottery.forEach(function (items) {
                            if (items.LotteryDate == item.date) {
                                data.push({
                                    lotteryId: items.LotteryId,
                                    lotteryChannelName: items.LotteryChannelName,
                                    quantity: items.Quantity,
                                    shortName: items.ShortName,
                                    lotteryDate: items.LotteryDate
                                })
                                total = total + parseInt(items.Quantity)
                            }

                        })
                    }
                    vm.labelsChart.push(item.time)
                    vm.dataLine.push({
                        data: data
                    })
                    vm.dataTotal.push({
                        total: total
                    })
                    console.log("total", total);
                    vm.dataColunm.push(total)
                })

                // data for chart colunm
                //vm.groupById.forEach(function (items) {
                //    var sum = 0;

                //    if (items) {
                //        items.data.forEach(function (item) {
                //            sum += (item.TotalReceived + item.TotalDupReceived)
                //        })
                //    }

                //    vm.listLabelColunm.push(items.name);
                //    vm.dataColunm.push(sum);
                //})
            }

            vm.init();
            console.log("vm.labelsChart", vm.labelsChart);
            console.log("vm.dataTotal", vm.dataTotal);
            
            var optionColunm = {
                series: [{
                    name: 'Total received',
                    data: vm.dataColunm,
                }],
                chart: {
                    height: 500,
                    type: 'bar',
                    events: {
                        click: function (chart, w, e) {
                        }
                    }
                },
               
                plotOptions: {
                    bar: {
                        columnWidth: '50%',
                        distributed: true,
                        dataLabels: {
                            position: 'top',
                        }
                    }
                },
                dataLabels: {
                    enabled: true,
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
                    categories: vm.labelsChart,
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