(function () {
    app.controller('Salepoint.createInvestor', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'userService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, userService) {
            var vm = angular.extend(this, viewModel);
            vm.saveData = {
                Account: "",
                Password: "tanphat123",
                FullName: "",
                Phone: "",
                Email: "",
                NumberIdentity: "",
                BankAccount: "",
                Address: "",
                SalePointId: 0,
            }
            vm.data = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName
            }
            vm.save = function () {
                vm.isSaving = true
                var tmp = []
                 tmp.push(vm.saveData)
                vm.data.Data = JSON.stringify(tmp)
                userService.createManager(vm.data).then(res => {
                   if(res&&res.Id>0){
                       notificationService.success(res.Message)
                       $uibModalInstance.close()
                       $state.reload()
                   }
                })
                vm.isSaving = false
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
