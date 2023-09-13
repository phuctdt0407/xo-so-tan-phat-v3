(function () {
    app.controller('System.manageAgency', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'dayOfWeekVN', 'salepointService', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, dayOfWeekVN, salepointService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.tabId = 1

            vm.classItem0 = vm.tabId && vm.tabId == 1 ? 'nav-link active' : 'nav-link';
            vm.classItem1 = vm.tabId && vm.tabId == 2 ? 'nav-link active' : 'nav-link';

            vm.changeTab = function (tabId) {
                if (tabId === 1) {
                    vm.tabId = 1
                }
                if (tabId === 2) {
                    vm.tabId = 2
                }

            };

            vm.openModal = function (model = {}, type, name) {
                var viewPath = baseAppPath + '/system/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'updateAgency.html' + versionTemplate,
                    controller: 'System.updateAgency as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService', 'systemService',
                            function ($q, $uibModal, userService, systemService) {
                                var deferred = $q.defer();
                                var modelBK = angular.copy(model)
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        agencyInfo: modelBK,
                                        type: type
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

        }]);
})();
