(function () {
    app.controller('User.createUser', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', '$uibModal', 'dayOfWeek', 'userService', 'notificationService',
        function ($scope, $rootScope, $state, viewModel, sortIcon, $uibModal, dayOfWeek, userService, notificationService) {
            var vm = angular.extend(this, viewModel);

            vm.isSaving = false;


            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                SalePointId: 1
            }

            vm.sendListData = [];
            vm.save = function () {
                if ($scope.formCreate.$valid && !vm.isSaving) {
                    vm.isSaving = true;

                    var temp = [{
                        Account: vm.update.Account,
                        Email: vm.update.Email,
                        FullName: vm.update.FullName,
                        SalePointId: vm.update.SalePointId,
                        Phone: vm.update.Phone,
                        NumberIdentity: vm.update.NumberIdentityCard,
                        BankAccount: vm.update.BankAccount,
                        Address: vm.update.Address,
                        Role: vm.update.Role
                    }]
                    vm.update.Data = JSON.stringify(temp);
                    console.log("vm.update.Data", vm.update.Data);
                    userService.createUser(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            notificationService.error(res.Message);
                            vm.isSaving = false;
                        }
                    })
                }else {
                    notificationService.error("Vui lòng nhập đầy đủ thông tin!!!")
                }
            }
        }]);
})();