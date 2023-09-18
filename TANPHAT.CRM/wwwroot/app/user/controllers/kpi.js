(function () {
    app.controller('User.kpi', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService', '$uibModal', 'dayOfWeekVN','reportService',
        function ($scope, $rootScope, $state, viewModel, notificationService, userService, $uibModal, dayOfWeekVN, reportService) {
            var vm = angular.extend(this, viewModel);

            //declare
            vm.isSaving = false;
            vm.listMonth = [];
            vm.listWeek = [];
            vm.month = vm.params.month;
            vm.thisMonth = moment(vm.params.month, 'YYYY-MM').format("MM/YYYY");
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.SalePointID = 0;
            vm.checkStaff = $rootScope.sessionInfo.IsStaff ? true : false;
            vm.staffId = $rootScope.sessionInfo.IsStaff ? $rootScope.sessionInfo.UserId : 0;

          

            ///listTaget

            if (vm.listTaget) {
                vm.listTaget.TargetKPI = JSON.parse(vm.listTaget.TargetKPI);
                vm.listTaget.TargetKPILeader = JSON.parse(vm.listTaget.TargetKPILeader)
                vm.listTaget.TargetMasterLevel = JSON.parse(vm.listTaget.TargetMasterLevel)
                vm.listTaget.TargetMasterLevelData = JSON.parse(vm.listTaget.TargetMasterLevelData)
            }
            vm.listOfUserTitle = [
                { Id: 5, Name: "Nhân viên", isGetSP: false, listSelected: [], listUser: [], listKPI: vm.listTaget.TargetKPI },
                { Id: 4, Name: "Trưởng nhóm", isGetSP: true, listSelected: [], listUser: [], listKPI: vm.listTaget.TargetKPILeader },
            ]

            vm.returnKPIPoint = function (list, value) {
                var temp = list.filter(x => (x.minTarget < value && value <= x.maxTarget));
                if (!temp || temp.length == 0) {
                    return 0;
                } else {
                    return temp[0].commission;
                }
            }

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

            vm.handleFilterEmployee = function (startDate) {
                var monthAndYearObject = moment(startDate, 'YYYY-MM');
                var currentSelectObject = moment(vm.month, 'YYYY-MM');
                return monthAndYearObject.toDate() <= currentSelectObject.toDate();
            }

            vm.changeTab = function (tabId) {
                vm.currentTab = vm.listWeek.filter(x => x.WeekId == tabId)[0];
            };
            vm.changeUserTitle = function (Id) {
                vm.CoreIndex = vm.listOfUserTitle.findIndex(x => x.Id == Id);
                vm.selectedUserTitleId = vm.listOfUserTitle[vm.CoreIndex];

            }

            vm.listSalePointDropDown.unshift({
                Id: 0,
                Name: "All"
            })
            vm.changeSalePoint = function (Id) {
                vm.SalePointID = Id
            }
            vm.onChangeValue = function (type) {
                if (parseInt(type.Point) > type.MaxValue) {
                    type.Point = type.MaxValue;
                }
            }
            /*vm.listOfUserTitle.forEach(function (res1) {
                res1.listUser.forEach(function (res2) {
                    res2.ListSalePoint.forEach(function (res3) {
                        res3.listWeek.forEach(function (res4) {
                            res4.listSelected.Point = null;
                        })
                    })
                })
            })*/
            vm.getTotalUser = function (indexType, indexUser, indexSalePoint) {
                var temp = vm.listOfUserTitle[indexType].listUser[indexUser].ListSalePoint[indexSalePoint];
                var sum = {
                    Point: 0,
                    Num: 0,
                    AVG: 0.0
                }
                temp.listWeek.forEach(function (week) {
                    var isGet = true
                    week.Sum = 0
                    if (week.check) {
                        week.listSelected.forEach(function (type) {
                            var p = angular.copy(type.Point * type.Coef);
                            //if (parseInt(p) > 0) {
                            sum.Point += parseInt(p) ;
                            week.Sum += parseInt(p);
                        
                                if (isGet) {
                                    /*sum.Num += 1;*/
                                    isGet = false;
                                }
                            // }
                        })
                        sum.Num = sum.Num + 1
                    } 
                    /*if (week.Sum > 0) { sum.Num = sum.Num + 1 }*/
                })
                if (sum.Num > 0) {
                    sum.AVG = Math.round((sum.Point / sum.Num) * 100) / 100
                }
                vm.listOfUserTitle[indexType].listUser[indexUser].ListSalePoint[indexSalePoint].SumInfo = sum;
            }

            vm.init = function () {
                // INIT MONTH
                var { startDate, endDate } = getDayFunction(vm.params.month);
                while (moment(startDate) <= moment(endDate)) {
                    vm.listMonth.push({
                        Date: startDate,
                        DateName: vm.dayOfWeekVN[moment(startDate).day()].SName,
                        IsWeekEnd: moment(startDate).day() == 0,
                        typeDate: moment(startDate).day(),
                    })
                    startDate = moment(startDate, "YYYY-MM-DD").add(1, 'day').format("YYYY-MM-DD");
                }
                // INIT WEEK
                var weekId = 1;
                var currentWeek;
                //
                var thisWeek = 1;


                console.log("vm.listMonth",vm.listMonth)

                vm.listMonth.forEach(function (date, index) {
                    console.log("vm.listWeek", vm.listWeek.length);
                        if (!currentWeek) {
                            currentWeek = {};
                            currentWeek.from = date;
                            currentWeek.WeekId = weekId;
                            currentWeek.Index = weekId - 1;
                            weekId++;
                            currentWeek.check = true;
                            currentWeek.month = moment(date.Date).format("YYYY-MM");
                    }
                    console.log("date.typeDate ",date.typeDate )
                    if (date.typeDate == 0 || index == (vm.listMonth.length - 1)) {
                      
                        currentWeek.to = date;
                        currentWeek.NameDislay = (moment(currentWeek.from.Date, 'YYYY-MM-DD').format('DD/MM')) + ' -> ' + (moment(currentWeek.to.Date, 'YYYY-MM-DD').format('DD/MM'))

                        vm.listWeek.push(currentWeek);
                        console.log("currentWeek", currentWeek)

                        if (moment().isBetween(currentWeek.from.Date, currentWeek.to.Date)) {
                            thisWeek = currentWeek.WeekId;
                        }

                        currentWeek = null;
                    }
                })

                //INIT USER
                //1
                vm.listOfUserTitle.forEach(function (typeUser, typeIndex) {
                    typeUser.listUser = vm.listUser.filter(x => x.UserTitleId == typeUser.Id);
                    typeUser.listSelected = vm.listTitle.filter(x => x.UserTitleId == typeUser.Id);
                    typeUser.listSelected.forEach(function (ele) {
                        ele.Point = 0;
                        ele.PointBK = 0;
                    })
                    var index = 0;
                    //2
                    typeUser.listUser.forEach(function (user) {
                        user.index = index;
                        index+=1;
                        if (user.ListSalePoint && user.ListSalePoint.length > 0) {
                            user.ListSalePoint = JSON.parse(user.ListSalePoint);
                        } else {
                            var data = vm.listData.filter(x => x.UserId == user.UserId)
                            user.ListSalePoint = [{
                                SalePointId: data && data.length>0 ? data[0].SalePointId : null,
                                SalePointName: data && data.length > 0 ? data[0].SalePointName: '',
                                /*SalePointId: 0,
                                SalePointName: "TP0",*/
                            }]
                        }

                        //3
                        user.ListSalePoint.forEach(function (salepoint, salepointIndex) {
                            salepoint.listWeek = angular.copy(vm.listWeek);
                            //4
                            salepoint.listWeek.forEach(function (week) {
                                vm.listExemptKpi.forEach(function (item) {
                                    if (item.Month == week.month && item.UserId == user.UserId && item.WeekId == week.WeekId) {
                                        week.check = item.IsSumKpi
                                    }
                                })
                                week.listSelected = angular.copy(typeUser.listSelected);
                                //Add Data
                                //5
                                week.listSelected.forEach(function (type) {
                                   
                                    var gData = vm.listData.filter(x => x.UserId == user.UserId && x.WeekId == week.WeekId && x.CriteriaId == type.CriteriaId && x.SalePointId == salepoint.SalePointId);
                                    
                                 if (gData && gData.length > 0) {
                                        type.Point = gData[0].KPI;
                                        type.PointBK = gData[0].KPI;
                                    }

                                })

                                //Dung BK data de check thay doi
                            })

                            /*vm.getTotalUser(typeIndex, user.index, salepointIndex, week.check);*/
                            vm.getTotalUser(typeIndex, user.index, salepointIndex);
                        })
                    })

                });

                vm.changeTab(thisWeek);
                vm.changeUserTitle(5);
            }

            vm.init();
            console.log("listWeek", vm.listWeek)
            vm.getDataSave = function () {
                var temp = [];
                vm.listOfUserTitle.forEach(function (typeOf) {
                    typeOf.listUser.forEach(function (user) {
                        user.ListSalePoint.forEach(function (salepoint) {
                            salepoint.listWeek.forEach(function (week) {
                                week.listSelected.forEach(function (type) {
                                    if (parseInt(type.Point) != type.PointBK) {
                                        temp.push({
                                            UserId: user.UserId,
                                            KPI: type.Point,
                                            SalePointId: salepoint.SalePointId,
                                            WeekId: week.WeekId,
                                            CriteriaId: type.CriteriaId,
                                            Month: moment(vm.month).format('YYYY-MM')
                                        })
                                    }
                                })
                            })
                        })
                    })
                })

                return temp;
            }

            vm.update = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',

            }
     
            vm.save = function () {
                vm.isSaving = true;
                var a = vm.getDataSave();
                if (a != []) {
                    vm.update.Data = JSON.stringify(a);
                    userService.updateListKPI(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                                $state.reload();
                                vm.isSaving = false;
                            }, 1000)
                        } else {
                            notificationService.warning(res.Message);
                            vm.isSaving = false;
                        }
                    })
                } else {
                    notificationService.warning("Chưa có thay đổi");
                    vm.isSaving = false;
                }
            }
            vm.checkAll = function (userId, weekId, month, check) {
                vm.dataUpdate = {
                    UserId: userId,
                    WeekId: weekId,
                    Month: month,
                    isdeleted: check
                }
                vm.IsChecked = !vm.IsChecked
                reportService.updateIsSumKpi(vm.dataUpdate)
            }

        }]);
})();