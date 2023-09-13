(function () {
    app.controller('Salepoint.addCommission', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            vm.params.date = moment(vm.params.date,formatDate).format('DD-MM-YYYY');
            vm.userInfo = {
                UserId: $rootScope.sessionInfo.UserId
            };
            vm.listUser = [];
            vm.saveData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                ActionType:1,
                Data:{
                    ListStaff:[],
                    
                }
            }
            vm.Data = {}
          
            vm.getListUser = function () {
                if (vm.params.salePointId && vm.params.date) {
                    vm.params.date = moment(vm.params.date,formatDate).format("YYYY-MM-DD")
                    salepointService.getListUserByDateAndSalePoint(vm.params).then(function (res) {
                        vm.listUser = res
                    })
                }
                vm.listUser.forEach(function(ele){
                    ele.IsCheck = false;
                })
            }
            vm.checkStaff = function (model) {
                var temp = []
                model.forEach(function (item) {
                    if (item.IsCheck) {
                        temp.push(item.UserId)
                    }
                })
                vm.saveData.Data.ListStaff = temp
            }



            vm.save = function () {
                vm.saveData.Data.Fee = vm.saveData.Data.Fee ? vm.saveData.Data.Fee.replaceAll(",", '') : 0;
                vm.isSaving = true;
                if (vm.saveData.Data.ListStaff.length == 0 ) {
                    notificationService.error("Chưa chọn nhân viên");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else if (!vm.saveData.Data.Commission || parseInt(vm.saveData.Data.Commission) === 0 || parseInt(vm.saveData.Data.Fee) >= parseInt(vm.saveData.Data.Commission.replaceAll(",", ''))) {
                    notificationService.error("Số tiền không hợp lệ");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                } else {
                    vm.saveData.Data.SalePointId =  vm.params.salePointId
                    vm.saveData.Data.Date =  vm.params.date
                    vm.saveData.Data.Commission = vm.saveData.Data.Commission.replaceAll(",", '');
                    vm.saveData.Data.Commission = vm.saveData.Data.Commission - vm.saveData.Data.Fee
                    vm.saveData.Data = JSON.stringify(vm.saveData.Data)
                    salepointService.updateCommission(vm.saveData).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            vm.isSaving = false;
                        }
                    })
                }
            };
            vm.cancel = function () {
                $uibModalInstance.close()
            }


        }]);
})();
