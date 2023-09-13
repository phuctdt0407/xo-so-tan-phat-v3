(function() {
    app.controller('Activity.transferDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.userInfo = {
                UserId: $rootScope.sessionInfo.UserId
            };
            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.changeTab = function (tabName) {
                vm.view = tabName;
                tabName == "paying-debt-content" ? vm.showSaveChange = true : vm.showSaveChange = false;

            }
            vm.changeTab('activity-log-content');

            vm.listData.forEach(function (item) {
                item.ShortName = '';
                try {
                    vm.listLottery.forEach(function (item1) {
                        if (item.LotteryChannelId == item1.Id) {
                            item.ShortName = item1.ShortName
                        }
                    })
                } catch (err) {

                }
                
            })

    }]);
})();
