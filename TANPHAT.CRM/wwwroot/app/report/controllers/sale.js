(function () {
    app.controller('Report.sale', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'activityService', 'dayOfWeekVN', '$uibModal', '$q',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, activityService, dayOfWeekVN, $uibModal, $q) {
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
            vm.month = moment().format('YYYY-MM')
            $scope.listSalePoint = vm.listSalePoint
            vm.selectedSalePoint = 1;
            vm.selectedSalePointName = "";
            vm.loiNhuanThang = "";
            // New version
            var chiTieu = [
                {
                    mainChiTieuId: 1,
                    name: "Tổng vé bán lẻ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng vé sỉ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng cào TP lẻ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng cào TP sỉ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng cào ĐN lẻ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng cào ĐN sỉ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng bóc lẻ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng XO-5K lẻ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng XO-2K lẻ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng XO-5K sỉ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng XO-2K sỉ",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Ôm ế",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Hoàn vé",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "3 số đặc biệt",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "4 số đặc biệt",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Hoa hồng số trúng trang tính",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 1,
                    name: "Tổng lãi truyền thống",
                    soLuong: 0,
                    thanhTien: 0,
                    isTotal: true
                },
                {
                    mainChiTieuId: 2,
                    name: "Hoa hồng 5.5%",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 2,
                    name: "Hoa hồng 1.5%",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 2,
                    name: "Hoa hồng trả thưởng 0.2%",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 2,
                    name: "Thuế TNCN 5%",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 2,
                    name: "Tiền bảo hiểm Vietlott",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 2,
                    name: "Tổng lãi Vietlott",
                    soLuong: 0,
                    thanhTien: 0,
                    isTotal: true
                },
                {
                    mainChiTieuId: 3,
                    name: "Doanh thu",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 3,
                    name: "Trả thưởng",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 3,
                    name: "Tổng lãi lotto",
                    soLuong: 0,
                    thanhTien: 0,
                    isTotal: true
                },
                {
                    mainChiTieuId: 4,
                    name: "Tiền mặt bằng",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Tiền điện",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Tiền nước",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Tiền internet",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Lương nhân viên",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Lương quản lý điểm",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Lương nhân sự",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Lương Trâm chia vé, kiếm tiền",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Tiền công cụ trang tính",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Tiền quỹ hệ thống",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Chi phí cúng",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Chi phí hoàn vốn đầu tư",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Chi phí",
                    soLuong: 0,
                    thanhTien: 0
                },
                {
                    mainChiTieuId: 4,
                    name: "Tổng chi",
                    soLuong: 0,
                    thanhTien: 0,
                    isTotal: true
                },
                {
                    mainChiTieuId: 5,
                    name: "",
                    soLuong: 0,
                    thanhTien: 0,
                    isTotal: true
                },

            ]
            $scope.chiTieu = chiTieu;
            $scope.selectedSalePointName = vm.selectedSalePointName;
            $scope.selectedSalePointName.selected = vm.listSalePoint[0];
            //func

            vm.getDoanhThuSalePoint = function () {
                var deferred = $q.defer();
                $q.all([
                    reportService.getSaleOfSalePointInMonth({ month: vm.month })
                ]).then(function (res) {
                    deferred.resolve(res);
                });
                return deferred.promise;
            }

            vm.onClickDoanhThu = function () {
                vm.getDoanhThuSalePoint().then(function (res) {
                    var dataReturn = res[0][vm.selectedSalePoint - 1];
                    console.log(dataReturn)
                    var jsonData = JSON.parse(dataReturn.DataSale)
                    //set values
                    vm.selectedSalePointName = jsonData.SalePointName
                    vm.loiNhuanThang = vm.month

                    // Thường lẻ
                    chiTieu[0].soLuong = jsonData.TotalRetail
                    chiTieu[0].thanhTien = jsonData.TotalRetailMoney

                    // Thường sỉ
                    chiTieu[1].soLuong = jsonData.TotalWholesale
                    chiTieu[1].thanhTien = jsonData.TotalWholesaleMoney

                    // Cào TP lẻ
                    chiTieu[2].soLuong = jsonData.TotalScratchRetailOfCity
                    chiTieu[2].thanhTien = jsonData.TotalRetailMoneyRetailOfCity

                    // Cào TP sỉ
                    chiTieu[3].soLuong = jsonData.TotalScratchWholesaleOfCity
                    chiTieu[3].thanhTien = jsonData.TotalWholesaleMoneyOfCity

                    // Cào TP sỉ
                    chiTieu[3].soLuong = jsonData.TotalScratchWholesaleOfCity
                    chiTieu[3].thanhTien = jsonData.TotalWholesaleMoneyOfCity

                    // Cào ĐN lẻ
                    chiTieu[4].soLuong = jsonData.TotalScratchRetailOfCaMau
                    chiTieu[4].thanhTien = jsonData.TotalRetailMoneyRetailOfCaMau

                    // Cào ĐN sỉ
                    chiTieu[5].soLuong = jsonData.TotalScratchWholesaleOfCaMau
                    chiTieu[5].thanhTien = jsonData.TotalScratchWholesaleOfCaMau

                    // Bóc lẻ
                    chiTieu[6].soLuong = jsonData.TotalOfBocLe
                    chiTieu[6].thanhTien = jsonData.TotalRetailMoneyBocLe

                    // XO 5K lẻ
                    chiTieu[7].soLuong = jsonData.TotalOfXo5K
                    chiTieu[7].thanhTien = jsonData.TotalRetailMoneyXo5K

                    // Cào 2K lẻ
                    chiTieu[8].soLuong = jsonData.TotalOfXo2K
                    chiTieu[8].thanhTien = jsonData.TotalRetailMoneyXo2K

                    // XO 5K sỉ
                    chiTieu[9].soLuong = 0
                    chiTieu[9].thanhTien = 0

                    // Cào 2K sỉ
                    chiTieu[10].soLuong = 0
                    chiTieu[10].thanhTien = 0

                    // Ôm ế
                    chiTieu[11].soLuong = jsonData.TongOmE
                    chiTieu[11].thanhTien = jsonData.TongOmEThanhTien

                    // Hoàn vé
                    chiTieu[12].soLuong = jsonData.TwoSpecial
                    chiTieu[12].thanhTien = jsonData.TwoSpecialPrice

                    // 3 số đặc biệt
                    chiTieu[13].soLuong = jsonData.ThreeSpecial
                    chiTieu[13].thanhTien = jsonData.ThreeSpecialPrice

                    // 4 số đặc biệt
                    chiTieu[14].soLuong = jsonData.FourSpecial
                    chiTieu[14].thanhTien = jsonData.FourSpecialPrice

                    // Hoa hồng đổi số trúng
                    chiTieu[15].soLuong = 0
                    chiTieu[15].thanhTien = jsonData.TotalCommission

                    // Tổng lãi truyền thống
                    chiTieu[16].soLuong = 0
                    chiTieu[16].thanhTien = chiTieu[0].thanhTien + chiTieu[1].thanhTien + chiTieu[2].thanhTien
                        + chiTieu[3].thanhTien + chiTieu[4].thanhTien + chiTieu[5].thanhTien
                        + chiTieu[6].thanhTien + chiTieu[7].thanhTien + chiTieu[8].thanhTien
                        + chiTieu[9].thanhTien + chiTieu[10].thanhTien - chiTieu[11].thanhTien
                        - chiTieu[12].thanhTien - chiTieu[13].thanhTien - chiTieu[14].thanhTien
                        + chiTieu[15].thanhTien

                    // Hoa hồng 5.5%
                    chiTieu[17].soLuong = 0
                    chiTieu[17].thanhTien = jsonData.HoaHong5_5

                    // Hoa hồng 1.5%
                    chiTieu[18].soLuong = 0
                    chiTieu[18].thanhTien = jsonData.HoaHong1_5

                    // Hoa hồng trả thưởng 0.2%
                    chiTieu[19].soLuong = 0
                    chiTieu[19].thanhTien = jsonData.HoaHong0_2

                    // Thuế TNCN
                    chiTieu[20].soLuong = 0
                    chiTieu[20].thanhTien = jsonData.ThueTNCN

                    // Tiền bảo hiểm Vietlott
                    chiTieu[21].soLuong = 0
                    chiTieu[21].thanhTien = 0

                    // Tổng lãi Vietlott
                    chiTieu[22].soLuong = 0
                    chiTieu[22].thanhTien = chiTieu[17].thanhTien + chiTieu[18].thanhTien + chiTieu[19].thanhTien - chiTieu[20].thanhTien - chiTieu[21].thanhTien

                    // Doanh thu Lotto
                    chiTieu[23].soLuong = 0
                    chiTieu[23].thanhTien = jsonData.SaleOfLoto

                    // Trả thưởng Lotto
                    chiTieu[24].soLuong = jsonData.Loto
                    chiTieu[24].thanhTien = jsonData.LotoPrice

                    // Tổng lãi Lotto
                    chiTieu[25].soLuong = 0
                    chiTieu[25].thanhTien = chiTieu[23].thanhTien - chiTieu[24].thanhTien

                    // Tiền mặt bằng
                    chiTieu[26].soLuong = 0
                    chiTieu[26].thanhTien = jsonData.StaticFee.EstateFee

                    // Tiền điện
                    chiTieu[27].soLuong = 0
                    chiTieu[27].thanhTien = jsonData.StaticFee.ElectronicFee

                    // Tiền nước
                    chiTieu[28].soLuong = 0
                    chiTieu[28].thanhTien = jsonData.StaticFee.WaterFee

                    // Tiền Internet
                    chiTieu[29].soLuong = 0
                    chiTieu[29].thanhTien = jsonData.StaticFee.InternetFee

                    // Lương nhân viên
                    chiTieu[30].soLuong = 0
                    chiTieu[30].thanhTien = jsonData.TotalAllSalary

                    // Lương quản lý điểm
                    chiTieu[31].soLuong = 0
                    chiTieu[31].thanhTien = jsonData.ManagerSalary

                    // Lương nhân sự
                    chiTieu[32].soLuong = 0
                    chiTieu[32].thanhTien = jsonData.HRSalary

                    // Lương Trâm chia vé
                    chiTieu[33].soLuong = 0
                    chiTieu[33].thanhTien = jsonData.DistributorSalary

                    // Tiền công cụ trang tính	
                    chiTieu[34].soLuong = 0
                    chiTieu[34].thanhTien = 0

                    // Tiền quỹ hệ thống	
                    chiTieu[35].soLuong = 0
                    chiTieu[35].thanhTien = 0

                    // Chi phí cúng
                    chiTieu[36].soLuong = 0
                    chiTieu[36].thanhTien = 0

                    // Chi phí hoàn vốn đầu tư
                    chiTieu[37].soLuong = 0
                    chiTieu[37].thanhTien = 0

                    // Chi phí
                    chiTieu[38].soLuong = 0
                    chiTieu[38].thanhTien = 0

                    // Tổng chi
                    chiTieu[39].soLuong = 0
                    chiTieu[39].thanhTien = chiTieu[26].thanhTien + chiTieu[27].thanhTien + chiTieu[28].thanhTien
                        + chiTieu[29].thanhTien + chiTieu[30].thanhTien + chiTieu[31].thanhTien + chiTieu[32].thanhTien
                        + chiTieu[33].thanhTien + chiTieu[34].thanhTien + chiTieu[35].thanhTien + chiTieu[36].thanhTien
                        + chiTieu[37].thanhTien + chiTieu[38].thanhTien

                    // Tổng cộng
                    chiTieu[40].soLuong = 0
                    chiTieu[40].thanhTien = chiTieu[16].thanhTien + chiTieu[22].thanhTien + chiTieu[25].thanhTien - chiTieu[39].thanhTien
                })
            }

            vm.loadData = function () {
                vm.month = moment(vm.month).format('YYYY-MM');
                //$state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.clickMonth = function (month) {
                vm.month = moment().add(month, 'month').format('YYYY-MM');
            }

            vm.init = function () {
                vm.onClickDoanhThu();
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