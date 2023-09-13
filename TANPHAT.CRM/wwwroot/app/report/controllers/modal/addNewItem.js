(function () {
    app.controller('Report.addNewItem', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'notificationService', 'viewModel', 'reportService','typeOfItem',
        function ($scope, $rootScope, $state, $uibModalInstance, notificationService, viewModel, reportService, typeOfItem) {
            var vm = angular.extend(this, viewModel);
            vm.CurrTypeOfItem = vm.typeOfItem.filter(x => x.Id == vm.typeOfItemId)[0];

            vm.selectBK = vm.listUnit[0]
            vm.importDate = moment().format('DD/MM/YYYY');

            vm.isSaving = false;

            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName
            }

            vm.initData = function () {
                vm.IsCheck = false;
                if (vm.model && vm.model.ItemId) {
                    vm.Name = vm.model.ItemName;
                    vm.selectBK = vm.listUnit.filter(x => x.UnitId == vm.model.UnitId)[0];
                    vm.Price = vm.model.Price;
                    vm.Quotation = vm.model.Quotation;
                }
            }
            vm.initData();

            vm.ChangetotalRemaning = function (price,value) {
                vm.total = vm.Price * vm.import
            }

            vm.listUnit.forEach(function (item) {
               item.TypeSelect = item.UnitName.toUnaccent()
            })

            vm.onChangeValue = function (item) {
                vm.selectBK = item;
            }

            vm.sendListData = [];
            vm.save = function () {
                vm.IsCheck = true;
                if ($scope.formCreate.$valid && !vm.isSaving) {
                    vm.isSaving = true;

                    var temp = {
                        ItemId: vm.model && vm.model.ItemId ? vm.model.ItemId: null,
                        ItemName: vm.Name,
                        UnitId: vm.selectBK.UnitId,
                        Price:  vm.Price,
                        Quotation: vm.Quotation,
                        TypeOfItemId: vm.CurrTypeOfItem.Id
                    }
                    vm.update.Data = JSON.stringify(temp);
                    reportService.updateORDeleteItem(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                /*$uibModalInstance.dismiss(vm.update)*/
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)

                        } else {
                            vm.isSaving = true;
                        }
                    })
                }

            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
