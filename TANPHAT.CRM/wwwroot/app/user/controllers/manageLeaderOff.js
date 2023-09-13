(function () {
    app.controller('User.manageLeaderOff', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService', '$uibModal','salepointService',
        function ($scope, $rootScope, $state, viewModel, notificationService, userService, $uibModal, salepointService) {
            var vm = angular.extend(this, viewModel);

            vm.isSaving = false;

            vm.listSalePoint.forEach(function (ele) {
                ele.SalePointId = ele.Id;
                ele.SalePointName = ele.Name;
            })
            if (vm.listLeader) {
                try {
                    vm.listData = JSON.parse(vm.listLeader[0].GroupSalePointData);
                    vm.listData.forEach(function (item) {
                        if (item.SalePointIds && JSON.parse(item.SalePointIds)) {
                            item.SalePointIds = JSON.parse(item.SalePointIds);
                        } else {
                            item.SalePointIds = []
                        }
                    })
                } catch (err) {
                    vm.listData = [];
                }

                try {
                    vm.listAttendent = JSON.parse(vm.listLeader[0].LeaderAttendentData);
                } catch (err) {
                    vm.listAttendent = [];
                }
            }


            if (vm.listSalePoint && vm.listSalePoint.length > 0) {
                vm.listSalePoint.sort((a, b) => (a.SalePointId - b.SalePointId));
            } 

            if (vm.listAttendent && vm.listAttendent.length > 0) {
                vm.maxOption = vm.listAttendent.sort((a, b) => (a.TriggerSalePoint - b.TriggerSalePoint))[vm.listAttendent.length-1].TriggerSalePoint;
            } else {
                vm.listAttendent = [];
                vm.maxOption = 0;
            }

            vm.pushUser = function () {
                vm.listUser.forEach(function (ele) {
                    var fIndex = vm.listAttendent.findIndex(x => x.UserId == ele.UserId);
                    if (fIndex < 0) {
                        vm.maxOption += 1;

                        vm.listAttendent.push({
                            UserId: ele.UserId,
                            FullName: ele.FullName,
                            TriggerSalePoint: vm.maxOption
                        })
                    } else {
                        vm.listAttendent[fIndex].FullName = ele.FullName;
                    }
                })

                vm.listAttendent.forEach(function (attendent, aIndex) {
                    attendent.ListUser = angular.copy(vm.listUser);

                    attendent.ListUser.forEach(function (user, uIndex) {
                        var temp = vm.listData.findIndex(x => (x.UserId == user.UserId && x.Option == attendent.TriggerSalePoint));

                        if (temp >= 0) {
                            user.SalePointIds = angular.copy(vm.listData[temp].SalePointIds);
                        } else {
                            user.SalePointIds = [];
                        }
                    })

                })
            }

            vm.changeTab = function (tabId) {
                
                vm.currentTab = vm.listAttendent.filter(x => x.TriggerSalePoint == tabId)[0];
                vm.currentTabId = vm.listAttendent.findIndex(x => x.TriggerSalePoint == tabId);

            };

            vm.CheckIn = function (array, value) {
                return array.includes(value);
            }

            vm.checkLengthSP = function (salepointId) {
                var tmp = 0;
                vm.listAttendent[vm.currentTabId].ListUser.forEach(function (item, index) {
                    if (item.SalePointIds.includes(salepointId) && item.UserId != vm.currentTab.UserId) {
                        tmp++;
                    }

                })

                return tmp;
            }

            vm.removeArr= function(arr) {
                var what, a = arguments, L = a.length, ax;
                while (L > 1 && arr.length) {
                    what = a[--L];
                    while ((ax = arr.indexOf(what)) !== -1) {
                        arr.splice(ax, 1);
                    }
                }
                return arr;
            }
            vm.addArr = function (arr, value) {
                if (vm.checkLengthSP(value) >= 1) {
                    notificationService.warning('Không thể chọn 2 trưởng nhóm cho 1 điểm bán')
                } else {

                    arr.push(value);
                }

            }


            vm.init = function () {
                vm.listAttendent.unshift({ UserId: 0, FullName: '(none)', TriggerSalePoint:0})
                vm.pushUser();

                vm.changeTab(0);
            }


            vm.init();

            vm.getDataSave = function () {
                var temp = [];
                vm.listAttendent.forEach(function (attd) {
                    attd.ListUser.forEach(function (user, uIndex) {
                        if (user.UserId != attd.UserId) {
                            temp.push({
                                UserId: user.UserId,
                                Option: attd.TriggerSalePoint,
                                SalePointIds: (user.SalePointIds)
                            })
                        } else {
                            temp.push({
                                UserId: user.UserId,
                                Option: attd.TriggerSalePoint,
                                SalePointIds: (vm.listAttendent[0].ListUser[uIndex].SalePointIds)
                            })
                        }
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
                var GroupSalePointData = vm.getDataSave();
                if (GroupSalePointData == []) {
                    notificationService.warning("Không có gì để lưu");
                    vm.isSaving = false;
                } else {
                    var temp = [];
                    for (let i = 1; i < vm.listAttendent.length; i++) {
                        temp.push({
                            "UserId": vm.listAttendent[i].UserId,
                            "TriggerSalePoint": vm.listAttendent[i].TriggerSalePoint
                        })
                    }

                    vm.update.Data = JSON.stringify({
                        GroupSalePointData: (GroupSalePointData),
                        LeaderAttendentData:(temp)
                    });

                    salepointService.updateLeaderAttendent(vm.update).then(function (res) {
                        if (res && res.Id > 0) {
                            setTimeout(function () {
                                notificationService.success(res.Message);
                              
                                vm.isSaving = false;
                                setTimeout(function () {
                                    $rootScope.$apply(vm.isSaving)
                                }, 100)
                               
                            }, 0)
                        } else {
                            notificationService.warning(res.Message);
                            vm.isSaving = false;
                            setTimeout(function () {
                                $rootScope.$apply(vm.isSaving)
                            }, 100)
                        }
                    })
                }                

                console.log("temp", GroupSalePointData);
            }

            
            console.log("listAttendent", vm.listAttendent);
        }]);
})();