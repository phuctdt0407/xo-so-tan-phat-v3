(function () {
    app.controller('User.shiftDetail', ['$scope', '$rootScope', '$state', 'viewModel', '$uibModalInstance', 'shiftStatus', 'userService','notificationService',
        function ($scope, $rootScope, $state, viewModel, $uibModalInstance, shiftStatus, userService, notificationService) {
            var vm = angular.extend(this, viewModel);
            vm.isApplyAll = true;
            vm.SaveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                SalePointId: vm.salePointId,
                DistributeDate: vm.distributeDate,
                ShiftId: vm.shift,
            };
        
          
            vm.selectedStaff = null;
            vm.close = function () {
                $uibModalInstance.close();
            }
            vm.onPickStaff = function (select){
                vm.selectedStaff = select
            }

            vm.init = function () {
                vm.listStatus = angular.copy(shiftStatus);

                var getUserName = vm.listStaff.filter(staff => staff.Id == vm.userOnShift.userId);
                if (getUserName.length > 0) {
                    vm.userOnShift.name = getUserName[0].Name;
                } else {
                    vm.userOnShift.name = "Không tìm thấy người dùng";
                }
                if (vm.isIntern) {
                    vm.listStaff = vm.listStaff.filter(staff => staff.Id !== vm.userOnShift.userId && staff.IsIntern)
                } else {
                    vm.listStaff = vm.listStaff.filter(staff => staff.Id !== vm.userOnShift.userId )
                }
                vm.listStaff.unshift({ Id: -1, Name: '' });
            }
            vm.init();
            console.log("vm.listStaff", vm.listStaff);
            vm.changeCheck = function () {
                console.log('vm.isApplyAll', vm.isApplyAll)
            }
            vm.save = function () {
                //Add
                //1.Note
                //2.ShiftTypeId
                //3.UserId 
                vm.SaveInfo.Note = vm.note;
                vm.SaveInfo.isApplyAll = vm.isApplyAll;
                //vm.SaveInfo.ShiftTypeId = vm.selectedStatus.Id; 
                vm.SaveInfo.ShiftTypeId = 1;

                vm.SaveInfo.UserId = vm.selectedStaff.Id;
                $uibModalInstance.dismiss(vm.SaveInfo);
                console.log('vm.SaveInfo', vm.SaveInfo)
            }

            vm.deleteInter = function () {
                var message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>xóa</strong> lịch thử việc?'


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
                            dataDelete = {
                                ShiftDistributeId: vm.ShiftDistributeId
                            }
                            userService.deleteDistributeForIntern(dataDelete).then((res) => {
                                if (res && res.Id > 0) {
                                    notificationService.success(res.Message);
                                    $state.go($state.current, {}, { reload: true, notify: true });
                                } else {
                                    notificationService.error(res.Message);
                                }
                            })
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').removeClass("modal-body")
                        $('.modal-md').css('display', 'none')
                    }, 0);
                });
            }
            
        }]);
})();
