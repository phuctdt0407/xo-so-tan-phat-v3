(function () {
    app.config(['$urlMatcherFactoryProvider', '$stateProvider', '$urlRouterProvider', '$locationProvider',
        function ($urlMatcherFactory, $stateProvider, $urlRouterProvider, $locationProvider) {

            $urlRouterProvider.otherwise('/error/404');

            $locationProvider.html5Mode({
                enabled: true,
                requireBase: false
            });

            $urlMatcherFactory.caseInsensitive(true);
            $urlMatcherFactory.strictMode(false);

            //root 
            $stateProvider.state('root', routes.root);

            //dasboard 
            $stateProvider.state('root.home', routes.home);

            //error
            $stateProvider.state('root.error', routes.error);

            //auth
            $stateProvider.state('auth', routes.auth)
                .state('auth.login', routes.auth.login);

            //user 
            $stateProvider.state('root.user', routes.user)
                .state('root.user.manage', routes.user.manage)
                .state('root.user.schedule', routes.user.schedule)
                .state('root.user.storeShiftManage', routes.user.storeShiftManage)
                .state('root.user.workSchedule', routes.user.workSchedule)
                .state('root.user.rolePermission', routes.user.rolePermission)
                .state('root.user.checkSchedule', routes.user.checkSchedule)
                .state('root.user.checkScheduleIntern', routes.user.checkScheduleIntern)
                .state('root.user.staffSchedule', routes.user.staffSchedule)
                .state('root.user.targetTable', routes.user.targetTable)
                .state('root.user.kpi', routes.user.kpi)
                .state('root.user.holidaySchedule', routes.user.holidaySchedule)
                .state('root.user.extraPayment', routes.user.extraPayment)
                .state('root.user.manageLeaderOff', routes.user.manageLeaderOff)
                .state('root.user.createUser', routes.user.createUser);

            //activity 
            $stateProvider.state('root.activity', routes.activity)
                .state('root.activity.manage', routes.activity.manage)
                .state('root.activity.manageScratchcard', routes.activity.manageScratchcard)
                .state('root.activity.create', routes.activity.create)
                .state('root.activity.createScratchcard', routes.activity.createScratchcard)
                .state('root.activity.salesActivity', routes.activity.salesActivity)
                .state('root.activity.inventoryManage', routes.activity.inventoryManage)
                .state('root.activity.checkTransfer', routes.activity.checkTransfer)
                .state('root.activity.selectSalepoint', routes.activity.selectSalepoint)
                .state('root.activity.moveTicket', routes.activity.moveTicket)
                .state('root.activity.manageConfirm', routes.activity.manageConfirm)
                .state('root.activity.agencyPrice', routes.activity.agencyPrice)
                .state('root.activity.returnAgency', routes.activity.returnAgency)
                .state('root.activity.managePayment', routes.activity.managePayment)
                .state('root.activity.purchaseHistory', routes.activity.purchaseHistory)
                .state('root.activity.ownDebtManage', routes.activity.ownDebtManage)
                .state('root.activity.requestOwnDebt', routes.activity.requestOwnDebt)
                .state('root.activity.moneyVietlott', routes.activity.moneyVietlott)
                .state('root.activity.groupLotteryManage', routes.activity.groupLotteryManage)
                .state('root.activity.groupMoneyManage', routes.activity.groupMoneyManage)
                .state('root.activity.historyBill', routes.activity.historyBill)
                .state('root.activity.otherCosts', routes.activity.otherCosts)
                .state('root.activity.otherCostsHistory', routes.activity.otherCostsHistory)
                .state('root.activity.scratchCardLog', routes.activity.scratchCardLog)
                .state('root.activity.scratchCardFullLog', routes.activity.scratchCardFullLog)
                .state('root.activity.activityLog', routes.activity.activityLog)
                .state('root.activity.distributeForSubAgency', routes.activity.distributeForSubAgency)
                .state('root.activity.sendAndReceive', routes.activity.sendAndReceive)
                .state('root.activity.subAgencyPrice', routes.activity.subAgencyPrice)
                .state('root.activity.manageScratchcardForSubAgency', routes.activity.manageScratchcardForSubAgency)
                .state('root.activity.manageStaffDebt', routes.activity.manageStaffDebt)
                .state('root.activity.staticFee', routes.activity.staticFee);
            //report 
            $stateProvider.state('root.report', routes.report)
                .state('root.report.hardWorking', routes.report.hardWorking)
                .state('root.report.dividedLottery', routes.report.dividedLottery)
                .state('root.report.soldLottery', routes.report.soldLottery)
                .state('root.report.detailSalePoint', routes.report.detailSalePoint)
                .state('root.report.receiveLottery', routes.report.receiveLottery)
                .state('root.report.returnLottery', routes.report.returnLottery)
                .state('root.report.remainingLottery', routes.report.remainingLottery)
                .state('root.report.reportSalePoint', routes.report.reportSalePoint)
                .state('root.report.lotteryTransport', routes.report.lotteryTransport)
                .state('root.report.detailDividedLottery', routes.report.detailDividedLottery)
                .state('root.report.historyActivity', routes.report.historyActivity)
                .state('root.report.manageItem', routes.report.manageItem)
                .state('root.report.lotterySaleInMonth', routes.report.lotterySaleInMonth)
                .state('root.report.confirmTransferItem', routes.report.confirmTransferItem)
                .state('root.report.salary', routes.report.salary)
                .state('root.report.sale', routes.report.sale)
                .state('root.report.feeOutside', routes.report.feeOutside)
                .state('root.report.reportSaleLotoAndVietllot', routes.report.reportSaleLotoAndVietllot)
                .state('root.report.compare', routes.report.compare)
                .state('root.report.salaryFund', routes.report.salaryFund)
                .state('root.report.unionFund', routes.report.unionFund)
                .state('root.report.winningReport', routes.report.winningReport)
                .state('root.report.reportReturnMoney', routes.report.reportReturnMoney)
                .state('root.report.agencyReport', routes.report.agencyReport)
                .state('root.report.keepLottery', routes.report.keepLottery)
                .state('root.report.lotteryOfManager', routes.report.lotteryOfManager);


            //system
            $stateProvider.state('root.system', routes.system)
                .state('root.system.manageSalePoint', routes.system.manageSalePoint)
                .state('root.system.createSalePoint', routes.system.createSalePoint)
                .state('root.system.manageAgency', routes.system.manageAgency)
                .state('root.system.createAgency', routes.system.createAgency);

            /*//system
            $stateProvider.state('root.saleActivity', routes.saleActivity)
                .state('root.saleActivity.selectSalePoint', routes.saleActivity.selectSalePoint);
*/
            //salepoint
            $stateProvider.state('root.salepoint', routes.salepoint)
                .state('root.salepoint.debtManage', routes.salepoint.debtManage)
                .state('root.salepoint.salePointPercent', routes.salepoint.salePointPercent)
                .state('root.salepoint.guestManage', routes.salepoint.guestManage)
                .state('root.salepoint.commissionWinning', routes.salepoint.commissionWinning)
               
        }]);
})();
