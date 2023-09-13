(function () {
    app.controller('Activity.feeOutsideOfSalePoint', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.showForm = false
            //Tab
            vm.listTab = [
                { "TabName": "Chuyển khoản cho khách", "TabId": 1},
                { "TabName": "Khách chuyển khoản", "TabId": 2 },
                { "TabName": "Chi phí ngoài", "TabId": 3 },
            ]

            vm.curTab = 1

            vm.changeTab = (id) => {
                vm.curTab = id
            }

            /*vm.listTypeOfFee.forEach(function (item) {
                if (item.TypeNameId == 3)
                    vm.listTypeOfFee1.push(item)
            })*/

            //Chuyển khoản
            
            vm.isSaving = false;

            vm.saveDataCK = {
                GuestActionTypeId: 1,
                FormPaymentId: 2,
                GuestInfo: {},
                ShiftDistributeId: $rootScope.sessionInfo.ShiftDistributeId,
                SalePointId: vm.data.SalePointId
            }

            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                Data: [],
                ActionType: 1,
            }

            vm.save = function (guestActionTypeId) {
                if (!vm.saveDataCK.GuestInfo.Name
                    || !vm.saveDataCK.GuestInfo.Phone
                    || !vm.saveDataCK.GuestInfo.Bank
                    || !vm.saveDataCK.GuestInfo.BankAccount
                    || !vm.saveDataCK.GuestInfo.Description
                    || !vm.saveDataCK.TotalPrice) {
                    notificationService.error("Yêu cầu nhập đầy đủ thông tin khách hàng");
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 200)
                } else if (!vm.isSaving) {
                    vm.isSaving = true;
                    vm.saveDataCK.GuestActionTypeId = guestActionTypeId
                    if (guestActionTypeId == 2)
                        vm.saveDataCK.Note = vm.saveDataCK.GuestInfo.Description
                    vm.saveDataCK.GuestInfo = JSON.stringify(vm.saveDataCK.GuestInfo)

                   /* vm.saveDataCK.TotalPrice = parseInt(vm.saveDataCK.TotalPrice, 10)*/
                    vm.saveDataCK.TotalPrice = vm.saveDataCK.TotalPrice.replace(/,/g, '');
                    vm.saveDataCK.TotalPrice = parseInt(vm.saveDataCK.TotalPrice, 10)
                    vm.saving.Data = []
                    vm.saving.Data.push(vm.saveDataCK)
                    vm.saving.Data = JSON.stringify(vm.saving.Data)
                    salepointService.updateOrCreateGuestAction(vm.saving).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.go($state.current, { tab: 1 }, { reload: true, notify: true });
                                vm.isSaving = false;
                                $rootScope.$apply(vm.isSaving);
                            }, 200)

                        } else {
                            setTimeout(function () {
                                notificationService.error(res.Message);
                                vm.isSaving = false;
                                $rootScope.$apply(vm.isSaving);
                            }, 200)
                        }
                    })
                }

            }


            //Chi phí ngoài

            vm.saveData = {
                Quantity: 1,
                SalePointId: vm.data.SalePointId,
                ShiftDistributeId: vm.ShiftDistributeId
            }
            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.showFormAddFee = function () {
                vm.showForm = true
            }

            vm.updateListFee = function (typeUpdate, dataSave) {
                vm.saving.ActionType = typeUpdate
                vm.saving.Data = []
                vm.saving.Data.push(dataSave)
                vm.saving.Data = JSON.stringify(vm.saving.Data)
                salepointService.updateFeeOutSite(vm.saving).then(function (res) {
                    if (res && res.Id > 0) {
                        notificationService.success(res.Message)
                        salepointService.getListFeeOutsite({ shiftDistributeId: vm.ShiftDistributeId, }).then(function (res1) {
                            vm.listFee = res1
                        })
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.listFee, vm.isSaving)
                        }, 200)
                        vm.saveData.TypeNameId = null
                        vm.saveData.Price = null
                        vm.saveData.Note = null
                    } else {
                        notificationService.warning(res.Message)
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.isSaving)
                        }, 200)
                    }
                })
            }


            vm.addNewFee = function () {
                vm.isSaving = true
                /*if (!vm.saveData.TypeNameId) {
                    notificationService.warning('Bạn chưa chọn loại chi phí!')
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 200)*/
                if (!vm.saveData.Price) {
                    notificationService.warning('Bạn chưa nhập chi phí!')
                    setTimeout(function () {
                        vm.saveData.Price = null
                        vm.SaveData.Note = null
                        vm.saveData.TypeNameId = null
                       vm.isSaving = false
                       $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else {
                    vm.saveData.TypeNameId = 3;
                    vm.showForm = false
                    vm.updateListFee(1, vm.saveData)
                }
            }

            vm.getBootBox = function (item) {
                var message = ''
                if (item) {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn có <strong>xác nhận muốn xóa</strong> chi phí?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> chuyển khoản?'
                };

                var dialog = bootbox.confirm({
                    message,
                    buttons: {
                        confirm: {
                            label: 'Đồng ý',
                            className: 'btn-success',
                        },
                        cancel: {
                            label: 'Huỷ',
                            className: 'btn-secondary'
                        }
                    },
                    callback: function (res) {
                        setTimeout(function () {
                            $('.modal-lg').css('display', 'block');
                        }, 500);


                        if (res) {
                            vm.deleteRow(item);
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').removeClass("modal-body")
                        $('.modal-lg').css('display', 'none')
                    }, 0);
                });

            }

            vm.deleteRow = function (item) {
                vm.saveData.Note = item.Note,
                vm.saveData.TypeNameId = item.TypeNameId,
                vm.saveData.TransactionId = item.TransactionId,
                vm.saveData.Price = item.Price

                vm.updateListFee(3, vm.saveData)
            }

        }]);
})();