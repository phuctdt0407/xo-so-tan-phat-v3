(function () {
    app.controller('Activity.manageStaffDebt', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.staffTypeId = String(vm.params.userTitleId);
            vm.month = moment().format("YYYY-MM")
            vm.staffType = [
                {
                    id: 5,
                    name: "Nhân viên"
                },
                {
                    id: 4,
                    name: "Trưởng nhóm"
                }
            ]

            vm.changeStaff = function () {
                console.log("vm.staffTypeId: ", vm.staffTypeId)
                vm.params.userTitleId = vm.staffTypeId;
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }

            vm.showDetail = function (model) {
                console.log("model: ", model)
                var viewPath = baseAppPath + '/report/views/modal/';
                var modalShowDetail = $uibModal.open({
                    templateUrl: viewPath + 'debtDetail.html' + versionTemplate,
                    controller: 'Report.debtDetail as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                    activityService.getPayedDebtAndNewDebtAllTime({ userId: model.UserId })
                                ]).then(function (res) {
                                    var result = {
                                        data: res[0],
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });
                modalShowDetail.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalShowDetail.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                        console.log('data: ', data)
                        $state.reload()
                    } else {
                        console.log('data2: ', data)
                        $state.reload()
                    }
                });

            }
            
            vm.openModalDebt = function (model) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var openModalDebt = $uibModal.open({
                    templateUrl: viewPath + 'newDebt.html' + versionTemplate,
                    controller: 'Report.newDebt as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                    
                                ]).then(function (res) {
                                    var result = {
                                        data: model,
                                        month: vm.month
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });
                openModalDebt.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                openModalDebt.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                        console.log('data: ', data)
                        $state.reload()
                    } else {
                        console.log('data2: ', data)
                        $state.reload()
                    }
                });


            }


        }]);
})();