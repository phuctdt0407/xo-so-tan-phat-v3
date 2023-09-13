(function () {
    app.controller('Report.confirmTransferItem', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal', 'transitionType', 'reportService',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN, $uibModal, transitionType, reportService) {
            var vm = angular.extend(this, viewModel);

            vm.checkRole = function () {
                var role = []
                var subRole = $rootScope.sessionInfo.SubUserTitle ? JSON.parse($rootScope.sessionInfo.SubUserTitle) : []
                subRole.forEach(function (item) {
                    if ((item.UserTitleId == 7 || $rootScope.sessionInfo.UserTitleId == 7) && !role.includes(item.UserTitleId)) {
                        role.push(1)
                    }
                    if ((item.UserTitleId == 8 || $rootScope.sessionInfo.UserTitleId == 8) && !role.includes(item.UserTitleId)) {
                        role.push(2)
                    }
                })
                return role;
            }

            vm.listDataBK = vm.listData.filter(x => x.Data)


            vm.init = function () {

                vm.listDataBK.forEach(function (item) {
                    vm.data = JSON.parse(item.Data)
                    item.NewData = [];
                    item.NewData.push(...vm.data)
                    item.TypeOfItemId = item.NewData[0].TypeOfItemId
                })
            }

            vm.init()

            vm.month = vm.params.month;
            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.openDetail = function (model = {},) {
                
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'confirmItemDetail.html' + versionTemplate,
                    controller: 'Report.confirmItemDetail as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
                            function ($q, $uibModal, reportService, ddlService) {
                                var deferred = $q.defer();

                                $q.all([

                                ]).then(function (res) {
                                    var result = {
                                        model: model,
                                        
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

                    }
                });
            }

        }]);
})();