(function () {
    app.controller('Report.soldLottery', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService', '$q', '$stateParams', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService, $q, $stateParams, salepointService) {
            var vm = angular.extend(this, viewModel);

            $scope.listSalePoint = vm.listSalePoint;
            $scope.listEmployee = vm.listStaff;

            vm.month = vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];
            vm.listLotteryType = [
                {
                    lotteryTypeId: 0,
                    lotteryName: "Tất cả"
                },{
                    lotteryTypeId: 1,
                    lotteryName: "Vé số"
                },
                {
                    lotteryTypeId: 3,
                    lotteryName: "Vé cào"
                }
            ]
            vm.listStaffDropDown = angular.copy(vm.listStaff);
            vm.listStaffDropDown.unshift({
                Id: 0,
                Name: 'Tất cả',
                NameEN: null,
                Email: null
            })

            vm.getListSalePoint = function () {
                var deferred = $q.defer();
                $q.all([
                    salepointService.getListSalePoint()
                ]).then(function (res) {
                    deferred.resolve(res);
                });
                return deferred.promise;
            }

            vm.getLotterySaleInMonthOfSalePoint = function (month) {
                var deferred = $q.defer();
                var params = angular.copy($stateParams);
                $q.all([
                    // userid = 0: get all sale point
                    // lotteryTypeId: 0: get all lottery type
                    reportService.getTotalLotterySellOfUserInMonth({ month: month, userid: 0, lotteryTypeId: 0 }),
                ]).then(function (res) {
                    deferred.resolve(res)
                });
                return deferred.promise;
            }

            vm.firstSalePointId = "";
            vm.firstSelectedMonth = moment().format('YYYY-MM');
            vm.firstSalePointChartData = {
                mienBac: 0,
                mienTrung: 0,
                mienNam: 0,
                caoTP: 0,
                caoDN: 0
            };

            vm.secondSalePoint = "";
            vm.secondSalePointId = "";
            vm.secondSelectedMonth = moment().format('YYYY-MM');
            vm.secondSalePointChartData = {
                mienBac: 0,
                mienTrung: 0,
                mienNam: 0,
                caoTP: 0,
                caoDN: 0
            };

            vm.onClickSearchFirstSalePoint = function () {
                vm.firstSalePointChartData = {
                    mienBac: [],
                    mienTrung: [],
                    mienNam: [],
                    caoTP: [],
                    caoDN: []
                };
                vm.getLotterySaleInMonthOfSalePoint(vm.firstSelectedMonth).then(function (res) {
                    var dataReturn = res[0];
                    var totalMienNam = 0;
                    var totalMienBac = 0;
                    var totalMienTrung = 0;
                    var caoTP = 0;
                    var caoDN = 0;
                    dataReturn.filter(item => item.SalePointId == vm.firstSalePointId).forEach(item => {
                        if (item.RegionId == 2 && item.LotteryChannelId < 1000) { // Mien nam
                            totalMienNam += item.TotalLottery;
                        }
                        if (item.RegionId == 3 && item.LotteryChannelId < 1000) { // Mien Trung
                            totalMienTrung += item.TotalLottery;
                        }
                        if (item.RegionId == 1 && item.LotteryChannelId < 1000) { // Mien Bac
                            totalMienBac += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1000) { // Cao Thanh pho
                            caoTP += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1001) { // Cao Dong Nai
                            caoDN += item.TotalLottery;
                        }
                    });
                    vm.firstSalePointChartData = {
                        mienBac: totalMienBac,
                        mienTrung: totalMienTrung,
                        mienNam: totalMienNam,
                        caoTP: caoTP,
                        caoDN: caoDN
                    };
                    var options = {
                        chart: {
                            type: 'bar',
                            height: 400,
                            width: '100%',
                            stacked: false,
                        },
                        dataLabels: {
                            enabled: true,
                            style: {
                                fontSize: ['14px'],
                                colors: ['#fff']
                            }
                        },
                        series: [
                            {
                                name: 'Tổng vé:',
                                data: [vm.firstSalePointChartData.mienBac, vm.firstSalePointChartData.mienTrung, vm.firstSalePointChartData.mienNam, vm.firstSalePointChartData.caoTP, vm.firstSalePointChartData.caoDN],
                            },
                        ],
                        xaxis: {
                            categories: ["Miền bắc", "Miền trung", "Miền nam", "Cào TP", "Cào ĐN"]
                        }
                    };
                    $('#firstSalePointChart').children().remove();
                    var chartSalePoint = new ApexCharts(
                        document.getElementById('firstSalePointChart'),
                        options
                    );
                    chartSalePoint.render();
                })
            }

            vm.onClickSearchSecondSalePoint = function () {
                vm.secondSalePointChartData = {
                    mienBac: [],
                    mienTrung: [],
                    mienNam: [],
                    caoTP: [],
                    caoDN: []
                };
                vm.getLotterySaleInMonthOfSalePoint(vm.secondSelectedMonth).then(function (res) {
                    var dataReturn = res[0];
                    var totalMienNam = 0;
                    var totalMienBac = 0;
                    var totalMienTrung = 0;
                    var caoTP = 0;
                    var caoDN = 0;
                    dataReturn.filter(item => item.SalePointId == vm.secondSalePointId).forEach(item => {
                        if (item.RegionId == 2 && item.LotteryChannelId < 1000) { // Mien nam
                            totalMienNam += item.TotalLottery;
                        }
                        if (item.RegionId == 3 && item.LotteryChannelId < 1000) { // Mien Trung
                            totalMienTrung += item.TotalLottery;
                        }
                        if (item.RegionId == 1 && item.LotteryChannelId < 1000) { // Mien Bac
                            totalMienBac += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1000) { // Cao Thanh pho
                            caoTP += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1001) { // Cao Dong Nai
                            caoDN += item.TotalLottery;
                        }
                    });
                    vm.secondSalePointChartData = {
                        mienBac: totalMienBac,
                        mienTrung: totalMienTrung,
                        mienNam: totalMienNam,
                        caoTP: caoTP,
                        caoDN: caoDN
                    };
                    var options = {
                        chart: {
                            type: 'bar',
                            height: 400,
                            width: '100%',
                            stacked: false,
                        },
                        dataLabels: {
                            enabled: true,
                            style: {
                                fontSize: ['14px'],
                                colors: ['#fff']
                            }
                        },
                        series: [
                            {
                                name: 'Tổng vé:',
                                data: [vm.secondSalePointChartData.mienBac, vm.secondSalePointChartData.mienTrung, vm.secondSalePointChartData.mienNam, vm.secondSalePointChartData.caoTP, vm.secondSalePointChartData.caoDN],
                            },
                        ],
                        xaxis: {
                            categories: ["Miền bắc", "Miền trung", "Miền nam", "Cào TP", "Cào ĐN"]
                        }
                    };
                    $('#secondSalePointChart').children().remove();
                    var chartSalePoint = new ApexCharts(
                        document.getElementById('secondSalePointChart'),
                        options
                    );
                    chartSalePoint.render();
                })
            }

            vm.onSelectFirstMonth = function () {
                vm.firstSelectedMonth = moment(vm.firstSelectedMonth).format('YYYY-MM');
            }

            vm.onSelectSecondMonth = function () {
                vm.secondSalePoint = moment(vm.secondSalePoint).format('YYYY-MM');
            }

            vm.firstEmployeeId = "";
            vm.firstEmployeeSelectedMonth = moment().format('YYYY-MM');
            vm.firstEmployeeChartData = {
                mienBac: 0,
                mienTrung: 0,
                mienNam: 0,
                caoTP: 0,
                caoDN: 0
            };

            vm.secondEmployeeId = "";
            vm.secondEmployeeIdSelectedMonth = moment().format('YYYY-MM');
            vm.secondEmployeeIdChartData = {
                mienBac: 0,
                mienTrung: 0,
                mienNam: 0,
                caoTP: 0,
                caoDN: 0
            };

            vm.onClickSearchFirstEmployee = function () {
                vm.firstEmployeeChartData = {
                    mienBac: 0,
                    mienTrung: 0,
                    mienNam: 0,
                    caoTP: 0,
                    caoDN: 0
                };
                vm.getLotterySaleInMonthOfSalePoint(vm.firstEmployeeSelectedMonth).then(function (res) {
                    var dataReturn = res[0];
                    var totalMienNam = 0;
                    var totalMienBac = 0;
                    var totalMienTrung = 0;
                    var caoTP = 0;
                    var caoDN = 0;
                    dataReturn.filter(item => item.UserId == vm.firstEmployeeId).forEach(item => {
                        if (item.RegionId == 2 && item.LotteryChannelId < 1000) { // Mien nam
                            totalMienNam += item.TotalLottery;
                        }
                        if (item.RegionId == 3 && item.LotteryChannelId < 1000) { // Mien Trung
                            totalMienTrung += item.TotalLottery;
                        }
                        if (item.RegionId == 1 && item.LotteryChannelId < 1000) { // Mien Bac
                            totalMienBac += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1000) { // Cao Thanh pho
                            caoTP += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1001) { // Cao Dong Nai
                            caoDN += item.TotalLottery;
                        }
                    });
                    vm.firstEmployeeChartData = {
                        mienBac: totalMienBac,
                        mienTrung: totalMienTrung,
                        mienNam: totalMienNam,
                        caoTP: caoTP,
                        caoDN: caoDN
                    };
                    var options = {
                        chart: {
                            type: 'bar',
                            height: 400,
                            width: '100%',
                            stacked: false,
                        },
                        dataLabels: {
                            enabled: true,
                            style: {
                                fontSize: ['14px'],
                                colors: ['#fff']
                            }
                        },
                        series: [
                            {
                                name: 'Tổng vé:',
                                data: [vm.firstEmployeeChartData.mienBac, vm.firstEmployeeChartData.mienTrung, vm.firstEmployeeChartData.mienNam, vm.firstEmployeeChartData.caoTP, vm.firstEmployeeChartData.caoDN],
                            },
                        ],
                        xaxis: {
                            categories: ["Miền bắc", "Miền trung", "Miền nam", "Cào TP", "Cào ĐN"]
                        }
                    };
                    $('#firstEmployeeChart').children().remove();
                    var chartSalePoint = new ApexCharts(
                        document.getElementById('firstEmployeeChart'),
                        options
                    );
                    chartSalePoint.render();
                })

            }

            vm.onClickSearchSecondEmployee = function () {
                vm.secondEmployeeIdChartData = {
                    mienBac: 0,
                    mienTrung: 0,
                    mienNam: 0,
                    caoTP: 0,
                    caoDN: 0
                };
                vm.getLotterySaleInMonthOfSalePoint(vm.secondEmployeeIdSelectedMonth).then(function (res) {
                    var dataReturn = res[0];
                    var totalMienNam = 0;
                    var totalMienBac = 0;
                    var totalMienTrung = 0;
                    var caoTP = 0;
                    var caoDN = 0;
                    dataReturn.filter(item => item.UserId == vm.secondEmployeeId).forEach(item => {
                        if (item.RegionId == 2 && item.LotteryChannelId < 1000) { // Mien nam
                            totalMienNam += item.TotalLottery;
                        }
                        if (item.RegionId == 3 && item.LotteryChannelId < 1000) { // Mien Trung
                            totalMienTrung += item.TotalLottery;
                        }
                        if (item.RegionId == 1 && item.LotteryChannelId < 1000) { // Mien Bac
                            totalMienBac += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1000) { // Cao Thanh pho
                            caoTP += item.TotalLottery;
                        }
                        if (item.LotteryChannelId == 1001) { // Cao Dong Nai
                            caoDN += item.TotalLottery;
                        }
                    });
                    vm.secondEmployeeIdChartData = {
                        mienBac: totalMienBac,
                        mienTrung: totalMienTrung,
                        mienNam: totalMienNam,
                        caoTP: caoTP,
                        caoDN: caoDN
                    };
                    var options = {
                        chart: {
                            type: 'bar',
                            height: 400,
                            width: '100%',
                            stacked: false,
                        },
                        dataLabels: {
                            enabled: true,
                            style: {
                                fontSize: ['14px'],
                                colors: ['#fff']
                            }
                        },
                        series: [
                            {
                                name: 'Tổng vé:',
                                data: [vm.secondEmployeeIdChartData.mienBac, vm.secondEmployeeIdChartData.mienTrung, vm.secondEmployeeIdChartData.mienNam, vm.secondEmployeeIdChartData.caoTP, vm.secondEmployeeIdChartData.caoDN],
                            },
                        ],
                        xaxis: {
                            categories: ["Miền bắc", "Miền trung", "Miền nam", "Cào TP", "Cào ĐN"]
                        }
                    };
                    $('#secondEmployeeChart').children().remove();
                    var chartSalePoint = new ApexCharts(
                        document.getElementById('secondEmployeeChart'),
                        options
                    );
                    chartSalePoint.render();
                })

            }

            vm.onSelectFirstEmployeeMonth = function () {
                vm.firstEmployeeSelectedMonth = moment(vm.firstEmployeeSelectedMonth).format('YYYY-MM');
            }

            vm.onSelectSecondEmployeeMonth = function () {
                vm.secondEmployeeIdSelectedMonth = moment(vm.secondEmployeeIdSelectedMonth).format('YYYY-MM');
            }

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

            vm.initData = function () {
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
                    })
                    vm.listLabelLine.push(parseInt(temp.slice(8)));
                    currentDate = moment(currentDate).add(1, 'day');

                }
     
                if (vm.params.userid == undefined || vm.params.userid == 0) {

                } else {
                    const ketQua = [];

                    vm.params.userid.forEach(function (item) {
                        vm.listStaff.forEach(function (item1) {
                            if (item1.Id == item) {
                                ketQua.push(item1);
                            }
                        })
                    })

                    vm.listStaff = ketQua;

                }
    
                for (var i=0; i < vm.listStaff.length; i++) {
                    var temp = [];
                    for (var j=0; j < vm.listData.length; j++) {

                        if (vm.listData[j].UserId === vm.listStaff[i].Id) {
                            temp.push(vm.listData[j]);
                        }
                    }
                    vm.groupById.push({
                         id: vm.listStaff[i].Id,
                         name: vm.listStaff[i].Name,
                         data: temp
                    });
                }

                // data for chart line
                vm.groupById.forEach(function (items) {
                    var data = [];

                    vm.listMonth.forEach(function (item) {
                        data.push(item.quantity == 0 ? null : item.quantity);
                    })

                    if (items) {
                        items.data.forEach(function (item) {
                            var index = parseInt(item.DateSell.slice(8));
                            data[index - 1] += item.TotalLottery;
                        })
                    }

                    vm.dataLine.push({
                        name: items.name,
                        data: data
                    })
                    
                })
               
                // data for chart colunm
                vm.groupById.forEach(function (items) {
                    var sum = 0;

                    if (items) {
                        items.data.forEach(function (item) {
                             //var index = parseInt(item.DateSell.slice(8));
                            if (item.TotalLottery >= 0) {
                                sum += item.TotalLottery;
                            }
                        })
                    }

                    vm.listLabelColunm.push(items.name);
                    vm.dataColunm.push(sum);
                })
                /*for(var i =1;i<=vm.dataLine[0].data.length;i++){
                    vm.listDate.push(i)
                }*/

                var month = vm.month ? moment(vm.month).format('MM') : moment().format('MM');
                var year = vm.month ? moment(vm.month).format('YYYY') : moment().format('YYYY');
                vm.getDaysArray(year, month)

                vm.onClickSearchFirstSalePoint();
                vm.onClickSearchSecondSalePoint();
                vm.onClickSearchFirstEmployee();
                vm.onClickSearchSecondEmployee();
            }

            vm.initData();
      
            if (vm.params.userid == undefined || vm.params.userid == 0) {

            } else {
                const ketQua = [];
            
                vm.params.userid.forEach(function (item) {
                    vm.listEx.forEach(function (item1) {
                        if (item1.UserId == item) {
                            ketQua.push(item1);
                        }
                    })
                })
        
                vm.listEx = ketQua;
          
            }
           
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

            var optionLine = {
                series: vm.dataLine,
                dataLabels: {
                    enabled: true,
                    /*style: {
                        colors: colorArray,
                    }*/
                },
                colors: colorArray,
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
                fill: {
                    colors: colorArray,
                    type: 'solid'
                },
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
                xaxis: {
                },
            };

            //var chart = new ApexCharts(document.querySelector("#chartline"), optionLine);
            //chart.render();

            var optionColunm = {
                series: [{
                    name: 'Total sold',
                    data: vm.listEx.map(item => item.Average),
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
                    categories: vm.listEx.map(item => item.FullName),
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