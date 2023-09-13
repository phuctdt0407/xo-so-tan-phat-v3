(function () {
    app.controller('Report.salary', ['$scope', '$rootScope', '$state', 'viewModel', 'authService', 'notificationService', 'reportService', 'activityService', 'dayOfWeekVN','$uibModal',
        function ($scope, $rootScope, $state, viewModel, authService, notificationService, reportService, activityService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            
            vm.typeUser = [
                { Name: 'TC', UserTitleId: 0, isStaff: true },
                { Name: 'Nhân viên', UserTitleId: 5, isStaff: false},
                { Name: 'Trưởng nhóm', UserTitleId:4, isStaff: true},
                { Name: 'Nhân sự', UserTitleId:6, isStaff: true},
                { Name: 'Chia vé', UserTitleId: 3, isStaff: true },
            ]

            vm.listTitle = [
                { TitleId: 1, Name: 'Lương thực lãnh' },
                { TitleId: 2, Name: 'Tổng lương tháng' },
                { TitleId: 3, Name: 'Doanh số cá nhân' },
                { TitleId: 4, Name: 'Thưởng doanh số' },
                { TitleId: 5, Name: 'Lương' },
                { TitleId: 6, Name: 'Lương cơ bản' },
                { TitleId: 7, Name: 'Lương ca và số ngày công' },
                { TitleId: 8, Name: 'KPI' },
                { TitleId: 9, Name: 'Tiền cơm' },
                { TitleId: 10, Name: 'Thu nhập khác và chí phí khác' },
            ]

            vm.listDisplay = [
                { TitleId:1, Name: '', DisplayName: 'RealSalary' },
                { TitleId:2, Name: '', DisplayName: 'TotalSalary' },
                { TitleId:3, Name: 'Vietlott', DisplayName: 'SaleOfVietlott' },
                { TitleId: 3, Name: 'Loto', DisplayName: 'SaleOfLoto' },
                { TitleId:3, Name: 'VSTT', DisplayName: 'Average' },
                { TitleId:4, Name: 'VIETLOTT', DisplayName: 'VietlottLottery' },
                { TitleId:4, Name: 'DS Loto 2%', DisplayName: 'OnePercentLoto' },
                { TitleId:4, Name: 'VSTT', DisplayName: 'TraditionalLottery' },
                { TitleId:5, Name: 'Ứng lương', DisplayName: 'Advance' },
                { TitleId:5, Name: 'Lương Chính', DisplayName: 'MainSalary' },
                { TitleId:6, Name: 'Lương cơ bản', DisplayName: 'BaseSalary' },
                { TitleId:6, Name: 'Trách nhiệm vé', DisplayName: 'ReponsibilityLottery' },
                { TitleId:7, Name: 'Lương công thường', DisplayName: 'SalaryOneDate' },
                { TitleId:7, Name: 'Lương công TC', DisplayName: 'SalaryOneDateSub' },
                { TitleId:7, Name: 'Số Công thường', DisplayName: 'TotalNormal' },
                { TitleId:7, Name: 'Số Công TC', DisplayName: 'TotalSub' },
                { TitleId:7, Name: 'TC 30p', DisplayName: 'L30' },
                { TitleId:7, Name: 'TC 60p', DisplayName: 'L60' },
                { TitleId:7, Name: 'TC 90p', DisplayName: 'L90' },
                { TitleId:8, Name: 'Điểm Kpi', DisplayName: 'KPI' },
                { TitleId:8, Name: 'Hệ số Ki', DisplayName: 'KPICoafficient' },
                { TitleId:9, Name: '', DisplayName: 'PriceForLunch' },
                { TitleId:10, Name: 'HHĐST', DisplayName: 'TotalCommission' },
                { TitleId:10, Name: 'Thưởng', DisplayName: 'Award' },
                { TitleId:10, Name: 'Phạt', DisplayName: 'Punish' },
                { TitleId:10, Name: 'Trích Bảo hiểm', DisplayName: 'Insure' },
                { TitleId:10, Name: 'Công đoàn', DisplayName: 'PriceUnion' },
                { TitleId: 10, Name: 'Tổng nợ còn lại', DisplayName: 'DebtAllTime' },
                { TitleId: 10, Name: 'Nợ trả trong tháng', DisplayName: 'PayedDebt' },
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
                    item.Data = JSON.parse(item.SalaryData)
                })
                console.log("vm.listData", vm.listData)
                //INIT TITLE
                vm.listTitle.forEach(function (item) {
                    var temp = vm.listDisplay.filter(x=> x.TitleId == item.TitleId);
                    item.len = temp.length;
                });

                // INIT USER
                vm.typeUser.forEach(function (tUser) {
                    tUser.ListUser = vm.listData.filter(x => x.UserTitleId == tUser.UserTitleId);
                })

            }
         
            vm.init();

        
         
            vm.openModalConfirmSalary = function (user) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var modalConfirm = $uibModal.open({
                    templateUrl: viewPath + 'confirmSalary.html' + versionTemplate,
                    controller: 'Report.confirmSalary as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        user: user,
                                        month: vm.params.month
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });
                modalConfirm.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalConfirm.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                        console.log('data: ', data)
                        $state.reload()
                    } else {
                        console.log('data2: ', data)
                        $state.reload()
                    }
                });
            }

            vm.updateDebtInMonth = function (model, money, month) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var modalUpdateDebtInMonth = $uibModal.open({
                    params: {
                    },
                    templateUrl: viewPath + 'updateDebtInMonth.html' + versionTemplate,
                    controller: 'Report.updateDebtInMonth as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$stateParams', 'ddlService', 'reportService', 'activityService',
                            function ($q, $stateParams, ddlService, reportService, activityService) {
                                var deferred = $q.defer();
                                var params = angular.copy($stateParams);
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        data: model,
                                        money: money,
                                        month: month
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });


                modalUpdateDebtInMonth.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').css('height', '60vh')
                        $('.modal-lg').css('max-width', '950px')
                    });
                });

                modalUpdateDebtInMonth.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {

                    }
                });
            }

           
            $scope.showContent = false;
            $scope.password = '';

            $scope.checkPassword = function () {
                var temp = {
                    Account: $rootScope.sessionInfo.Email,
                    Password: vm.password,
                    MACAddress: "",
                    IPAddress: ""
                }

                authService.login(temp).then(function (checkRes) {
                    if (checkRes && checkRes.Id > 0) {
                        $scope.showContent = true;
                    }
                    else {
                        alert('Mật khẩu không đúng. Vui lòng thử lại.');

                    }
               
                });

               
            };

        }]);
})();