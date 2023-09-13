(function () {
    app.controller('Report.updateTotalFirst', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService', 'userService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, userService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;

           


            vm.save = function () {
               
                if (vm.dataSave.money) {
                
                    vm.dataSave.money = vm.dataSave.money.replace(/,/g, '');
                    vm.dataSave.money = parseInt(vm.dataSave.money, 10)
                }
                if (vm.dataSave.money == vm.data.Data.TotalFirst) {
                    notificationService.warning("Dữ liệu không thay đổi!");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else {
                 
                    if (vm.dataSave.money==1) {
                   
                        notificationService.error("Dữ liệu không được trống!");
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 1000)
                    } else {
                        
                        dataSave = {
                            ActionBy: $rootScope.sessionInfo.UserId,
                            ActionByName: $rootScope.sessionInfo.FullName,
                            UserId: vm.data.UserId,
                            TotalFirst: vm.dataSave.money,
                            Insure: vm.data.Insure
                        }
                        vm.isSaving = true;
                        userService.updateTotalFirst(dataSave).then(function (res) {
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
            }

            vm.close = function () {
                $uibModalInstance.close()
            }
        }]);
})();
