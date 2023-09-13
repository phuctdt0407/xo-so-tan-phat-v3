(function () {
    app.controller('System.updateAgency', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService', 'salepointService','activityService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService, salepointService, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.checkActive = vm.agencyInfo.IsActive;

            vm.save = function () {
                if ($scope.formCreate.$valid && !vm.isSaving) {
                    vm.isSaving = true;
                    if (vm.type == 1) {
                        var temp = {
                            AgencyName: vm.agencyInfo.Name,
                            AgencyId: vm.agencyInfo.Id,
                            Activity: vm.checkActive,
                            IsDeleted: false
                        }
                        activityService.insertOrUpdateAgency(temp).then(function (res) {
                            if (res && res.Id > 0) {
                                setTimeout(function () {
                                    notificationService.success(res.Message);
                                    $state.reload();
                                    vm.isSaving = false;
                                }, 1000)

                            } else {
                                vm.isSaving = true;
                            }
                        })
                    } else if (vm.type == 2) {
                        var temp = {
                            AgencyName: vm.agencyInfo.AgencyName,
                            AgencyId: vm.agencyInfo.AgencyId,
                            Activity: vm.checkActive,
                            IsDeleted: false,
                            Price: 0
                        }
                        activityService.insertOrUpdateSubAgency(temp).then(function (res) {
                            if (res && res.Id > 0) {
                                setTimeout(function () {
                                    notificationService.success(res.Message);
                                    $state.reload();
                                    vm.isSaving = false;
                                }, 1000)

                            } else {
                                vm.isSaving = true;
                            }
                        })
                    }
                    
                }

            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();