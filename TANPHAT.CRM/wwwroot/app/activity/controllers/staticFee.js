(function () {
    app.controller('Activity.staticFee', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'shiftStatus', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, shiftStatus, $uibModal) {
            var vm = angular.extend(this, viewModel);

            vm.month = vm.params.month == '' ? moment().format('YYYY-MM') : vm.params.month;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM-YYYY");
            vm.listMonth = [];
            vm.isSaving = false;

            vm.dataTable = []

            vm.listDisplay = [
                { Name: 'Tiền điện ', DisplayName: 'ElectronicFee', Id: 1 },
                { Name: 'Tiền nước', DisplayName: 'WaterFee', Id: 2 },
                { Name: 'Tiền mặt bằng', DisplayName: 'EstateFee', Id: 3 },
                { Name: 'Tiền internet', DisplayName: 'InternetFee', Id: 4 }
            ]

            vm.changeFee = function (ele) {
                console.log("ele: ", ele)
            }







            vm.init = function () {

                vm.listSalePoint.forEach(function (item) {
                    var temp = {};
                    temp.name = item.Name;
                    temp.id = item.Id;
                    temp.data = [];

                    vm.listDisplay.forEach(ele => {
                        smallData = {
                            id: ele.Id,
                            fee: 0,
                            feeName: ele.DisplayName,
                            isUpdate: false
                        }
                        temp.data.push(smallData)
                        vm.listStaticFee.forEach(function (ele2) {
                            if (item.Id == ele2.SalePointId) {
                                temp.data.forEach(function (ele3) {
                                    if (ele3.feeName == 'WaterFee') {
                                        ele3.fee = ele2.WaterFee
                                        ele3.isUpdate = true
                                    } else if (ele3.feeName == 'ElectronicFee') {
                                        ele3.fee = ele2.ElectronicFee
                                        ele3.isUpdate = true
                                    } else if (ele3.feeName == 'EstateFee') {
                                        ele3.fee = ele2.EstateFee
                                        ele3.isUpdate = true
                                    } else if (ele3.feeName == 'InternetFee') {
                                        ele3.fee = ele2.InternetFee
                                        ele3.isUpdate = true
                                    }
                                })
                            }
                        })

                    })
                    vm.dataTable.push(temp)
                })
                console.log("listSalePoint: ", vm.listSalePoint)
                console.log("dataTable: ", vm.dataTable)
            }

            vm.init();

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }
            console.log("dataTable111: ", vm.dataTable)

            vm.updateStaticFee = function (model, index, fee) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalUpdateStaticFee = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'updateStaticFee.html' + versionTemplate,
                    controller: 'Activity.updateStaticFee as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService',
                            function ($q, $stateParams, ddlService, reportService, activityService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        data: model,
                                        index: index,
                                        fee: fee
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalUpdateStaticFee.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
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
