(function () {
    app.controller('User.updateInfo', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService) {
            var vm = angular.extend(this, viewModel);

            var formatYMD = "YYYY-MM-DD";
            var formatDMY = "DD/MM/YYYY";
            vm.update = angular.extend(vm.userInfo,
                {
                    ActionBy: $rootScope.sessionInfo.UserId,
                    ActionByName: $rootScope.sessionInfo.FullName,
                }
            )

            vm.update.EndDate = vm.update.EndDate ? vm.update.EndDate : '';
            vm.update.StartDate = vm.update.StartDate ? vm.update.StartDate : '';
            vm.update.SalaryDisplay = vm.update.BasicSalary ? vm.update.BasicSalary.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0';

            vm.update.EndDayDisplay = vm.update.EndDate ? moment(vm.update.EndDate, formatYMD).format(formatDMY) : moment().format(formatDMY);
            vm.update.StartDayDisplay = vm.update.StartDate ? moment(vm.update.StartDate, formatYMD).format(formatDMY) : moment().format(formatDMY);

            vm.checkDate = function () {
                try {
                    return moment(vm.update.StartDayDisplay, formatDMY).diff(moment(vm.update.EndDayDisplay, formatDMY).format(formatYMD)) <= 0;
                } catch (err) {
                    return false;
                }
            }

            vm.save = function () {
                if ($scope.formCreate.$valid && !vm.isSaving) {
                    vm.isSaving = true;
                    var temp = {
                        FullName: vm.update.FullName,
                        IsActive: vm.update.IsActive,
                        BasicSalary: vm.update.SalaryDisplay.replace(/\,/g, ''),
                        StartDate: moment(vm.update.StartDayDisplay, formatDMY).format(formatYMD),
                        SalePointId: vm.update.SalePointId,
                        Phone: vm.update.Phone,
                        NumberIdentity: vm.update.NumberIdentity,
                        Address: vm.update.Address,
                        BankAccount: vm.update.BankAccount,
                        IsIntern:vm.update.IsIntern
                    }

                    if (!vm.update.IsActive) {
                        temp.EndDate = moment(vm.update.EndDayDisplay, formatDMY).format(formatYMD) 
                    }
                    
                    vm.update.Data = JSON.stringify(temp);
                    userService.updateUserInfo(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            setTimeout(function () {
                                notificationService.error(res.Message)
                                vm.isSaving = false;
                                $rootScope.$apply(vm.isSaving)
                            }, 1000)
                        }
                    })
                    console.log(vm.update)
                }
            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();