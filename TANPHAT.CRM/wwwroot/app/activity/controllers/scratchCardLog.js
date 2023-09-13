(function () {
    app.controller('Activity.scratchCardLog', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.day = vm.params.day;

    
            vm.totalRow = vm.listScratchCardLog && vm.listScratchCardLog.length > 0 ? vm.listScratchCardLog.length : 0;

            vm.changeDate = function () {
                vm.params.p = 1
                vm.params.day = vm.day ? moment(vm.day).format('YYYY-MM-DD') : moment().format('YYYY-MM-DD')
                $state.go($state.current, vm.params, { reload: true, notify: true });
                
            }

            vm.openModal = function (model = {}, name) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'updateScratchCardLog.html' + versionTemplate,
                    controller: 'Activity.updateScratchCardLog as $vm',
                    backdrop: 'static',
                    size: 'sm',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService', 'ddlService',
                            function ($q, $uibModal, userService, ddlService) {
                                var deferred = $q.defer();
                                var scratchCardLogId = angular.copy(model.ScratchcardLogId)
                                var TotalReceive = angular.copy(model.TotalReceived)
                                $q.all([

                                ]).then(function (res) {
                                    var result = {
                                        Id: scratchCardLogId,
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

            /*$rootScope.$apply(vm.params, vm.totalRow)*/
        }]);
})();