(function () {
    app.controller('Salepoint.salePointPercent', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);

            vm.listSalePoint.unshift({
                Id: 0,
                Name: 'Tất cả'
            })

            vm.month = angular.copy(vm.params.month)

            vm.listPercent.forEach(function (item) {
                item.MainUserData = item.MainUserData ? JSON.parse(item.MainUserData) : []
            })

            vm.listData = angular.copy(vm.listPercent)


            /*vm.loadData = function () {
                vm.params.month = vm.month
                $state.go($currentState, { month: moment(vm.month).format("YYYY-MM")})
            }*/

            vm.filterBySalePoint = function (id) {
                vm.salePointId = id
                if (id != 0) {
                    vm.listData = vm.listPercent.filter(x => x.SalePointId == vm.salePointId)
                } else {
                    vm.listData = angular.copy(vm.listPercent)
                }
            }
            
            vm.openModalCreateInvestor = function (){
                var viewPath = baseAppPath + '/salepoint/views/modal/';
                var modalCreateInvestor = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'createInvestor.html' + versionTemplate,
                    controller: 'Salepoint.createInvestor as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'userService',
                            function ($q, $stateParams, ddlService, reportService, userService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                $q.all([
                                ]).then(function (res) {
                                   
                                    deferred.resolve();
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalCreateInvestor.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalCreateInvestor.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }
            
            

            vm.updatePercent = function (model) {
                var viewPath = baseAppPath + '/salepoint/views/modal/';
                var modalUpdatePercent = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'updatePercent.html' + versionTemplate,
                    controller: 'Salepoint.updatePercent as $vm',
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
                                        listLeader: vm.listLeader
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalUpdatePercent.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalUpdatePercent.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

        }]);
})();