(function () {
    app.controller('Report.detailSaleLoto', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'reportService', 'salepointService', '$uibModal',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, reportService, salepointService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.dayDisplay = moment(vm.model.Date).format('DD-MM-YYYY')
            try {
                vm.model.Data = JSON.parse(vm.model.Data)
            } catch (err) {

            }
            
            

            vm.openUpdate = function (model) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'updateLotoAndVietlott.html' + versionTemplate,
                    controller: 'Report.updateLotoAndVietlott as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
                            function ($q, $uibModal, reportService, ddlService) {
                                var deferred = $q.defer();

                                $q.all([

                                ]).then(function (res) {
                                    var result = {
                                        model: model,
                                        type:vm.type
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
                })
            }
            
            vm.cancel = function () {
                $uibModalInstance.close()
            }
        }]);
})();
