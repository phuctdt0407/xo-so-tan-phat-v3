(function () {
    app.controller('Activity.historyBill', ['$scope', '$rootScope', '$state', 'viewModel', 'activityService', 'notificationService', 'dayOfWeekVN',
        function ($scope, $rootScope, $state, viewModel, activityService, notificationService, dayOfWeekVN) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];

            vm.DateDisplay = moment(vm.params.date, formatDate).format('DD-MM-YYYY')
            console.log(vm.listlotteryChannel)
            vm.listData.forEach((item, index) => {
                item.Data = JSON.parse(item.Data)
                item.RowNumber = index + 1
                var listSale = item.Data.SalePointLogData;
                var temp = 0;
                var temp2 = 0;
                if (listSale) {
                    listSale.forEach((itemv2, index2) => {
                        temp += itemv2.Quantity
                        temp2 += itemv2.TotalValue
                        var listShortName = vm.listlotteryChannel.filter(itemC => itemC.Id == itemv2.LotteryChannelId)
                        itemv2.ShortName = (listShortName && listShortName.length > 0 && listShortName[0].ShortName) || ''
                    })
                }
                item.Quantity = temp;
                item.TotalPrice = temp2;
            })
            vm.changeDate = function () {
                vm.params.date = moment(vm.DateDisplay, formatDate).format('YYYY-MM-DD')
                console.log(vm.params)

                $state.go($state.current, vm.params, { reload: true, notify: true });
            }
            vm.Check = function () {
                if (!vm.listData || vm.listData.length == 0) {
                    return true
                } else {
                    var temp = vm.listData.filter(x => x.Data.SalePointLogData)
                    if (temp && temp.length > 0) { return false }
                    else return true
                  
                }
                
            }
        }]);
})();