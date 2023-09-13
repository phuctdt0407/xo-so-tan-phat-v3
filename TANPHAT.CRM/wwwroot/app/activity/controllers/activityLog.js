(function () {
    app.controller('Activity.activityLog', ['$scope', '$uibModal', '$rootScope', '$state', 'authService', 'notificationService', 'viewModel', 'reportService', 'salepointService', 'activityService',
        function ($scope, $uibModal, $rootScope, $state, authService, notificationService, viewModel, reportService, salepointService, activityService) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            vm.userInfo = {
                UserId: $rootScope.sessionInfo.UserId
            };
            vm.totalRow = vm.listSold && vm.listSold.length > 0 ? vm.listSold[0].TotalCount : 0;

            vm.totalConfirming1 = 0;

            vm.init = function () {
                vm.listTrans.forEach(function (item) {
                    item.totalConfirming1 = 0;
                    item.detail = item.DetailData ? JSON.parse(item.DetailData) : []

                    if (item.ConfirmStatusId == 1) {
                        vm.totalConfirming1++;
                    }
                })

                /*vm.listSold.forEach(function (item) {
                    item.detail = item.DetailData ? JSON.parse(item.DetailData) : []

                    item.detail.forEach(function (item1) {
                        item1.ShortName = '';
                        vm.listLottery.forEach(function (item2) {
                            if (item1.LotteryChannelId == item2.Id) {
                                item1.ShortName = item2.ShortName;
                            }
                        })
                    })
                })*/

                vm.listSold.forEach(function (item) {
                    item.detail = item.Data ? JSON.parse(item.Data) : []
                })

                vm.listSold = vm.listSold.filter(x => x.detail.SalePointLogData && x.detail.SalePointLogData.length > 0)

                console.log("vm.listSold", vm.listSold);
                vm.listSold.forEach(function (item, index) {
                    item.TotalQuantity = 0
                    item.RowNumber = index+1
                    item.TotalPrice = 0
                    item.detail.SalePointLogData.forEach(function (item1) {
                        item1.ShortName = '';
                        vm.listLottery.forEach(function (item2) {
                            if (item1.LotteryChannelId == item2.Id) {
                                item1.ShortName = item2.ShortName;
                            }else{
                            
                            }
                        })
                        item.TotalQuantity += item1.Quantity
                        item.TotalPrice += item1.TotalValue
                    })
                })

                vm.listTrans.forEach(function (item) {
                    item.detail.forEach(function (item1) {
                        item1.ShortName = '';
                        vm.listLottery.forEach(function (item2) {
                            if (item1.LotteryChannelId == item2.Id) {
                                item1.ShortName = item2.ShortName;
                            }
                        })
                    })
                })

                vm.listWinning.forEach(function (item) {
                    item.ShortName = '';
                    vm.listLottery.forEach(function (item2) {
                        if (item.LotteryChannelId == item2.Id) {
                            item.ShortName = item2.ShortName;
                        }
                    })
                })

            }
            vm.init();

            vm.getBootBox = function (model) {
                var message = ''
                if (confirm) {
                    message = ' <i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa vé?'
                } else {
                    message = ' <i class="fa fa-times fa-lg" aria-hidden="true" style="color: red;"></i> Bạn muốn <strong>huỷ yêu cầu</strong> chuyển/nhận vé?'
                };

                var dialog = bootbox.confirm({
                    message,
                    size:"small",
                    buttons: {
                        confirm: {
                            label: 'Đồng ý',
                            className: 'btn-success',
                        },
                        cancel: {
                            label: 'Huỷ',
                            className: 'btn-secondary'
                        }
                    },
                    callback: function (res) {
                        setTimeout(function () {
                            // $('.modal-lg').css('display', 'block');
                        }, 500);


                        if (res) {
                            vm.deleteData(model);
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').css('height','')
                        // $('.modal-lg').css('display', 'none')
                    }, 0);
                });
            }

            vm.getBootBoxWinnning = function (model) {
                var message = '<i class="fa fa-check fa-lg" aria-hidden="true" style="color: green;"></i> Bạn có <strong>xác nhận</strong> xóa trả thưởng?'

                var dialog = bootbox.confirm({
                    message,
                    size: "small",
                    buttons: {
                        confirm: {
                            label: 'Đồng ý',
                            className: 'btn-success',
                        },
                        cancel: {
                            label: 'Huỷ',
                            className: 'btn-secondary'
                        }
                    },
                    callback: function (res) {
                        setTimeout(function () {
                            // $('.modal-lg').css('display', 'block');
                        }, 500);

                        if (res) {
                            vm.deleteWinning(model);
                        }

                    }
                });

                dialog.init(function () {
                    setTimeout(function () {
                        $('.modal-body').css('height', '')
                        // $('.modal-lg').css('display', 'none')
                    }, 0);
                });
            }
            
            vm.deleteData = function (model) {
                vm.deleteRow = {
                    ActionBy: $rootScope.sessionInfo.UserId,
                    ActionByName: $rootScope.sessionInfo.FullName,
                    Data: JSON.stringify({
                        ActionType: 3,
                        HistoryOfOrderId: model.HistoryOfOrderId,
                    })
                }

                salepointService.updateHistoryOrder(vm.deleteRow).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            notificationService.success(res.Message);
                            $state.reload();
                            vm.isSaving = false;
                        }, 200)
                    } else {
                        vm.isSaving = true;
                    }
                })
            }

            vm.deleteWinning = function (model) {
                var deleteRow = {
                    ActionBy: $rootScope.sessionInfo.UserId,
                    ActionByName: $rootScope.sessionInfo.FullName,
                    WinningId: model.WinningId
                }
                activityService.deleteLogWinning(deleteRow).then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            notificationService.success(res.Message);
                            $state.reload();
                            vm.isSaving = false;
                        }, 200)
                    } else {
                        vm.isSaving = true;
                    }
                })
            }
            var resultCompareChannel = [
                {
                    dayId:0 ,
                    name: 'Kon Tum'
                },
                {
                    dayId:1 ,
                    name: 'Thừa Thiên Huế'
                },

                {
                    dayId:2 ,
                    name: 'Đăk Lăk'
                },
                {
                    dayId:3 ,
                    name: 'Đà Nẵng'
                },
                {
                    dayId:4 ,
                    name: 'Quảng Trị'
                },
                {
                    dayId:5 ,
                    name: 'Ninh Thuận'
                },
                {
                    dayId:6 ,
                    name: 'Quảng Ngãi'
                },

            ]
            vm.printBill = function (model) {
                
                var ChannelName = ""
                var data = JSON.parse(model.Data)
                console.log("promotion code before",data.SalePointLogData[0].PromotionCode)
                var promotionCodeList = data.SalePointLogData[0].PromotionCode!=null?data.SalePointLogData[0].PromotionCode:[]
                var tempList = []
                promotionCodeList.forEach(ele=>{
                    switch (ele.length){
                        case 1:
                            ele = '0000'+ele;
                            break;
                        case 2:
                            ele = '000'+ele;
                            break;
                        case 3:
                            ele = '00'+ele;
                            break;
                        case 4:
                            ele = '0'+ele;
                            break;
                        default:
                           
                    }
                    tempList.push(ele)
                    console.log("check code",ele)
                })
                var promotionCode = tempList.length>0?tempList.join(' | \n'):''
                var temp =   data.SalePointLogData.filter(ele=>ele.LotteryDate != null && ele.LotteryDate != undefined );

                var listDate = temp.map(function(ele) {
                    return ele.LotteryDate;
                })

                var maxDate = moment.max(listDate.map(function(date) {
                    return moment(date,'YYYY-MM-DD');
                }));
                var minDate = moment.min(listDate.map(function(date) {
                    return moment(date,'YYYY-MM-DD');
                }));
                
                
                if(temp.find(ele=>moment(ele.LotteryDate,'YYYY-MM-DD').day() != moment().day()) ){
                    ///trong đơn hàng có vé ngày hôm khác 
                    console.log("case 1")
                    if(moment().day() == 6){
                        console.log("case 1.1")
                        ChannelName =  resultCompareChannel.find(ele=>ele.dayId == 0).name + ' ' + moment(maxDate).format('DD/MM/YYYY')
                    }else{
                        console.log("case 1.2")
                        ChannelName =  resultCompareChannel.find(ele=>(ele.dayId == moment().day() + 1)).name + ' ' + moment(maxDate).format('DD/MM/YYYY')
                    }
                }else{
                    ///trong đơn hàng chỉ có vé ngày hôm nay 
                    ChannelName = resultCompareChannel.find(ele=>(ele.dayId == moment().day())).name + ' ' + moment(minDate).format('DD/MM/YYYY')
                }
                
                var billData = {
                    FullAddress: vm.listSellData.SalePointAddress != null ? vm.listSellData.SalePointAddress : '',
                    SalePoint: vm.listSellData.SalePointName,
                    DatePrint: moment(model.CreatedDate).format('DD/MM/YYYY'),
                    ShiftName: vm.params.shiftId == 1 ? "Ca Sáng" : "Ca Chiều",
                    DateTime: moment().format('HH:mm:ss'),
                    BillNumber: $rootScope.createBillNumber(model.HistoryOfOrderId),
                    ActionName: $rootScope.sessionInfo.FullName,
                    CustomerName: model.detail.GuestData ? model.detail.GuestData.FullName : 'Khách lẻ',
                    ListInfo: [],
                    TotalQuatity: model.TotalQuantity,
                    Sum: model.TotalPrice,
                    CustomerGive: 0,
                    TotalDebt: 0,
                    OldDebt: model.LastData ? model.LastData.OldDebt : 0,
                    NewDebt: model.LastData ? model.LastData.NewDebt : 0,
                    PromotionCode: promotionCode,
                    ChannelName:  ChannelName
                }
                model.detail.SalePointLogData.forEach(function (item) {
                    billData.ListInfo.push({
                        LotteryName: item.ShortName,
                        Quantity: item.Quantity,
                        FourLastNumber: item.FourLastNumber ? (' --> ' + item.FourLastNumber) : '',
                        Price: item.TotalValue
                    })
                })
                if (model.detail.GuestActionData && model.detail.GuestActionData.length > 0) {
                    model.detail.GuestActionData.forEach(x => billData.CustomerGive += x.TotalPrice)
                } else {
                    billData.CustomerGive = billData.Sum
                }

                var typeGuest = model.detail.GuestData ? 2 : 1
                console.log("print bill")
                $rootScope.printBill(billData, typeGuest);
            }

            vm.changeTab = function (tabName) {
                vm.view = tabName;
                tabName == "paying-debt-content" ? vm.showSaveChange = true : vm.showSaveChange = false;
               
            };
            vm.changeTab('activity-log-content');

            vm.openDetail = function (model) {
                var viewPath = baseAppPath + '/activity/views/modal/';
                var modalTransfer = $uibModal.open({
                    templateUrl: viewPath + 'paymentDetail.html' + versionTemplate,
                    controller: 'Activity.paymentDetail as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', 'ddlService',
                            function ($q, ddlService) {
                                var deferred = $q.defer();
                                $q.all([
                                ]).then(function (res) {
                                    var result = {
                                        paymentData: model,
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    },
                });
                modalTransfer.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-body').removeClass("modal-body")
                    });
                });

                modalTransfer.result.then(function (data) {
                }, function (data) {
                    if (typeof (data) == 'object') {
                    }
                });
            }
            

        }]);
})();
