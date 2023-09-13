(function () {
    app.controller('Report.historyActivity', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'ddlService', '$uibModal', 'shiftStatus2',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, ddlService, $uibModal, shiftStatus2) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';

            vm.lotteryInfo = vm.listSaleUpdate.LotteryInfo ? JSON.parse(vm.listSaleUpdate.LotteryInfo) : []
            vm.salePointInfo = vm.listSaleUpdate.SalePointInfo ? JSON.parse(vm.listSaleUpdate.SalePointInfo) : []
            vm.historyInfo = vm.listSaleUpdate.HistoryInfo ? JSON.parse(vm.listSaleUpdate.HistoryInfo) : []

            vm.checkClicked = moment(moment().format('YYYY-MM-DD')).diff(moment(vm.params.date, formatDate)) == 0;
            //console.log("vm.lotteryInfo", vm.lotteryInfo);
            //console.log("vm.salePointInfo", vm.salePointInfo);
            //console.log("vm.historyInfo", vm.historyInfo);

            vm.shiftStatus2 = angular.copy(shiftStatus2)

            vm.lotteryInfo.forEach(function (item) {
                item.LotteryDateBk = moment(item.LotteryDate).format("DD-MM-YYYY")
            })
            
            if (vm.historyInfo) {
                vm.historyInfo.forEach(function (item) {
                    item.ActionDateBk = moment(item.ActionDate).format("DD/MM/YYYY, HH:mm:ss")
                })
            }


            vm.changeDate = function () {
                vm.params.date = moment(vm.params.date, formatDate).format(outputDate)
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }

            vm.deleteRow = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                ShiftDistributeId: vm.salePointInfo.ShiftDistributeId,
                SalePointId: vm.salePointInfo.SalePointId,
                DistributeId: vm.salePointInfo.ShiftDistributeId
            }

            vm.getBootBox = function ( model) {
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

            vm.rmShistTransfer = function () {
                var message = ''
                message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn có muốn <strong>HUỶ KẾT CA</strong>?'

                var dialog = bootbox.confirm({
                    message,
                    buttons: {
                        confirm: {
                            label: 'Đồng ý',
                            className: 'btn-danger',
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
                            var deleteShiftTransfer = {
                                ActionBy: $rootScope.sessionInfo.UserId,
                                ActionByName: $rootScope.sessionInfo.FullName,
                                ShiftDistributeId: vm.salePointInfo.ShiftDistributeId
                            }
                            reportService.deleteShiftTransfer(deleteShiftTransfer).then(function (res) {
                                if (res && res.Id > 0) {
                                    notificationService.success(res.Message);
                                    vm.checkClicked = false;
                                } else {
                                    notificationService.warning(res.Message);
                                }

                            })
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


            }

            vm.openModal = function (model = {}, historyInfo) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'amount.html' + versionTemplate,
                    controller: 'Report.amount as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
                            function ($q, $uibModal, reportService, ddlService) {
                                var deferred = $q.defer();

                                var sendData = {
                                    ShiftDistributeId: vm.salePointInfo.ShiftDistributeId,
                                    DistributeId: vm.salePointInfo.ShiftDistributeId,
                                    SalePointId: vm.salePointInfo.SalePointId
                                }
                                $q.all([

                                ]).then(function (res) {
                                    console.log('model', model)
                                    var result = {
                                        listData: model,
                                        listTypeSelect: vm.listTypeSelect,
                                        historyInfo: vm.historyInfo,
                                        lotteryInfo: vm.lotteryInfo,
                                        sendData: sendData
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

        }]);
})();