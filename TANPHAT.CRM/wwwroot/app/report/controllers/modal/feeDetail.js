(function () {
    app.controller('Report.feeDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.listFee = [];

            console.log("model: ", vm.model)

            try {
                vm.model.Shift1.TotalPriceBK = vm.model.Shift1.TotalPrice
                vm.model.Shift2.TotalPriceBK = vm.model.Shift2.TotalPrice
                vm.model.TotalPriceBK = vm.model.TotalPrice
            }
            catch (err) { }

            vm.save = function () {

            }
            vm.close = function () {
                $uibModalInstance.close();
            }

        }]);
})();
