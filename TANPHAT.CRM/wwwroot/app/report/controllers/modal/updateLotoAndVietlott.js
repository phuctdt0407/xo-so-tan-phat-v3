(function () {
    app.controller('Report.updateLotoAndVietlott', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService, salepointService) {
            let vm = angular.extend(this, viewModel);
            vm.commission = angular.copy(vm.model)
            let totalPrice = vm.model.TotalPrice;
            let backupTotalPrice = angular.copy(totalPrice)

            vm.editNumber = function () {
                totalPrice = 0;
                totalPrice = vm.model.TotalPrice.replace(/,/g, '');
                totalPrice = parseInt(totalPrice);
            }

            vm.isSaving = false;
            vm.save = function () {
                if(vm.model.TransactionId!=null){
                    if (totalPrice == backupTotalPrice) {
                        notificationService.warning("Dữ liệu không thay đổi!");
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 1000)
                    } else if (totalPrice != null && !vm.isSaving) {
                        let dataSave = {
                            TransactionId: vm.model.TransactionId,
                            ActionBy: $rootScope.sessionInfo.UserId,
                            ActionByName: $rootScope.sessionInfo.FullName,
                            Quantity: 1,
                            date: vm.model.Date ? moment(vm.model.Date).format('YYYY-MM-DD') : null,
                            TotalPrice: totalPrice,
                            Price: totalPrice
                        }
                        /*dataSave = JSON.stringify(dataSave)*/
                        vm.isSaving = true;
                        userService.updateTransaction(dataSave).then(function (res) {
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
                }else{
                    vm.isSaving = true;
                    
                    var newData = {
                        ActionType: 1,
                        ActionBy: $rootScope.sessionInfo.UserId,
                        ActionByName: $rootScope.sessionInfo.FullName,
                        Data: JSON.stringify([
                            {
                                Price: totalPrice,
                                SalePointId: vm.model.SalePointId,
                                ShiftDistributeId: vm.model.ShiftDistributeId,
                                Date: vm.model.Date
                            }
                        ])
                    }
                    // create transaction
                    if(vm.type==2){
                        salepointService.saleOfVietlott(newData).then(function (res){
                            if(res&&res.Id>0){
                                notificationService.success(res.Message)
                                vm.isSaving = false;
                                $state.reload();
                            }else{
                                notificationService.error(res.Message)
                                vm.isSaving = false;
                            }


                        })
                    }else if (vm.type==3){
                        salepointService.saleOfLoto(newData).then(function (res){
                            if(res&&res.Id>0){
                                notificationService.success(res.Message)
                                vm.isSaving = false;
                                $state.reload();
                            }else{
                                notificationService.error(res.Message)
                                vm.isSaving = false;
                            }
                        })
                    }else{
                        
                    }
                        
                    
                 
                }
                
                
                
            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();