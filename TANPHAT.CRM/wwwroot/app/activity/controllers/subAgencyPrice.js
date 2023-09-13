(function () {
    app.controller('Activity.subAgencyPrice', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', 'activityService', 'notificationService', 'dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, sortIcon, activityService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);

            vm.listLotteryOnWeek = angular.copy(dayOfWeekVN);
            vm.listLotteryOnWeek.sort((a, b) => { return a.Id2 - b.Id2 })
            vm.isSaving = false;

            //INIT
            vm.init = function () {
                vm.listLottery.forEach(function (item) {
                    item.DayId = JSON.parse(item.DayIds);
                })

                vm.listScratchcard = vm.listLottery.filter(x => x.IsScratchcard == true);

                var isColor = true;
                //VE CAO
                vm.listLotteryOnWeek.push({
                    isColor: isColor,
                    LotteryData: vm.listScratchcard,
                    SName: 'Vé cào',
                    IsScratchcard: true
                })
                //VE TRUYEN THONG 
                vm.listLotteryOnWeek.forEach(function (ele) {
                    ele.isColor = isColor;
                    if (!ele.IsScratchcard) {
                        ele.LotteryData = vm.listLottery.filter(x => x.DayId.includes(ele.Id2));
                    }
                    ele.LotteryData.forEach(function (item) {
                        //item.Id = LotteryChannelId
                        item.listSubAgency = angular.copy(vm.listSubAgency);
                        item.listSubAgency.forEach(function (agency) {
                            //agency.Id = AgencyId
                            let price = vm.listData.filter(x => x.AgencyId == agency.AgencyId && x.LotteryChannelId == item.Id)
                            if (price && price[0]) {
                                agency.PriceDisplay = (price[0].Price).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                            } else {
                                agency.PriceDisplay = 0;
                            }
                            agency.isChange = false;
                        })
                    })
                    isColor = !isColor;
                })
            }

            vm.init();

            vm.getListSave = function () {
                var temp = []
                vm.listLotteryOnWeek.forEach(function (ele) {
                    ele.LotteryData.forEach(function (item) {
                        //item.Id = LotteryChannelId 
                        item.listSubAgency.forEach(function (agency) {
                            ////agency.Id = AgencyId
                            if (agency.isChange == true) {
                                agency.Price = agency.PriceDisplay.replace(/,/g, '');
                                temp.push({
                                    AgencyId: agency.AgencyId,
                                    LotteryChannelId: item.Id,
                                    Price: agency.Price,
                                })
                            }
                        })
                    })
                })
                return temp;
            }

            vm.saveInfo = {
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName + ' (' + $rootScope.sessionInfo.UserTitleName + ')',
                ActionType: 1
            }
            vm.save = function () {
                vm.isSaving = true;
                var tmp = vm.getListSave();
                if (tmp.length == 0) {
                    notificationService.warning('Không có gì để lưu');
                    vm.isSaving = false;
                } else {
                    vm.saveInfo.Data = JSON.stringify(tmp);
                    activityService.updateLotteryPriceSubAgency(vm.saveInfo).then(function (res) {
                        if (res && res.Id > 0) {
                            notificationService.success(res.Message);
                            setTimeout(function () {
                                vm.isSaving = false;
                                $rootScope.$apply(vm.isSaving);
                                $state.reload()
                            }, 1500)
                        } else {
                            notificationService.warning(res.Message);
                            vm.isSaving = false;
                        }
                    })
                }
            }
        }]);
})();