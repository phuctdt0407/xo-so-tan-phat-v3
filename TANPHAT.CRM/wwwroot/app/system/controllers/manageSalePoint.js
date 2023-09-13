(function () {
    app.controller('System.manageSalePoint', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'dayOfWeekVN', 'salepointService','$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, dayOfWeekVN, salepointService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;

            vm.openModal = function (model = {}, name) {
                var viewPath = baseAppPath + '/system/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'updateSalePoint.html' + versionTemplate,
                    controller: 'System.updateSalePoint as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService','systemService',
                            function ($q, $uibModal, userService, systemService) {
                                var deferred = $q.defer();
                                var modelBK = angular.copy(model)
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        salePointInfo: modelBK,
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    }
                });

                request.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-footer').addClass('remove-modal-footer');
                    });
                });

                request.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {
                        $state.reload();
                    }
                });
            }



           /* vm.deleteRow = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                ShiftDistributeId: vm.salePointInfo.ShiftDistributeId,
                SalePointId: vm.salePointInfo.SalePointId,
                DistributeId: vm.salePointInfo.ShiftDistributeId
            }

            vm.getBootBox = function (model) {
                var message = ''
                if (confirm) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa vé?'
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
                            console.log('res', res)
                            vm.deleteData(model);
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

            vm.deleteData = function (model, index) {
                var temp = [];
                var tmp = angular.extend({
                    SalePointLogId: model.SalePointLogId,
                    IsDeleted: true,
                }, model)

                temp.push(tmp)

                vm.deleteRow.UpdateData = JSON.stringify(temp);
                console.log('vm.deleteRow', vm.deleteRow)



                reportService.updateORDeleteSalePointLog(vm.deleteRow).then(function (res) {
                    if (res && res.Id > 0) {
                        vm.historyInfo.splice(index, 1)
                        setTimeout(function () {
                            notificationService.success(res.Message);
                            $state.reload();
                            vm.isSaving = false;


                        }, 200)
                    } else {
                        vm.isSaving = false;
                    }
                })


            }*/
        }]);
})();
