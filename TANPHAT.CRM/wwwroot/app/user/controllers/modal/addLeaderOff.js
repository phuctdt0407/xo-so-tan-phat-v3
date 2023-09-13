(function () {
    app.controller('User.addLeaderOff', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService','salepointService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService, salepointService) {
            var vm = angular.extend(this, viewModel);

            var formatYMD = "YYYY-MM-DD";
            var formatDMY = "DD/MM/YYYY";

            vm.date.DateDisplay = moment(vm.date.DistributeDate, formatYMD).format(formatDMY);

            vm.update = {
                    ActionBy: $rootScope.sessionInfo.UserId,
                    ActionByName: $rootScope.sessionInfo.FullName,
                    ActionType:1
            }

            if (vm.date && vm.date.UserId) {
                var temp = vm.listLeader.findIndex(x => x.Id == vm.date.UserId);
                if (temp >= 0) {
                    vm.selectedLeader = vm.listLeader[temp];
                }
                vm.Note = vm.date.Note;
            }
            vm.listLeader.unshift({ Id:-1,Name: '' });
          
            vm.isSaving = false;
            vm.save = function () {
                vm.isSaving = true;
                if (vm.selectedLeader && vm.selectedLeader.Id) {
                    vm.update.Data = JSON.stringify([{
                        WorkingDate: vm.date.DistributeDate,
                        UserId: vm.selectedLeader.Id,
                        Note: vm.Note
                    }])

                    salepointService.updateDateOffOfLeader(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            vm.isSaving = false;
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $uibModalInstance.dismiss({
                                    UserId: vm.selectedLeader.Id,
                                    Name: vm.selectedLeader.Name,
                                    Note: vm.Note
                                })
                            }, 0)

                        } else {
                            notificationService.warning(res.Message);
                            vm.isSaving = false;
                        }
                    })
                    vm.isSaving = false;
                } else {
                    notificationService.warning("Something wrong");
                    vm.isSaving = false;
                }
            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();