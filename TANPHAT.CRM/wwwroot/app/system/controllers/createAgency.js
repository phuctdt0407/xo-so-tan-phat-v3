(function () {
    app.controller('System.createAgency', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'dayOfWeekVN', 'salepointService','activityService',
        function ($scope, $rootScope, $state, viewModel, notificationService, dayOfWeekVN, salepointService, activityService) {
            var vm = angular.extend(this, viewModel);

            vm.isSaving = false;

            function initData() {
                vm.IsCheck = false;

            }
            initData();

            vm.checkData = function () {

            }
            vm.listTypeAgency = [
                {
                    id: 1,
                    type: "Đại lý"
                },
                {
                    id: 2,
                    type: "Đại lý con"
                }
            ]


            vm.sendListData = [];
            vm.save = function () {
                vm.IsCheck = true;
                if ($scope.formCreate.$valid && !vm.isSaving) {
                    vm.isSaving = true;
                    if (vm.dataTypeAngency.id == 1) {
                        var temp = {
                            AgencyName: vm.update.Name,
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
                    } else if (vm.dataTypeAngency.id == 2) {
                        var temp = {
                            AgencyName: vm.update.Name,
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
        }]);
})();
