(function () {
    app.controller('Activity.sellToWholesaleDetail', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService', 'viewModel', 'activityService', 'salepointService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService, viewModel, activityService, salepointService) {
            var vm = angular.extend(this, viewModel);
            vm.totalPayment = vm.newDebt
            vm.newDebt = 0;

            vm.savingBill = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                ActionType: 1,
                Data: {
                    ShiftDistributeId: vm.data.ShiftDistributeId,
                    SalePointId: vm.data.SalePointId,
                    GuestId: vm.wholesaleData.GuestId,
                    ActionType: 1,
                    ActionTypeId: 1,
                    Data: {
                        OldDebt: 0,
                        NewDebt: 0
                    }
                }
            }

            vm.getSaveData = function (model) {
                var temp = [];
                model.forEach(function (item) {
                    for (let i = 0; i <= 2; i++) {
                        if (i == 0) {
                            if (item["inputSale_0"] > 0) {
                              
                                    var temp1 = {
                                        LotteryDate: item.LotteryDate == "VE_CAO" ? null : item.LotteryDate,
                                        IsScratchcard: item.isScratchCard,
                                        LotteryChannelId: item.LotteryChannelId,
                                        Quantity: item["inputSale_0"],
                                        LotteryTypeId: 2,
                                        LotteryPriceId: 6,
                                    };
                                
                                temp.push(temp1);
                            }
                        } else if (i == 2 && !item.isScratchCard && vm.params.clientType == 3) {
                            if (item["inputSale_" + i] > 0) {
                               
                                var getType = item.isScratchCard ? 2 : 0;
                                item.ListDetail.forEach(function (ele) {
                                   
                                        var temp1 = {
                                            LotteryDate: item.LotteryDate == "VE_CAO" ? null : item.LotteryDate,
                                            IsScratchcard: item.isScratchCard,
                                            LotteryChannelId: item.LotteryChannelId,
                                            Quantity: ele.input,
                                            FourLastNumber: ele.fourLastNumber,
                                            LotteryTypeId: i == 1 ? 2 : (item.isScratchCard ? 3 : 1),
                                            LotteryPriceId: vm[vm.typeOfPrice[getType].Name].LotteryPriceId
                                        }
                                    
                                    temp.push(temp1);
                                })
                            }
                        } else if (item["inputSale_" + i] > 0) {
                      
                            var getType = item.isScratchCard ? 2 : 0;
                            if (vm.wholesaleData) {
                                var choose = i == 1 ? 2 : (item.isScratchCard ? 3 : 1);
                                var temp1 = {
                                    LotteryDate: item.LotteryDate == "VE_CAO" ? null : item.LotteryDate,
                                    IsScratchcard: item.isScratchCard,
                                    LotteryChannelId: item.LotteryChannelId,
                                    Quantity: item["inputSale_" + i],
                                    LotteryTypeId: i == 1 ? 2 : (item.isScratchCard ? 3 : 1),
                                    
                                    LotteryPriceId: choose == 1 ? vm.wholesaleData.WholesalePriceId : vm.wholesaleData.ScratchPriceId,
                                };
                            } else {
                                var temp1 = {
                                    LotteryDate: item.LotteryDate == "VE_CAO" ? null : item.LotteryDate,
                                    IsScratchcard: item.isScratchCard,
                                    LotteryChannelId: item.LotteryChannelId,
                                    Quantity: item["inputSale_" + i],
                                    LotteryTypeId: i == 1 ? 2 : (item.isScratchCard ? 3 : 1),
                                    LotteryPriceId: vm[vm.typeOfPrice[getType].Name].LotteryPriceId
                                    

                                };
                            }
                            temp.push(temp1);
                        }
                    }
                })
            
                return temp;
            }

            //Thanh toán nợ cũ
            vm.paymentOldDebt = {
                TypeAction: 1,
                Data: []
            };

            //Thanh toán mua mới
            vm.paymentNewBuy = [];

            //Tổng thanh toán
            vm.totalPayment = 0;
            vm.PaymentData.forEach(function (item) {
                vm.totalPayment += item.TotalPrice;
            })

            // trả ế vượt nợ cũ
            if (vm.returnData.totalReturn > vm.wholesaleData.Debt) {

                //số tiền còn dư sau khi trả ế > số tiền mua mới + số tiền trả lại khách

                if ((vm.returnData.totalReturn - vm.wholesaleData.Debt) >= (vm.totalBuy + vm.returnForGuest.Input)) {

                    if (vm.returnForGuest.Input > 0) {
                        vm.paymentOldDebt.Data.push({
                            TotalPrice: vm.returnForGuest.Input,
                            FormPaymentId: 1,
                            GuestId: vm.wholesaleData.GuestId,
                            SalePointId: vm.data.SalePointId,
                            GuestActionTypeId: 3,
                            ShiftDistributeId: vm.data.ShiftDistributeId
                        })
                    }

                } else {
                    vm.PaymentData.forEach(function (item) {
                        var temp = {
                            GuestId: vm.wholesaleData.GuestId,
                            SalePointId: vm.data.SalePointId,
                            TotalPrice: item.TotalPrice,
                            FormPaymentId: item.FormPaymentId,
                            GuestActionTypeId: 2,
                            ShiftDistributeId: vm.data.ShiftDistributeId
                        }
                        if (item.FormPaymentId == 2) {
                            temp.Note = item.Note
                            temp.TotalPrice = item.TotalPrice
                        } else {
                            temp.TotalPrice = temp.TotalPrice
                        }
                        if (temp.TotalPrice > 0) {
                            vm.paymentNewBuy.push(temp)
                        }
                    })
                }
            } else {// trả ế <= nợ cũ
                //Tổng thanh toán  <= nợ cũ - trả ế
                if (vm.totalPayment <= (vm.wholesaleData.Debt - vm.returnData.totalReturn)) {
                    vm.PaymentData.forEach(function (item) {
                        if (item.TotalPrice > 0) {
                            item.GuestId = vm.wholesaleData.GuestId
                            item.SalePointId = vm.data.SalePointId
                            item.GuestActionTypeId = 2
                            item.ShiftDistributeId = vm.data.ShiftDistributeId
                            vm.paymentOldDebt.Data.push(item)
                        }
                    })
                } else { //Tổng thanh toán  > nợ cũ - trả ế
                    //chuyển khoản > nợ cũ - trả ế *******
                    if (vm.PaymentData[1].TotalPrice > (vm.wholesaleData.Debt - vm.returnData.totalReturn)) {


                        vm.PaymentData.forEach(function (item) {
                            var temp = {
                                GuestId: vm.wholesaleData.GuestId,
                                SalePointId: vm.data.SalePointId,
                                TotalPrice: item.TotalPrice,
                                FormPaymentId: item.FormPaymentId,
                                GuestActionTypeId: 2,
                                ShiftDistributeId: vm.data.ShiftDistributeId
                            }
                            if (item.FormPaymentId == 2) {
                                temp.Note = item.Note
                                temp.TotalPrice = item.TotalPrice
                            }
                            if (temp.TotalPrice > 0) {
                                vm.paymentNewBuy.push(temp)
                            }
                        })
                    } else { //chuyển khoản <= nợ cũ - trả ế
                        vm.PaymentData.forEach(function (item) {
                            var temp = {
                                GuestId: vm.wholesaleData.GuestId,
                                SalePointId: vm.data.SalePointId,
                                TotalPrice: item.TotalPrice,
                                FormPaymentId: item.FormPaymentId,
                                GuestActionTypeId: 2,
                                Note: item.Note,
                                ShiftDistributeId: vm.data.ShiftDistributeId
                            }
                            if (item.FormPaymentId == 1) {
                                temp.TotalPrice = (vm.wholesaleData.Debt - vm.returnData.totalReturn) - vm.PaymentData[1].TotalPrice
                            }
                            if (temp.TotalPrice > 0) {
                                vm.paymentOldDebt.Data.push(temp)
                            }
                        })
                        if ((vm.totalPayment - (vm.wholesaleData.Debt - vm.returnData.totalReturn)) > 0) {
                            vm.paymentNewBuy.push({
                                GuestId: vm.wholesaleData.GuestId,
                                SalePointId: vm.data.SalePointId,
                                TotalPrice: vm.totalPayment - (vm.wholesaleData.Debt - vm.returnData.totalReturn),
                                FormPaymentId: 1,
                                GuestActionTypeId: 2,
                                ShiftDistributeId: vm.data.ShiftDistributeId
                            })
                        }
                    }
                }
            }
            // tổng thanh toán <= nợ cũ - trả ế
            vm.totalPaymentOldDebt = 0;
            if (vm.paymentOldDebt.Data.length > 0) {
                vm.paymentOldDebt.Data.forEach(function (item) {
                    if (item.GuestActionTypeId != 3) {
                        vm.totalPaymentOldDebt += item.TotalPrice
                    }

                })
            }

            vm.savingReturn = {
                ShiftDistributeId: $rootScope.sessionInfo.ShiftDistributeId,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                GuestId: vm.wholesaleData.GuestId,
            }

            vm.savingReturn.Data = []

            vm.returnData.data.forEach(function (item) {
                if (item.InputReturn > 0) {
                    vm.savingReturn.Data.push({
                        GuestId: vm.wholesaleData.GuestId,
                        LotteryDate: !item.IsScratchcard ? moment().format('YYYY-MM-DD') : '',
                        IsScratchcard: item.IsScratchcard,
                        LotteryChannelId: item.LotteryChannelId,
                        Quantity: -(item.InputReturn),
                        LotteryTypeId: item.IsScratchcard ? 3 : 1,
                        LotteryPriceId: item.IsScratchcard ? vm.mainScratchCardTypeId.LotteryPriceId : vm.mainLotteryTypeId.LotteryPriceId,
                    })
                }
            })

            vm.loading = true
            vm.saving.LotteryData = []
            vm.saving.LotteryDataInfo = {
                UserRoleId: vm.saving.UserRoleId,
                GuestId: vm.wholesaleData.GuestId,
                ShiftDistributeId: vm.saving.ShiftDistributeId
            }

            vm.saving.GuestId = vm.wholesaleData.GuestId

            vm.typeOfLottery.forEach(function (ele) {
                if (vm.data[ele.JSName]) {
                    vm.saving.LotteryData = vm.saving.LotteryData.concat(vm.getSaveData(vm.data[ele.JSName].lottery));
                }
            })
            console.log("vm", vm);
            //save
            vm.saveWholesale = function () {
                vm.isSaving = true

                var saveBill = {
                    FullAddress: vm.listSellData.SalePointAddress != null ? vm.listSellData.SalePointAddress : '',
                    SalePoint: vm.listSellData.SalePointName,
                    DatePrint: moment().format('DD/MM/YYYY'),
                    ShiftName: vm.params.shiftId == 1 ? "Ca Sáng" : "Ca Chiều",
                    DateTime: moment().format('HH:mm:ss'),
                    ActionName: $rootScope.sessionInfo.FullName,
                    CustomerName: vm.wholesaleData.FullName,
                    ListInfo: [],
                    TotalQuatity: 0,
                    Sum: 0,
                    CustomerGive: vm.totalPayment,
                    TotalDebt: 0,
                    OldDebt: vm.wholesaleData.Debt,
                    NewDebt: vm.newDebt > 0 ? vm.newDebt : 0
                }

                vm.savingReturn.Data.forEach(function (item) {
                    var temp = {
                        LotteryName: vm.listLottery.find(x => x.Id == item.LotteryChannelId).ShortName,
                        Quantity: item.Quantity,
                        FourLastNumber: item.FourLastNumber ? (' --> ' + item.FourLastNumber) : '',
                        //Price: (!item.IsScratchcard) ? (item.Quantity * vm.listTypeSelect.find(x => x.LotteryPriceId == item.LotteryPriceId).Price) : (item.Quantity * 10000 / 11 * 10)
                        Price: (item.LotteryPriceId != 6) ? (item.Quantity * vm.listTypeSelect.find(x => x.LotteryPriceId == item.LotteryPriceId).Price) : (item.Quantity * 10000 / 11 * 10)

                    }

                    console.log("temp111", temp);
                    saveBill.ListInfo.push(temp)
                    saveBill.TotalQuatity += temp.Quantity;
                    saveBill.Sum += temp.Price;
                })

                vm.saving.LotteryData.forEach(function (item) {
                   
                    var temp = {
                        LotteryName: vm.listLottery.find(x => x.Id == item.LotteryChannelId).ShortName,
                        Quantity: item.Quantity,
                        FourLastNumber: item.FourLastNumber ? (' --> ' + item.FourLastNumber) : '',
                        //Price: (!item.IsScratchcard) ? (item.Quantity * vm.listTypeSelect.find(x => x.LotteryPriceId == item.LotteryPriceId).Price) : (item.Quantity * 10000 / 11 * 10)
                        Price: (item.LotteryPriceId != 6) ? (item.Quantity * vm.listTypeSelect.find(x => x.LotteryPriceId == item.LotteryPriceId).Price) : (item.Quantity * 10000 / 11 * 10)
                        

                    }
                  
                    saveBill.ListInfo.push(temp)
                    saveBill.TotalQuatity += temp.Quantity;
                    saveBill.Sum += temp.Price;
                })

                saveBill.CustomerGive = vm.totalPayment
                saveBill.TotalDebt = vm.wholesaleData ? vm.wholesaleData.Debt : 0
                saveBill.OldDebt = vm.wholesaleData.Debt
                saveBill.NewDebt = vm.newDebt
                vm.savingBill.Data.Data.OldDebt = saveBill.OldDebt
                vm.savingBill.Data.Data.NewDebt = saveBill.NewDebt + vm.returnForGuest.Input
                vm.savingBill.Data.Data = JSON.stringify(vm.savingBill.Data.Data)
                vm.savingBill.Data = JSON.stringify(vm.savingBill.Data)

                if (vm.saving.LotteryData.length == 0 && vm.paymentOldDebt.Data.length == 0 && vm.savingReturn.Data.length == 0) {
                    notificationService.warning("Không có gì để lưu");
                    setTimeout(function () {
                        vm.isSaving = false
                        $rootScope.$apply(vm.isSaving)

                    }, 400)
                } else {
                    console.log("vm.savingBill", vm.savingBill);
                    salepointService.updateHistoryOrder(vm.savingBill).then(function (ress) {
                        console.log("ress", ress);
                        if (ress && ress.Id > 0) {
                        
                            var checkPrint = true
                            vm.saving.OrderId = ress.Id
                            vm.savingReturn.OrderId = ress.Id
                            vm.paymentOldDebt.OrderId = ress.Id
                            saveBill.BillNumber = $rootScope.createBillNumber(ress.Id)
                            vm.saving.LotteryDataInfo = JSON.stringify(vm.saving.LotteryDataInfo);
                            if (vm.savingReturn.Data.length > 0) {
                                vm.savingReturn.Data = JSON.stringify(vm.savingReturn.Data);
                                activityService.sellLottery(vm.savingReturn).then(async function (res) {
                            
                                    vm.isSaving = false
                                    if (checkPrint) {
                                        $rootScope.printBill(saveBill, 2);
                                        checkPrint = false
                                    }
                                })
                            }

                            if (vm.paymentOldDebt.Data.length > 0) {
                                vm.paymentOldDebt.UserRoleId = $rootScope.sessionInfo.UserRoleId
                                vm.paymentOldDebt.ActionBy = $rootScope.sessionInfo.UserId
                                vm.paymentOldDebt.ActionByName = $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')'
                                vm.paymentOldDebt.GuestId = vm.wholesaleData.GuestId
                                vm.paymentOldDebt.Data = JSON.stringify(vm.paymentOldDebt.Data);
                                vm.paymentOldDebt.ShiftDistributeId = vm.saving.ShiftDistributeId;
                                
                                salepointService.updateOrCreateGuestAction(vm.paymentOldDebt).then(async function (res) {
                                    vm.isSaving = false
                                })
                            }

                            if (vm.saving.LotteryData && vm.saving.LotteryData.length > 0) {
                                if (vm.paymentNewBuy && vm.paymentNewBuy.length > 0) {
                                    vm.saving.PaymentData = vm.paymentNewBuy
                                    vm.saving.PaymentData.forEach(function (item, index) {
                                        item.ShiftDistributeId = vm.saving.ShiftDistributeId;
                                        if (item.TotalPrice == 0) {
                                            vm.saving.PaymentData.splice(index, 1)
                                        }
                                    })
                                    vm.saving.PaymentData = JSON.stringify(vm.saving.PaymentData);
                                }

                                vm.saving.LotteryData = JSON.stringify(vm.saving.LotteryData);
                                console.log("vm.saving.LotteryData", vm.saving.LotteryData);
                                salepointService.createListConfirmPayment(vm.saving).then(async function (res) {
                                    vm.isSaving = false
                                    if (res && res.Id > 0 && vm.newDebt == 0) {
                                        let autoConfirm = {
                                            ActionType: 4,
                                            HistoryOfOrderId: vm.saving.OrderId,
                                            ActionBy: $rootScope.sessionInfo.UserId,
                                            ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                                        }
                                        autoConfirm.data = JSON.stringify(autoConfirm)
                                        salepointService.updateHistoryOrder(autoConfirm).then((res2) => {
                                            if (res2 && res2.Id > 0) {
                                                notificationService.success("Thao tác thành công");
                                            } else {
                                                notificationService.error(res.Message);
                                            }
                                        })
                                    }
                                    else if (res && res.Id > 0) {
                                        vm.typeOfLottery.forEach(function (ele) {
                                            if (vm.data[ele.JSName]) {
                                                vm.data[ele.JSName].lottery.forEach(e => {
                                                    vm.data.soldData[0].TotalRetailQuantity += e.inputSale_0;
                                                    vm.data.soldData[0].TotalRetailPrice += Math.ceil(e.inputSale_0 * vm.mainLotteryDupTypeId.Price);

                                                    var getNum = e.isScratchcard ? 2 : 0;

                                                    for (let i = 1; i <= 2; i++) {
                                                        var detail = vm[vm.typeOfPrice[getNum].Name]
                                                        if (detail.LotteryPriceId == 1) {
                                                            vm.data.soldData[0].TotalRetailQuantity += e['inputSale_' + i];
                                                            vm.data.soldData[0].TotalRetailPrice += e['inputSale_' + i] * detail.Price;
                                                        } else {
                                                            vm.data.soldData[0].TotalWholesaleQuantity += e['inputSale_' + i];
                                                            vm.data.soldData[0].TotalWholesalePrice += e['inputSale_' + i] * detail.Price;
                                                        }
                                                    }
                                                })
                                            }
                                        })
                                        if (checkPrint) {
                                            $rootScope.printBill(saveBill, 2);
                                            checkPrint = false
                                        }
                                    }
                                })
                            }
                            $rootScope.connection.invoke("SendMessage", "ChangeRemain", "Change").catch(function (err) {
                                return console.error(err.toString());
                            });
                            //vm.getTotal();
                            $state.go($state.current, vm.params, { reload: true, notify: true })
                            notificationService.success("Thao tác thành công");
                        } else {
                            notificationService.warning('Chưa có ID order')
                        }
                    })
                }
            }

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
