
(function () {
    app.controller('Report.dividedLottery', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService', '$q', 'ddlService', '$stateParams',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService, $q, ddlService, $stateParams) {
            var vm = angular.extend(this, viewModel);
            vm.totalRow = vm.listUser && vm.listUser.length > 0 ? vm.listUser[0].TotalCount : 0;

            vm.month = vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];

            var dataChartColunm = [];
            var lableChartColunm = [];

            var dataChartLine = [];
            var dataSold = [];
            var lableChartLine = [];
            vm.dataTable = []
            vm.listDate = []

            vm.listSalePointDropDown = angular.copy(vm.listSalePoint)
            vm.listSalePointDropDown.unshift({
                Id: 0,
                Name: 'Tất cả',
                Email: null,
                NameEN: null
            })

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

            var result = [];

            vm.currentSalePoint = '';

            vm.getLotterySellInMonth = function () {
                var deferred = $q.defer();
                var params = angular.copy($stateParams);
                params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                $q.all([
                    reportService.getLotterySellInMonth({ month: params.month }),
                ]).then(function (res) {
                    var result = {
                        listData: res[0],
                    };
                    deferred.resolve(result);
                });
                return deferred.promise;
            }

            vm.showChartDialog = function (name) {
                dataSold = [];
                vm.currentSalePoint = name;
                vm.getLotterySellInMonth().then(function (res) {
                    const sumInMonth = JSON.parse(res.listData.SUM);
                    vm.listSalePoint.forEach(function (item) {
                        var totalRetail = 0;
                        var temp = {};
                        temp.name = item.Name;
                        temp.data = [];
                        vm.listMonth.forEach(function (ele) {
                            temp.data.push(null);
                        })
                        sumInMonth.forEach(function (ele) {
                            if (item.Id == ele.SalePointId) {
                                totalRetail += ele.Retail;
                                var index = parseInt(ele.ActionDate.slice(8, 10)) - 1;
                                temp.data[index] += ele.Retail;
                            }
                        })
                        dataSold.push(temp);
                    })
                    
                    var selectedData = vm.dataTable.find(function (ele) {
                        return ele.name === name;
                    });

                    var chartData = selectedData.data.map(function (item) {
                        return item;
                    });

                    var selectedSalePointSoldData = dataSold.find(function (ele) {
                        return ele.name === name;
                    });

                    var chartSoldData = selectedSalePointSoldData.data.map(function (item) {
                        return item;
                    });

                    var options = {
                        chart: {
                            type: 'bar',
                            height: 400,
                            width: '100%',
                            stacked: false,
                        },
                        dataLabels: {
                            enabled: false
                        },
                        series: [
                            {
                                name: 'Vé chia',
                                data: chartData,
                            },
                            {
                                name: 'Vé bán',
                                data: chartSoldData,
                            },
                        ],
                        xaxis: {
                            categories: vm.listDate.map(function (item) {
                                return item.time;
                            }),
                        }
                    };
                    $('#chartDialog').children().remove();
                    chartSalePoint = new ApexCharts(
                        document.getElementById('chartDialog'),
                        options
                    );
                    chartSalePoint.render();
                })
            };

            vm.init = function () {
                vm.listMonth = [];
                dataSold = [];

                var { startDate, endDate } = getDayFunction(vm.month);
                var currentDate = startDate;

                while (moment(currentDate) <= moment(endDate)) {
                    var temp = moment(currentDate).format('YYYY-MM-DD');
                    vm.listMonth.push({
                        date: temp,
                        quantity: 0
                    })
                    currentDate = moment(currentDate).add(1, 'day');
                    lableChartLine.push(parseInt(temp.slice(8)));
                }

                vm.listSalePoint.forEach(function (item) {
                    var totalReceived = 0;
                    var temp = {};
                    temp.name = item.Name;
                    temp.data = [];
                  
                    vm.listMonth.forEach(function (ele) {
                        temp.data.push(null);
                    })

                    lableChartColunm.push(item.Name);
                    vm.listDetail.forEach(function (ele) {
                        
                        
                        if (item.Id == ele.SalePointId) {
                          
                            totalReceived += ele.TotalReceived;
                            totalReceived += ele.TotalDupReceived;

                            var index = parseInt(ele.LotteryDate.slice(8, 10)) - 1;
                            temp.data[index] += ele.TotalReceived;
                            temp.data[index] += ele.TotalDupReceived;
                        }
                    })

                    dataChartLine.push(temp);
                    dataChartColunm.push(totalReceived);
                    var c = 1;
                    if (Array.isArray(vm.params.salePointId)) {
                        console.log('Vào đây1');
                      
                        if (vm.params.salePointId.length > 0) {
                            for (var i = 0; i < vm.params.salePointId.length; i++) {
                                //console.log("item.Id", item.Id);
                                console.log("vm.params.salePointId[]", vm.params.salePointId[i]);
                                if (item.Id == vm.params.salePointId[i]) {
                                    result.push(totalReceived);
                                    //vm.params.salePointId.splice(i, 1);
                                    c = 0;
                                }
                            }
                            if (c == 1) {
                                result.push(0);
                            }
                        } else {
                            result.push(totalReceived);
                        }

                    } else {
                        
                        if (vm.params.salePointId == undefined || vm.params.salePointId == 0) {
                            console.log('Vào đây');
                            result.push(totalReceived);
                        }
                        else if (item.Id == vm.params.salePointId) {
                            result.push(totalReceived);
                        } else {
                            console.log('Vào đây1');
                            result.push(0);

                        }
                    }
                   
                })
             //   console.log("vm.params.salePointId", vm.params.salePointId);
             //   console.log("Độ dàu", dataChartColunm.length);
             //   var selectedItem = vm.params.salePointId;
             //   if (Array.isArray(vm.params.salePointId)) {
             //       result = new Array(dataChartColunm.length).fill(0);
             //       for (var i = 0; i < vm.params.salePointId.length; i++) {

             //           result[vm.params.salePointId[i] - 1] = dataChartColunm[vm.params.salePointId[i]-1];

             //       }
             //   } else if (vm.params.salePointId != 0 && vm.params.salePointId != undefined) {
             //       result = new Array(dataChartColunm.length).fill(0);
             //       result[vm.params.salePointId-1] = dataChartColunm[vm.params.salePointId-1];
             //1   } else {
             //       result = angular.copy(dataChartColunm);
                //   }
                vm.dataTable = dataChartLine;
                console.log("result.length",result);
                var month = vm.month ? moment(vm.month).format('MM') : moment().format('MM');
                var year = vm.month ? moment(vm.month).format('YYYY') : moment().format('YYYY');
                vm.getDaysArray(year, month)

                //console.log("vm.params.salePointId", vm.params.salePointId);
                vm.params.salePointId = [];
                vm.showChartDialog(vm.listSalePoint[0].Name);
            }

            vm.init();
            $scope.getTotalForColumn = function (columnIndex) {
                let total = 0;
                for (const ele of vm.dataTable) {
                    total += ele.data[columnIndex];
                }
                return total;
            };
            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.loadData = function () {
               
                vm.params.month = moment(vm.month).format('YYYY-MM');
             
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            var colorArray = ['#FF1700', '#CC6600', '#CF6DFA', '#FE6D03', '#FCD600',
                '#EDFC00', '#A4FC00', '#58FC00', '#1C9C03', '#04C35E',
                '#04C392', '#04C3B8', '#049BC3', '#0266D6', '#03257F',
                '#03257F', '#FE6D03', '#99045E', '#CC00FF', '#BD8656',
                '#836665', '#C68ECF', '#9EA640', '#cc00cc', '#95928A']
            var options = {
                series: [{
                    name: 'Tổng vé chia',
                    data: result,
                }],
                chart: {
                    height: 350,
                    type: 'bar',
                    events: {
                        click: function (chart, w, e) {
                        }
                    }
                },
                colors: colorArray,
                plotOptions: {
                    bar: {
                        columnWidth: '60%',
                        distributed: true,
                        dataLabels: {
                            position: 'top'
                        },
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
                            fontSize: '12px'
                        }
                    }
                }
            };

            var chart = new ApexCharts(document.querySelector("#chartColunm"), options);
            chart.render();

        }]);
})();