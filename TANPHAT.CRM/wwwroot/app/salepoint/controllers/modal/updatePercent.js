(function () {
    app.controller('Salepoint.updatePercent', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.listData = angular.copy(vm.data.MainUserData)
            vm.listBackup = angular.copy(vm.data.MainUserData)
            vm.isSaving = false;
            vm.saveData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                Data:[]
            }

            vm.showForm = false

            vm.showFormUpdate = function () {
                vm.showForm = true
            }
            vm.closeForm = function () {
                vm.showForm = false
                vm.UserId = null
                vm.Percent = null
            }

            vm.updateListPercent = function () {
                vm.isSaving = true
                if (!vm.UserId) {
                    vm.isSaving = false
                    notificationService.error('Chưa chọn quản lý')
                    setTimeout(function () {
                        console.log(' vm.isSaving: ', vm.isSaving)
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else if (!vm.Percent) {
                    notificationService.error('Chưa nhập hệ số')
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else  if (vm.listData.filter(x => x.UserId == vm.UserId).length > 0) {
                    vm.isSaving = false
                    setTimeout(function () {
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                    vm.getBootBox(vm.UserId, 1)
                } else  {
                    vm.listData.push({
                        UserId: vm.UserId,
                        FullName: vm.listLeader.find(x => x.UserId == vm.UserId).FullName,
                        Percent: vm.Percent
                    })
                    vm.isSaving = false
                    setTimeout(function () {
                        $rootScope.$apply(vm.isSaving, vm.listData)
                    }, 200)
                    vm.closeForm()
                }
            }

            vm.getBootBox = function (userId, type) {
                var message = ''
                if (type == 1) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Quản lý đã có trong danh sách, bạn có <strong>xác nhận cập nhật</strong> hệ số?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn có muốn <strong>xóa hệ số</strong> khỏi danh sách?'
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
                            $('.modal-md').css('display', 'block');
                        }, 500);

                        if (res) {
                            vm.updateRow(userId, type);
                            vm.closeForm()
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        //$('.modal-body').removeClass("modal-body")
                        $('.modal-md').css('display', 'none')
                    }, 0);
                });
            }

            vm.updateRow = function (userId, type) {
                var index = vm.listData.findIndex(x => x.UserId == userId)
                if (type == 3) {
                    vm.listData.splice(index, 1)
                } else {
                    vm.listData[index].Percent = vm.Percent
                }
                setTimeout(function () {
                    vm.isSaving = false
                    $rootScope.$apply(vm.isSaving, vm.listData)
                }, 200)
            }

            vm.checkChange = function () {
                if (vm.listBackup.length == vm.listData.length) {
                    vm.listBackup.forEach(x => {
                        var check = false
                        vm.listData.forEach(y => {
                            if (y.UserId == x.UserId && y.Percent == x.Percent) {
                                check = true
                            }
                        })
                        if (check == false)
                            return true
                    })
                    return false
                } else {
                    return true
                }
            }

            vm.save = function () {
                vm.isSaving = true
                vm.saveData.Data.push({
                    SalePointId: vm.data.SalePointId,
                    MainUserData: vm.listData
                })
                vm.saveData.Data = JSON.stringify(vm.saveData.Data)
                salepointService.updatePercent(vm.saveData).then(function (res) {
                    if (res && res.Id > 0) {
                        vm.isSaving = false
                        notificationService.success(res.Message)
                        setTimeout(function () {
                            $rootScope.$apply(vm.isSaving, vm.listData)
                        }, 200)
                        $state.reload()
                    } else {
                        vm.isSaving = false
                        notificationService.warning(res.Message)
                        setTimeout(function () {
                            $rootScope.$apply(vm.isSaving, vm.listData)
                        }, 200)
                    }
                })
            }
            
            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
