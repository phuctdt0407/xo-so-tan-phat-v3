(function () {
    app.controller('Report.hardWorking', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'shiftStatus',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, shiftStatus) {
            var vm = angular.extend(this, viewModel);
            //vm.totalRow = vm.listUser && vm.listUser.length > 0 ? vm.listUser[0].TotalCount : 0;
            vm.listStatus = angular.copy(shiftStatus);

            vm.month = vm.params.month;
            vm.loadData = function () {
                console.log("test")
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }
            console.log("vm.listStaff1", vm.listStaff);
            vm.initData = function () {
                vm.listStaff.forEach(function (item) {
                    var temp = angular.copy(vm.listSalePoint);
                    item.sumType1 = 0;
                    item.sumType2 = 0;
                    item.sumType3 = 0;
                    item.listSalePoint = temp;
                })
       
                vm.listSalePoint.forEach(function (item) {
                    var temp2 = angular.copy(vm.listStaff);
                    item.listStaff = temp2;
                })
                console.log("vm.listTotalShift", vm.listTotalShift);
                vm.listTotalShift.forEach(function (item) {
                    var target = vm.listStaff.findIndex(x => x.Id == item.UserId);
                    var targetSalePoint = vm.listSalePoint.findIndex(x => x.Id == item.SalePointId);

                    try {
                        var temp = vm.listSalePoint[targetSalePoint].listStaff[target];
                        temp["TotalRemaining_" + item.ShiftTypeId] = item.Quantity;

                        vm.listStaff[target]['sumType' + item.ShiftTypeId] += item.Quantity;
                       
                        vm.listStatus.forEach(function (ele) {
                            var targetShiftStatus = vm.listStatus.findIndex(x => x.Id == item.ShiftTypeId);
                            temp["Ca_" + item.ShiftTypeId] = vm.listStatus[targetShiftStatus].SName;
                        })
                    } catch (err) {

                    }
                   
                })
            }
            vm.initData();

        }]);
})();
