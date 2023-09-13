(function () {
    app.controller('User.workSchedule', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService','dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, notificationService, userService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            vm.distributeInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                SalePointId: vm.params.salePointId
            };
            vm.month = vm.params.distributeMonth;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];

            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.loadData = function () {
                vm.params.distributeMonth = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.initData = function () {
                vm.listMonth = [];
                var { startDate, endDate } = getDayFunction(vm.month);
                var currentDate = startDate;
                while (moment(currentDate) <= moment(endDate)) {
                    var temp = moment(currentDate).format('YYYY-MM-DD');
                    vm.listMonth.push({
                        DistributeDate: temp,
                        IsChecked: false,
                        IsWeekEnd: moment(temp).day() == 0,
                        DateName: vm.dayOfWeekVN[moment(temp).day()].SName,
                    })
                    currentDate = moment(currentDate).add(1, 'day');
                }
                if (vm.listDistribute && vm.listDistribute.length > 0) {
                    angular.forEach(vm.listMonth, function (m) {
                        angular.forEach(vm.listDistribute, function (d) {
                            if (m.DistributeDate == moment(d.DistributeDate).format('YYYY-MM-DD')) {
                                m['Shift' + d.ShiftId] = d.UserId;
                            }
                        });
                    });
                }
            }
            vm.initData();

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.isCheckApply = function (index) {
                if (vm.listMonth[index].IsChecked == true && (!vm.listMonth[index + 1] || vm.listMonth[index + 1].IsChecked == false))
                    return true;
                return false;
            }

            vm.save = function () {

                if (vm.listMonth.length > 0) {
                    vm.listSave = [];
                    vm.listMonth.forEach(function (item) {
                        vm.listSave.push({
                            DistributeDate: item.DistributeDate,
                            ShiftId: 1,
                            UserId: item.Shift1
                        })
                        vm.listSave.push({
                            DistributeDate: item.DistributeDate,
                            ShiftId: 2,
                            UserId: item.Shift2
                        })
                    })
                    vm.distributeInfo.DistributeData = JSON.stringify(vm.listSave);
                    userService.distributeShift(vm.distributeInfo).then(function (res) {
                        if (res && res.Id > 0) {
                            notificationService.success(res.Message);
                        }
                        else {
                            notificationService.error(res.Message);
                        }
                    });
                }
                else {
                    notificationService.error('Chưa chọn nhân viên nào để chia ca');
                }
            }

            vm.onClickApplyAll = function (index) {
                var _index = angular.copy(index);
                var temp = [];
                do {
                    temp.unshift(vm.listMonth[_index]);

                    _index = _index - 1;
                } while (_index >= 0 && vm.listMonth[_index].IsChecked == true)

                var _index1 = index + 1;
                var i = 0;
                var n = temp.length;
                while (vm.listMonth[_index1]) {
                    if (i == n) {
                        i = 0;
                    } else {
                        vm.listMonth[_index1].Shift1 = temp[i].Shift1;
                        vm.listMonth[_index1].Shift2 = temp[i].Shift2;
                        vm.listMonth[_index1].IsChecked = false;

                        i = i + 1;
                        _index1 = _index1 + 1;
                    }
                }
            }

            vm.onChangeShift2 = function (model, index) {
                if (vm.listMonth[index + 1]) {
                    vm.listMonth[index + 1].Shift1 = model.Shift2
                }
            }
         
        }]);
})();

