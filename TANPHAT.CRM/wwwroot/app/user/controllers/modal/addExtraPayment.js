(function () {
    app.controller('User.addExtraPayment', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService', 'notificationService', 'extraPaymentType', 'ddlService','salepointService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService, extraPaymentType, ddlService, salepointService) {
            var vm = angular.extend(this, viewModel);

            vm.isSaving = false;

            vm.extraPaymentType = angular.copy(extraPaymentType);
            vm.currentTab = vm.extraPaymentType[0];
            vm.saveInfo = {};
            console.log("vm.extraPaymentType", vm.extraPaymentType);
            vm.changeTab = function (tabId, transactionTypeId = 0) {
                vm.currentTab = vm.extraPaymentType.filter(x => x.Id == tabId)[0];
                ddlService.getTypeNameDDL({ transactionTypeId: transactionTypeId }).then(function (res) {
                    vm.listSelected = res;
                    try {
                        vm.saveInfo.typeTransactionId = res[0];
                        if (vm.saveInfo.typeTransactionId.Price > 0) {
                            vm.saveInfo.PriceDisplay = vm.saveInfo.typeTransactionId.Price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                            vm.saveInfo.isChangePrice = false;
                        } else {
                            vm.saveInfo.isChangePrice = true;
                            vm.saveInfo.PriceDisplay = 0;
                        }
                    } catch (err) {
                        vm.saveInfo.typeTransactionId = null;
                        vm.saveInfo.PriceDisplay = 0;
                        vm.saveInfo.isChangePrice = true;
                    }
                    
                })
            };
            vm.changeTab(1, 6);

            vm.changePrice = function (selected) {

                vm.saveInfo.SelectPrice = selected; 
                vm.saveInfo.PriceDisplay = selected.Price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            }

            vm.changeShiftDistribute = function (selected) {

                vm.saveInfo.SelectDistribute= selected; 
            }
            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionType:1,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
            }
            vm.getSaveData = function () {
                return [{
                     Date: vm.dateInfo.Date,
                    Price: vm.saveInfo.PriceDisplay.replace(/,/g, ''),
                    UserId: vm.userInfo.UserId,
                    //ShiftDistributeId
                    ShiftDistributeId: vm.saveInfo.ShiftDistributeId ? vm.saveInfo.ShiftDistributeId.ShiftDistributeId : null,
                    SalePointId: vm.saveInfo.ShiftDistributeId ? vm.saveInfo.ShiftDistributeId.SalePointId : null,

                    ///TransactionTypeId 
                    TransactionTypeId: vm.saveInfo.typeTransactionId ? vm.saveInfo.typeTransactionId.TransactionTypeId : null,
                    TypeNameId: vm.saveInfo.typeTransactionId ? vm.saveInfo.typeTransactionId.TypeNameId : null,
                    TypeName: vm.saveInfo.typeTransactionId.TypeName,

                    Note: vm.saveInfo.Note
                }]
            }

            vm.save = function () {
                vm.isSaving = true;
                vm.update.TransactionTypeId= vm.saveInfo.typeTransactionId ? vm.saveInfo.typeTransactionId.TransactionTypeId : null,
                vm.update.Data = JSON.stringify(vm.getSaveData());
                salepointService.insertUpdateTransaction(vm.update).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            notificationService.success(res.Message);
                          
                            vm.isSaving = false;

                            var a = {
                                ActionBy: vm.update.ActionBy,
                                ActionByName: vm.update.ActionByName,
                                ActionDate: moment(),
                                Date: vm.dateInfo.Date,
                                Note: vm.saveInfo.Note,
                                Price: vm.saveInfo.PriceDisplay.replace(/,/g, ''),
                                SalePointId: vm.saveInfo.ShiftDistributeId ? vm.saveInfo.ShiftDistributeId.SalePointId : null,
                                TransactionId: res.Id,
                                TransactionTypeId: vm.saveInfo.typeTransactionId ? vm.saveInfo.typeTransactionId.TransactionTypeId : null,
                                UserId: vm.userInfo.UserId,
                                TypeNameId: vm.saveInfo.typeTransactionId.TypeNameId,
                                TypeName: vm.saveInfo.Name,
                                extraPaymentType: extraPaymentType.filter(x => x.TransactionTypeId == vm.saveInfo.typeTransactionId.TransactionTypeId)[0]
                            };
                            $uibModalInstance.dismiss(a);
                        }, 1000)

                    } else {
                        vm.isSaving = false;
                    }
                })
            }

            vm.close = function () {
                $uibModalInstance.close();
            }
        }]);
})();