(function () {
    app.controller('Salepoint.guestManage', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'salepointService', 'notificationService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, sortIcon, salepointService, notificationService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.listSalePoint.unshift({
                Id: 0, Name: 'Tất cả '
            })

            vm.listAllGuest.forEach(function (item) {
                item.SalePointName = vm.listSalePoint.find(x => x.Id == item.SalePointId).Name
            })

            vm.listWholesaleGuest = vm.listAllGuest.filter(x => x.CanBuyWholesale)
            vm.listDebtGuest = vm.listAllGuest.filter(x => !x.CanBuyWholesale)
            vm.loadData = function () {
                $state.go($state.current, vm.params, { reload: true, notify: true })
            }

            vm.changeTab = function (tabId) {
                vm.tabId = tabId
            }

            vm.openModalEdit = function (model, typeGuest) {
                var viewPath = baseAppPath + '/salepoint/views/modal/';
                var modalEditGuest = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'updateGuest.html' + versionTemplate,
                    controller: 'Salepoint.updateGuest as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService', 'salepointService',
                            function ($q, $stateParams, ddlService, reportService, activityService, salepointService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                $q.all([
                                    ddlService.lotteryPriceDDL(),
                                    ddlService.salePointDDL()
                                ]).then(function (res) {
                                    var result = {
                                        params: vm.params,
                                        guestData: model,
                                        listPrice: res[0],
                                        typeGuest: typeGuest,
                                        listSalePoint: res[1],
                                        listDebtGuest: vm.listDebtGuest,
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalEditGuest.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '50vh')
                        $('.modal-md').css('max-width', '800px')
                    });
                });

                modalEditGuest.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

            vm.addNewGuest = function (typeGuest) {
                var viewPath = baseAppPath + '/salepoint/views/modal/';
                var modalAddGuest = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'addNewGuest.html' + versionTemplate,
                    controller: 'Salepoint.addNewGuest as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService', 'salepointService',
                            function ($q, $stateParams, ddlService, reportService, activityService, salepointService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                $q.all([
                                    ddlService.lotteryPriceDDL(),
                                    ddlService.salePointDDL()
                                ]).then(function (res) {
                                    var result = {
                                        params: vm.params,
                                        listPrice: res[0],
                                        typeGuest: typeGuest,
                                        listSalePoint: res[1],
                                        listDebtGuest: vm.listDebtGuest,
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalAddGuest.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '50vh')
                        $('.modal-md').css('max-width', '800px')
                    });
                });

                modalAddGuest.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

        }]);


})();