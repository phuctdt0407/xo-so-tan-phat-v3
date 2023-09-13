(function () {
    app.controller('System.createSalePoint', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'dayOfWeekVN','salepointService',
        function ($scope, $rootScope, $state, viewModel, notificationService, dayOfWeekVN, salepointService) {
            var vm = angular.extend(this, viewModel);
            
            vm.isSaving = false;

            function initData() {
                vm.IsCheck = false;

            }
            initData();

            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName
            }

            vm.checkData = function () {

            }


            vm.sendListData = [];
            vm.save = function () {
                vm.IsCheck = true;
                if ($scope.formCreate.$valid && !vm.isSaving) {
                    vm.isSaving = true;

                    var temp = {
                        FullAddress: vm.update.Address,
                        SalePointName: vm.update.Name,
                        Note: vm.update.Note,
                    }
                    vm.update.Data = JSON.stringify(temp);
                    salepointService.updateSalePoint(vm.update).then(function (res) {
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
        }]);
})();
