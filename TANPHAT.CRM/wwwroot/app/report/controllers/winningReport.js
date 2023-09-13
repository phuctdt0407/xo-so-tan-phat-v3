(function () {
    app.controller('Report.winningReport', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);

            var formatDate = 'DD/MM/YYYY';
            var outputDate = 'YYYY-MM-DD';
            vm.showData = angular.copy(vm.listWinning)

            vm.changeDate = function () {
                vm.params.date = moment(vm.params.date, formatDate).format(outputDate)
                $state.go($state.current, vm.params, { reload: true, notify: true });
            }      

            vm.sortWinningType = (a, b) => {
                if (a.LotteryChannelId > b.LotteryChannelId)
                    return 1;
                else
                    return -1;
            }

            vm.openModalDetail = function (data, id) {
                if (data.DataGroupType && data.DataGroupType.length > 0) {
                    var viewPath = baseAppPath + '/report/views/modal/';
                    var modalDetail = $uibModal.open({
                        params: {
                        },
                        templateUrl: viewPath + 'winningDetail.html' + versionTemplate,
                        controller: 'Report.winningDetail as $vm',
                        backdrop: 'static',
                        size: 'lg',
                        resolve: {
                            viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService', 'salepointService',
                                function ($q, $stateParams, ddlService, reportService, activityService, salepointService) {
                                    var deferred = $q.defer();
                                    var params = angular.copy($stateParams);
                                    $q.all([

                                    ]).then(function (res) {
                                        var result = {
                                            data: data,
                                            lotteryChannelId: id
                                        };
                                        deferred.resolve(result);
                                    });
                                    return deferred.promise;
                                }]
                        },
                    });


                    modalDetail.opened.then(function (res) {
                        $(document).ready(function () {
                            $('.modal-body').css('height', '60vh')
                            $('.modal-lg').css('max-width', '950px')
                        });
                    });

                    modalDetail.result.then(function (data) {

                    }, function (data) {
                        if (typeof (data) == 'object') {

                        }
                    });
                } else { }
                
            }

            vm.init = () => {
                vm.dataSalePoint = angular.copy(vm.listSalePoint)
                if (vm.showData && vm.showData.length > 0)
                    vm.showData.forEach((item) => {
                        item.DataWinning = item.DataWinning ? JSON.parse(item.DataWinning) : []
                        item.DataGroupType = item.DataGroupType ? JSON.parse(item.DataGroupType) : []
                        item.DataGroupType.sort(vm.sortWinningType)
                    })
            }
            vm.init()

            console.log(vm.showData)
        }]);
})();