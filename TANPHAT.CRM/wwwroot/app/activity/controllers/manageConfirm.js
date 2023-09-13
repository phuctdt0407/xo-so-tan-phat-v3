(function () {
    app.controller('Activity.manageConfirm', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);

            vm.listGuest = vm.listGuest.filter(x => x.CanBuyWholesale)
            vm.listGuest.unshift({
                GuestId: 0,
                FullName: 'Tất cả',
                Phone: ''
            })
            vm.listSalePoint.unshift({
                Id: 0,
                Name: 'Tất cả'
            })

            vm.loadData = function () {
                 $state.go($state.current, vm.params, { reload: true, notify: true });
            }

            vm.listData.forEach(function (item) {
                item.DataConfirm = item.DataConfirm ? JSON.parse(item.DataConfirm) : []
                item.DataConfirm.forEach(function (ele) {
                    ele.Data = ele.Data ? JSON.parse(ele.Data) : []
                    ele.DataActionInfo = ele.DataActionInfo ? JSON.parse(ele.DataActionInfo) : []
                    item.ConfirmStatusId = ele.ConfirmStatusId
                })
            })

            vm.openDetail = function (model) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalTransfer = $uibModal.open({
                    templateUrl: viewPath + 'confirmDetail.html' + versionTemplate,
                    controller: 'Activity.confirmDetail as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        listConfirm: model,
                                        listLottery: vm.listLottery,
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });
                modalTransfer.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalTransfer.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                    }
                });
            }



        }]);
})();