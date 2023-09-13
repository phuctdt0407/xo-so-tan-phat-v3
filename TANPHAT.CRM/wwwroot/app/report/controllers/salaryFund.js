(function () {
    app.controller('Report.salaryFund', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.checkShowUpdateTotalFirst = vm.params.year == '2023' ? true : false;

            //Declare
            vm.monthOfYear = [];
            vm.year = angular.copy(vm.params.year);

            //Func
            vm.loadData = function () {
                vm.params.year = moment(vm.year).format('YYYY');
                $state.go($state.current, vm.params, { reload: false, notify: true })
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
                vm.listFundInYear.forEach(function (item) {
                    item.Data = item.Data ? JSON.parse(item.Data) : null
                    item.SalePointId = item.Data.SalePointId
                    item.SalePointName = item.Data.SalePointName
                })
                if (vm.listFundInYear && vm.listFundInYear.length > 0) {
                    vm.listData = Enumerable.From(vm.listFundInYear)
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
            console.log('listData', vm.listData);
            console.log('vm.listFundInYear', vm.listFundInYear);
            vm.openModalPayFund = function (model) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var modalPayFund = $uibModal.open({
                    templateUrl: viewPath + 'payFundOfUser.html' + versionTemplate,
                    controller: 'Report.payFundOfUser as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        data: model.Data,
                                        month: moment().format('YYYY-MM')
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });
                modalPayFund.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalPayFund.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                        /*userService.getListFundInYear({ year: params.year }).then(function (res) {

                        })*/
                        console.log('data: ', data)
                        $state.reload()
                    } else {
                        console.log('data2: ', data)
                        $state.reload()
                    }
                });

                
            }
         
            vm.updateTotalFirst = function (model) {
               
                var viewPath = baseAppPath + '/report/views/modal/';
                var modalUpdateTotalFirst = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'updateTotalFirst.html' + versionTemplate,
                    controller: 'Report.updateTotalFirst as $vm',
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
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalUpdateTotalFirst.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalUpdateTotalFirst.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            ////Bảo Hiểm
            vm.updateTotalFirst1 = function (model) {
                model.Insure = 1;
                console.log("model", model);
                var viewPath = baseAppPath + '/report/views/modal/';
                var modalUpdateTotalFirst = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'updateTotalFirst.html' + versionTemplate,
                    controller: 'Report.updateTotalFirst as $vm',
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
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalUpdateTotalFirst.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalUpdateTotalFirst.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }
        }]);
})();