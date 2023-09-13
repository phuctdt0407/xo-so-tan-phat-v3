(function () {
    app.controller('Report.unionFund', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService', 'dayOfWeekVN', 'salepointService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService, dayOfWeekVN, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.tab = angular.copy(vm.params.tab)
            //vm.month = moment().format("YYYY-MM")

            //Declare
            vm.monthOfYear = [];
            vm.year = angular.copy(vm.params.year);

            //Func
            vm.loadData = function () {
                vm.params.year = moment(vm.year).format('YYYY');
                vm.params.tab = 1
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            //changeTab
            vm.changeTab = function (tab) {
                vm.tab = tab
            }

            // INIT
            // get listUser giong trong feeOutside
            vm.init = function () {
                for (let i = 0; i < 12; i++) {
                    index = i + 1;
                    vm.monthOfYear.push({
                        Month: vm.params.year + '-' + ((index / 10 < 1) ? '0' + index : index)
                    })
                }

                vm.listSalePoint = []

                vm.listUnionInYear.DataUse = vm.listUnionInYear.DataUse ? JSON.parse(vm.listUnionInYear.DataUse) : []
                vm.listDataUse = angular.copy(vm.listUnionInYear.DataUse)
                vm.listUnionInYear.UserData = vm.listUnionInYear.UserData ? JSON.parse(vm.listUnionInYear.UserData) : []

                if (vm.listUnionInYear.UserData && vm.listUnionInYear.UserData.length > 0) {
                    vm.listUserData = Enumerable.From(vm.listUnionInYear.UserData)
                        .GroupBy(function (item) { return item.SalePointId; })
                        .Select(function (item) {
                            vm.listSalePoint.push({
                                SalePointId: item.source[0].SalePointId,
                                SalePointName: item.source[0].SalePointName,
                                Id: item.source[0].SalePointId,
                                Name: item.source[0].SalePointName
                            })
                            return {
                                SalePointId: item.source[0].SalePointId,
                                SalePointName: item.source[0].SalePointName,
                                Data: item.source
                            }
                        })
                        .ToArray();
                }

            };

            vm.init();

            //Lọc lịch trích tiền công đoàn theo tháng
            vm.filterByMonth = function () {
                vm.listDataUse = vm.listUnionInYear.DataUse.filter(x => moment(x.Date).format("YYYY-MM") == vm.month)
                setTimeout(function () {
                    vm.isSaving = false
                    $rootScope.$apply(vm.listDataUse)
                }, 200)
            }

            //trích tiền công đoàn
            vm.showForm = false
            vm.isSaving = false

            vm.showFormUseUnion = function () {
                vm.showForm = true
            }
            vm.closeForm = function () {
                vm.showForm = false
            }

            vm.updateData = {
                ShiftDistributeId: $rootScope.sessionInfo.ShiftDistributeId,
                Date: moment().format("DD-MM-YYYY")
            }

            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
            }

            vm.useUnion = function () {
                vm.isSaving = true
                if (!vm.updateData.Price) {
                    notificationService.warning('Bạn chưa nhập số tiền!')
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else {
                    vm.updateData.Date = moment(vm.updateData.Date, "DD-MM-YYYY").format("YYYY-MM-DD")
                    vm.saving.ActionType = 1
                    vm.saving.Data = []
                    vm.saving.Data.push(vm.updateData)
                    vm.saving.Data = JSON.stringify(vm.saving.Data)
                    salepointService.useUnion(vm.saving).then(function (res) {
                        if (res && res.Id > 0) {
                            notificationService.success(res.Message)
                            setTimeout(function () {
                                vm.isSaving = false
                                $rootScope.$apply(vm.isSaving)
                                $state.go($state.current, { tab: 2 }, { reload: true, notify: true });
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
            }

            //getBootBox
            vm.getBootBox = function (item) {
                var message = ''
                if (item) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa trích quỹ công đoàn?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn có <strong>xác nhận</strong> xóa trích quỹ công đoàn?'
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

            //Xóa
            vm.deleteRow = function (item) {
                vm.isSaving = true
                vm.updateData.Date = item.Date,
                vm.updateData.TransactionId = item.TransactionId,
                vm.updateData.Price = item.Price,
                vm.updateData.Note = item.Note
                vm.saving.ActionType = 3
                vm.saving.Data = []
                vm.saving.Data.push(vm.updateData)
                vm.saving.Data = JSON.stringify(vm.saving.Data)
                salepointService.useUnion(vm.saving).then(function (res) {
                    if (res && res.Id > 0) {
                        notificationService.success(res.Message)
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.isSaving)
                            $state.go($state.current, { tab: 2 }, { reload: true, notify: true });
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