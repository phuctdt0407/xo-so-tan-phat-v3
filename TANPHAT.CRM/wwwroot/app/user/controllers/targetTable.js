(function () {
    app.controller('User.targetTable', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService', '$uibModal',
        function ($scope, $rootScope, $state, viewModel,notificationService, userService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            vm.saving = {
                ActionType: 2,
                UserRoleId: $rootScope.sessionInfo.UserRoleId,
                ActionBy: $rootScope.sessionInfo.UserId,
                ActionByName: $rootScope.sessionInfo.FullName
            }
            $scope.numToCurrency = function (value) {
                if (!value) return ''; // Trả về chuỗi rỗng nếu giá trị không tồn tại hoặc không hợp lệ

                // Chuyển đổi giá trị sang định dạng có dấu phẩy ở hàng nghìn
                return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            };
            vm.targetLottery = JSON.parse(vm.data.TargetLottery)
            vm.responsibilityLottery = JSON.parse(vm.data.ResponsibilityLottery)
            vm.targetVietlott = JSON.parse(vm.data.TargetVietlott)
            vm.targetKPI = JSON.parse(vm.data.TargetKPI)
            vm.targetLottery.forEach(function (item) {
                item.minTarget = item.minTarget.toLocaleString('en-US');
                item.commission = item.commission.toLocaleString('en-US');
                item.maxTarget = item.maxTarget.toLocaleString('en-US');
            });
            vm.responsibilityLottery.forEach(function (item) {
                item.minTarget = item.minTarget.toLocaleString('en-US');
                item.commission = item.commission.toLocaleString('en-US');
                item.maxTarget = item.maxTarget.toLocaleString('en-US');
            });
            vm.targetVietlott.forEach(function (item) {
                item.minTarget = item.minTarget.toLocaleString('en-US');
                item.commission = item.commission.toLocaleString('en-US');
                item.maxTarget = item.maxTarget.toLocaleString('en-US');
            });
            vm.changeTab = function (tabName) {
                vm.view = tabName;
                console.log("vm view", vm.view);
            };
            vm.changeTab('target_lottery');
     
            vm.saveChanges = function () {
                if (vm.view == 'target_lottery') {
                    vm.targetLottery.forEach(function (item) {
                        item.minTarget = item.minTarget.replace(/,/g, '');
                        item.commission = item.commission.toString().replaceAll(",", '');
                        item.maxTarget = item.maxTarget.toString().replaceAll(",", '');
                    });
                    vm.saving.Data = JSON.stringify(vm.targetLottery)
                  
                }
                if (vm.view == 'responsibility_lottery') {
                    console.log("vm.responsibilityLotteryforEach", vm.responsibilityLotteryforEach)
                    vm.responsibilityLottery.forEach(function (item) {
                    
                        item.minTarget = item.minTarget.replace(/,/g, '');
                        item.commission = item.commission.toString().replaceAll(",", '');
                        item.maxTarget = item.maxTarget.toString().replaceAll(",", '');

                    });
                    vm.saving.Data = JSON.stringify(vm.responsibilityLottery)
                    
   
                }
                if (vm.view == 'target_vietlott') {
                    vm.targetVietlott.forEach(function (item) {

                        item.minTarget = item.minTarget.replace(/,/g, '');
                        item.commission = item.commission.toString().replaceAll(",", '');
                        item.maxTarget = item.maxTarget.toString().replaceAll(",", '');

                    });
                    vm.saving.Data = JSON.stringify(vm.targetVietlott)
                  
                }
                if (vm.view == 'kpi') {
                    vm.targetKPI.forEach(function (item) {

                        item.minTarget = item.minTarget.replace(/,/g, '');
                        item.commission = item.commission.toString().replaceAll(",", '');
                        item.maxTarget = item.maxTarget.toString().replaceAll(",", '');

                    });
                    vm.saving.Data = JSON.stringify(vm.targetKPI)
                   
                }
                userService.UpdateListTarget(vm.saving).then(function (res) {
                    notificationService.success(res.Message);

                });
              
                };
           
            

        }]);
})();