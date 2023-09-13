(function () {
    var viewPath = baseAppPath + '/shared/views/';

    routes.root = {
        url: '',
        abstract: true,
        resolve: {
            auth: ['$rootScope', 'authService', '$state', '$q','sessionService',
                function ($rootScope, authService, $state, $q, sessionService) {
                    var deferred = $q.defer();
                    $q.when(authService.getSession()).then(function (res) {
                        if (res.UserId == 0) {
                            setTimeout(function () {
                                $q.when(authService.getSession()).then(function (res) {
                                        if (res && res.UserRoleId > 0) {
                                            $rootScope.sessionInfo = res;
                                            authService.getUserPermission({ userRoleId: res.UserRoleId }).then(function (res2) {
                                                res2.forEach(function (item) {
                                                    item.url = item.ControllerName != 'home' ? ('/' + item.ControllerName + '/' + item.RoleName) : '/';
                                                    item.root = item.ControllerName != 'home' ? ('root.' + item.ControllerName.replaceAll('-', '') + '.' + item.ActionName) : ('root.home');
                                                })

                                                sessionService.setUserRole(res2);
                                                deferred.resolve(res2);
                                            });
                                        }
                                        else {
                                            $state.go('auth.login');
                                        }
                                });
                            },500)
                        } else {
                            if (res && res.UserRoleId > 0) {
                                $rootScope.sessionInfo = res;
                                authService.getUserPermission({ userRoleId: res.UserRoleId }).then(function (res2) {
                                    res2.forEach(function (item) {
                                        item.url = item.ControllerName != 'home' ? ('/' + item.ControllerName + '/' + item.RoleName) : '/';
                                        item.root = item.ControllerName != 'home' ? ('root.' + item.ControllerName.replaceAll('-', '') + '.' + item.ActionName) : ('root.home');
                                    })

                                    sessionService.setUserRole(res2);
                                    deferred.resolve(res2);
                                });
                            }
                            else {
                                $state.go('auth.login');
                            }
                        }
                    });
                    return deferred.promise;
                }
            ]
        },
        views: {
            '': {
                templateUrl: viewPath + '_layout.html' + versionTemplate,
                controller: 'Shared.Main as $vm'
            },
            'header@root': {
                templateUrl: viewPath + 'header.html' + versionTemplate,
                controller: 'Shared.Header as $vm'
            },
            'left-menu@root': {
                templateUrl: viewPath + 'leftMenu.html' + versionTemplate,
                controller: 'Shared.LeftMenu as $vm'
            }
        }
    };

})();