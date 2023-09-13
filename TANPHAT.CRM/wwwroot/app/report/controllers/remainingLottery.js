(function () {
    app.controller('Report.remainingLottery', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService) {
            var vm = angular.extend(this, viewModel);
            vm.chart = null
            
            vm.init = function () {
                var dataRow = [];
                var dataColumnForTheNorth = [];
                var dataColumnForTheSouth = [];
                var dataColumnForTheCentral = [];
                var totalSum = [];
                vm.listRemainLottery.forEach(function (item) {
                    dataRow.push("Tổng:" + (item.TotalRemainingTheNorth + item.TotalRemainingTheCentral + item.TotalRemainingTheSouth) +'\n'+ item.SalePointName);
                    dataColumnForTheNorth.push(item.TotalRemainingTheNorth);
                    dataColumnForTheSouth.push(item.TotalRemainingTheSouth);
                    dataColumnForTheCentral.push(item.TotalRemainingTheCentral);
                    totalSum.push[ item.TotalRemainingTheNorth + item.TotalRemainingTheCentral + item.TotalRemainingTheSouth];
                })
                console.log('totalSum', totalSum);
                
                var optionColunm = {
                    series: [{
                        name: 'Miền Nam',
                        data: dataColumnForTheSouth,
                        color: '#008FFB',

                    },{
                        name: 'Miền Trung',
                        data: dataColumnForTheCentral,
                        color: '#00E396',

                    },{
                        name: 'Miền Bắc',
                        data: dataColumnForTheNorth,
                        color: '#FEB019',

                    }],
                    chart: {
                        height: 500,
                        type: 'bar',
                        events: {
                            click: function (chart, w, e) {
                            }
                        },
                        stacked: true,
                        colorByPoint: true,
                    },
                    /*colors: colorArray,*/
                    plotOptions: {
                        /*bar: {
                            columnWidth: '60%',
                            distributed: true,
                            dataLabels: {
                                position: 'center'
                            },
                        }*/

                        bar: {
                            columnWidth: '60%',
                            horizontal: false,
                            borderRadius: 10,
                            dataLabels: {
                                total: {
                                    enabled: true,

                                }
                            }
                        },
                    },
                    dataLabels: {
                        enabled: true,
                        style: {
                            fontSize: '12px',
                            fontWeight: 'bold'
                        },
                     
                    },
                    tooltip: {
                        y: {
                            formatter: function (val) {
                                return val
                            }
                        }
                    },
                    fill: {
                        opacity: 1
                    },
                    legend: {
                        position: 'top',
                        horizontalAlign: 'left',
                        offsetX: 40
                    },
                    stroke: {
                        width: 1,
                        colors: ['#fff']
                    },
                    xaxis: {
                        categories: dataRow,
                        labels: {
                            /*style: {
                                colors: '#000',
                                fontSize: '14px'
                            },*/
                            formatter: function (val) {
                                return val 
                            }
                        }
                    },
                    yaxis: {
                        title: {
                            text: undefined
                        },
                    },
                };
                vm.chart = new ApexCharts(document.querySelector("#chartColunm"), optionColunm);
                console.log(vm.chart)

                vm.chart.render();
            }

            vm.init();

            $rootScope.connection.on("ReceiveMessage", function (user, message) {
                if ((user == 'addLotteryManage' || user == 'ChangeRemain') && message) {
                    reportService.getTotalRemainingOfAllSalePointInDate().then(res => {
                        vm.listRemainLottery = res
                        if (vm.chart) {
                            vm.chart.destroy()
                        }
                        vm.init()
                    })
                }
            })

            var colorArray = ['#FF1700', '#CC6600', '#CF6DFA', '#FE6D03', '#FCD600',
                '#EDFC00', '#A4FC00', '#58FC00', '#1C9C03', '#04C35E',
                '#04C392', '#04C3B8', '#049BC3', '#0266D6', '#03257F',
                '#03257F', '#FE6D03', '#99045E', '#CC00FF', '#BD8656',
                '#836665', '#C68ECF', '#9EA640', '#cc00cc', '#95928A']
        }]);
})();