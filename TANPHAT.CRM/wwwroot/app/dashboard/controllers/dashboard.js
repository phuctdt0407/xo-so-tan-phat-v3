(function () {
    app.controller('DashBoard', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'dashboardService', 'authService','$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, dashboardService, authService,$uibModal) {
            var vm = angular.extend(this, viewModel);

        }]);
})();

