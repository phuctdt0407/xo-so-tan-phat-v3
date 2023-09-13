(function () {
    app.service('dashboardService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/Dashboard';

            this.getDashboardTeacherClass = function (params) {
                var url = baseUrl + '/GetDashboardTeacherClass';
                return baseService.getData(url, params);
            };

            this.getDashboardQCSC = function (params) {
                var url = baseUrl + '/GetDashboardQCSC';
                return baseService.getData(url, params);
            };

            this.getDashboardTotalClasses = function (params) {
                var url = baseUrl + '/GetDashboardTotalClasses';
                return baseService.getData(url, params);
            };

        }]);
})(); 