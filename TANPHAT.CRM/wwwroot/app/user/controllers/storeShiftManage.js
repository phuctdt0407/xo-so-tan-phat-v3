(function () {
    app.controller('User.storeShiftManage', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', '$uibModal', 'dayOfWeek', 'dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, sortIcon, $uibModal, dayOfWeek, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';
            vm.params.day = moment(vm.params.day, formatDate).format('DD-MM-YYYY');
            vm.listForManager = [];

            if ($rootScope.sessionInfo.IsManager) {
                console.log("vào đây 1");
                vm.listStore = Enumerable.From(vm.listSalePoint)
                    .GroupBy(function (item) { return item.SalePointId; })
                    .Select(function (item, i) {
                        return {
                            ManagerId: item.source[0].ManagerId,
                            ManagerName: item.source[0].ManagerName,
                            SalePointName: item.source[0].SalePointName,
                            SalePointId: item.source[0].SalePointId,
                            ShiftUser1Id: item.source[0].UserId,
                            ShiftUser1Name: item.source[0].FullName,
                            ShiftUser2Id: item.source[1].UserId,
                            ShiftUser2Name: item.source[1].FullName,
                            DistributeMonth: moment(vm.params.days).format('YYYY-MM')
                        };
                    })
                    .ToArray();
               
                vm.listStore.forEach(function (res) {
                    if (res.ManagerId == $rootScope.sessionInfo.UserId) {
                        vm.listForManager.push(res);
                    }
                   
                })
            } else {
                console.log("vào đây 2");
                vm.listStore = Enumerable.From(vm.listSalePoint)
                    .GroupBy(function (item) { return item.SalePointId; })
                    .Select(function (item, i) {
                        return {
                            ManagerId: item.source[0].ManagerId,
                            ManagerName: item.source[0].ManagerName,
                            SalePointName: item.source[0].SalePointName,
                            SalePointId: item.source[0].SalePointId,
                            ShiftUser1Id: item.source[0].UserId,
                            ShiftUser1Name: item.source[0].FullName,
                            ShiftUser2Id: item.source[1].UserId,
                            ShiftUser2Name: item.source[1].FullName,
                            DistributeMonth: moment(vm.params.days).format('YYYY-MM')
                        };
                    })
                    .ToArray();
                vm.listForManager = vm.listStore;
            }

            console.log(" vm.listForManager", vm.listForManager);
            console.log("vm.listStore1: ", vm.listStore1);
            console.log("vm.listSalePoint", vm.listSalePoint);

            vm.dayDisplay = dayOfWeekVN[moment(moment(vm.params.day, formatDate)).day()].Name + ", " + vm.params.day;
            vm.changeDate = function () {
                $state.go($state.current, { day: moment(vm.params.day, formatDate).format(outputDate) }, { reload: true, notify: true });
            }

            vm.clickToday = function (days = 0) {
                vm.params.day = moment().add(days, 'days').format("YYYY-MM-DD");
                vm.changeDate();
            }

            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            
        }]);
})();
