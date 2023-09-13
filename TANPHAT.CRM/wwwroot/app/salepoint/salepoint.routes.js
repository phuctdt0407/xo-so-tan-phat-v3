(function () {
    var viewPath = baseAppPath + '/salepoint/views/';

    routes.salepoint = {
        url: '/salepoint',
        abstract: true,
        template: '<ui-view></ui-view>'
    };


    routes.salepoint.debtManage = {
        url: '/debtManage',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'debtManage.html' + versionTemplate,
        controller: 'Salepoint.debtManage as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'salepointService', 'ddlService',
                function ($q, $rootScope, $stateParams, userService, salepointService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);

                    $q.all([
                        salepointService.getListItemConfirm(
                            {
                                Month: "2022-06",
                                ConfirmForTypeId: 2
                            }
                        )
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listRequestDebt: res[0]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý nợ'
    };
    routes.salepoint.salePointPercent = {
        url: '/salePointPercent?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'salePointPercent.html' + versionTemplate,
        controller: 'Salepoint.salePointPercent as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month != '' ? params.month : moment().format('YYYY-MM')
                    $q.all([
                        salepointService.getListSalePointPercent(params),
                        ddlService.salePointDDL(),
                        ddlService.getUserDDL({userTitleId: 2})
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listPercent: res[0],
                            listSalePoint: res[1],
                            listLeader: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Hệ số chia sẻ doanh thu'
    };

    routes.salepoint.guestManage = {
        url: '/guestManage?salePointId',
        params: {
            salePointId: {
                value: '0',
                squash: true
            },
        },
        templateUrl: viewPath + 'guestManage.html' + versionTemplate,
        controller: 'Salepoint.guestManage as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.salePointId = params.salePointId ? params.salePointId : 0;
                    $q.all([
                        ddlService.getGuestDDL(params),
                        ddlService.salePointDDL()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listAllGuest: res[0],
                            listSalePoint: res[1]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý khách'
    };
    routes.salepoint.commissionWinning = {
        url: '/commissionWinning?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'commissionWinning.html' + versionTemplate,
        controller: 'Salepoint.commissionWinning as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'salepointService', 'userService', 'ddlService',
                function ($q, $stateParams, $rootScope, salepointService, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month.length > 0 ? params.month : moment().format('YYYY-MM');

                    $q.all([
                        salepointService.getListComission({ month: params.month }),
                        salepointService.getListFeeOfCommission({ month: params.month }),
                        userService.getListUser({
                            p:1,
                            ps: 100,
                            qj:1
                        }),
                        ddlService.salePointDDL(),
                        salepointService.getTotalCommisionAndFee({ date: params.month, salePointId: 0 })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listCommission: res[0],
                            listFee:res[1],
                            listUser: res[2],
                            listSalePoint: res[3],
                            listTotalComissionAndFee: res[4],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Hoa hồng ĐST'
    };

    routes.salepoint.staticFee = {
        url: '/staticFee?month',
        params: {
            month: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'staticFee.html' + versionTemplate,
        controller: 'Salepoint.staticFee as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService', 'activityService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM-DD') : params.month;
                    $q.all([
                        ddlService.salePointDDL(),
                        activityService.getStaticFee({ month: params.month }),
                        salepointService.getAllStaticFee()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listStaticFee: res[1],
                            listDisplay: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chi phí cố định'
    };
})();