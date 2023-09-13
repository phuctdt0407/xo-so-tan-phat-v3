(function () {
    app.controller('User.addHoliday', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService) {
            var vm = angular.extend(this, viewModel);
         
            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
            }

            vm.dayDisplay = moment(vm.Date).format("DD/MM/YYYY");

            vm.save = function (isDelete = false) {
                vm.isSaving = true;
                if (vm.HolidayName && vm.HolidayName.length > 0) {
                    var temp = [{
                        Date: vm.Date,
                        Note: vm.HolidayName,
                        IsDeleted: isDelete
                    }]
                    vm.update.Data = JSON.stringify(temp);
                    userService.updateListEventDate(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            notificationService.warning(res.Message);
                            vm.isSaving = false;
                        }

                    })
                } else {
                    notificationService.warning("Chưa nhập thông tin ngày lễ");
                    vm.isSaving = false;
                }
            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();