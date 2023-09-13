(function () {
    app.controller('Report.debtDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService', '$uibModal',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.tabId = 1;

            vm.listDebtData = vm.data != ""? JSON.parse(vm.data[0].DebtData) : [];
            vm.listPayedDebtData = vm.data != "" ? JSON.parse(vm.data[0].PayedDebtData) : [];


            vm.classItem0 = vm.tabId && vm.tabId == 1 ? 'nav-link active' : 'nav-link';
            vm.classItem1 = vm.tabId && vm.tabId == 2 ? 'nav-link active' : 'nav-link';

            vm.changeTab = function (tabId) {
                if (tabId === 1) {
                    vm.tabId = 1
                }
                if (tabId === 2) {
                    vm.tabId = 2
                }

            };

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            
        }]);
})();
