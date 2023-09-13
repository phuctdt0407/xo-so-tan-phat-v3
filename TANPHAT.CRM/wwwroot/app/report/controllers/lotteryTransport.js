(function () {
	app.controller('Report.lotteryTransport', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService',
		function ($scope, $rootScope, $state, viewModel, notificationService, reportService) {
			var vm = angular.extend(this, viewModel);
			var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
			var outputDate = 'YYYY-MM-DD';
			vm.params.day = moment(vm.params.day, formatDate).format('YYYY-MM-DD');

			vm.changeDate = function () {
				$state.go($state.current, { day: moment(vm.params.day, formatDate).format(outputDate) }, { reload: true, notify: true });
			}

			vm.noDuplicate = function (array_) {
				return Array.from(new Set(array_))
			}

			vm.init = function () {
				vm.listDaiBan = [];
				vm.listData = [];
				vm.listTotalTrans = [];

				vm.lotteryTransport.forEach(function (item) {
					vm.listDaiBan.push(item.LotteryChannelId);
				})

				vm.listData = vm.noDuplicate(vm.listDaiBan);
				vm.setKey = function (item, index) {
					var fullname = { "LotteryChannelId": item };
					return fullname;
				};

				vm.listData = vm.listData.map(vm.setKey);

				vm.listSalePoint.forEach(function (item) {
					item.TotalRemaining = 0;
				})

				vm.listData.forEach(function (item) {
					var temp = angular.copy(vm.listSalePoint);
					item.listSalePoint = temp;
					item.TotalRemaining = 0;
					item.TotalTrans1 = 0;
					item.TotalTrans2 = 0;

				})

				vm.lotteryTransport.forEach(function (item) {
					vm.listData.forEach(function (item2) {
						if (item.LotteryChannelId == item2.LotteryChannelId) {
							item2.LotteryChannelName = item.LotteryChannelName;
						}
					})
				})

				vm.lotteryTransport.forEach(function (item) {
					item.DataShift = item.DataShift ? JSON.parse(item.DataShift) : [];
				})

				if (vm.lotteryTransport.length > 0) {
					vm.lotteryTransport.forEach(function (item) {
						var index = vm.listData.findIndex(x => x.LotteryChannelId == item.LotteryChannelId)
						var temp = vm.listData[index];
						var diemban = temp.listSalePoint.filter(x => x.Id == item.SalePointId)[0];
						diemban.TotalRemaining = item.TotalRemaining + item.TotalDupRemaining;
						temp.TotalRemaining += diemban.TotalRemaining;

						item.DataShift.forEach(function (ele) {
							diemban['TotalTrans' + ele.ShiftId] = ele['TotalTrans'];
							temp['TotalTrans' + ele.ShiftId] += diemban['TotalTrans' + ele.ShiftId];
						});
					})
				}
			}

			vm.init();

			vm.listTotalTrans.TotalRemaining = 0;
			vm.listTotalTrans.TotalTrans1 = 0;
			vm.listTotalTrans.TotalTrans2 = 0;

			vm.listData.forEach(function (item) {
				vm.listTotalTrans.TotalRemaining += item.TotalRemaining;
				vm.listTotalTrans.TotalTrans1 += item.TotalTrans1;
				vm.listTotalTrans.TotalTrans2 += item.TotalTrans2;
			})
			
		}]);
})();