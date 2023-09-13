(function () {
    app.controller('Activity.sendAndReceive', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'shiftStatus',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, shiftStatus) {
            var vm = angular.extend(this, viewModel);

            vm.month = vm.params.month == '' ? moment().format('YYYY-MM') : vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];

            vm.dataTable = []
            vm.listDate = []

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
                //console.log("listDate: ", vm.listDate)
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
                    })
                    currentDate = moment(currentDate).add(1, 'day');
                }
                vm.listSalePoint.forEach(function (item) {
                    var totalOffset = 0;
                    var temp = {};
                    temp.name = item.Name;
                    temp.data = [];
                    temp.data1 = [];
                    vm.listMonth.forEach(function (ele) {
                        temp.data.push(null);
                        temp.data1.push(null);
                    })

                    vm.listTransitionTypeOffset.forEach(function (ele) {
                        if (item.Id == ele.SalePointId && ele.ChannelGroup==-1) {
                            totalOffset += ele.Offset;
                            var index = parseInt(ele.TransitionDate.slice(8, 10)) - 1;
                            temp.data[index] += ele.Offset;
                        } else if (item.Id == ele.SalePointId && ele.ChannelGroup == 1) {
                            totalOffset += ele.Offset;
                            var index = parseInt(ele.TransitionDate.slice(8, 10)) - 1;
                            temp.data1[index] += ele.Offset;
                        }
                    })
                    vm.dataTable.push(temp)

                })
                /*for (var i = 1; i <= vm.dataTable[0].data.length; i++) {
                    vm.listDate.push(i)
                }*/

                var month = vm.month ? moment(vm.month).format('MM') : moment().format('MM');
                var year = vm.month ? moment(vm.month).format('YYYY') : moment().format('YYYY');
                vm.getDaysArray(year, month)
            }

            vm.init();
            console.log("vm.dataTable", vm.dataTable)
            console.log("vm.listTransitionTypeOffset", vm.listTransitionTypeOffset)
            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

        }]);
})();
