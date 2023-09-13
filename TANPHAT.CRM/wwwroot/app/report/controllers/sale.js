(function () {
    app.controller('Report.sale', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.checkShowTableSalary = false;
            vm.checkShowReward = false;
            vm.checkShowStaticFee = false;

            vm.listTitle = [
                { TitleId: 1, Name: 'Lương thực lãnh' },
                { TitleId: 2, Name: 'Tổng lương tháng' },
                { TitleId: 3, Name: 'Doanh số cá nhân' },
                { TitleId: 4, Name: 'Lương' },
                { TitleId: 5, Name: 'Lương cơ bản' },
                { TitleId: 6, Name: 'Lương ca và số ngày công' },
                { TitleId: 7, Name: 'KPI' },
                { TitleId: 8, Name: 'Tiền cơm' },
                { TitleId: 9, Name: 'Thưởng doanh số' },
                { TitleId: 10, Name: 'Thu nhập khác và chí phí khác' },
            ]

            vm.listDisplay = [
                { Name: 'Vé bán', DisplayName: 'TotalRetailMoney', colorCss: "blue-color", colorType: "+"},
                { Name: 'Vé bán sỉ', DisplayName: 'TotalWholesaleMoney', colorCss: "blue-color", colorType: "+"},
                { Name: 'Vé cào', DisplayName: 'TotalScratchRetailMoney', colorCss: "blue-color", colorType: "+"},
                { Name: 'Vé cào sỉ', DisplayName: 'TotalScratchWholesaleMoney', colorCss: "blue-color", colorType: "+"},
                /*{ Name: '2 số cuối', DisplayName: 'TwoSpecial', colorCss: "red-color", colorType: "-"},
                { Name: '3 số cuối', DisplayName: 'ThreeSpecial', colorCss: "red-color", colorType: "-"},
                { Name: '4 số cuối', DisplayName: 'FourSpecial', colorCss: "red-color", colorType: "-"},*/
                { Name: 'Trả thưởng', DisplayName: 'Prize', colorCss: "red-color", colorType: "-"},
                { Name: 'ÔM Ế', DisplayName: 'TotalRemaining', colorCss: "red-color", colorType: "-"},
                { Name: 'Chi phí', DisplayName: 'TotalFee', colorCss: "red-color", colorType: "-"},
                { Name: 'Chi phí cố định', DisplayName: 'StaticFee', colorCss: "red-color", colorType: "-"},
                { Name: 'Loto', DisplayName: 'SaleOfLoto', colorCss: "blue-color", colorType: "+" },
                { Name: 'Vietlott', DisplayName: 'SaleOfVietlott', colorCss: "blue-color", colorType: "+" },
                { Name: 'Hoa hồng', DisplayName: 'TotalCommission', colorCss: "blue-color", colorType: "+" },
                { Name: 'Nạp Vietllot', DisplayName: 'ToUpVietlott', colorCss: "red-color", colorType: "-" },
                { Name: 'Lương NV', DisplayName: 'TotalSalary', colorCss: "red-color", colorType: "-" },
                { Name: 'tiền nhập vé', DisplayName: 'TotalMoneyFromAgency', colorCss: "red-color", colorType: "-" },
                { Name: 'LN trước phí', DisplayName: 'Profit', BgCss: "yellow-bg ", Css: "red-color " },
                { Name: 'LN sau phí', DisplayName: 'TotalSale', BgCss: "yellow-bg", Css: "red-color " },
               
            ]

            //declare

            vm.listMonth = [];
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.month = vm.params.month
            //func

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.clickMonth = function (month) {
                vm.month = moment().add(month, 'month').format('YYYY-MM');
                vm.loadData();
            }

            vm.init = function () {
                // INIT MONTH
                var { startDate, endDate } = getDayFunction(vm.params.month);

                while (moment(startDate) <= moment(endDate)) {
                    vm.listMonth.push({
                        Date: startDate,
                        DateName: vm.dayOfWeekVN[moment(startDate).day()].SName,
                        IsWeekEnd: moment(startDate).day() == 0,
                        DataInfo: [],
                    })
                    startDate = moment(startDate, "YYYY-MM-DD").add(1, 'day').format("YYYY-MM-DD");
                }

                vm.listData.forEach(function (item) {
                  
                    item.Data = JSON.parse(item.DataSale)
                    var total = 0;
                    var totalPercent = 0;
                    item.DataPercent = [{
                        "FullName":"A. Phi",
                        "Sale": Math.round(item.Data.TotalSale),
                        "Percent":100
                    }]
                    var data = item.DataSalePercent!=undefined?JSON.parse(item.DataSalePercent):[]
                    
                    if (data && data.length > 0) {
                        data.forEach(function (percent) {
                            percent.Percent =  percent.Percent*100
                            percent.Sale = Math.round(percent.Sale)
                            total += percent.Sale
                            totalPercent+=percent.Percent;
                            item.DataPercent.push(percent)
                        })
                    }
                    item.DataPercent[0].Sale = item.DataPercent[0].Sale - total
                    item.DataPercent[0].Percent = item.DataPercent[0].Percent - totalPercent
                })

                console.log('vm.listData: ', vm.listData)
            }

            vm.init();

            vm.clickCheckShow = function () {
                vm.checkShowTableSalary = !vm.checkShowTableSalary
            }

            vm.clickCheckShowReward = function () {
                vm.checkShowReward = !vm.checkShowReward
            }

            vm.clickCheckShowStaticFee = function () {
                vm.checkShowStaticFee = !vm.checkShowStaticFee
            }

            vm.showFeeDetail = function (model) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'feeDetail.html' + versionTemplate,
                    controller: 'Report.feeDetail as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService',
                            function ($q, $uibModal, userService) {
                                var deferred = $q.defer();
                                $q.all([

                                ]).then(function (res) {
                                    var result = {
                                        model: model
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    }
                });

                request.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').addClass('modal-body-rm');
                    });
                });

                request.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });

            }

        }]);
})();