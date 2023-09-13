(function () {
    app.controller('Activity.requestOwnDebt', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal', 'userService',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN, $uibModal, userService) {
            var vm = angular.extend(this, viewModel);
            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                Data: {
                    UserId: $rootScope.sessionInfo.UserId,
                    DataForConfirm: []
                }
            }

            vm.totalRow = vm.listBorrow && vm.listBorrow.length > 0 ? vm.listBorrow.length : 0;
            
            vm.listBorrow.forEach(function (item) {
                item.DataConfirm = item.DataConfirm ? JSON.parse(item.DataConfirm) : []
                if (item.DataConfirm && item.DataConfirm.length > 0) {
                    item.DataConfirm.forEach(function (ele) {
                        item.TotalPrice = 0
                        if (ele.FormPaymentId == 1) {
                            item.Cash = ele.Price
                            item.TotalPrice += item.Cash
                        } else {
                            item.Transfer = ele.Price
                            item.TotalPrice += item.Transfer
                        }
                    })
                }
            })

            console.log('vm.listBorrow: ', vm.listBorrow)

            //Tạo yêu cầu
            vm.openModalAddRequest = function () {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalRequest = $uibModal.open({
                    templateUrl: viewPath + 'requestNewOwnDebt.html' + versionTemplate,
                    controller: 'Activity.requestNewOwnDebt as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });

                modalRequest.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalRequest.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                    } else {
                    }
                });
            }

            //Xoa yeu cau chua duoc confirm
            vm.getBootBox = function (model) {
                var message = ''
                if (model) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa yêu cầu nợ?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn có <strong>xác nhận</strong> xóa yêu cầu nợ?'
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
                            vm.deleteRow(model);
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

            //Xóa
            vm.deleteRow = function (item) {
                console.log('deleteRow: ', item)
                vm.isSaving = true
                vm.saving.ActionType = 3
                vm.saving.Data.ConfirmLogId = item.ConfirmLogId
                vm.saving.Data.DataConfirm = item.DataConfirm
                vm.saving.Data = JSON.stringify(vm.saving.Data)
                userService.insertUpdateBorrow(vm.saving).then(function (res) {
                    if (res && res.Id > 0) {
                        notificationService.success(res.Message)
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.isSaving)
                            $state.reload();
                        }, 200)
                    } else {
                        notificationService.warning(res.Message)
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.isSaving)
                        }, 200)
                    }
                })
            }

            

        }]);
})();