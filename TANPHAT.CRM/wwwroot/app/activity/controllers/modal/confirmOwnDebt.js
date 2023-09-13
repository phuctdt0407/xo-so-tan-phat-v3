(function () {
    app.controller('Activity.confirmOwnDebt', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'userService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, userService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false
            vm.saveData = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                Data: {
                    UserId: vm.data.UserId,
                    DataConfirm: vm.data.DataConfirm,
                    ConfirmLogId: vm.data.ConfirmLogId
                }
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.getBootBox = function (confirm) {
                var message = ''
                if (confirm == 2) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> yêu cầu nợ riêng?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> nợ riêng?'
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
                            vm.save(confirm);
                        }
                       
                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').removeClass("modal-body")
                        $('.modal-lg').css('display', 'none')  
                    },0);
                });

            } 

            vm.save = function (confirm) {
                vm.isSaving = true
                vm.saveData.ActionType = confirm;
                vm.saveData.Data = JSON.stringify(vm.saveData.Data)
                userService.insertUpdateBorrow(vm.saveData).then(function (res) {
                    if (res && res.Id > 0) {
                        vm.isSaving = false
                        notificationService.success(res.Message);
                        $state.reload();
                    } else {
                        notificationService.warning(res.Message);
                        vm.isSaving = false
                        setTimeout(function () {
                            $rootScope.$apply(vm.isSaving)
                        }, 100)
                    }
                })
            }
        }]);
})();