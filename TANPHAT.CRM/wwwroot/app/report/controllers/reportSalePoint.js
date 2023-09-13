(function () {
    app.controller('Report.reportSalePoint', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var outputDate = 'YYYY-MM-DD';

            console.log("lottery data", JSON.parse(vm.lotteryData[0].Data))

            vm.params.day = moment(vm.params.day, formatDate).format('YYYY-MM-DD');
            vm.params.nextDay = moment(vm.params.day, formatDate).add(1, 'days').format('YYYY-MM-DD');
            vm.saveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')'
            }

            vm.changeDate = function () {
                vm.params.nextDay = moment(vm.params.day, formatDate).add(1, 'days').format('YYYY-MM-DD');
                vm.params.day = moment(vm.params.day, formatDate).format(outputDate)
                $state.go($state.current, vm.params, {
                    reload: true,
                    notify: true
                });

            }


            vm.loadData = function () {
                vm.changeDate();
                $state.go($state.current, vm.params, { reload: true, notify: true })
            };

            vm.noDuplicate = function (array_) {
                return Array.from(new Set(array_))
            }

            vm.setKey = function (item, index) {
                var fullname = { "ShortName": item };
                return fullname;
            };
            vm.shift1ScratchCardList = [];
            vm.shift2ScratchCardList = [];


            (vm.lotteryData ? vm.listLotteryData = JSON.parse(vm.lotteryData[0].Data) : vm.listLotteryData = []);
            (vm.listReportSalePoint.RepaymentData ? vm.listRepaymentData = JSON.parse(vm.listReportSalePoint.RepaymentData) : vm.listRepaymentData = []);
            (vm.listReportSalePoint.ScratchcardData ? vm.listScratchcardData = JSON.parse(vm.listReportSalePoint.ScratchcardData) : vm.listScratchcardData = []);
            (vm.listReportSalePoint.WinningData ? vm.listWinningData = JSON.parse(vm.listReportSalePoint.WinningData) : vm.listWinningData = []);
            (vm.listReportSalePoint.MoneyData ? vm.listMoneyData = JSON.parse(vm.listReportSalePoint.MoneyData) : vm.listMoneyData = []);

            if (vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0] != undefined) {
                vm.shift1 = {
                    Loto: vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0].Loto,
                    Vietlott: vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0].Vietllot,
                    MoneyReturn: vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0].TotalMoneyInDay != null ? vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0].TotalMoneyInDay : 0,
                    TransferConfirmed: vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0].TransferConfirmed,
                    TransferToGuest: vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0].TransferToGuest,
                    Cost: vm.listMoneyData.filter(ele => ele.ShiftId == 1)[0].Cost,
                }
            } else {
                vm.shift1 = {
                    Loto: 0,
                    Vietlott: 0,
                    MoneyReturn: 0,
                    TransferConfirmed: 0,
                    TransferToGuest: 0,
                    Cost: 0,
                }
            }
            if (vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0] != undefined) {
                vm.shift2 = {
                    Loto: vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0].Loto,
                    Vietlott: vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0].Vietllot,
                    MoneyReturn: vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0].TotalMoneyInDay != null ? vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0].TotalMoneyInDay : 0,
                    TransferConfirmed: vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0].TransferConfirmed,
                    TransferToGuest: vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0].TransferToGuest,
                    Cost: vm.listMoneyData.filter(ele => ele.ShiftId == 2)[0].Cost,
                }
            } else {
                vm.shift2 = {
                    Loto: 0,
                    Vietlott: 0,
                    MoneyReturn: 0,
                    TransferConfirmed: 0,
                    TransferToGuest: 0,
                    Cost: 0,
                }
            }

            vm.shift1ScratchCard1000 = {}
            vm.shift1ScratchCard1001 = {}
            vm.shift2ScratchCard1000 = {}
            vm.shift2ScratchCard1001 = {}
            vm.shift1Sum = {
                Stock: 0,
                Balance: 0,
                Sold: 0,
                Remaining: 0
            }
            vm.shift2Sum = {
                Stock: 0,
                Balance: 0,
                Sold: 0,
                Remaining: 0
            }
            vm.shift1VeBoc = {}
            vm.shift2VeBoc = {}
            vm.shift1XO = {}
            vm.shift2XO = {}
            vm.shift1XO2k = {}
            vm.shift2XO2k = {}


            vm.init = function () {
                vm.dataShift1 = vm.listLotteryData.filter(function (e) {
                    e.ShortNameNew = vm.lotteryChannels.find(ele => ele.Id == e.LotteryChannelId).ShortName
                    return e.ShiftId == 1;
                })

                vm.dataShift2 = vm.listLotteryData.filter(function (e) {
                    e.ShortNameNew = vm.lotteryChannels.find(ele => ele.Id == e.LotteryChannelId).ShortName
                    return e.ShiftId == 2
                })
                // vm.dataShift2 = vm.dataShift2RawData;


                vm.dataRepayShift1 = vm.listRepaymentData.filter(e => e.ShiftId == 1)
                vm.dataRepayShift2 = vm.listRepaymentData.filter(e => e.ShiftId == 2)
                vm.dataWinningShift1 = vm.listWinningData.filter(e => e.ShiftId == 1)
                vm.dataWinningShift2 = vm.listWinningData.filter(e => e.ShiftId == 2)
                vm.shift1ScratchCardRaw1000 = vm.listScratchcardData.filter(e => e.ShiftId == 1 && (e.LotteryChannelId == 1000))
                vm.shift1ScratchCardRaw1001 = vm.listScratchcardData.filter(e => e.ShiftId == 1 && (e.LotteryChannelId == 1001))
                vm.shift2ScratchCardRaw1000 = vm.listScratchcardData.filter(e => e.ShiftId == 2 && (e.LotteryChannelId == 1000))
                vm.shift2ScratchCardRaw1001 = vm.listScratchcardData.filter(e => e.ShiftId == 2 && (e.LotteryChannelId == 1001))
                vm.shift1VeBocRaw = vm.listScratchcardData.filter(e => e.ShiftId == 1 && e.LotteryChannelId == 1002)
                vm.shift2VeBocRaw = vm.listScratchcardData.filter(e => e.ShiftId == 2 && e.LotteryChannelId == 1002)
                vm.shift1XORaw = vm.listScratchcardData.filter(e => e.ShiftId == 1 && e.LotteryChannelId == 1003)
                vm.shift2XORaw = vm.listScratchcardData.filter(e => e.ShiftId == 2 && e.LotteryChannelId == 1003)
                vm.shift1XO2kRaw = vm.listScratchcardData.filter(e => e.ShiftId == 1 && e.LotteryChannelId == 1004)
                vm.shift2XO2kRaw = vm.listScratchcardData.filter(e => e.ShiftId == 2 && e.LotteryChannelId == 1004)

                /// Balance
                vm.dataShift1.forEach(e => {
                    e.Balance = (e.Received + e.ReceivedDup) - (e.Transfer + e.TransferDup)
                })
                vm.dataShift2.forEach(e => {
                    e.Balance = (e.Received + e.ReceivedDup) - (e.Transfer + e.TransferDup)
                })
                console.log("vm.dataShift1", vm.dataShift1)

                for (let i = 1; i <= 2; i++) {
                    if (vm['dataShift' + i] && vm['dataShift' + i].length > 0) {
                        vm['shift' + i].totalWholesale = 0
                        vm['shift' + i].totalWholesaleMoney = 0
                        vm['shift' + i].totalRetail = 0
                        vm['shift' + i].totalRetailMoney = 0
                        vm['shift' + i].totalSold = 0
                        vm['shift' + i].totalSoldMoney = 0
                        vm['shift' + i].totalStocks = 0
                        vm['shift' + i].totalRemaining = 0
                        vm['shift' + i].totalReceived = 0
                        vm['shift' + i].totalReturns = 0
                        vm['shift' + i].totalTrans = 0
                        vm['shift' + i].totalRepay = 0
                        vm['shift' + i].type1Quantity = 0
                        vm['shift' + i].type1Sum = 0
                        vm['shift' + i].type2Quantity = 0
                        vm['shift' + i].type2Sum = 0
                        vm['shift' + i].type3Quantity = 0
                        vm['shift' + i].type3Sum = 0
                        vm['shift' + i].type4Quantity = 0
                        vm['shift' + i].type4Sum = 0
                        vm['shift' + i].type5Quantity = 0
                        vm['shift' + i].type5Sum = 0
                        vm['shift' + i].type6Quantity = 0
                        vm['shift' + i].type6Sum = 0
                        vm['shift' + i].totalExpired = 0
                        vm['shift' + i].totalChuyen1 = 0
                        vm['shift' + i].totalChuyen2 = 0
                        vm['shift' + i].totalBalance = 0

                        vm['dataShift' + i].forEach(ele => {
                            vm['shift' + i].totalWholesale += (ele.SoldWholeSale + ele.SoldWholeSaleDup)
                            vm['shift' + i].totalWholesaleMoney += (ele.SoldWholeSaleMoney + ele.SoldWholeSaleMoneyDup)
                            vm['shift' + i].totalRetail += (ele.SoldRetail + ele.SoldRetailDup)
                            vm['shift' + i].totalRetailMoney += (ele.SoldRetailMoney + ele.SoldRetailMoneyDup)
                            vm['shift' + i].totalSold += (ele.SoldRetail + ele.SoldRetailDup + ele.SoldWholeSale + ele.SoldWholeSaleDup)
                            vm['shift' + i].totalSoldMoney += (ele.SoldRetailMoney + ele.SoldRetailMoneyDup + ele.SoldWholeSaleMoney + ele.SoldWholeSaleMoneyDup)
                            vm['shift' + i].totalStocks += (ele.Stock + ele.StockDup)
                            vm['shift' + i].totalRemaining += (ele.Remaining + ele.RemainingDup)
                            vm['shift' + i].totalReceived += (ele.Received + ele.ReceivedDup)
                            vm['shift' + i].totalReturns += ele.TotalReturns
                            vm['shift' + i].totalTrans += (ele.Transfer + ele.TransferDup)
                            vm['shift' + i].totalBalance += ele.Balance

                        })
                        vm['dataRepayShift' + i].forEach(ele => {
                            vm['shift' + i].totalRepay += ele.TotalRepay
                        })
                        console.log('win 1', vm.dataWinningShift1)
                        vm['dataWinningShift' + i].forEach(ele => {
                            if (ele.WinningTypeId == 1) {
                                vm['shift' + i].type1Quantity += ele.TotalPrice
                            }
                            if (ele.WinningTypeId == 2) {
                                vm['shift' + i].type2Quantity += ele.TotalQuantity
                                vm['shift' + i].type2Sum += ele.TotalPrice
                            }
                            if (ele.WinningTypeId == 3) {
                                vm['shift' + i].type3Quantity += ele.TotalQuantity
                                vm['shift' + i].type3Sum += ele.TotalPrice
                            }
                            if (ele.WinningTypeId == 4) {
                                vm['shift' + i].type4Quantity += ele.TotalQuantity
                                vm['shift' + i].type4Sum += ele.TotalPrice
                            }
                            if (ele.WinningTypeId == 5) {
                                vm['shift' + i].type5Quantity += ele.TotalQuantity
                                vm['shift' + i].type5Sum += ele.TotalPrice
                            }
                            if (ele.WinningTypeId == 6) {
                                vm['shift' + i].type6Quantity += ele.TotalQuantity
                                vm['shift' + i].type6Sum += ele.TotalPrice
                            }
                        })
                    }
                }



                // Tồn đầu cào
                vm.shift1ScratchCard1000.TotalStocks = vm.shift1ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)
                vm.shift1ScratchCard1001.TotalStocks = vm.shift1ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)
                vm.shift2ScratchCard1000.TotalStocks = vm.shift2ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)
                vm.shift2ScratchCard1001.TotalStocks = vm.shift2ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)

                // Bán si cào
                vm.shift1ScratchCard1000.TotalWholesale = vm.shift1ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                vm.shift1ScratchCard1001.TotalWholesale = vm.shift1ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                vm.shift2ScratchCard1000.TotalWholesale = vm.shift2ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                vm.shift2ScratchCard1001.TotalWholesale = vm.shift2ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                // Giá lẻ cào
                vm.shift1ScratchCard1000.TotalWholesaleMoney = vm.shift1ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)
                vm.shift1ScratchCard1001.TotalWholesaleMoney = vm.shift1ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)
                vm.shift2ScratchCard1000.TotalWholesaleMoney = vm.shift2ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)
                vm.shift2ScratchCard1001.TotalWholesaleMoney = vm.shift2ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)

                // Bán lẻ cào
                vm.shift1ScratchCard1000.TotalRetail = vm.shift1ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)
                vm.shift1ScratchCard1001.TotalRetail = vm.shift1ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)
                vm.shift2ScratchCard1000.TotalRetail = vm.shift2ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)
                vm.shift2ScratchCard1001.TotalRetail = vm.shift2ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)
                // Giá lẻ cào
                vm.shift1ScratchCard1000.TotalRetailMoney = vm.shift1ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)
                vm.shift1ScratchCard1001.TotalRetailMoney = vm.shift1ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)
                vm.shift2ScratchCard1000.TotalRetailMoney = vm.shift2ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)
                vm.shift2ScratchCard1001.TotalRetailMoney = vm.shift2ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)
                // Tồn cuối ca cào
                vm.shift1ScratchCard1000.TotalRemaining = vm.shift1ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)
                vm.shift1ScratchCard1001.TotalRemaining = vm.shift1ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)
                vm.shift2ScratchCard1000.TotalRemaining = vm.shift2ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)
                vm.shift2ScratchCard1001.TotalRemaining = vm.shift2ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)
                /// Cao XO 2k

                vm.shift1XO2k.TotalStocks = vm.shift1XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)
                vm.shift2XO2k.TotalStocks = vm.shift2XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)

                // Bán si cào
                vm.shift1XO2k.TotalWholesale = vm.shift1XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                vm.shift2XO2k.TotalWholesale = vm.shift2XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                // Giá lẻ cào
                vm.shift1XO2k.TotalWholesaleMoney = vm.shift1XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)
                vm.shift2XO2k.TotalWholesaleMoney = vm.shift2XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)

                // Bán lẻ cào
                vm.shift1XO2k.TotalRetail = vm.shift1XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)
                vm.shift2XO2k.TotalRetail = vm.shift2XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)

                // Giá lẻ cào
                vm.shift1XO2k.TotalRetailMoney = vm.shift1XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)
                vm.shift2XO2k.TotalRetailMoney = vm.shift2XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)

                // Tồn cuối ca cào
                vm.shift1XO2k.TotalRemaining = vm.shift1XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)
                vm.shift2XO2k.TotalRemaining = vm.shift2XO2kRaw.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)


                ///VE BOC

                vm.shift1VeBoc.TotalStocks = vm.shift1VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)
                vm.shift2VeBoc.TotalStocks = vm.shift2VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)
                /// XO
                vm.shift1XO.TotalStocks = vm.shift1XORaw.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)
                vm.shift2XO.TotalStocks = vm.shift2XORaw.reduce(function (a, s) {
                    return a += s.TotalStocks
                }, 0)

                // Bán si boc
                vm.shift1VeBoc.TotalWholesale = vm.shift1VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                vm.shift2VeBoc.TotalWholesale = vm.shift2VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                // Bán si XO
                vm.shift1XO.TotalWholesale = vm.shift1XORaw.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)
                vm.shift2XO.TotalWholesale = vm.shift2XORaw.reduce(function (a, s) {
                    return a += s.TotalWholesale
                }, 0)

                // Giá lẻ boc
                vm.shift1VeBoc.TotalWholesaleMoney = vm.shift1VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)
                vm.shift2VeBoc.TotalWholesaleMoney = vm.shift2VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)


                // Giá lẻ XO
                vm.shift1XO.TotalWholesaleMoney = vm.shift1XORaw.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)
                vm.shift2XO.TotalWholesaleMoney = vm.shift2XORaw.reduce(function (a, s) {
                    return a += s.TotalWholesaleMoney
                }, 0)

                // Bán lẻ boc
                vm.shift1VeBoc.TotalRetail = vm.shift1VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)
                vm.shift2VeBoc.TotalRetail = vm.shift2VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)

                // Giá lẻ boc
                vm.shift1VeBoc.TotalRetailMoney = vm.shift1VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)
                vm.shift2VeBoc.TotalRetailMoney = vm.shift2VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)

                // Tồn cuối boc
                vm.shift1VeBoc.TotalRemaining = vm.shift1VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)
                vm.shift2VeBoc.TotalRemaining = vm.shift2VeBocRaw.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)


                // Bán lẻ boc
                vm.shift1XO.TotalRetail = vm.shift1XORaw.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)
                vm.shift2XO.TotalRetail = vm.shift2XORaw.reduce(function (a, s) {
                    return a += s.TotalRetail
                }, 0)

                // Giá lẻ boc
                vm.shift1XO.TotalRetailMoney = vm.shift1XORaw.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)
                vm.shift2XO.TotalRetailMoney = vm.shift2XORaw.reduce(function (a, s) {
                    return a += s.TotalRetailMoney
                }, 0)

                // Tồn cuối boc
                vm.shift1XO.TotalRemaining = vm.shift1XORaw.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)
                vm.shift2XO.TotalRemaining = vm.shift2XORaw.reduce(function (a, s) {
                    return a += s.TotalRemaining
                }, 0)

                ///END VE BOC
                ///
                vm.shift1.totalBalance = vm.dataShift1.filter(ele => ele.LotteryChannelId != 1000 && ele.LotteryChannelId != 1001 && ele.LotteryChannelId != 1002 && ele.LotteryChannelId != 1003 && ele.LotteryChannelId != 1004).reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                vm.shift2.totalBalance = vm.dataShift2.filter(ele => ele.LotteryChannelId != 1000 && ele.LotteryChannelId != 1001 && ele.LotteryChannelId != 1002 && ele.LotteryChannelId != 1003 && ele.LotteryChannelId != 1004).reduce(function (a, s) {
                    return a += s.Balance
                }, 0)

                vm.shift1ScratchCardRaw1000.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })
                vm.shift1ScratchCardRaw1001.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })

                vm.shift2ScratchCardRaw1000.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })
                vm.shift2ScratchCardRaw1001.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })

                vm.shift1VeBocRaw.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })

                vm.shift2VeBocRaw.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })

                vm.shift1XORaw.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })

                vm.shift2XORaw.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans
                })

                vm.shift1XO2kRaw.forEach(e => {
                    e.Balance = e.TotalReceived - e.TotalTrans

                })

                vm.shift2XO2kRaw.forEach(e => {

                    e.Balance = e.TotalReceived - e.TotalTrans

                })

                vm.shift1ScratchCard1000.totalBalance = vm.shift1ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                vm.shift1ScratchCard1001.totalBalance = vm.shift1ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                vm.shift2ScratchCard1000.totalBalance = vm.shift2ScratchCardRaw1000.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                vm.shift2ScratchCard1001.totalBalance = vm.shift2ScratchCardRaw1001.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)

                vm.shift1VeBoc.totalBalance = vm.shift1VeBocRaw.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                vm.shift2VeBoc.totalBalance = vm.shift2VeBocRaw.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)

                vm.shift1XO.totalBalance = vm.shift1XORaw.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                vm.shift2XO.totalBalance = vm.shift2XORaw.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)


                vm.shift1XO2k.totalBalance = vm.shift1XO2kRaw.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                vm.shift2XO2k.totalBalance = vm.shift2XO2kRaw.reduce(function (a, s) {
                    return a += s.Balance
                }, 0)
                /// Om e
                vm.dataShift2.filter(e => e.LotteryDate == vm.params.day).forEach(f => {
                    f.TotalExpired = f.TotalStocks + f.TotalReceived - f.TotalTrans - f.TotalReturns - f.TotalSold
                })

                vm.shift2.totalExpired = vm.dataShift2.filter(e => e.LotteryDate == vm.params.day).reduce(function (a, s) {
                    return a += s.TotalExpired
                }, 0)
                ///Chuyen 2

                vm.dataShift1.forEach(f => {
                    f.Chuyen2 = f.TotalRemaining + f.Balance - f.TotalReturns
                    console.log(f)
                    vm.shift1Sum.Stock += (f.Stock + f.StockDup)
                    vm.shift1Sum.Balance += f.Balance
                    vm.shift1Sum.Sold += (f.SoldRetail + f.SoldRetailDup + f.SoldWholeSale + f.SoldWholeSaleDup)
                    vm.shift1Sum.Remaining += (f.Remaining + f.RemainingDup)
                })
                vm.shift1.totalChuyen2 = vm.dataShift1.reduce(function (a, s) {
                    return a += s.Chuyen2
                }, 0)


                /// Chuyen 1
                vm.dataShift2.forEach(f => {
                    f.Chuyen1 = f.TotalRemaining + f.Balance - f.TotalReturns
                    vm.shift2Sum.Stock += (f.Stock + f.StockDup)
                    vm.shift2Sum.Balance += f.Balance
                    vm.shift2Sum.Sold += (f.SoldRetail + f.SoldRetailDup + f.SoldWholeSale + f.SoldWholeSaleDup)
                    vm.shift2Sum.Remaining += (f.Remaining + f.RemainingDup)


                })
                vm.shift2.totalChuyen1 = vm.dataShift2.filter(e => e.LotteryDate != vm.params.day).reduce(function (a, s) {
                    return a += s.Chuyen1
                }, 0)

                vm.shift1ScratchCardList = vm.listScratchcardData.filter(ele => ele.ShiftId == 1).sort((a, b) => a.LotteryChannelId - b.LotteryChannelId)

                vm.shift2ScratchCardList = vm.listScratchcardData.filter(ele => ele.ShiftId == 2).sort((a, b) => a.LotteryChannelId - b.LotteryChannelId)
                console.log("shift1 sum", vm.shift1Sum)

            }


            vm.init();
        }]);
})();