(function () {
    var viewPath = baseAppPath + '/activity/views/';

    routes.activity = {
        url: '/activity',
        abstract: true,
        template: '<ui-view></ui-view>'
    };

    routes.activity.groupLotteryManage = {
        url: '/groupLotteryManage',
        templateUrl: viewPath + 'groupLotteryManage.html' + versionTemplate,
        controller: 'Activity.groupLotteryManage as $vm',
        resolve: {
            viewModel: ['$q', 'reportService',
                function ($q, reportService) {
                    var deferred = $q.defer();
                    $q.all([
                    ]).then(function (res) {
                        var result = {
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý vé'
    };

    routes.activity.groupMoneyManage = {
        url: '/groupMoneyManage',
        templateUrl: viewPath + 'groupMoneyManage.html' + versionTemplate,
        controller: 'Activity.groupMoneyManage as $vm',
        resolve: {
            viewModel: ['$q', 'reportService',
                function ($q, reportService) {
                    var deferred = $q.defer();
                    $q.all([
                    ]).then(function (res) {
                        var result = {
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý tiền'
    };

    routes.activity.manage = {
        url: '/manage?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manage_v2.html' + versionTemplate,
        controller: 'Activity.manage as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getDataDistributeForSalePoint({
                            lotteryDate: params.day
                        }),
                        ddlService.agencyDDL(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            lotteryDate: params.day
                        }),
                        ddlService.salePointDDL(),
                        activityService.getDataReceivedFromAgency({
                            lotteryDate: params.day
                        }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listAgency: res[1],
                            listLottery: res[2],
                            listSalePoint: res[3],
                            listTotalAgency: res[4]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chia vé cho điểm bán'
    };

    routes.activity.manageScratchcard = {
        url: '/manageScratchcard?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manageScratchcard.html' + versionTemplate,
        controller: 'Activity.manageScratchcard as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        ddlService.agencyDDL(),
                        ddlService.salePointDDL(),
                        activityService.getDataDistributeScratchForSalePoint(),
                        activityService.getScratchcardFull(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listAgency: res[0],
                            listSalePoint: res[1],
                            listData: res[2],
                            totalScratchcard: res[3],
                            listLotteryDDL: res[4]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chia vé cào'
    };

    routes.activity.create = {
        url: '/create?day',
        params: {
            day: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'create.html' + versionTemplate,
        controller: 'Activity.create as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService', 'activityService',
                function ($q, $stateParams, userService, ddlService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        ddlService.agencyDDL(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            lotteryDate: params.day
                        }),
                        activityService.getDataReceivedFromAgency({
                            lotteryDate: params.day
                        })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listAgency: res[0],
                            listLottery: res[1],
                            listTotal: res[2]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Nhận vé từ đại lý'
    };

    routes.activity.createScratchcard = {
        url: '/createScratchcard?day',
        params: {
            day: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'createScratchcard.html' + versionTemplate,
        controller: 'Activity.createScratchcard as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'ddlService', 'activityService',
                function ($q, $stateParams, userService, ddlService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        ddlService.agencyDDL(),
                        activityService.getDataScratchcardFromAgency({ date: params.day }),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listAgency: res[0],
                            listData: res[1],
                            listLotteryDDL: res[2]
                        };



                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Nhận vé cào'
    };

    routes.activity.salesActivity = {
        url: '/salesActivity?shiftDistributeId&shiftId&clientType&wholesaleId',
        params: {
            shiftDistributeId: {
                value: '',
                squash: true
            },
            shiftId: {
                value: '',
                squash: true
            },
            clientType: {
                value: '1',
                squash: true
            },
            wholesaleId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'salesActivity.html' + versionTemplate,
        controller: 'Activity.salesActivity as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.clientType = parseInt(params.clientType);
                    $q.all([
                        activityService.getDataSell({
                            shiftDistributeId: params.shiftDistributeId,
                            userRoleId: $rootScope.sessionInfo.UserRoleId,
                            date: moment().format("YYYY-MM-DD")
                        }),
                        ddlService.lotteryPriceDDL(),
                        ddlService.lotteryTypeDDL(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            lotteryDate: params.day
                        }),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            lotteryDate: moment().format("YYYY-MM-DD")
                        }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSellData: res[0],
                            listTypeSelect: res[1],
                            listTypeDDL: res[2],
                            listLottery: res[3],
                            listLotteryToday: res[4],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Bán hàng'
    };

    routes.activity.inventoryManage = {
        url: '/inventoryManage?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'inventoryManage.html' + versionTemplate,
        controller: 'Activity.InventoryManage as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'activityService', 'ddlService',
                function ($q, $stateParams, $rootScope, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getInventoryLog({ date: params.day })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listInventory: res[0]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chuyển nhận vé'
    };

    routes.activity.moveTicket = {
        url: '/moveTicket?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'moveTicket.html' + versionTemplate,
        controller: 'Activity.moveTicket as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', '$rootScope', 'activityService', 'ddlService',
                function ($q, $stateParams, $rootScope, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getSalePointReturn({ date: params.day })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listInventory: res[0]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Kho ế'
    };

    routes.activity.checkTransfer = {
        url: '/checkTransfer?p&ps&day&salePointId&transitionTypeId',
        params: {
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '100',
                squash: true
            },
            day: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '0',
                squash: true
            },
            transitionTypeId: {
                value: '0',
                squash: true
            }
        },
        templateUrl: viewPath + 'checkTransfer.html' + versionTemplate,
        controller: 'Activity.checkTransfer as $vm',
        resolve: {

            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService','$rootScope',

                function ($q, $stateParams, userService, activityService, ddlService, $rootScope) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getTransitionListToConfirm(
                            { p: params.p, ps: params.ps, date: params.day, salePointId: params.salePointId, transitionTypeId: params.transitionTypeId, userRoleId: $rootScope.sessionInfo.UserRoleId }
                        ),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        }),
                        ddlService.salePointDDL(),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listConfirm: res[0],
                            listLottery: res[1],
                            listsalePoint: res[2]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Yêu cầu chuyển nhận vé'
    };

    routes.activity.selectSalepoint = {
        url: '/selectSalepoint?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'selectSalepoint.html' + versionTemplate,
        controller: 'Activity.selectSalepoint as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getShiftDistributeByDate({
                            date: moment().format('YYYY-MM-DD'),
                            userId: $rootScope.sessionInfo.UserId
                        })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chọn điểm bán'
    };

    routes.activity.manageConfirm = {
        url: '/manageConfirm?salePointId&guestId',
        params: {
            salePointId: {
                value: '',
                squash: true
            },
            guestId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manageConfirm.html' + versionTemplate,
        controller: 'Activity.manageConfirm as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    $q.all([
                        ddlService.salePointDDL(),
                        ddlService.getGuestDDL({ salePointId: params.salePointId }),
                        salepointService.getListConfirmPayment(params),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listGuest: res[1],
                            listData: res[2],
                            listLottery: res[3]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },

        title: 'Quản lý yêu cầu khách nợ'
    };

    routes.activity.agencyPrice = {
        url: '/agencyPrice',
        params: {
        },
        templateUrl: viewPath + 'agencyPrice.html' + versionTemplate,
        controller: 'Activity.agencyPrice as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'activityService', 'ddlService',
                function ($q, $stateParams, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getLotteryPriceAgency(),
                        ddlService.agencyDDL(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listAgency: res[1],
                            listLottery: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Giá vé từ đại lý'
    };

    routes.activity.returnAgency = {
        url: '/returnAgency?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'returnAgency.html' + versionTemplate,
        controller: 'Activity.returnAgency as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getListLotteryForReturn({
                            lotteryDate: params.day
                        }),
                        ddlService.agencyDDL(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            lotteryDate: params.day
                        }),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listAgency: res[1],
                            listLottery: res[2],
                            listScratchCard: res[3]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Trả ế đại lý'
    };

    routes.activity.managePayment = {
        url: '/managePayment?ps&p&salePointId&date&tab',
        params: {
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '100',
                squash: true
            },
            date: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '0',
                squash: true
            },
            tab: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'managePayment.html' + versionTemplate,
        controller: 'Activity.managePayment as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.date = params.date == '' ? moment().format('YYYY-MM-DD') : params.date;
                    $q.all([
                        ddlService.salePointDDL(),
                        salepointService.getListPaymentForConfirm(params)
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listPayment: res[1]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý chuyển khoản'
    };

    routes.activity.purchaseHistory = {
        url: '/purchaseHistory',
        params: {
        },
        templateUrl: viewPath + 'purchaseHistory.html' + versionTemplate,
        controller: 'Activity.purchaseHistory as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    $q.all([
                        ddlService.salePointDDL(),
                        salepointService.getListHistoryOfGuest({ guestId: 1 })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            data: res[1]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch sử mua hàng'
    };

    routes.activity.requestOwnDebt = {
        url: '/requestOwnDebt?date&userId&p&ps',
        params: {
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '100',
                squash: true
            },
            date: {
                value: '',
                squash: true
            },
            userId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'requestOwnDebt.html' + versionTemplate,
        controller: 'Activity.requestOwnDebt as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.date = params.date != '' ? params.date : moment().format('YYYY-MM-DD')
                    params.userId = params.userId != '' ? params.userId : $rootScope.sessionInfo.UserId
                    $q.all([
                        userService.getListBorrowForConfirm(params)
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listBorrow: res[0]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Yêu cầu nợ riêng'
    };

    routes.activity.ownDebtManage = {
        url: '/ownDebtManage?month&userId',
        params: {
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '100',
                squash: true
            },
            month: {
                value: '',
                squash: true
            },
            userId: {
                value: '',
                squash: true
            },
            date: {
                value: '',
                squash: true
            },
            tab: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'ownDebtManage.html' + versionTemplate,
        controller: 'Activity.ownDebtManage as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month != '' ? params.month : moment().format('YYYY-MM')
                    params.date = params.date != '' ? params.date : moment().format('YYYY-MM-DD')
                    params.tab = params.tab != '' ? params.tab : 1
                    $q.all([
                        userService.getListBorrowForConfirm({
                            p: params.p,
                            ps: params.ps,
                            userId: params.userId,
                            date: params.date
                        }),
                        userService.getListBorrowInMonth({ month: params.month, userId: params.userId }),
                        ddlService.getUserDDL({ userTitleId: 4 })
                    ]).then(function (res) {
                        res[2].unshift({
                            UserId: 0,
                            FullName: 'Tất cả'
                        })
                        var result = {
                            params: params,
                            listBorrow: res[0],
                            listDetail: res[1],
                            listLeader: res[2]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý nợ riêng'
    };

    routes.activity.moneyVietlott = {
        url: '/moneyVietlott?month',
        params: {
            month: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'moneyVietlott.html' + versionTemplate,
        controller: 'Activity.moneyVietlott as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month != '' ? params.month : moment().format('YYYY-MM')
                    $q.all([
                        salepointService.getListPayVietlott(params),
                        ddlService.salePointDDL()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listPayVietlott: res[0],
                            listSalePoint: res[1]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Tiền nạp Vietlott'
    };
    routes.activity.historyBill = {
        url: '/historyBill?date&shiftId&salePointId&regionId',
        params: {
            date: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '1',
                squash: true
            },
            shiftId: {
                value: '1',
                squash: true
            },
            regionId: {
                value: '2',
                squash: true
            },
        },
        templateUrl: viewPath + 'historyBill.html' + versionTemplate,
        controller: 'Activity.historyBill as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService', 'shiftStatus2',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService, shiftStatus2) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.date = params.date != '' ? params.date : moment().format('YYYY-MM-DD')

                    $q.all([

                        activityService.getListHistoryForManager({ date: params.date, salePointId: params.salePointId, shiftid: params.shiftId }),
                        ddlService.salePointDDL(),
                        ddlService.lotteryChannelDDL({ regionId: params.regionId }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listSalePoint: res[1],
                            listShift: shiftStatus2,
                            listlotteryChannel: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch Sử Bill'
    };

    routes.activity.otherCosts = {
        url: '/otherCosts',
        params: {
        },
        templateUrl: viewPath + 'otherCosts.html' + versionTemplate,
        controller: 'Activity.otherCosts as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    $q.all([
                        ddlService.getTypeNameDDL({ transactionTypeId: 1, }),
                        salepointService.getListSalePoint()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listTypeOfFee: res[0],
                            listSalePoint: res[1],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chi phí khác'
    };

    routes.activity.otherCostsHistory = {
        url: '/otherCostsHistory?day&salePointId',
        params: {
            day: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'otherCostsHistory.html' + versionTemplate,
        controller: 'Activity.otherCosts as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day != '' ? params.day : moment().format('YYYY-MM-DD');
                    params.salePointId = params.salePointId ? params.salePointId : 0;
                    $q.all([
                        ddlService.getTypeNameDDL({ transactionTypeId: 1, }),
                        salepointService.getListOtherFees({ date: params.day, salePointId: params.salePointId }),
                        salepointService.getListSalePoint()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listTypeOfFee: res[0],
                            listFee: res[1],
                            listSalePoint: res[2],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch sử chi phí khác'
    };

    routes.activity.scratchCardLog = {
        url: '/scratchCardLog?day&ps&p',
        params: {
            day: {
                value: '',
                squash: true
            },
            ps: {
                value: '100',
                squash: true
            },
            p: {
                value: '1',
                squash: true
            }
        },
        templateUrl: viewPath + 'scratchCardLog.html' + versionTemplate,
        controller: 'Activity.scratchCardLog as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        userService.getHistoryScratchCardLog({ ps: params.ps, p: params.p, date: params.day })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listScratchCardLog: res[0],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch sử chia thẻ cào'
    };

    routes.activity.scratchCardFullLog = {
        url: '/scratchCardFullLog?day&ps&p',
        params: {
            day: {
                value: '',
                squash: true
            },
            ps: {
                value: '100',
                squash: true
            },
            p: {
                value: '1',
                squash: true
            }
        },
        templateUrl: viewPath + 'scratchCardFullLog.html' + versionTemplate,
        controller: 'Activity.scratchCardFullLog as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        userService.getHistoryScratchCardFullLog({ ps: params.ps, p: params.p, date: params.day })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listScratchCardFullLog: res[0],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch sử nhập thẻ cào'
    };

    routes.activity.activityLog = {
        url: '/activityLog?ShiftDistributeId&SalePointId&day',
        params: {
            day: {
                value: '',
                squash: true
            },
            p: {
                value: '1',
                squash: true
            },
            ps: {
                value: '20',
                squash: true
            },
            ShiftDistributeId: {
                value: '',
                squash: true
            },
            SalePointId: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'activityLog.html' + versionTemplate,
        controller: 'Activity.activityLog as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'reportService', 'salepointService', 'ddlService',
                function ($q, $rootScope, $stateParams, userService, activityService, reportService, salepointService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    params.p = !parseInt(params.p) || parseInt(params.p) < 1 ? 1 : params.p;
                    params.ps = !parseInt(params.ps) || parseInt(params.ps) < 1 ? 20 : params.ps;

                    $q.all([
                        activityService.getSalePointLog({
                            UserRoleId: $rootScope.sessionInfo.UserRoleId,
                            ShiftDistributeId: params.ShiftDistributeId,
                            SalePointId: params.SalePointId,
                            Date: moment(params.day).format("YYYY-MM-DD")
                        }),
                        activityService.getRepaymentLog({
                            UserRoleId: $rootScope.sessionInfo.UserRoleId,
                            ShiftDistributeId: params.ShiftDistributeId,
                            SalePointId: params.SalePointId,
                            Date: moment(params.day).format("YYYY-MM-DD")
                        }),
                        activityService.getWinningList({
                            shiftDistributeId: params.ShiftDistributeId,
                            //UserRoleId:$rootScope.sessionInfo.UserRoleId,
                            salePointId: params.SalePointId,
                            date: moment(params.day).format("YYYY-MM-DD")
                        }),
                        activityService.getSoldLogDetail({
                            UserRoleId: $rootScope.sessionInfo.UserRoleId,
                            ShiftDistributeId: params.ShiftDistributeId,
                        }),

                        activityService.getTransLogDetail({
                            ShiftDistributeId: params.ShiftDistributeId,
                        }),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            /*lotteryDate: params.day*/
                        }),
                        salepointService.getListHistoryOrder({ shiftDistributeId: params.ShiftDistributeId, p: params.p, ps: params.ps }),
                        activityService.getDataSell({
                            shiftDistributeId: params.ShiftDistributeId,
                            userRoleId: $rootScope.sessionInfo.UserRoleId,
                            date: moment().format("YYYY-MM-DD")
                        }),
                        salepointService.getListPaymentForConfirm({
                            salePointId: params.SalePointId,
                            date: moment(params.day).format("YYYY-MM-DD")
                        })
                    ]).then(function (res) {
                        console.log("res",res)
                        let listSales = res[0].filter(ele => ele.TransitionTypeId == 0)
                        let listTransfer = res[0].filter(ele => ele.TransitionTypeId != 0)
                        var result = {
                            params: params,
                            listSalePointLog: listSales,
                            listTransferLog: listTransfer,
                            listPayingDebtLog: res[1],
                            listWinning: res[2],
                            listSold: res[6],
                            listTrans: res[4],
                            listLottery: res[5],
                            listSellData: res[7],
                            listPayment: res[8]
                            
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Nhật kí hoạt động'
    };

    routes.activity.distributeForSubAgency = {
        url: '/distributeForSubAgency?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manage_v2.html' + versionTemplate,
        controller: 'Activity.distributeForSubAgency as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        ddlService.agencyDDL(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            lotteryDate: params.day
                        }),
                        activityService.getDataReceivedFromAgency({
                            lotteryDate: params.day
                        }),
                        activityService.getDataSupAgency({ Date: params.day }),
                        ddlService.subAgencyDDL()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listAgency: res[0],
                            listLottery: res[1],
                            listTotalAgency: res[2],
                            listTotalSupAgency: res[3],
                            listSupAgency: res[4],

                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chia vé cho đại lý con'
    };

    routes.activity.sendAndReceive = {
        url: '/sendAndReceive?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'sendAndReceive.html' + versionTemplate,
        controller: 'Activity.sendAndReceive as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        ddlService.salePointDDL(),
                        reportService.getTransitonTypeOffset({ month: params.month })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listTransitionTypeOffset: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Thống kê chuyển nhận vé'
    };

    routes.activity.subAgencyPrice = {
        url: '/subAgencyPrice',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'subAgencyPrice.html' + versionTemplate,
        controller: 'Activity.subAgencyPrice as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'activityService', 'ddlService',
                function ($q, $stateParams, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getListLotteryPriceSubAgency(),
                        activityService.getListSubAgency(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listSubAgency: res[1],
                            listLottery: res[2],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Giá vé từ đại lý con'
    };

    routes.activity.manageScratchcardForSubAgency = {
        url: '/manageScratchcardForSubAgency?day',
        params: {
            day: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manageScratchcardForSubAgency.html' + versionTemplate,
        controller: 'Activity.manageScratchcardForSubAgency as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'activityService', 'ddlService',
                function ($q, $stateParams, userService, activityService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    $q.all([
                        activityService.getDataDistributeScratchForSubAgency(),
                        activityService.getScratchcardFull(),
                        ddlService.lotteryChannelDDL({
                            regionId: 2
                        }),
                        activityService.getListSubAgency(),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            totalScratchcard: res[1],
                            listLotteryDDL: res[2],
                            listSubAgency: res[3]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chia vé cào cho đại lý con'
    };

    routes.activity.manageStaffDebt = {
        url: '/manageStaffDebt?salePointId&userTitleId',
        params: {
            userTitleId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manageStaffDebt.html' + versionTemplate,
        controller: 'Activity.manageStaffDebt as $vm',
        resolve: {
            viewModel: ['$q', '$rootScope', '$stateParams', 'userService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $rootScope, $stateParams, userService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.userTitleId = params.userTitleId ? params.userTitleId : 5
                    $q.all([
                        activityService.getDebtOfStaff({ UserTitleId: params.userTitleId })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },

        title: 'Quản lý nợ nhân viên'
    };
    routes.activity.staticFee = {
        url: '/staticFee?month',
        params: {
            month: {
                value: '',
                squash: true
            },
            date: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'staticFee.html' + versionTemplate,
        controller: 'Activity.staticFee as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService', 'activityService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    params.date = params.date == '' ? moment().format('YYYY-MM-DD') : params.date;
                    $q.all([
                        ddlService.salePointDDL(),
                        reportService.getListUnsoldLotteryTicket({ month: params.month }),
                        activityService.getStaticFee({ month: params.date })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listUnsoldLotteryTicket: res[1],
                            listStaticFee: res[2]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chi phí cố định'
    };

})();