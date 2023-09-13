(function () {
    app.controller('Activity.scratchCardFullLog', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.day = vm.params.day;
            vm.TotalReceiveForUpdate

            console.log("listScratchCardFullLog: ", vm.listScratchCardFullLog)
            vm.totalRow = vm.listScratchCardFullLog && vm.listScratchCardFullLog.length > 0 ? vm.listScratchCardFullLog.length : 0;

            vm.changeDate = function () {
                vm.params.p = 1
                vm.params.day = vm.day ? moment(vm.day).format('YYYY-MM-DD') : moment().format('YYYY-MM-DD')
                $state.go($state.current, vm.params, { reload: true, notify: true });

            }

            vm.openModal = function (model = {}, name) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'updateScratchCardFullLog.html' + versionTemplate,
                    controller: 'Activity.updateScratchCardFullLog as $vm',
                    backdrop: 'static',
                    size: 'sm',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService', 'ddlService',
                            function ($q, $uibModal, userService, ddlService) {
                                var deferred = $q.defer();
                                var scratchCardFullLogId = angular.copy(model.ScratchcardFullLogId)
                                var TotalReceive = angular.copy(model.TotalReceive)
                                $q.all([
                                    
                                ]).then(function (res) {
                                    var result = {
                                        Id: scratchCardFullLogId,
                                        TotalReceive: TotalReceive,
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
                        $state.reload();
                    }
                });
            }
            /*$rootScope.$apply(vm.totalRow)*/
        }]);
})();