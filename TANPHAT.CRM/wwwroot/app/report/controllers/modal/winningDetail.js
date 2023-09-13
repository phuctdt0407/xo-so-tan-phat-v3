(function () {
    app.controller('Report.winningDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService) {
            var vm = angular.extend(this, viewModel);

            vm.listData = []

            vm.init = function () {
                vm.data.DataWinning.forEach(function (res) {
                    if (res.LotteryChannelId == vm.lotteryChannelId) {
                        vm.listData.push(res)
                    }
                })
                vm.listData.forEach(function (res) {
                    res.totalPrice = res.Quantity * res.WinningPrice;
                })
            }
           vm.init()

            vm.close = function () {
                $uibModalInstance.close();
            }

        }]);
})();
