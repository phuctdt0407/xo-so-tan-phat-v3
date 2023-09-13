(function () {
    app.controller('Activity.ownDebtManage', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal', 'userService',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN, $uibModal, userService) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';
            vm.params.date = moment(vm.params.date, formatDate).format('DD-MM-YYYY');

            vm.changeTab = function (tabId) {
                vm.params.tab = tabId
                vm.params.userId = ''
                vm.loadData();
            }

            vm.loadData = function () {
                vm.params.date = moment(vm.params.date, formatDate).format(outputDate)
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }

            //----------------Danh sách yêu cầu nợ hôm nay-----------------
            vm.totalRow = vm.listBorrow && vm.listBorrow.length > 0 ? vm.listBorrow.length : 0;

            vm.listBorrow.forEach(function (item) {
                item.DataConfirm = item.DataConfirm ? JSON.parse(item.DataConfirm) : []

                //item.FullName = vm.listLeader.find(x => x.UserId == item.UserId).FullName
                if (item.DataConfirm && item.DataConfirm.length > 0) {
                    item.DataConfirm.forEach(function (ele) {
                        item.TotalPrice = 0
                        if (ele.FormPaymentId == 1) {
                            item.Cash = ele.Price
                            item.TotalPrice += item.Cash
                        } else {
                            item.Transfer = ele.Price
                            item.TotalPrice += item.Transfer
                        }
                    })
                }
            })

            //Mở modal confirm/hủy
            vm.openModalConfirm = function (model) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalConfirm = $uibModal.open({
                    templateUrl: viewPath + 'confirmOwnDebt.html' + versionTemplate,
                    controller: 'Activity.confirmOwnDebt as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        data: model
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });

                modalConfirm.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalConfirm.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                    } else {
                    }
                });
            }

            //------------------Lịch sử nợ riêng---------------
            vm.listDetail.forEach(function (item) {
                item.TotalData = item.TotalData ? JSON.parse(item.TotalData) : []
            })

            vm.openModalPayBorrow = function (model) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalPayBorrow = $uibModal.open({
                    templateUrl: viewPath + 'payBorrow.html' + versionTemplate,
                    controller: 'Activity.payBorrow as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        data: model
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });

                modalPayBorrow.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalPayBorrow.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                    } else {
                    }
                });
            }


        }]);
})();