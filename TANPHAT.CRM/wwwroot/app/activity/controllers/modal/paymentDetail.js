(function () {
    app.controller('Activity.paymentDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'salepointService', '$uibModalInstance',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, salepointService, $uibModalInstance ) {
            var vm = angular.extend(this, viewModel);
            console.log("user", $rootScope.sessionInfo)
            vm.arrayGuestActionId = "";
            vm.saveData = {
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
            }

            vm.data = JSON.parse(vm.paymentData.ArrayGuestActionId)
            vm.Data = []

            let array = JSON.parse(vm.paymentData.ArrayGuestActionId)
            array.forEach((res) => {
                vm.arrayGuestActionId = vm.arrayGuestActionId != '' ? vm.arrayGuestActionId + "," + res : res;
            })
            vm.data.forEach(function (item) {
                vm.Data.push({
                    GuestActionId: item,
                    DoneTransfer: true,
                })
            })

            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.getBootBox = function (confirm) {
                var message = ''
                if (confirm == 2) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận yêu cầu</strong> chuyển khoản?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> chuyển khoản?'
                }

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
                            if (confirm == 2) {
                               vm.save(confirm);
                            } else {
                                dataDelete = {
                                    ActionBy: $rootScope.sessionInfo.UserId,
                                    ActionByName: $rootScope.sessionInfo.FullName,
                                    ArrGuestActionId: String(vm.arrayGuestActionId)
                                }
                                activityService.updateActivityGuestAction(dataDelete).then((res) => {
                                    if (res && res.Id > 0) {
                                        notificationService.success(res.Message);
                                        $state.go($state.current, {}, { reload: true, notify: true });
                                    } else {
                                        notificationService.error(res.Message);
                                    }
                                })
                               
                           }
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
                vm.saveData.Data = JSON.stringify(vm.Data)
                salepointService.updateOrCreateGuestAction(vm.saveData).then(function (res) {
                    if (res && res.Id > 0) {
                        //vm.sendDataTL();

                        notificationService.success(res.Message);
                    } else {
                        notificationService.warning(res.Message);
                    }
                    $state.reload();
                })
            }
            
            vm.cancelPayment = function (){
                
            }

            vm.checkCanClick = function () {
                console.log($rootScope.sessionInfo)
                var listSubTitle = $rootScope.sessionInfo.SubUserTitle ? JSON.parse($rootScope.sessionInfo.SubUserTitle) : []
                var userTitle = $rootScope.sessionInfo.UserTitleId
                if (userTitle == 9 || userTitle == 1)
                    return true
                for (var i = 0; i < listSubTitle.length; i++) {
                    if (listSubTitle[i].UserTitleId == 9 || listSubTitle[i].UserTitleId == 1)
                        return true;
                }
                return false;
            }

        }]);
})();