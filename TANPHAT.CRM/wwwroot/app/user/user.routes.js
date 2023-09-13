    (function () {
    var viewPath = baseAppPath + '/user/views/';

    routes.user = {
        url: '/user',
        abstract: true,
        template: '<ui-view></ui-view>'
    };

    routes.user.manage = {
        url: '/manage?p&ps&userTitleId',
        params: {
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '100',
                squash: true
            },
            userTitleId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manage.html' + versionTemplate,
        controller: 'User.manage as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService',
                function ($q, $stateParams, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.p = !parseInt(params.p) || parseInt(params.p) < 1 ? 1 : params.p;
                    params.ps = !parseInt(params.ps) || parseInt(params.ps) < 1 ? 20 : params.ps;
                    $q.all([
                        userService.getListUser(params),
                        ddlService.userTitleDDL(),
                        ddlService.salePointDDL()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listUser: res[0],
                            listUserTitle: res[1],
                            listSalePoint: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Danh sách nhân viên'
    };

    routes.user.schedule = {
        url: '/schedule?distributeMonth&salePointId',
        params: {
            distributeMonth: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '1',
                squash: true
            }
        },
        templateUrl: viewPath + 'schedule.html' + versionTemplate,
        controller: 'User.schedule as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService',
                function ($q, $stateParams, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.distributeMonth = params.distributeMonth.length > 0 ? params.distributeMonth : moment().format('YYYY-MM');
                    params.isActive = true;
                    $q.all([
                        userService.getDataDistributeShift(params),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listDistribute: res[0],
                            listSalePoint: res[1],
                            listStaff: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch theo điểm bán'
    };

    routes.user.storeShiftManage = {
        url: '/storeShiftManage?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'storeShiftManage.html' + versionTemplate,
        controller: 'User.storeShiftManage as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService',
                function ($q, $stateParams, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        userService.getSalePointManage({ date: params.day }),
                        ddlService.userByTitleDDL({ userTitleId: 5 })
                    ]).then(function (res) {
                        var result = {
                            listSalePoint: res[0],
                            listStaff: res[1],
                            params: params,
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý chi nhánh'
    };

    routes.user.workSchedule = {
        url: '/workSchedule?distributeMonth&salePointId',
        params: {
            distributeMonth: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '1',
                squash: true
            }
        },
        templateUrl: viewPath + 'workSchedule.html' + versionTemplate,
        controller: 'User.workSchedule as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService',
                function ($q, $stateParams, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.distributeMonth = params.distributeMonth.length > 0 ? params.distributeMonth : moment().format('YYYY-MM');
                    params.isActive = false;
                    $q.all([
                        userService.getDataDistributeShift(params),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 })
                    ]).then(function (res) {
                        var result = {
                            listDistribute: res[0],
                            listSalePoint: res[1],
                            listStaff: res[2],
                            params: params
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chia lịch làm việc'
    };

    routes.user.rolePermission = {
        url: '/rolePermission',
        params: {},
        templateUrl: viewPath + 'rolePermission.html' + versionTemplate,
        controller: 'User.rolePermission as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'userService', 'ddlService',
                function ($q, $stateParams, $rootScope, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);

                    $q.all([
                        ddlService.userTitleDDL({
                            isGetFull: true
                        })
                    ]).then(function (res) {
                        var result = {
                            listRole: res[0]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Phân quyền'
    };

    routes.user.checkSchedule = {
        url: '/checkSchedule?distributeMonth',
        params: {
            distributeMonth: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'checkSchedule.html' + versionTemplate,
        controller: 'User.checkSchedule as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService',
                function ($q, $stateParams, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    console.log(params)
                    params.distributeMonth = params.distributeMonth.length > 0 ? params.distributeMonth : moment().format('YYYY-MM');
                    params.isActive = false;
                    var month = moment(params.distributeMonth, "YYYY-MM").format("MM");
                    var year = moment(params.distributeMonth, "YYYY-MM").format("YYYY");
                    $q.all([
                        userService.getDataDistributeShiftMonth(params),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 }),
                        userService.getListEventDate({
                            month: month,
                            year: year
                        }),
                        ddlService.userByTitleDDL({ userTitleId: 4 }),
                        userService.getListOffOfLeader({ month: params.distributeMonth}),
                       
                    ]).then(function (res) {
                        var result = {
                            listDistribute: res[0],
                            listSalePoint: res[1],
                            listStaff: res[2],
                            listHoliday: res[3],
                            listLeader: res[4],
                            listLeaderOff:res[5],
                            params: params
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chia lịch làm việc'
    };

    routes.user.staffSchedule = {
        url: '/staffSchedule?distributeMonth&userId',
        params: {
            distributeMonth: {
                value: '',
                squash: true
            },
            userId: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'staffSchedule.html' + versionTemplate,
        controller: 'User.staffSchedule as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'userService', 'ddlService',
                function ($q, $stateParams, $rootScope, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.distributeMonth = params.distributeMonth.length > 0 ? params.distributeMonth : moment().format('YYYY-MM');
                    params.userId = params.userId.length > 0 ? params.userId : $rootScope.sessionInfo.UserId.toString();
                    $q.all([
                        userService.getAllShiftInMonthOfOneUser({ month: params.distributeMonth, UserRole: params.userId }),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listDistribute: res[0],
                            listSalePoint: res[1],
                            listStaff: res[2]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch nhân viên'
    };

    routes.user.createUser = {
        url: '/createUser',
        params: {
            
        },
        templateUrl: viewPath + 'createUser.html' + versionTemplate,
        controller: 'User.createUser as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'userService', 'ddlService',
                function ($q, $stateParams, $rootScope, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    $q.all([
                        ddlService.salePointDDL()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Tạo người dùng'
    };

    routes.user.targetTable = {
        url: '/targetTable',
        params: {

        },
        templateUrl: viewPath + 'targetTable.html' + versionTemplate,
        controller: 'User.targetTable as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'userService', 'ddlService',
                function ($q, $stateParams, $rootScope, userService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    $q.all([
                        userService.getListTarget(),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            data:res[0]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Bảng target'
    };

    routes.user.kpi = {
        url: '/kpi?p&ps&month',
        params: {
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '10000',
                squash: true
            },
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'kpi.html' + versionTemplate,
        controller: 'User.kpi as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'userService', 'ddlService', 'salepointService', 'reportService',
                function ($q, $stateParams, $rootScope, userService, ddlService, salepointService, reportService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month && params.month != '' ? params.month : moment().format('YYYY-MM');

                    $q.all([
                        ddlService.getUserDDL({
                            date: moment(params.month, "YYYY-MM").endOf().format("YYYY-MM-DD"),
                            userTitleId: 0
                        }),
                        ddlService.getCriteriaDDL({
                            userTitleId: 0
                        }),
                        salepointService.getListSalePointOfLeader({
                            date: moment(params.month, "YYYY-MM").endOf().format("YYYY-MM-DD"),
                        }),
                        userService.getListKPIOfUser({
                            month: params.month
                        }),
                        userService.getListTargetMaster(),
                        ddlService.salePointDDL(),
                        reportService.getListExemptKpi({ month: params.month })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listUser: res[0],
                            listTitle: res[1],
                            listSalePoint: res[2],
                            listData: res[3],
                            listTaget: res[4],
                            listSalePointDropDown: res[5],
                            listExemptKpi: res[6]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'KPI'
    };
   
    routes.user.holidaySchedule = {
        url: '/holidaySchedule?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'holidaySchedule.html' + versionTemplate,
        controller: 'User.holidaySchedule as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService',
                function ($q, $stateParams, userService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month && params.month != '' ? params.month : moment().format('YYYY-MM');
                    //
                    var month = moment(params.month, "YYYY-MM").format("MM");
                    var year = moment(params.month, "YYYY-MM").format("YYYY");
                    $q.all([
                        userService.getListEventDate({
                            month: month,
                            year: year
                        })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listHoliday: res[0]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch nghỉ lễ'
    };

    routes.user.extraPayment = {
        url: '/extraPayment?p&ps&month',
        params: {
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '10000',
                squash: true
            },
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'extraPayment.html' + versionTemplate,
        controller: 'User.extraPayment as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService','salepointService',
                function ($q, $stateParams, userService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month && params.month != '' ? params.month : moment().format('YYYY-MM');
                    var month = moment(params.month, "YYYY-MM").format("MM");
                    var year = moment(params.month, "YYYY-MM").format("YYYY");
                    $q.all([
                        userService.getListEventDate({
                            month: month,
                            year: year
                        }),
                        ddlService.getUserDDL({
                            date: moment(params.month, "YYYY-MM").endOf().format("YYYY-MM-DD"),
                            userTitleId: 0
                        }),
                        salepointService.getListTransaction(params)
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listHoliday: res[0],
                            listUser: res[1],
                            listData: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Đánh giá chuyên cần'
    };

    routes.user.manageLeaderOff = {
        url: '/manageLeaderOff',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manageLeaderOff.html' + versionTemplate,
        controller: 'User.manageLeaderOff as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService','salepointService',
                function ($q, $stateParams, userService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month && params.month != '' ? params.month : moment().format('YYYY-MM');
                    $q.all([
                        ddlService.getUserDDL({
                            date: moment(params.month, "YYYY-MM").endOf().format("YYYY-MM-DD"),
                            userTitleId: 4
                        }),
                        ddlService.salePointDDL(),
                        salepointService.getListAttendentOfLeader()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listUser: res[0],
                            listSalePoint: res[1],
                            listLeader:  res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Trưởng nhóm nghỉ'
    };


        routes.user.checkScheduleIntern = {
            url: '/checkScheduleIntern?distributeMonth',
            params: {
                distributeMonth: {
                    value: '',
                    squash: true
                }
            },
            templateUrl: viewPath + 'checkScheduleIntern.html' + versionTemplate,
            controller: 'User.checkScheduleIntern as $vm',
            resolve: {
                viewModel: ['$q', '$stateParams', 'userService', 'ddlService',
                    function ($q, $stateParams, userService, ddlService) {
                        var deferred = $q.defer();
                        var params = angular.copy($stateParams);
                        console.log(params)
                        params.distributeMonth = params.distributeMonth.length > 0 ? params.distributeMonth : moment().format('YYYY-MM');
                        params.isActive = false;
                        var month = moment(params.distributeMonth, "YYYY-MM").format("MM");
                        var year = moment(params.distributeMonth, "YYYY-MM").format("YYYY");
                        $q.all([
                            userService.getShiftDistributeOfIntern(params),
                            ddlService.salePointDDL(),
                            ddlService.internByTitleDDL(),
                            userService.getListEventDate({
                                month: month,
                                year: year
                            }),
                           
                        ]).then(function (res) {
                            var result = {
                                listDistribute: res[0],
                                listSalePoint: res[1],
                                listStaff: res[2],
                                listHoliday: res[3],
                                listLeader: res[4],
                                listLeaderOff:res[5],
                                params: params
                            };

                            deferred.resolve(result);
                        });
                        return deferred.promise;
                    }]
            },
            title: 'Lịch thử việc'
        };
})();