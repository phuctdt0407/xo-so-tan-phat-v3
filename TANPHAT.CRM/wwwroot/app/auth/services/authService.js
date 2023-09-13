(function () {
    app.service('authService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/Auth';

            this.login = function (params) {
                var url = baseUrl + '/Login';
                return baseService.postData(url, params);
            };

            this.sendMailChangePassword = function (params) {
                var url = baseUrl + '/SendMailChangePassword';
                return baseService.postData(url, params);
            };

            this.getSession = function () {
                var url = baseUrl + '/GetSession';
                return baseService.getData(url);
            };

            this.getUserPermission = function (params) {
                var url = baseUrl + '/GetUserPermission';
                return baseService.getData(url, params);
            };
            
            this.getFirstPageShow = function (params) {
                var url = baseUrl + '/GetFirstPageShow';
                return baseService.getData(url, params);
            };

            this.changePassword = function (params) {
                var url = baseUrl + '/ChangePassword';
                return baseService.postData(url, params);
            };

            this.forgotPassword = function (params) {
                var url = baseUrl + '/ForgotPassword';
                return baseService.postData(url, params);
            };

            this.logout = function () {
                var url = baseUrl + '/Logout';
                return baseService.postData(url);
            };

        }]);
})();