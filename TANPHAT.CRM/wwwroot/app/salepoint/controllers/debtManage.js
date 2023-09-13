(function () {
    app.controller('Salepoint.debtManage', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'salepointService', 'notificationService', 'dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, sortIcon, salepointService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);

            vm.changeTab = function (tabName) {
                vm.view = tabName;
            };
            vm.changeTab('debtManage');
        }]);
})();