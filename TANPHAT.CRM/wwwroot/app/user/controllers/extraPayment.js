(function () {

    //extrapayment nằm trong app.js ->app.constant.js
    app.controller('User.extraPayment', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', '$uibModal', 'dayOfWeek', 'userService', 'notificationService', 'dayOfWeekVN','extraPaymentType',
        function ($scope, $rootScope, $state, viewModel, sortIcon, $uibModal, dayOfWeek, userService, notificationService, dayOfWeekVN, extraPaymentType) {
            var vm = angular.extend(this, viewModel);
            vm.listUserAfter = [];
            vm.check = true;
            //Descript
            //1. DDL Staff
            //2. Holiday
            //3. Data payment

            //MODAL xu ly
            //1. chon tab thuong phat
            //2. load salepoint cua nv trong ngay => SalepointId, ShiftDistributeId
            //3. dien so tien, noote

            //declare
            console.log("extraPaymentType",extraPaymentType);
            vm.isCanChangeData = currentEvi != 'pro' ? true : ($rootScope.sessionInfo.UserTitleId == 6 || $rootScope.sessionInfo.UserTitleId == 1 || $rootScope.sessionInfo.UserTitleId == 4);


            vm.listMonth = [];
            vm.dayOfWeekVN = angular.copy(dayOfWeekVN);
            vm.month = vm.params.month;
            vm.thisMonth = moment(vm.params.month, 'YYYY-MM').format("MM/YYYY");
            vm.extraPaymentType = angular.copy(extraPaymentType);
            //func

            function getDayFunction(month) {
                var startDate = moment(month, 'YYYY-MM').format('YYYY-MM-01');
                var endDate = moment(month, 'YYYY-MM').endOf('month').format('YYYY-MM-DD');
                return { startDate, endDate };
            }
            function sortBySalePointId(a, b) {
                return a.SalePointId - b.SalePointId;
            }
            vm.loadData = function () {
                vm.params.month = moment(vm.month).format('YYYY-MM');
                $state.go($state.current, vm.params, { reload: false, notify: true })
            }

            vm.clickMonth = function (month) {
                vm.month = moment().add(month, 'month').format('YYYY-MM');
                vm.loadData();
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

            vm.init = function () {
                vm.listUser.sort(sortBySalePointId);
                // INIT MONTH
                var { startDate, endDate } = getDayFunction(vm.params.month);
                while (moment(startDate) <= moment(endDate)) {
                    //Add Holiday

                    var holiday = vm.listHoliday.filter(x => moment(x.Date).format('YYYY-MM-DD') == startDate);
                    var isHoliday = false;
                    if (holiday && holiday[0]) {
                        isHoliday = true
                    }

                    vm.listMonth.push({
                        Date: startDate,
                        DateName: vm.dayOfWeekVN[moment(startDate).day()].SName,
                        IsWeekEnd: moment(startDate).day() == 0,
                        DataInfo: [],
                        IsHoliday: isHoliday,
                        Tooltip: isHoliday ? holiday[0].DateName : ''
                    })
                    startDate = moment(startDate, "YYYY-MM-DD").add(1, 'day').format("YYYY-MM-DD");
                }

                // INIT USER
                if (vm.listUser && vm.listUser.length > 0) {
                    vm.listUser = vm.listUser.filter(ele=>ele.UserTitleId == 4 || ele.UserTitleId == 5 )
                    vm.listUser.forEach(function (user, index) {
                        user.listMonth = angular.copy(vm.listMonth);
                        user.listSum = angular.copy(vm.extraPaymentType);
                        user.sum = 0;

                        var temp = vm.listData.filter(x => x.UserId == user.UserId);
                        if (temp && temp.length > 0) {
                            temp.forEach(function (item) {
                                var dateIndex = parseInt(moment(item.Date).format('DD')) - 1;
                                try {
                                    var tempIndex = vm.extraPaymentType.findIndex(x => x.TransactionTypeId == item.TransactionTypeId);
                                    item.extraPaymentType = vm.extraPaymentType[tempIndex];
                                    user.listSum[tempIndex].Sum += item.Price;

                                    if (item.extraPaymentType.IsSum) {
                                        user.sum += item.Price;
                                    } else {
                                        user.sum -= item.Price;
                                    }
                                } catch (err) {
                                }
                                user.listMonth[dateIndex].DataInfo.push(item);
                            })
                            console.log("...", user)
                        }
                      
                    })
                }
                if ($rootScope.sessionInfo.IsStaff) {
                    vm.check = false;
                    vm.listUser.forEach(function (res) {
                        if ($rootScope.sessionInfo.UserId == res.UserId) {
                            vm.listUserAfter.push(res)
                        }
                    })
                }
                
            }
            
            //modal
            
            vm.openModalCreate = function (model = {}, date = '', pindex, index) {
                var viewPath = baseAppPath + '/user/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'addExtraPayment.html' + versionTemplate,
                    controller: 'User.addExtraPayment as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService',
                            function ($q, $uibModal, userService) {
                                var deferred = $q.defer();
                                $q.all([
                                    userService.getListSalePointInDate({
                                        userId: model.UserId,
                                        date: date.Date
                                    })
                                ]).then(function (res) {
                                    var result = {
                                        listShiftActive: res[0],
                                        userInfo: model,
                                        dateInfo: date
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    }
                });

                request.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-content').addClass("w70vw");
                        $('.modal-body').addClass('modal-body-rm');
                    });
                });

                request.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {
                        vm.listUser[pindex].listMonth[index].DataInfo.push(data);
                        data.Price = parseInt(data.Price);
                        var getType = vm.extraPaymentType.findIndex(x => x.TransactionTypeId == data.TransactionTypeId);
                        vm.listUser[pindex].listSum[getType].Sum += data.Price;

                        if (data.extraPaymentType.IsSum) {
                            vm.listUser[pindex].sum += data.Price;
                        } else {
                            vm.listUser[pindex].sum -= data.Price;
                        }
                    }
                });
            }

            vm.openModalUpdate = function (model = {}, list = {}, pindex, index) {
                var viewPath = baseAppPath + '/user/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'extraPaymentInfo.html' + versionTemplate,
                    controller: 'User.extraPaymentInfo as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService',
                            function ($q, $uibModal, userService) {
                                var deferred = $q.defer();
                                $q.all([

                                ]).then(function (res) {
                                    console.log("model", model);
                                    console.log("list", list);
                                    console.log("index", pindex, index);
                                    var result = {
                                        modelInfo: model,
                                        listInfo: list,
                                        isCanChangeData: vm.isCanChangeData
                                    };
                                    deferred.resolve(result);
                                });
                                return deferred.promise;
                            }]
                    }
                });

                request.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-content').addClass("w70vw");
                        $('.modal-body').addClass('modal-body-rm');
                    });
                });

                request.result.then(function (data) {

                }, function (data) {
                        if (typeof (data) == 'object') {
                            var tempId = data.TransactionId;
                            var getIndex = vm.listUser[pindex].listMonth[index].DataInfo.findIndex(x => x.TransactionId == tempId);
                            var getTemp = angular.copy(vm.listUser[pindex].listMonth[index].DataInfo[getIndex]);
                            var getType = vm.extraPaymentType.findIndex(x => x.TransactionTypeId == getTemp.TransactionTypeId);
                            vm.listUser[pindex].listSum[getType].Sum -= getTemp.Price;
                          
                            if (!getTemp.extraPaymentType.IsSum) {
                                vm.listUser[pindex].sum += getTemp.Price;
                            } else {
                                vm.listUser[pindex].sum -= getTemp.Price;
                            }

                            vm.listUser[pindex].listMonth[index].DataInfo = vm.listUser[pindex].listMonth[index].DataInfo.filter(x => x.TransactionId != tempId);
                    }
                });

                event.stopPropagation();
            }

            //Init
            vm.init();
            console.log("listUserAfter", vm.listUser);
            $(document).ready(function () {
                setTimeout(function () {
                    $(".table-responsive").animate({ scrollLeft: (parseInt(moment().format('DD')) - 1) *  $(window).width() * 0.12 }, 400);
                },500)

                //init tooltip
                $('.tooltips').append("<span></span>");
                $(".tooltips").mouseenter(function () {
                    $(this).find('span').empty().append($(this).attr('tooltip'));
                });
            });

        }]);
})();