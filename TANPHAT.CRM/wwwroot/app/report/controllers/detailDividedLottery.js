(function () {
    app.controller('Report.detailDividedLottery', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService) {
            var vm = angular.extend(this, viewModel);

            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';

            vm.listSalePoint.unshift({
                Id: 0, Name: 'Tất cả '
            })

            vm.listData.forEach(function (item) {
                item.ActionDate =moment(item.ActionDate).format("DD/MM/yyyy,  HH:mm:ss")
            })
            console.log("vm.listData", vm.listData);
            vm.changeDate = function () {
                vm.params.date = moment(vm.params.date, formatDate).format(outputDate)
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }

            /*function groupBy(arr, prop) {
                const map = new Map(Array.from(arr, obj => [obj[prop], []]));
                arr.forEach(obj => map.get(obj[prop]).push(obj));
                return Array.from(map.values());
            }

            console.log(groupBy(vm.listData, "group"));*/
        }]);
})();