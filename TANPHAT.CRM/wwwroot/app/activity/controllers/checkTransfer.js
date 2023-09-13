(function () {
    app.controller('Activity.checkTransfer', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal','transitionType',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN, $uibModal, transitionType) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';



            $rootScope.connection.on("ReceiveMessage", function (user, message) {
                if (user == 'checkTransferReload' && parseInt(message) == $rootScope.sessionInfo.UserId) {
                    $state.reload()
                }
            });

            vm.listsalePoint.unshift({
                Id: 0, Name: 'Tất cả '
            })

            vm.listTransitionType = transitionType;

            vm.totalRow = vm.listConfirm && vm.listConfirm.length > 0 ? vm.listConfirm[0].TotalCount : 0;

            vm.getLotteryName = function (id) {
                return vm.listLottery.filter(item => item.Id == id)[0].ShortName
            }
            if (vm.listConfirm.length > 0) {
                vm.listConfirm.forEach(function (item) {
                    item.Data = JSON.parse(item.TransData);
                })
            }
            // if($rootScope.sessionInfo.UserTitleId==4){
            //     vm.listConfirm = vm.listConfirm.filter(ele=>ele.ManagerId == $rootScope.sessionInfo.UserId)
            // }
           

            vm.changeDate = function () {
                vm.params.day = moment(vm.params.day, formatDate).format(outputDate)
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }
            $scope.getTotalForColumn = function (data) {
                let total = 0;
                data.forEach(ele => {
                    total += ele.TotalTrans;
                });
                return total;
            };
            vm.openDetail = function (model = {}) {
                if (true) {
                    var viewPath = baseAppPath + '/activity/views/modal/';
                    var modalTransfer = $uibModal.open({
                        templateUrl: viewPath + 'checkTransferDetail.html' + versionTemplate,
                        controller: 'Activity.checkTransferDetail as $vm',
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
            }

        }]);
})();