(function () {
    var viewPath = baseAppPath + '/auth/views/';

    routes.auth = {
        url: '/auth',
        abstract: true,
        template: '<ui-view></ui-view>'
    };

    routes.auth.login = {
        url: '/login',
        controller: 'Auth.Signin as $vm',
        templateUrl: viewPath + 'signin.html' + versionTemplate,
        title: 'Login',
        resolve: {
            auth: ['$rootScope', 'authService', '$state', '$q',
                function ($rootScope, authService, $state, $q) {
                    var deferred = $q.defer();

                    if ($rootScope.checkHeader()) {
                        authService.getSession().then(function (res) {
                            if (res && res.UserId > 0) {
                                $state.go('root.home');
                            }
                            //else {
                            //    var i = 0;
                            //    var interval_obj = setInterval(function () {
                            //        i++;
                            //        authService.getSession().then(function (res1) {
                            //            if (res1 && res1.UserRoleId > 0) {
                            //                $rootScope.showLoading = false;
                            //                clearInterval(interval_obj);
                            //                $state.go('root.home');
                            //            }
                            //        })

                            //        if (i == 5) {
                            //            clearInterval(interval_obj);
                            //            $rootScope.showLoading = false;
                            //        }
                            //    }, 800)
                            //}
                            deferred.resolve(res);
                        });
                    }
                    deferred.resolve({});
                    return deferred.promise;
                }
            ]
        }
    };
})();