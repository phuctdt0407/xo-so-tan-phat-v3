(function () {
    app.controller('Activity.confirmDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, salepointService) {
            var vm = angular.extend(this, viewModel);
            console.log('a',vm.listConfirm)
            vm.saveData = {
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                GuestId: vm.listConfirm.GuestId
            }

            vm.data = []

            vm.listConfirm.DataConfirm.forEach(function (item) {
                if (item) {
                    vm.data.push({
                        ConfirmLogId: item.ConfirmLogId
                    })
                }
            })

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.getLotteryName = function (id) {
                return vm.listLottery.find(item => item.Id == id).ShortName
            }

            vm.getBootBox = function (confirm) {
                var message = ''
                if (confirm) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> thanh toán khách sỉ?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> thanh toán khách sỉ?'
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
                    }, 0);
                });

            }

            vm.save = function (confirm) {
                vm.saveData.ConfirmTypeId = confirm;
                vm.saveData.Data = JSON.stringify(vm.data)
                salepointService.confirmListPayment(vm.saveData).then(function (res) {
                    if (res && res.Id > 0) {
                        //vm.sendDataTL();
                        $rootScope.connection.invoke("SendMessage", "ChangeRemain", "Change").catch(function (err) {
                            return console.error(err.toString());
                        });
                        notificationService.success(res.Message);
                    } else {
                        notificationService.warning(res.Message);
                    }
                    $state.reload();
                })
            }

        }]);
})();