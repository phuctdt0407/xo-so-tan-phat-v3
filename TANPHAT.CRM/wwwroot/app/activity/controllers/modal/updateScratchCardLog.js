(function () {
    app.controller('Activity.updateScratchCardLog', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService) {
            var vm = angular.extend(this, viewModel);
            vm.RevisionNumberUpdate = vm.TotalReceive;

            vm.save = function () {
                if (vm.RevisionNumberUpdate != vm.TotalReceive && vm.RevisionNumberUpdate != null && !vm.isSaving) {

                    vm.isSaving = true;
                    var data = {
                        ActionBy: $rootScope.sessionInfo.UserId,
                        ActionByName: $rootScope.sessionInfo.FullName,
                        ScratchcardLogId: vm.Id,
                        RevisionNumber: Number(vm.RevisionNumberUpdate)
                    }
                    console.log("data: ", data)

                    data = JSON.stringify(data);
                    userService.updateScratchcardLog(data).then(function (res) {
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
                }
            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();