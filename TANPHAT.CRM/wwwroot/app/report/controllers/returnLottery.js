(function () {
    app.controller('Report.returnLottery', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService) {
            var vm = angular.extend(this, viewModel);

            vm.month = vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];

            vm.listSalePointDropDown = angular.copy(vm.listSalePoint)
            vm.listSalePointDropDown.unshift({
                Id: 0,
                Name: 'Tất cả',
                Email: null,
                NameEN: null
            })

            var dataChartColunm = [];
            var lableChartColunm = [];

            var dataChartLine = [];
            var lableChartLine = [];
            vm.listDate = [];
            vm.dataTable = [];

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
                console.log("month: ", month)
                console.log("year: ", year)
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

            vm.init = function () {

                vm.listMonth = [];

                var { startDate, endDate } = getDayFunction(vm.month);
                var currentDate = startDate;

                while (moment(currentDate) <= moment(endDate)) {
                    var temp = moment(currentDate).format('YYYY-MM-DD');
                    vm.listMonth.push({
                        date: temp,
                        quantity: 0
                    });
                    currentDate = moment(currentDate).add(1, 'day');
                    lableChartLine.push(parseInt(temp.slice(8)));
                };

                vm.listSalePoint.forEach(function (item) {
                    var totalReturn = 0;
                    var temp = {};
                    temp.name = item.Name;
                    temp.data = [];

                    vm.listMonth.forEach(function (ele) {
                        temp.data.push(null);
                    })

                    lableChartColunm.push(item.Name);

                    vm.listReturnLottery.forEach(function (ele) {
                        if (item.Id == ele.SalePointId) {
                            totalReturn += ele.TotalReturn;

                            var index = parseInt(ele.DateReturn.slice(8, 10)) - 1;
                            temp.data[index] += ele.TotalReturn;
                        }
                    })

                    dataChartLine.push(temp);
                    dataChartColunm.push(totalReturn);
                })
                vm.dataTable = dataChartLine;
                /*for(var i =1;i<=vm.dataTable[0].data.length;i++){
                    vm.listDate.push(i)
                }*/

                var month = vm.month ? moment(vm.month).format('MM') : moment().format('MM');
                var year = vm.month ? moment(vm.month).format('YYYY') : moment().format('YYYY');
                vm.getDaysArray(year, month)
            }

            vm.init();

            var colorArray = ['#FF1700', '#CC6600', '#CF6DFA', '#FE6D03', '#FCD600',
                '#EDFC00', '#A4FC00', '#58FC00', '#1C9C03', '#04C35E',
                '#04C392', '#04C3B8', '#049BC3', '#0266D6', '#03257F',
                '#03257F', '#FE6D03', '#99045E', '#CC00FF', '#BD8656',
                '#836665', '#C68ECF', '#9EA640', '#CC00FF', '#95928A']

            var optionLine = {
                series: dataChartLine,
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
                labels: lableChartLine,
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

            var optionColunm = {
                series: [{
                    name: 'Total return',
                    data: dataChartColunm,
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
                    categories: lableChartColunm,
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