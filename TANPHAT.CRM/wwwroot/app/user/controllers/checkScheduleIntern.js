(function () {
    app.controller('User.checkScheduleIntern', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService', 'dayOfWeekVN', 'shiftStatus', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, userService, dayOfWeekVN, shiftStatus, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.isSaving = false;
            var formatMonth = ['MM-YYYY', 'YYYY-MM'];

            $scope.$on('$locationChangeStart', function( event ) {
                var answer = confirm("Dữ liệu có thể mất nếu bạn chưa lưu lại!!!")
                if (!answer) {
                    event.preventDefault();
                }
            });

            vm.month = vm.params.distributeMonth;
            vm.thisMonth = moment(vm.month, 'YYYY-MM').format("MM/YYYY");
            vm.listMonth = [];

            vm.listStatus = angular.copy(shiftStatus);
            vm.isCanChangeData = $rootScope.sessionInfo.UserTitleId == 1 || (currentEvi != 'pro' ? true : $rootScope.sessionInfo.UserTitleId == 6);
            vm.isCanFixData = $rootScope.sessionInfo.UserTitleId == 1 || currentEvi != 'pro';

            /*vm.isCanChangeData = $rootScope.sessionInfo.UserTitleId == 1 || (currentEvi != 'local' ? true : $rootScope.sessionInfo.UserTitleId == 6);
            vm.isCanFixData = $rootScope.sessionInfo.UserTitleId == 1 || currentEvi != 'local';*/

            vm.isCheckMonth = function (model = {}, shift, isMain = false) {
                //var tBegin = shift == 1 ? "06:00:00" : "13:30:00";

                var tBegin = shift == 1 ? "13:30:00" : "23:59:59";
                if (isMain) {
                    return vm.isCanFixData|| moment().diff(moment(vm.month + '-01 ' + tBegin, 'YYYY-MM-01 HH:mm:ss')) < 0;
                }
                return vm.isCanFixData || moment().diff(moment(model.DistributeDate + ' ' + tBegin, 'YYYY-MM-DD HH:mm:ss')) < 0;
                //true allow
            }

            vm.objStaff = {};
            vm.objStatus = {};

            vm.listStaff.forEach(function (item) {
                vm.objStaff[item.Id.toString()] = item.Name;
            })
            console.log("vm.listStaff", vm.listStaff);
            console.log("vm.listSalePoint", vm.listSalePoint);
            vm.listStatus.forEach(function (item) {
                vm.objStatus[item.Id.toString()] = item.SName;
            })

            vm.distributeInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                Month: vm.params.distributeMonth
            };


            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.loadData = function () {
                vm.params.distributeMonth = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            //Algorithm
            vm.getSaveData = function () {
                var temp = [];
                vm.listSalePoint.forEach(function (salePoint) {
                    var temp1 = {
                        SalePointId: salePoint.Id
                    }
                    temp1.MainShift = {
                        inputShift_1: salePoint.inputShift_1,
                        inputShift_2: salePoint.inputShift_2,
                        inputIntern: salePoint.inputIntern
                    }
                    temp1.ShiftData = [];
                    salePoint.listMonth.forEach(function (ele) {
                        for (let i = 1; i <= 2; i++) {
                            var user = null;
                            var getTarget = ele['objShift' + i].isShift1 ? 1 : 2;
                            if (ele['Shift' + getTarget]) {
                                user = ele['Shift' + getTarget];
                            } else {
                                user = salePoint['inputShift_' + getTarget];
                            }
                            if (user) {
                                var temp2 = {
                                    ShiftId: i,
                                    UserId: user,
                                    DistributeDate: ele.DistributeDate,
                                    ShiftTypeId: ele['ShiftTypeId' + getTarget],
                                    Note: ele['Note' + getTarget]
                                }
                                temp1.ShiftData.push(temp2)
                            }
                        }
                    })
                    if (temp1.ShiftData.length > 0) {
                        temp.push(temp1);
                    }

                })
                return temp;

            }

            vm.getShiftMain = function () {
                var list = [];
                var temp = [];
                vm.listSalePoint.forEach(function (salePoint) {
                    try {
                        if (salePoint.ShiftMain.inputShift_1) {
                            list.push(salePoint.ShiftMain.inputShift_1);
                        }
                    } catch (err) { }
                    try {
                        if (salePoint.ShiftMain.inputShift_2) {
                            list.push(salePoint.ShiftMain.inputShift_2);
                        }
                    } catch (err) { }
                    try {
                        if (salePoint.ShiftMain.inputIntern) {
                            list.push(salePoint.ShiftMain.inputIntern);
                        }
                    } catch (err) { }
                })
                $.each(list, function (i, el) {
                    if ($.inArray(el, temp) === -1) temp.push(el);
                });
                return temp;
            }

            vm.checkNotIncludes = function (value, arr) {
                return !arr.includes(value)
            }

            vm.getExtendUser = function () {
                var temp = [];
                var list = [];
                vm.fullListData.forEach(function (item) {
                    var temp1 = item.ShiftData.filter(function (x) {
                        return vm.checkNotIncludes(x.UserId, vm.listMainShift)
                    })
                    if (temp1.length > 0) {
                        temp1.forEach(function (x) {
                            list.push(x.UserId);
                        })
                    }
                })
                $.each(list, function (i, el) {
                    if ($.inArray(el, temp) === -1) temp.push(el);
                });
                return temp;
            }

            vm.getMonthOfWork = function (UserId, getFull = true) {
                var listWork = [];
                var len = 0;
                vm.listMonth.forEach(function (date) {
                    listWork.push({
                        Day: date.DistributeDate,
                        Working: []
                    })
                })

                vm.fullListData.forEach(function (salepoint) {
                    var listWorkingInMonth = salepoint.ShiftData.filter(function (x) {
                        if (x.UserId == UserId) {
                            x.SalePointId = salepoint.SalePointId;
                            x.target = parseInt(x.DistributeDate.slice(8, 10)) - 1;
                            return x;
                        }
                    });

                    if (listWorkingInMonth.length > 0) {
                        //Get Total Shift 
                        len += listWorkingInMonth.length;
                        listWorkingInMonth.forEach(function (item) {
                            listWork[item.target].Working.push(item);
                        })
                    }
                });
                //Get Total Off 
                var OffNumber = listWork.filter(x => x.Working.length == 0).length;

                var TotalOT = 0;
                if (getFull) {
                    var tempOff = angular.copy(OffNumber);
                    //Add overtime
                    listWork.forEach(function (date) {
                        if (date.Working.length >= 2) {
                            var item = date.Working;
                            for (let i = 1; i < item.length; i++) {
                                if (tempOff > 0) {
                                    //Add label off
                                    item[i].ShiftTypeId = 2;
                                    tempOff--;
                                } else {
                                    //Add label overtime
                                    item[i].ShiftTypeId = 3;
                                    TotalOT++;
                                }
                                var tempSalePoint = vm.listSalePoint.filter(x => x.Id == item[i].SalePointId)[0];

                                var thisTaget = tempSalePoint.listMonth[item[i].target]['objShift' + item[i].ShiftId].isShift1 ? 1 : 2;

                                tempSalePoint.listMonth[item[i].target]["ShiftTypeId" + thisTaget] = item[i].ShiftTypeId;
                            }
                        }
                    })
                }

                //push 
                vm.listAttend.push({
                    UserId: UserId,
                    TotalShift: len,
                    TotalAbsent: getFull ? OffNumber : 0,
                    TotalMakeup: getFull ? (OffNumber - tempOff) : 0,
                    TotalOT: TotalOT,
                    IsMainShift: getFull
                })
            }

            vm.restartShiftType = function () {
                vm.listSalePoint.forEach(function (salePoint) {
                    salePoint.listMonth.forEach(function (date) {
                        date.ShiftTypeId1 = 1;
                        date.ShiftTypeId2 = 1;
                    })
                })
            }

            vm.checkFullSchedule = function () {
                vm.listAttend = [];
                vm.restartShiftType();
                //Get list user
                vm.listMainShift = vm.getShiftMain();
                //list full data 
                vm.fullListData = vm.getSaveData();
                //list NotIn mainShiftSalesPoint 
                vm.listExtend = vm.getExtendUser();

                vm.listMainShift.forEach(function (userId) {
                    vm.getMonthOfWork(userId);
                })

                vm.listExtend.forEach(function (userId) {
                    vm.getMonthOfWork(userId, false);
                })
            }



            //End...algorithm
            vm.openPopup = function (shift, model = {}, list = {}, shiftDistributeId, isApplyAll= false) {
                var user = null;

                //getName
                var getTarget = model['objShift' + shift].isShift1 ? 1 : 2;

                if (model['Shift' + getTarget]) {
                    user = model['Shift' + getTarget];
                } else {
                    user = list['inputShift_' + getTarget];
                }

                var listStaff = angular.copy(vm.listStaff);
                //Get status
                if (true) {
                    //if (user) {
                    var viewPath = baseAppPath + '/user/views/modal/';
                    var modalHistoryLog = $uibModal.open({
                        templateUrl: viewPath + 'shiftDetail.html' + versionTemplate,
                        controller: 'User.shiftDetail as $vm',
                        backdrop: 'static',
                        size: 'md',
                        windowClass: 'remove-modal-footer',
                        resolve: {
                            viewModel: {
                                userOnShift: {
                                    name: model.name,
                                    userId: user,
                                },
                                note: model["Note" + getTarget],
                                shift: shift,
                                salePointId: list.Id,
                                distributeDate: model.DistributeDate,
                                listStaff: listStaff,
                                isIntern: true,
                                ShiftDistributeId: shiftDistributeId
                            }
                        }
                    });

                    modalHistoryLog.opened.then(function (res) {
                        $(document).ready(function () {
                            $('.modal-footer').addClass('remove-modal-footer');
                        });
                    });

                    modalHistoryLog.result.then(function (data) {

                    }, function (data) {
                        if (typeof (data) == 'object') {
                            //$state.reload();
                            //add modal


                            var getIndex = list.listMonth.findIndex(x => x.DistributeDate == model.DistributeDate);

                            for (let i = getIndex; i < (data.isApplyAll ? list.listMonth.length : getIndex+1); i++) {
                                list.listMonth[i]['Shift' + getTarget] = data.UserId;
                                list.listMonth[i]['Note' + getTarget] = data.Note;
                                list.listMonth[i]['ShiftTypeId' + getTarget] = data.ShiftTypeId;


                                var getUserName = vm.listStaff.filter(staff => staff.Id == data.UserId);
                                var status = vm.listStatus.filter(x => x.Id == data.ShiftTypeId)[0];
                                if (getUserName.length > 0) {
                                    list.listMonth[i]['objShift' + shift].isChangeData = true;

                                    list.listMonth[i]['objShift' + shift].Name = getUserName[0].Name;
                                } else {
                                    list.listMonth[i]['objShift' + shift].Name = "Không tìm thấy người dùng";
                                }
                                shift = shift == 1 ? 2 : 1;
                            }



                            var getDate = list.listMonth.findIndex(x => x.DistributeDate == model.DistributeDate);
                            /*   vm.exec(shift, getDate);
                               vm.listDateInMont[getDate].isDup = false
                               vm.checkFullSchedule();*/
                            vm.checkDupValueAll();
                        }
                    });
                } else {
                    notificationService.warning("Chưa chia nhân viên cố định cho điểm bán");
                }

            }

            vm.openDayOffLeader = function (model = {}) {
                var viewPath = baseAppPath + '/user/views/modal/';
                var modalHistoryLog = $uibModal.open({
                    templateUrl: viewPath + 'addLeaderOff.html' + versionTemplate,
                    controller: 'User.addLeaderOff as $vm',
                    backdrop: 'static',
                    size: 'md',
                    windowClass: 'remove-modal-footer',
                    resolve: {
                        viewModel: {
                            date: model,
                            listLeader: vm.listLeader
                        }
                    }
                });

                modalHistoryLog.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-footer').addClass('remove-modal-footer');
                    });
                });

                modalHistoryLog.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {
                        model = angular.extend(model, data);
                    }
                });
            }
            ///checkDupValue...start

            vm.getIdTarget = function (salePoint, shift, date) {
                var target = vm.listSalePoint[salePoint].listMonth[date]['objShift' + shift].isShift1 ? 1 : 2;
                if (vm.listSalePoint[salePoint].listMonth[date]["Shift" + target]) {
                    return vm.listSalePoint[salePoint].listMonth[date]["Shift" + target]
                }
                if (vm.listSalePoint[salePoint]["inputShift_"+ target]) {
                    return vm.listSalePoint[salePoint]["inputShift_" + target]
                }
                return null;
            }
            vm.checkDupValue = function (thisSalePoint, shift, date) {
                var thisUserId = vm.getIdTarget(thisSalePoint, shift, date);
                if (thisUserId) {
                    for (let salePoint =  (thisSalePoint + 1) ; salePoint < vm.listSalePoint.length; salePoint++) {
                        if (thisSalePoint != salePoint) {
                            UserId = vm.getIdTarget(salePoint, shift, date);

                            if (UserId && UserId == thisUserId) {
                                vm.listSalePoint[salePoint].listMonth[date]['objShift' + shift].isDup = true;
                                vm.listSalePoint[thisSalePoint].listMonth[date]['objShift' + shift].isDup = true;
                                vm.listDateInMonth[date].isDup = true;
                                vm.totalDup++;
                                break;
                            }
                        }

                    }
                }
            }

            vm.exec = function (shift, date) {
                for (let salePoint = 0; salePoint < vm.listSalePoint.length - 1; salePoint++) {
                    vm.listSalePoint[salePoint].listMonth[date]['objShift' + shift].isDup = false;

                }
                for (let salePoint = 0; salePoint < vm.listSalePoint.length - 1; salePoint++) {
                    vm.checkDupValue(salePoint, shift, date);
                }
            }
            vm.checkDupValueAll = function () {
                vm.totalDup = 0;
                var { startDate, endDate } = getDayFunction(vm.month);
                var endDate = parseInt(endDate.slice(8, 10))
                for (let date = 0; date < endDate; date++) {
                    vm.listDateInMonth[date].isDup = false;
                    for (let shift = 1; shift <= 2; shift++) {
                        vm.exec(shift, date);
                    }
                }
                vm.checkFullSchedule()
            }
            ///checkDupValue...end
            vm.initData = function () {
                vm.listMonth = [];
                var { startDate, endDate } = getDayFunction(vm.month);
                var currentDate = startDate;
                /// init listMonth
                while (moment(currentDate) <= moment(endDate)) {
                    var temp = moment(currentDate).format('YYYY-MM-DD');
                    //Add Holiday
                    var holiday = vm.listHoliday.filter(x => moment(x.Date).format('YYYY-MM-DD') == temp);
                    var isHoliday = false;
                    if (holiday && holiday[0]) {
                        isHoliday = true
                    }
                    vm.listMonth.push({
                        DistributeDate: temp,
                        IsChecked: false,
                        IsWeekEnd: moment(temp).day() == 0,
                        DateName: vm.dayOfWeekVN[moment(temp).day()].SName,

                        //HOLIDAY
                        IsHoliday: isHoliday,
                        Tooltip: isHoliday ? holiday[0].DateName : ''
                    })
                    currentDate = moment(currentDate).add(1, 'day');
                }

                vm.listEvent = [];
                /// init listSalePoint
                vm.listSalePoint.forEach(function (item) {
                    item.inputShift_1 = null;
                    item.inputShift_2 = null;
                    var temp = angular.copy(vm.listMonth);
                    temp.forEach(function (ele, index) {
                        ele.objShift1 = {};
                        ele.objShift2 = {};
                        ele.ShiftTypeId1 = 1;
                        ele.ShiftTypeId2 = 1;
                        ele.objShift1.isShift1 = (index % 2 == 1);
                        ele.objShift2.isShift1 = (index % 2 == 0);
                    })
                    //temp[0].objShift1.isChangeValue = true;
                    //temp[temp.length - 1].objShift2.isChangeValue = true;
                    item.listMonth = temp;
                })
                /// init listDistributelistDistribute
                // 
                vm.listDistribute = vm.listDistribute.filter(x => x.IsActive== true);
                var temp = Enumerable.From(vm.listDistribute)
                    .GroupBy(function (item) { return item.SalePointId; })
                    .Select(function (item, i) {
                        return {
                            "ShiftDistributeId": item.source[0].ShiftDistributeId,
                            "SalePointId": item.source[0].SalePointId,
                            "ShiftMain": item.source[0].ShiftMain,
                            "Data": item.source,
                        };
                    })
                    .ToArray();
                
                if (temp.length > 0) {
                    temp.forEach(function (item) {
                        var target = vm.listSalePoint.findIndex(x => x.Id === item.SalePointId);
                        var salePoint = vm.listSalePoint[target];
                        
                        item.Data.forEach(function (tem) {
                            salePoint.listMonth.forEach(function (res) {
                                if (res.DistributeDate == moment(tem.DistributeDate).format("YYYY-MM-DD")) {
                                    res.ShiftDistributeId = tem.ShiftDistributeId;
                                }
                            })
                        })
                        
                        if (item.ShiftMain) {
                            salePoint.ShiftMain = JSON.parse(item.ShiftMain);
                            salePoint.inputShift_1 = salePoint.ShiftMain.inputShift_1;
                            salePoint.inputShift_2 = salePoint.ShiftMain.inputShift_2;
                        }
                        item.Data.forEach(function (ele) {
                            var targetDay = salePoint.listMonth.findIndex(x => x.DistributeDate == moment(ele.DistributeDate).format("YYYY-MM-DD"));
                            var day = salePoint.listMonth[targetDay];
                            ////////
                            //Check change value?
                            var shiftId = day['objShift' + ele.ShiftId].isShift1? 1:2;

                            if (salePoint["inputShift_" + shiftId] != ele.UserId) {
                                day["Shift" + shiftId] = ele.UserId;
                                day["ShiftTypeId" + shiftId] = ele.ShiftTypeId;
                                day["Note" + shiftId] = ele.Note;

                                var getUserName = vm.listStaff.filter(staff => staff.Id == ele.UserId);
                                var status = vm.listStatus.filter(x => x.Id == ele.ShiftTypeId)[0];
                                if (getUserName.length > 0) {
                                    //add objShift1 --> changeValue
                                    
                                    day['objShift' + ele.ShiftId].isChangeData = true;

                                    day['objShift' + ele.ShiftId].ShiftDistributeId = ele.ShiftDistributeId;

                                    day['objShift' + ele.ShiftId].Name = getUserName[0].Name ;
                                } else {
                                    day['objShift' + ele.ShiftId].Name = "Không tìm thấy người dùng";
                                }
                            }
                        })
                    })
                }

                vm.listDateInMonth = angular.copy(vm.listMonth);

                //Leader Off
                if (vm.listLeader && vm.listLeader.length > 0) {
                    vm.listLeader.forEach(function(leader) {
                        leader.DataSearch = leader.Name.toUnaccent()
                    })
                }
                vm.listDateOff = angular.copy(vm.listMonth);

                if (vm.listLeaderOff && vm.listLeaderOff.length > 0) {
                    vm.listLeaderOff.forEach(function (leader) {
                        var temp = vm.listDateOff.findIndex(x => x.DistributeDate == moment(leader.Date).format("YYYY-MM-DD"));
                        leader.Name = leader.FullName;
                        if (temp > 0) {
                            vm.listDateOff[temp] = angular.extend(vm.listDateOff[temp], leader);

                        }
                    })
                }

            }

            vm.initData();

            vm.checkDateDup = function (dateId) {
                var result = false;
                vm.listSalePoint.forEach(function (item) {
                    if (item.listMonth[dateId].objShift1.isDup || item.listMonth[dateId].objShift2.isDup) {
                        result = true;
                    }
                })
                return result;
            }

            vm.checkCurrentDate = function (dateId) {
                var curentDate = moment().format("YYYY-MM-DD");
                var indexCurentDate = parseInt(curentDate.slice(8)) - 1;
                var currentMonthYear = curentDate.slice(0, 7);
                if (dateId == indexCurentDate && vm.month == currentMonthYear)
                    return true;
                else
                    return false;
            }

            vm.checkDupValueAll();
            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }

            vm.save = function () {
                vm.isSaving = true;
                if (vm.totalDup == 0 || currentEvi != 'pro') {
                    vm.listSave = vm.getSaveData();
                    vm.distributeInfo.DistributeData = JSON.stringify(vm.listSave);
                    vm.distributeInfo.AttendanceData = JSON.stringify(vm.listAttend);
                    if (vm.listSave.length == 0) {
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 1000)
                        notificationService.warning("Chưa có thông tin để lưu")
                    } else {
                        userService.updateShiftDistributeForIntern(vm.distributeInfo).then(function (res) {
                            if (res && res.Id > 0) {

                                setTimeout(function () {
                                    notificationService.success(res.Message);
                                    $state.reload();
                                    vm.isSaving = false;
                                }, 1000)

                            } else {
                                vm.isSaving = false;
                                notificationService.error(res.Message);
                            }
                        });
                    }
                } else {
                    setTimeout(function () {
                        vm.isSaving = false;
                        $rootScope.$apply(vm.isSaving);
                    }, 1000)
                    notificationService.warning("Đang có trùng ca");
                }

            }

            $(document).ready(function () {
                $(".select2-drop").css("position", "sticky");
                //init tooltip
                $('.tooltips').append("<span></span>");
                $(".tooltips").mouseenter(function () {
                    $(this).find('span').empty().append($(this).attr('tooltip'));
                });
                setTimeout(function () {
                    $(".table-responsive").animate({ scrollLeft: (parseInt(moment().format('DD')) - 1) * 200 }, 400);
                }, 500)
            });

            vm.checkFullSchedule()

            vm.clickMonth = function (month) {
                vm.month = moment().add(month, 'month').format('YYYY-MM');
                vm.loadData();
            }

        }]);
})();