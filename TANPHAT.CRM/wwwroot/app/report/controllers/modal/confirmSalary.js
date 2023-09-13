(function () {
    app.controller('Report.confirmSalary', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService', 'userService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, userService) {

            var vm = angular.extend(this, viewModel);
            
            vm.isSaving = false;

            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                Data: [],
                ActionType: 1
            }

            vm.data = angular.copy(vm.user)
            vm.realSalaryTemp = vm.user.Data.RealSalary
            vm.data.Data.RealSalary = vm.realSalaryTemp - vm.data.Data.PriceUnion - vm.data.Data.Insure
            console.log("vm.user: ", vm.user)
            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.changeValue = function (input, type) {
                if (input == null) {
                    vm.data.Data[type] = 0;
                }
                vm.data.Data.RealSalary = vm.user.Data.RealSalary - vm.data.Data.PriceUnion - vm.data.Data.Insure
            }
            vm.save = function () {
                vm.isSaving = true

                vm.updateData = {
                    UserId: vm.data.UserId,
                    Month: vm.month,
                    SalaryData: vm.data.Data
                }

                vm.saving.Data.push(vm.updateData)
                vm.saving.Data = JSON.stringify(vm.saving.Data)

                userService.confirmSalary(vm.saving).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            $state.reload();
                            notificationService.success(res.Message);
                            $uibModalInstance.dismiss();
                            vm.isSaving = false;
                        }, 0)

                    } else {
                        notificationService.warning(res.Message)
                        vm.isSaving = false;
                    }
                })

            }
        }]);
})();
