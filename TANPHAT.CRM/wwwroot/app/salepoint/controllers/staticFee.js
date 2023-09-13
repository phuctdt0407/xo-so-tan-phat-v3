(function () {
    app.controller('Salepoint.staticFee', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'shiftStatus', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, shiftStatus, $uibModal) {
            var vm = angular.extend(this, viewModel);

            vm.month = vm.params.month == '' ? moment().format('YYYY-MM') : vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];
            vm.isSaving = false;

            vm.dataTable = []

            vm.init = function () {

                vm.listSalePoint.forEach(function (item) {
                    var temp = {};
                    temp.name = item.Name;
                    temp.id = item.Id;
                    temp.data = [];

                    vm.listDisplay.forEach(ele => {
                        smallData = {
                            id: ele.StaticFeeTypeId,
                            fee: 0,
                            feeName: ele.StaticFeeTypeName,
                            isUpdate: false,
                            feeNameV: ele.StaticFeeTypeNameVIET
                        }
                        temp.data.push(smallData)
                        vm.listStaticFee.forEach(function (ele2) {
                            if (item.Id == ele2.SalePointId) {
                                temp.data.forEach(function (ele3) {
                                    if (ele2.StaticFeeTypeId == 1 && ele3.feeName == 'EstateFee') {
                                        ele3.fee = ele2.Value
                                        ele3.isUpdate = true
                                    } else if (ele2.StaticFeeTypeId == 2 && ele3.feeName == 'WaterFee') {
                                        ele3.fee = ele2.Value
                                        ele3.isUpdate = true
                                    } else if (ele2.StaticFeeTypeId == 3 && ele3.feeName == 'InternetFee') {
                                        ele3.fee = ele2.Value
                                        ele3.isUpdate = true
                                    } else if (ele2.StaticFeeTypeId == 4 && ele3.feeName == 'ElectronicFee') {
                                        ele3.fee = ele2.Value
                                        ele3.isUpdate = true
                                    }
                                })
                            }
                        })

                    })
                    vm.dataTable.push(temp)
                })
            }

            vm.init();

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM') + '-01';
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.updateStaticFee = function (model, index, fee, feeNameV, month) {
                var viewPath = baseAppPath + '/salepoint/views/modal/';
                var modalUpdateStaticFee = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'updateStaticFee.html' + versionTemplate,
                    controller: 'Salepoint.updateStaticFee as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService',
                            function ($q, $stateParams, ddlService, reportService, activityService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                month = moment(vm.params.month).format("YYYY-MM");
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        model: model,
                                        index: index,
                                        fee: fee,
                                        feeName: feeNameV,
                                        month: month
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalUpdateStaticFee.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '20vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalUpdateStaticFee.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

        }]);
})();
