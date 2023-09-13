(function () {
    var viewPath = baseAppPath + '/system/views/';

    routes.system = {
        url: '/system',
        abstract: true,
        template: '<ui-view></ui-view>'
    };

    routes.system.manageSalePoint = {
        url: '/manageSalePoint',
        params: {
         id: {
                value: '0',
                squash: true
            },
        },
        templateUrl: viewPath + 'manageSalePoint.html' + versionTemplate,
        controller: 'System.manageSalePoint as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'systemService', 'ddlService','salepointService',
                function ($q, $stateParams, userService, systemService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        salepointService.getListSalePoint({ id: params.id })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint:res[0],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý điểm bán'
    };

    routes.system.createSalePoint = {
        url: '/createSalePoint',
        params: {
        },
        templateUrl: viewPath + 'createSalePoint.html' + versionTemplate,
        controller: 'System.createSalePoint as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'systemService', 'ddlService',
                function ($q, $stateParams, userService, systemService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                      
                    ]).then(function (res) {
                        var result = {
                            params: params,
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Tạo điểm bán'
    };

    routes.system.manageAgency = {
        url: '/manageAgency',
        params: {
            id: {
                value: '0',
                squash: true
            },
        },
        templateUrl: viewPath + 'manageAgency.html' + versionTemplate,
        controller: 'System.manageAgency as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'systemService', 'ddlService', 'salepointService', 'activityService',
                function ($q, $stateParams, userService, systemService, ddlService, salepointService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        ddlService.agencyDDL(),
                        activityService.getListSubAgency()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listAgencyDDL: res[0],
                            listSubAgency: res[1],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý đại lý'
    };

    routes.system.createAgency = {
        url: '/createAgency',
        params: {
        },
        templateUrl: viewPath + 'createAgency.html' + versionTemplate,
        controller: 'System.createAgency as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'systemService', 'ddlService',
                function ($q, $stateParams, userService, systemService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([

                    ]).then(function (res) {
                        var result = {
                            params: params,
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Tạo đại lý'
    };

})();