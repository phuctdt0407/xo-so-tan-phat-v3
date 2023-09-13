(function () {
    app.controller('Activity.otherCosts', ['$scope', '$rootScope', '$state', 'authService', 'notificationService', 'viewModel', 'activityService', 'salepointService',
        function ($scope, $rootScope, $state, authService, notificationService, viewModel, activityService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.showForm = false

            vm.listSalePointForGet = angular.copy(vm.listSalePoint);
            vm.date = vm.params.day;
            vm.listSalePoint.forEach(function (item) {
                if (item.Id == vm.params.salePointId)
                    vm.salePointGet = item
            })

            console.log("vm.salePointGet", vm.salePointGet)

            vm.saveData = {
                SalePointId: '',
            }

            vm.changeSalePointUpdate = function (ele) {
                vm.saveData.SalePointId = ele.Id
            }
            vm.showFormAddFee = function () {
                vm.showForm = true
            }

            //search
            vm.submitSearch = () => {
                vm.params.day = vm.date ? moment(vm.date).format('YYYY-MM-DD') : moment().format('YYYY-MM-DD');
                vm.params.salePointId = vm.salePointGet ? vm.salePointGet.Id : 0;
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }

            try {
                vm.listSalePointForGet.unshift({
                    Id: 0,
                    Name: "All"
                })
                vm.listActivityCode.unshift({ Id: 0, Name: 'All' })
            } catch (err) {

            }

            vm.saving = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                Data: [],
                ActionType: 1,
            }

            vm.updateListFee = function (typeUpdate, dataSave) {
                vm.saving.ActionType = typeUpdate
                vm.saving.Data = []
                vm.saving.Data.push(dataSave)
                vm.saving.Data = JSON.stringify(vm.saving.Data)
                salepointService.updateFeeOutSite(vm.saving).then(function (res) {
                    if (res && res.Id > 0) {
                        notificationService.success(res.Message)
                        salepointService.getListOtherFees({ date: vm.params.day, salePointId: vm.params.salePointId }).then(function (res1) {
                            vm.listFee = res1
                        })
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.listFee, vm.isSaving)
                        }, 200)
                        vm.saveData.TypeNameId = null
                        vm.saveData.Price = null
                        vm.saveData.Note = null
                    } else {
                        notificationService.warning(res.Message)
                        setTimeout(function () {
                            vm.isSaving = false
                            $rootScope.$apply(vm.isSaving)
                        }, 200)
                    }
                })
            }


            vm.addNewFee = function () {
                vm.isSaving = true
                if (!vm.saveData.TypeNameId) {
                    notificationService.warning('Bạn chưa chọn loại chi phí!')
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else if (!vm.saveData.Price) {
                    notificationService.warning('Bạn chưa nhập chi phí!')
                    setTimeout(function () {
                        vm.saveData.Price = null
                        vm.SaveData.Note = null
                        vm.saveData.TypeNameId = null
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)
                    }, 200)
                } else {
                    vm.showForm = false
                    vm.updateListFee(1, vm.saveData)
                }
            }

            vm.getBootBox = function (item) {
                var message = ''
                if (item) {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn có <strong>xác nhận muốn xóa</strong> chi phí?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> chuyển khoản?'
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

            vm.deleteRow = function (item) {
                vm.saveData.Note = item.Note,
                    vm.saveData.TypeNameId = item.TypeNameId,
                    vm.saveData.TransactionId = item.TransactionId,
                    vm.saveData.Price = item.Price

                vm.updateListFee(3, vm.saveData)
            }

        }]);
})();