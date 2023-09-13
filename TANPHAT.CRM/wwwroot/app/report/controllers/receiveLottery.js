(function () {
    app.controller('Report.receiveLottery', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService) {
            var vm = angular.extend(this, viewModel);

            vm.month = vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];

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
                console.log("listDate: ", vm.listDate)
            }

            var data = [];
            var salePoint = [];
            vm.init = function () {
                vm.listMonth = [];
                vm.listLabelLine = [];
                vm.listLabelColunm = [];
                vm.groupById = [];
                vm.dataLine = [];
                vm.dataColunm = [];
                vm.listDate = [];

                var { startDate, endDate } = getDayFunction(vm.month);
                var currentDate = startDate;
                while (moment(currentDate) <= moment(endDate)) {
                    var temp = moment(currentDate).format('YYYY-MM-DD');
                    vm.listMonth.push({
                        date: temp,
                        quantity: 0
                    });
                    vm.listLabelLine.push(parseInt(temp.slice(8)));
                    currentDate = moment(currentDate).add(1, 'day');
                };
                console.log("vm.listLabelLine", vm.listLabelLine);

                vm.listAgency.forEach(function (item) {
                    var temp = [];
                    vm.listData.forEach(function (ele) {
                        if (ele.AgencyId == item.Id) {
                            temp.push(ele);
                        }
                    });
                    vm.groupById.push({
                        id: item.Id,
                        name: item.Name,
                        data: temp,
                    });
                })
                console.log("vm.groupById: ", vm.groupById)


                // data for chart line
                vm.groupById.forEach(function (items) {
                    var data = [];
                    vm.listMonth.forEach(function (item) {
                        data.push(item.quantity == 0 ? null : item.quantity);
                    })

                    if (items) {
                        items.data.forEach(function (item) {
                            var index = parseInt(item.ActionDate.slice(8,10));
                            data[index - 1] += (item.TotalReceived + item.TotalDupReceived);
                        })
                    }
                    vm.dataLine.push({
                        name: items.name,
                        data: data,
                        id: items.id
                    })
                })

                // data for chart colunm
                vm.groupById.forEach(function (items) {
                    var sum = 0;

                    if (items) {
                        items.data.forEach(function (item) {
                            // var index = parseInt(item.DateSell.slice(8));
                            //if (item.TotalReturn >= 0) {
                            //    sum += item.TotalReturn;
                            //}

                            sum += (item.TotalReceived + item.TotalDupReceived)

                        })
                    }

                    vm.listLabelColunm.push(items.name);
                    vm.dataColunm.push(sum);
                })
                /*for(var i =1;i<=vm.dataLine[0].data.length;i++){
                    vm.listDate.push(i)
                }
                console.log(" vm.listDate: ", vm.listDate)*/

                var month = vm.month ? moment(vm.month).format('MM') : moment().format('MM');
                var year = vm.month ? moment(vm.month).format('YYYY') : moment().format('YYYY');
                vm.getDaysArray(year, month)
               

            }

            vm.init();
            $scope.getTotalForColumn = function (columnIndex) {
                let total = 0;
                for (const ele of vm.dataLine) {
                    total += ele.data[columnIndex];
                }
                return total;
            };

            var colorArray = ['#FF1700', '#CC6600', '#CF6DFA', '#FE6D03', '#FCD600',
                '#EDFC00', '#A4FC00', '#58FC00', '#1C9C03', '#04C35E',
                '#04C392', '#04C3B8', '#049BC3', '#0266D6', '#03257F',
                '#03257F', '#FE6D03', '#99045E', '#CC00FF', '#BD8656',
                '#836665', '#C68ECF', '#9EA640', '#cc00cc', '#95928A']

            var optionLine = {
                series: vm.dataLine,
                dataLabels: {
                    enabled: true,
                },
                chart: {
                    height: 500,
                    type: 'line',
                    zoom: {
                        enabled: false
                    },
                    animations: {
                        enabled: false
                    }
                },
                colors: colorArray,
                legend: {
                    position: 'right',
                    colors: colorArray
                },
                stroke: {
                    width: [5, 5, 4],
                    curve: 'straight'
                },
                labels: vm.listLabelLine,
                title: {
                    text: '' //'Missing data (null values)'
                },
                fill: {
                    colors: colorArray,
                    type: 'solid'
                },

            };

            //var chart = new ApexCharts(document.querySelector("#chartline"), optionLine);
            //chart.render();
            console.log("dataColunm", vm.dataColunm);
            var optionColunm = {
                series: [{
                    name: 'Total return',
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
                colors: colorArray,
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
                    categories: vm.listLabelColunm,
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