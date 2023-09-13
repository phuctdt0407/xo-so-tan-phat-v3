(function () {
    app.controller('Report.viewVietLott', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService) {
            var vm = angular.extend(this, viewModel);

            try {
                vm.model.Shift1.TotalPriceBK = parseInt(vm.model.Shift1.TotalPrice.replace(/,/g, ''))
                vm.model.Shift2.TotalPriceBK = parseInt(vm.model.Shift2.TotalPrice.replace(/,/g, ''))
                vm.model.TotalPriceBK = parseInt(vm.model.TotalPrice.replace(/,/g, ''))
            }
            catch (err) { }

            vm.save = function () {

            }
            vm.close = function () {
                $uibModalInstance.close();
            }

        }]);
})();
