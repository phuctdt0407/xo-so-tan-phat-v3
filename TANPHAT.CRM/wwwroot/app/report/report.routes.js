(function () {
    var viewPath = baseAppPath + '/report/views/';

    routes.report = {
        url: '/report',
        abstract: true,
        template: '<ui-view></ui-view>'
    };

    routes.report.hardWorking = {
        url: '/hardWorking?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'hardWorking.html' + versionTemplate,
        controller: 'Report.hardWorking as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        reportService.getTotalShiftOfUserBySalePointInMonth({ month: params.month }) ,
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 }),
                    ]).then(function (res) {
                        var result = {
                            listTotalShift: res[0],
                            listSalePoint: res[1],
                            listStaff: res[2],
                            params: params
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chuyên cần'
    };

    routes.report.dividedLottery = {
        url: '/dividedLottery?month&salePointId',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'dividedLottery.html' + versionTemplate,
        controller: 'Report.dividedLottery as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        ddlService.salePointDDL(),
                        reportService.getDataInventoryInMonthOfAllSalePoint({ month: params.month }),
                        reportService.getDataInventoryInDayOfAllSalePoint({ month: params.month, salePointId: 0 })
                       
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listData: res[1],
                            listDetail: res[2]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Số lượng vé chia'
    };

    routes.report.soldLottery = {
        url: '/soldLottery?month&userid&lotteryTypeId',
        params: {
            month: {
                value: '',
                squash: true
            },
            /*userid: {
                value: 0,
                squash: true
            },
            lotteryTypeId: {
                value: 0,
                squash: true
            }*/
        },
        templateUrl: viewPath + 'soldLottery.html' + versionTemplate,
        controller: 'Report.soldLottery as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'reportService', 'activityService', 'ddlService', 'salepointService',
                function ($q, $stateParams, reportService, activityService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        reportService.getTotalLotterySellOfUserToCurrentInMonth({ month: params.month, userid: params.userid, lotteryTypeId: params.lotteryTypeId }),
                        ddlService.userByTitleDDL({ userTitleId: 5 }),
                        reportService.getAverageLotterySellOfUser({ month: params.month, userid: params.userid, lotteryTypeId: params.lotteryTypeId }),
                        salepointService.getListSalePoint()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listStaff: res[1],
                            listEx: res[2],
                            listSalePoint: res[3]
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Số lượng vé bán'
    };    

    routes.report.detailSalePoint = {
        url: '/detailSalePoint?month&salePointId',
        params: {
            month: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'detailSalePoint.html' + versionTemplate,
        controller: 'Report.detailSalePoint as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'activityService', 'reportService', 'ddlService',
                function ($q, $stateParams, activityService, reportService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        reportService.getTotalShiftOfUserBySalePointInMonth(params ),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 }),
                    ]).then(function (res) {
                        var result = {
                            listTotalShift: res[0],
                            listSalePoint: res[1],
                            listStaff: res[2],
                            params: params
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chi tiết điểm bán'
    };

    routes.report.returnLottery = {
        url: '/returnLottery?month&salePointId',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'returnLottery.html' + versionTemplate,
        controller: 'Report.returnLottery as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    params.isActive = true;
                    $q.all([
                        reportService.getTotalLotteryReturnOfAllSalePointInMonth({ month: params.month, salePointId: params.salePointId }),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 }),
                    ]).then(function (res) {
                        var result = {
                            listReturnLottery: res[0],
                            listSalePoint: res[1],
                            params: params
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Số lượng vé hoàn'
    };

    routes.report.receiveLottery = {
        url: '/receiveLottery?month&salePointId',
        params: {
            month: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'receiveLottery.html' + versionTemplate,
        controller: 'Report.receiveLottery as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    params.isActive = true;
                    $q.all([

                        ddlService.agencyDDL(),
                        reportService.getTotalLotteryReceiveOfAllAgencyInMonth({ month: params.month }),
                    ]).then(function (res) {
                        var result = {
                            listAgency: res[0],
                            listData: res[1],
                            params: params
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Số lượng vé nhận'
    };

    routes.report.remainingLottery = {
        url: '/remainingLottery',
        templateUrl: viewPath + 'remainingLottery.html' + versionTemplate,
        controller: 'Report.remainingLottery as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService) {
                    var deferred = $q.defer();

                    $q.all([
                        reportService.getTotalRemainingOfAllSalePointInDate(),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 }),
                    ]).then(function (res) {
                        var result = {
                            listRemainLottery: res[0],
                            listSalePoint: res[1],
                        };

                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Số lượng còn lại'
    };

    routes.report.reportSalePoint = {
        url: '/reportSalePoint?day&salePointId',
        params: {
            day: {
                value: '',
                squash: true,
            },
            salePointId: {
                value: '1',
                squash: true,
            },
        },
        templateUrl: viewPath + 'reportSalePoint.html' + versionTemplate,
        controller: 'Report.reportSalePoint as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', '$rootScope', 'activityService',
                function ($q, $stateParams, userService, reportService, ddlService, $rootScope, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;
                    params.salePointId = params.salePointId == '' ? 1 : params.salePointId;
                    
                    $q.all([
                        reportService.getReportManagerOverall({ lotteryDate: params.day, salePointId: params.salePointId, userRoleId: $rootScope.sessionInfo.UserRoleId }),
                        ddlService.salePointDDL(),
                        reportService.reportLotteryInADay({
                            SalePointId : params.salePointId,
                            Date : params.day,
                            ShiftId : 0
                        }),
                        ddlService.lotteryChannelDDL({
                            regionId:2
                        })
                    
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listReportSalePoint: res[0],
                            listSalePoint: res[1],
                            lotteryData:res[2],
                            lotteryChannels:res[3]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Báo cáo điểm bán hằng ngày'
    };

    routes.report.lotteryTransport = {
        url: '/lotteryTransport?day',
        params: {
            day: {
                value: '',
                squash: true,
            },
        },
        templateUrl: viewPath + 'lotteryTransport.html' + versionTemplate,
        controller: 'Report.lotteryTransport as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 
                function ($q, $stateParams, userService, reportService, ddlService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.day = params.day == '' ? moment().format('YYYY-MM-DD') : params.day;

                    $q.all([
                        reportService.getTotalLotteryNotSellOfAllSalePoint({ lotteryDate: params.day }),
                        ddlService.salePointDDL(),
                        ddlService.userByTitleDDL({ userTitleId: 5 }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            lotteryTransport: res[0],
                            listSalePoint: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Trả ế'
    };

    routes.report.detailDividedLottery = {
        url: '/detailDividedLottery?date&salePointId',
        params: {
            date: {
                value: '',
                squash: true,
            },
            salePointId: {
                value: '0',
                squash: true
            },
            
        },
        templateUrl: viewPath + 'detailDividedLottery.html' + versionTemplate,
        controller: 'Report.detailDividedLottery as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.date = params.date == '' ? moment().format('YYYY-MM-DD') : params.date;
                    /*params.date = "2022-05-30";*/
                    $q.all([
                        reportService.getLogDistributeForSalepoint({ date: params.date, salePointId: params.salePointId }),
                        ddlService.salePointDDL(),
                        
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listSalePoint: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch sử chia vé'
    };

    routes.report.historyActivity = {
        url: '/historyActivity?date&salePointId&shiftId',
        params: {
            date: {
                value: '',
                squash: true,
            },
            salePointId: {
                value: '1',
                squash: true
            },
            shiftId: {
                value: '1',
                squash: true
            },

        },
        templateUrl: viewPath + 'historyActivity.html' + versionTemplate,
        controller: 'Report.historyActivity as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService, activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.date = params.date == '' ? moment().format('YYYY-MM-DD') : params.date;

                    $q.all([
                        reportService.getLogDistributeForSalepoint({ date: params.date, salePointId: params.salePointId }),
                        ddlService.salePointDDL(),
                        reportService.getListForUpdate({ date: params.date, salepointId: params.salePointId, shiftId: params.shiftId }),
                        ddlService.lotteryPriceDDL(),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listSalePoint: res[1],
                            listSaleUpdate: res[2],
                            listTypeSelect: res[3],

                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Lịch sử hoạt động'
    };

    routes.report.manageItem = {
        url: '/manageItem?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'manageItem.html' + versionTemplate,
        controller: 'Report.manageItem as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;


                    $q.all([
                        reportService.getTotalLotteryNotSellOfAllSalePoint({ lotteryDate: params.day }),
                        ddlService.salePointDDL(),
                        reportService.getFullTotalItemInMonth({ month: params.month }),
                        ddlService.getItemDDL(),
                        ddlService.getTypeOfItemDDL()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            lotteryTransport: res[0],
                            listSalePoint: res[1],
                            listData: res[2],
                            listItem: res[3],
                            typeOfItem: res[4]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quản lý dụng cụ'
    };

    routes.report.lotterySaleInMonth = {
        url: '/lotterySaleInMonth?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'lotterySaleInMonth.html' + versionTemplate,
        controller: 'Report.lotterySaleInMonth as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService',
                function ($q, $stateParams, userService, reportService, ddlService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;

                    $q.all([
                        reportService.getTotalLotteryNotSellOfAllSalePoint({ lotteryDate: params.day }),
                        ddlService.salePointDDL(),
                        reportService.getLotterySellInMonth({ month: params.month }),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[1],
                            listData: res[2],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Doanh số điểm bán'
    };

    routes.report.confirmTransferItem = {
        url: '/confirmTransferItem?month&salePointId',
        params: {
            month: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '',
                squash: true
            },
            
        },
        templateUrl: viewPath + 'confirmTransferItem.html' + versionTemplate,
        controller: 'Report.confirmTransferItem as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService','salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;

                    $q.all([
                        ddlService.salePointDDL(),
                        salepointService.getListItemConfirm({ salePointId: params.salePointId, month: params.month, })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listData: res[1],

                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Chuyển nhận dụng cụ'
    };

    routes.report.salary = {
        url: '/salary?month&userId',
        params: {
            month: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'salary.html' + versionTemplate,
        controller: 'Report.salary as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService','$rootScope',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService,$rootScope) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                 
                    if($rootScope.sessionInfo.UserTitleId ==5){
                        params.userId = $rootScope.sessionInfo.UserId
                    }
                    

                    $q.all([
                        userService.getListSalary(params)
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
        title: 'Lương nhân viên'
    };

    routes.report.sale = {
        url: '/sale?month',
        params: {
            month: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'sale.html' + versionTemplate,
        controller: 'Report.sale as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;

                    $q.all([
                        reportService.getSaleOfSalePointInMonth(params),
                        salepointService.getListSalePoint()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listSalePoint: res[1]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Doanh thu'
    };

    routes.report.compare = {
        url: '/compare?month',
        params: {
            month: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'compare.html' + versionTemplate,
        controller: 'Report.compare as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;

                    $q.all([
                        salepointService.getListSaleOfVietLottInMonth(params),
                        ddlService.salePointDDL(),
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listSalePoint: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Đối chiếu Vietlott'
    };

    routes.report.feeOutside = {
        url: '/feeOutside?month',
        params: {
            month: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'feeOutside.html' + versionTemplate,
        controller: 'Report.feeOutside as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService','$rootScope',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService, $rootScope) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;

                    $q.all([
                        salepointService.getListFeeOutSiteInMonth({
                            month: params.month,
                            userId: $rootScope.sessionInfo.UserId
                        }),
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
        title: 'Chi phí ngoài'
    };
    routes.report.reportSaleLotoAndVietllot = {
        url: '/reportSaleLotoAndVietllot?month&salePointId&transactionType',
        params: {
            month: {
                value: '',
                squash: true
            },
            salePointId: {
                value: '',
                squash: true
            },
            transactionType: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'reportSaleLotoAndVietllot.html' + versionTemplate,
        controller: 'Report.reportSaleLotoAndVietllot as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    params.transactionType = params.transactionType ? params.transactionType : 3;
                    params.salePointId = params.salePointId ? params.salePointId : 0;

                    $q.all([
                        salepointService.getListSaleOfLotoInMonth(params),
                        ddlService.salePointDDL(),

                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listData: res[0],
                            listSalePoint: res[1]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Doanh thu Loto và Vietlott'
    };

    routes.report.salaryFund = {
        url: '/salaryFund?year',
        params: {
            year: {
                value: '',
                squash: true
            },
        },
        templateUrl: viewPath + 'salaryFund.html' + versionTemplate,
        controller: 'Report.salaryFund as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.year = params.year == '' ? moment().format('YYYY') : params.year;

                    $q.all([
                        userService.getListFundInYear({ year: params.year})
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listFundInYear: res[0]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quỹ lương nhân viên'
    };

    routes.report.unionFund = {
        url: '/unionFund?year&tab',
        params: {
            year: {
                value: '',
                squash: true
            },
            tab: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'unionFund.html' + versionTemplate,
        controller: 'Report.unionFund as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.year = params.year == '' ? moment().format('YYYY') : params.year;

                    $q.all([
                        salepointService.getListUnionInYear({ year: params.year })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listUnionInYear: res[0]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Quỹ công đoàn'
    };


    routes.report.winningReport = {
        url: '/winningReport?date',
        params: {
            date: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'winningReport.html' + versionTemplate,
        controller: 'Report.winningReport as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.date = params.date == '' ? moment().format('YYYY-MM-DD') : params.date;

                    $q.all([
                        ddlService.salePointDDL(),
                        salepointService.getListLotteryAwardExpected({ date: params.date }),
                        ddlService.lotteryChannelDDL({
                            regionId: 2,
                            lotteryDate: params.date
                        }),
                        ddlService.reportWinningTypeDDL()
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listWinning: res[1],
                            listChannel: res[2],
                            listWinningType: res[3]
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Báo cáo trúng thưởng'
    };

   /* routes.report.sendAndReceive = {
        url: '/sendAndReceive?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'sendAndReceive.html' + versionTemplate,
        controller: 'Report.sendAndReceive as $vm',
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
        title: 'Báo cáo chuyển nhận'
    };*/



    routes.report.reportReturnMoney = {
        url: '/reportReturnMoney?Date',
        params: {
            Date: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'reportReturnMoney.html' + versionTemplate,
        controller: 'Report.reportReturnMoney as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService','activityService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService,activityService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.Date = params.Date == ''||params.Date==undefined ? moment().format('YYYY-MM-DD') : params.Date;
                    $q.all([
                        ddlService.salePointDDL(),
                        activityService.getListReportMoneyInADay({Date:params.Date})
                        
                    ]).then(function (res) {
                        console.log("res",res[1])
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listReturnMoney: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Báo cáo tiền nộp về'
    };

    routes.report.agencyReport = {
        url: '/agencyReport?month&agencyId&agencyName',
        params: {
            month: {
                value: '',
                squash: true
            },
            agencyId: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'agencyReport.html' + versionTemplate,
        controller: 'Report.agencyReport as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService,) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' || params.month == undefined ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        ddlService.salePointDDL(),

                        reportService.totalLotteryReceiveOfAllAgencyInDay(params)

                    ]).then(function (res) {
                        console.log("res",res[1])
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listTotalLottery: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Báo cáo vé nhận đại lý'
    };

    routes.report.keepLottery = {
        url: '/keepLottery?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'keepLottery.html' + versionTemplate,
        controller: 'Report.keepLottery as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        ddlService.salePointDDL(),
                        reportService.getListUnsoldLotteryTicket({ month: params.month })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listUnsoldLotteryTicket: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Báo cáo ôm ế'
    };


    routes.report.lotteryOfManager = {
        url: '/lotteryOfManager?month',
        params: {
            month: {
                value: '',
                squash: true
            }
        },
        templateUrl: viewPath + 'lotteryOfManager.html' + versionTemplate,
        controller: 'Report.lotteryOfManager as $vm',
        resolve: {
            viewModel: ['$q', '$stateParams', 'userService', 'reportService', 'ddlService', 'salepointService',
                function ($q, $stateParams, userService, reportService, ddlService, salepointService) {
                    var deferred = $q.defer();
                    var params = angular.copy($stateParams);
                    params.month = params.month == '' ? moment().format('YYYY-MM') : params.month;
                    $q.all([
                        ddlService.salePointDDL(),
                        reportService.getListTotalNumberOfTicketsOfEachManager({ month: params.month })
                    ]).then(function (res) {
                        var result = {
                            params: params,
                            listSalePoint: res[0],
                            listTotalNumberOfTicketsOfEachManager: res[1],
                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Báo cáo tổng số vé của quản lý'
    };

})();