(function () {
    app.controller('Activity.managePayment', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'salepointService', 'notificationService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, sortIcon, salepointService, notificationService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.changeTab = function (tabId) {
                vm.params.tab = tabId
                $state.go($state.current, vm.params, { reload: false, notify: true, inherit: false });
            }

            // Danh sách chuyển khoản
            vm.listSalePointBK = angular.copy(vm.listSalePoint)
            vm.listSalePoint.unshift({
                Id: 0,
                Name: 'Tất cả'
            })

            vm.listPayment.forEach(function (item) {
                item.GuestInfo = item.GuestInfo ? JSON.parse(item.GuestInfo) : []
                item.FullName = item.FullName ? item.FullName : item.GuestInfo.Name
                item.BankAccount = item.GuestActionTypeId == 1 ? item.GuestInfo.BankAccount : ''
                item.Description = item.GuestActionTypeId == 1 ? item.GuestInfo.Description: ''
            })

            var formatDate = ['DD-MM-YYYY', 'YYYY-MM-DD'];
            var outputDate = 'YYYY-MM-DD';

            vm.loadData = function () {
                $state.go($state.current, { date: moment(vm.params.date, formatDate).format(outputDate), salePointId: vm.params.salePointId }, { reload: true, notify: true });
            }

            vm.openDetail = function (model) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalTransfer = $uibModal.open({
                    templateUrl: viewPath + 'paymentDetail.html' + versionTemplate,
                    controller: 'Activity.paymentDetail as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        paymentData: model,
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