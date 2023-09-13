(function () {
    app.controller('Activity.summary', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService','viewModel','activityService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.checkZeroVietlott = false;
            vm.checkZeroLoto = false;
            vm.TotalReturnBK = 0;
            vm.backupVietlott = 0;
            vm.backupLoto = 0;
            let vietlott = -1;
            let loto = -1;
            vm.total = 0;
            vm.listReportLotteryForView = []
            vm.rawData = vm.listReportLottery != undefined ? vm.listReportLottery[0].Data!=null? JSON.parse(vm.listReportLottery[0].Data):[] : [];
            vm.rawData.forEach(ele=>{
                ele.LotteryTypeId = 1
                ele.LotteryChannelName = vm.listLottery.find(e=>e.Id == ele.LotteryChannelId)!=undefined?vm.listLottery.find(e=>e.Id == ele.LotteryChannelId).ShortName:""

                console.log(ele.LotteryChannelName)
                vm.listReportLotteryForView.push(ele)
               if(ele.StockDup>0 || ele.SoldRetailDup>0 || ele.RemainingDup>0){
                   var temp = angular.copy(ele)
                   temp.LotteryTypeId = 2
                   temp.Stock = temp.StockDup
                   temp.Remaining = temp.remainingDup
                   temp.SoldRetail = temp.remainingDup
                   temp.SoldRetailMoney = temp.SoldRetailMoneyDup
                   temp.SoldWholeSale = temp.SoldWholeSaleDup
                   temp.SoldWholeSaleMoney = temp.SoldWholeSaleMoneyDup
                   vm.listReportLotteryForView.push(temp)
               }
            })
            vm.editNumber1 = function () {
                vietlott = 0;
                vietlott = vm.revenue.Vietlott.replace(/,/g, '');
                vietlott = parseInt(vietlott);

                vm.total = loto > 0 ? vm.TotalReturnBK + vietlott + loto : vm.TotalReturnBK + vietlott;
            }

            vm.editNumber2 = function () {
                loto = 0;
                loto = vm.revenue.Loto.replace(/,/g, '');
                loto = parseInt(loto);

                vm.total = vietlott > 0 ? vm.TotalReturnBK + loto + vietlott : vm.TotalReturnBK + loto;
            }


            vm.changeTotalReturn1 = function (num) {

            }

            vm.changeTotalReturn2 = function (num) {

            }
            
            vm.saveData = {
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName,
                ShiftDistributeId: vm.ShiftDistributeId,
            };

            vm.totalConfirming1 = 0;
            vm.listTrans.forEach(function (item) {
                item.detail = JSON.parse(item.DetailData)
                if (item.ConfirmStatusId == 1) {
                    vm.totalConfirming1++;
                }
            })

            vm.summaryLottery = vm.dataSummary[0].LotteryData ? JSON.parse(vm.dataSummary[0].LotteryData) : []
            vm.summaryMoney = vm.dataSummary[0].MoneyData ? JSON.parse(vm.dataSummary[0].MoneyData) : null


            vm.TotalReturnBK = vm.summaryMoney.TotalSoldMoney - vm.summaryMoney.TotalGuestTransferConfirm + vm.summaryMoney.TotalTransferForGuestConfirm - vm.summaryMoney.TotalFeeOutSite - vm.summaryMoney.WinningPrice
            
            
            vm.lotterySummaryData = vm.summaryLottery.filter(x => x.LotteryDate)
            vm.scratchSummaryData = vm.summaryLottery.filter(x => !x.LotteryDate)

            vm.totalSummaryLottery = {
                TotalReceived : 0,
                TotalRemaining : 0,
                TotalRetail: 0,
                TotalReturns: 0,
                TotalRetailMoney : 0,
                TotalSold : 0,
                TotalSoldMoney: 0,
                TotalStocks : 0,
                TotalTrans : 0,
                TotalWholesale : 0,
                TotalWholesaleMoney : 0,
            }

            vm.lotterySummaryData.forEach(function (item) {
                item.DayDisplay = moment(item.LotteryDate).format('DD-MM-YYYY')
                vm.totalSummaryLottery.TotalStocks += item.TotalStocks
                vm.totalSummaryLottery.TotalTrans += item.TotalTrans
                vm.totalSummaryLottery.TotalReceived += item.TotalReceived
                vm.totalSummaryLottery.TotalReturns += item.TotalReturns
                vm.totalSummaryLottery.TotalSold += item.TotalSold
                vm.totalSummaryLottery.TotalRemaining += item.TotalRemaining
            })


            vm.getBootBox = function (confirm) {


                var message = ''
                if (!(vietlott >= 0 && loto >= 0)) {
                    vm.isSaving = false;
                    notificationService.warning('Cần nhập đủ doanh thu Vietlott và Loto!!!');
                }else if(vm.summaryMoney.TotalGuestTransferNotConfirm > 0 || vm.summaryMoney.TotalTranferForGuestNotConfirm > 0){
                    vm.isSaving = false;
                    notificationService.warning('Còn yêu cầu chuyển khoản chưa xác nhận!!!');
                }
                else {
                    if (confirm) {
                        message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> muốn kết ca?'
                    } else {
                        message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn có <strong>xác nhận</strong> muốn kết ca?'
                    };

                    var dialog = bootbox.confirm({
                        message,
                        buttons: {
                            confirm: {
                                label: 'Xác nhận',
                                className: 'btn-success',
                            },
                            cancel: {
                                label: 'Huỷ',
                                className: 'btn-secondary'
                            }
                        },
                        callback: function (res) {
                            setTimeout(function () {
                                $('.modal-lg').css('display', 'block');
                            }, 500);


                            if (res) {
                                vm.save();
                            }

                        }
                    });

                    dialog.init(function () {
                        setTimeout(function () {
                            $('.modal-body').removeClass("modal-body")
                            $('.modal-lg').css('display', 'none')
                        }, 0);
                    });
                }
            }

            vm.save = function () {
                vm.isSaving = true;
                let temp = []
              
                    temp.push({
                        'TotalReceived':0,
                        'TotalRemaining':0,
                        'LotteryChannelId':1,
                        'LotteryDate': '2023-03-20',
                        'LotteryTypeId':1,
                        'TotalStocks': 0,
                        'TotalTrans':0,
                        'TotalReturns': 0,
                        'TotalSold': 0,
                        'TotalSoldMoney':0,
                        'TotalWholesale':0,
                        'TotalWholesaleMoney': 0,
                        'TotalRetail':0,
                        'TotalRetailMoney': 0

                    })
                

                vm.saveData.Data = JSON.stringify(temp);
                vm.saveData.temp = temp;

                if (!(vietlott >= 0 && loto >= 0)) {
                    vm.isSaving = false;
                    notificationService.warning('Cần nhập đủ doanh thu Vietlott và Loto');
                } else {
                    var saveVietlott = {
                        ActionType: 1,
                        ActionBy: $rootScope.sessionInfo.UserId,
                        ActionByName: $rootScope.sessionInfo.FullName,
                        Data: JSON.stringify([
                            {
                                Price: vietlott,
                                SalePointId: vm.data.SalePointId,
                                ShiftDistributeId: vm.ShiftDistributeId
                            }
                        ])
                    }
                    //
                
                    
                    
                    salepointService.saleOfVietlott(saveVietlott).then(function (res1) {
                        if (res1 && res1.Id > 0) {
                            vm.isSaving = false;
                            var saveLoto = {
                                ActionType: 1,
                                ActionBy: $rootScope.sessionInfo.UserId,
                                ActionByName: $rootScope.sessionInfo.FullName,
                                Data: JSON.stringify([
                                    {
                                        Price: loto,
                                        SalePointId: vm.data.SalePointId,
                                        ShiftDistributeId: vm.ShiftDistributeId,
                                        Date: moment().format('YYYY-MM-DD')
                                    }
                                ])
                            }
                            salepointService.saleOfLoto(saveLoto).then(function (res2) {
                                if (res2 && res2.Id > 0) {
                                    vm.isSaving = false;
                                    // Kết ca
                                    vm.saveData.Money = vm.total
                                    

                                    activityService.shiftTransfer(vm.saveData).then(function (res) {
                                        if (res && res.Id > 0) {
                                            
                                            notificationService.success(res.Message);
                                            authService.logout().then(function (res) {
                                                if (res && res.Id > 0) {
                                                    setTimeout(function () {
                                                        localStorage.removeItem('bearer');
                                                        vm.isSaving = false;
                                                        deleteCookie('AUTH_');
                                                        $rootScope.isReloading = false;
                                                        notificationService.success("Đăng xuất thành công");
                                                        $state.go('auth.login')
                                                    }, 1000);
                                                } else {
                                                    vm.isSaving = false;
                                                    setTimeout(function () {
                                                        notificationService.success(res.Message);
                                                    }, 1000);

                                                }
                                            });
                                        }
                                    })
                                }
                            })
                        }
                    })
                    
                }
                /**/
            };
           
            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
