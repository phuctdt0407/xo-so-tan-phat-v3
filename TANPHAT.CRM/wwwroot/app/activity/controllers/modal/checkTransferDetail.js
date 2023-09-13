(function () {
    app.controller('Activity.checkTransferDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isLoading = false;
            var salePointId = vm.data.TransitionTypeId == 2 ? vm.data.ToSalePointId : vm.data.FromSalePointId
            vm.saveData = {
              
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                TransitionTypeId: vm.data.TransitionTypeId,
                SalePointId: vm.data.TransitionTypeId == 2 ? vm.data.ToSalePointId : vm.data.FromSalePointId,
                Note:"",
                Data: JSON.stringify(vm.data.Data)
            }

            vm.sendDataTL = function () {
                $rootScope.connection.invoke("SendMessage", "SellActivitySalepoint" + salePointId, JSON.stringify(vm.saveData)).catch(function (err) {
                    return console.error(err.toString());
                });
                $rootScope.connection.invoke("SendMessage", "ChangeRemain", "Change").catch(function (err) {
                    return console.error(err.toString());
                });
            }
            
            vm.cancel = function () {
                $uibModalInstance.close()
            }

            vm.getLotteryName = function (id) {
                return vm.listLottery.filter(item => item.Id == id)[0].Name

            }

            vm.returnTransitionTypeName = function (type) {
                return type == 2 ? 'ToSalePointName' : 'FromSalePointName'
            }
            vm.getBootBox = function (confirm) {
                var message = ''
                if (confirm) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> chuyển/nhận vé?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> chuyển/nhận vé?'
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
                            vm.isLoading = true;
                            vm.save(confirm);
                            vm.isLoading = false;
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
                vm.saveData.IsConfirm = confirm;
                activityService.confirmTransition(vm.saveData).then(function (res) {
                    if (res && res.Id > 0) {
                        vm.sendDataTL();

                        notificationService.success(res.Message);
                    } else {
                        notificationService.warning(res.Message);
                    }
                    $state.reload();
                })

            }

        }]);
})();