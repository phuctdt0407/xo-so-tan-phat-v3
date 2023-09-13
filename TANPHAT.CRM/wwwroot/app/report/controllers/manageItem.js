(function () {
	app.controller('Report.manageItem', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', '$uibModal', 'ddlService','typeOfItem',
		function ($scope, $rootScope, $state, viewModel, notificationService, reportService, $uibModal, ddlService, typeOfItem ) {
			var vm = angular.extend(this, viewModel);
			// Init Globas
			vm.month = vm.params.month;
			vm.loadData = function () {
				vm.params.month = moment(vm.month).format('YYYY-MM');
				$state.go($state.current, vm.params, { reload: false, notify: true })
			}

			vm.checkRole = function () {
				var role = []
				var subRole = JSON.parse($rootScope.sessionInfo.SubUserTitle)
				subRole.forEach(function (item) {
					if ((item.UserTitleId == 7 || $rootScope.sessionInfo.UserTitleId == 7) && !role.includes(item.UserTitleId)) {
						role.push(1)
					}
					if ((item.UserTitleId == 8 || $rootScope.sessionInfo.UserTitleId == 8) && !role.includes(item.UserTitleId)) {
						role.push(2)
					}
				})
				return role;
			}

			vm.listItemBK = angular.copy(vm.listItem)
			vm.listDataBK = angular.copy(vm.listData)

			vm.typeOfItem.forEach(function (CoreI, index) {
				CoreI.Id = CoreI.TypeOfItemId;
				CoreI.Name = CoreI.TypeName.toLowerCase();
				vm['type' + CoreI.Id] = { listSalePoint: angular.copy(vm.listSalePoint) };
				vm['type' + CoreI.Id].listItemBK = vm.listItemBK.filter(x => x.TypeOfItemId == CoreI.Id);
				vm['type' + CoreI.Id].listDataBK = vm.listDataBK.filter(x => x.TypeOfItemId == CoreI.Id);

				//Chia ra KHO vs DIEMBAN
				vm['type' + CoreI.Id].listDataForWarehouse = vm['type' + CoreI.Id].listDataBK.filter(x => x.SalePointId == 0)
				vm['type' + CoreI.Id].listDataForSalepoint = vm['type' + CoreI.Id].listDataBK.filter(x => x.SalePointId != 0)

				vm['type' + CoreI.Id].listItemBK1 = [];

				vm['type' + CoreI.Id].listItemBK.forEach(function (item) {
					var temp = vm['type' + CoreI.Id].listDataForWarehouse.filter(x => x.ItemId == item.ItemId);
					if (temp && temp.length > 0) {
						item = angular.extend(temp[0], item);

						vm['type' + CoreI.Id].listItemBK1.push(item)
					}
					if (temp && temp.length == 0) {
						item.Export = 0;
						item.ExportPrice = 0;
						item.Import = 0;
						item.ImportPrice = 0;
						item.Note = 'Mới tạo';
						//item.Quotation = 1;
						item.TotalReceive = 0;
						item.TotalRemaining = 0;
						vm['type' + CoreI.Id].listItemBK1.push(item)
					}
				})

				vm['type' + CoreI.Id].listItemBK1.forEach(function (item) {
					item.SalePoint = [];
					vm['type' + CoreI.Id].listSalePoint.forEach(function (element) {
						var temp = vm['type' + CoreI.Id].listDataForSalepoint.find(x => x.ItemId == item.ItemId && x.SalePointId == element.Id);
						if (temp) {
							item.SalePoint.push(temp)
						} else {
							item.SalePoint.push({
								SalePointId: element.Id,
								/*Use: 0,
								UsePrice: 0*/
							})
						}
					})
				})
				vm['type' + CoreI.Id].temp = vm['type' + CoreI.Id].listItemBK1.filter(x => x.TotalRemaining > 0)
				
				vm['type' + CoreI.Id].listSalePoint.forEach(function (item) {
					item.data = [];
					item.data.push(...vm['type' + CoreI.Id].temp)
				})
			
			})

			console.log('BK1: ', vm.type1.listItemBK1)

			// open modal for salepoint
			vm.openTransferSalePoint = function (model = {}, type, index = 0) {
				var viewPath = baseAppPath + '/report/views/modal/';
				var request = $uibModal.open({
					templateUrl: viewPath + 'updateItem.html' + versionTemplate,
					controller: 'Report.updateItem as $vm',
					backdrop: 'static',
					size: 'lg',
					resolve: {
						viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
							function ($q, $uibModal, reportService, ddlService) {
								var deferred = $q.defer();

								$q.all([

								]).then(function (res) {
									var result = {
										model: model,
										index: index,
										typeOfTransfer: type,
										month: vm.month,
									};
									deferred.resolve(result);
								});
								return deferred.promise;
							}]
					}
				});

				request.opened.then(function (res) {
					$(document).ready(function () {
						$('.modal-footer').addClass('remove-modal-footer');
					});
				});

				request.result.then(function (data) {
					
				}, function (data) {
					if (typeof (data) == 'object') {
						$state.reload();

					}
				});
			}

			vm.openAddNewItem = function (model = {}, typeOfItemId = 1) {
				var viewPath = baseAppPath + '/report/views/modal/';
				var request = $uibModal.open({
					templateUrl: viewPath + 'addNewItem.html' + versionTemplate,
					controller: 'Report.addNewItem as $vm',
					backdrop: 'static',
					size: 'lg',
					resolve: {
						viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
							function ($q, $uibModal, reportService, ddlService) {
								var deferred = $q.defer();

								$q.all([
									ddlService.getUnitDDL()
								]).then(function (res) {
									var result = {
										model: model,
										listUnit: res[0],
										typeOfItemId: typeOfItemId,
										typeOfItem: vm.typeOfItem
									};
									deferred.resolve(result);
								});
								return deferred.promise;
							}]
					}
				});

				request.opened.then(function (res) {
					$(document).ready(function () {
						$('.modal-footer').addClass('remove-modal-footer');
					});
				});

				request.result.then(function (data) {
				}, function (data) {
					if (typeof (data) == 'object') {
						$state.reload();

					}
				});
			}

			vm.openImportForStorage = function (model = {}, typeOfItemId = 1) {
				var viewPath = baseAppPath + '/report/views/modal/';
				var request = $uibModal.open({
					templateUrl: viewPath + 'importForStorage.html' + versionTemplate,
					controller: 'Report.importForStorage as $vm',
					backdrop: 'static',
					size: 'lg',
					resolve: {
						viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
							function ($q, $uibModal, reportService, ddlService) {
								var deferred = $q.defer();

								$q.all([

								]).then(function (res) {
									var result = {
										model: model, 
										typeOfItemId: typeOfItemId,
										typeOfItem: vm.typeOfItem,
										month: vm.month,
									};
									deferred.resolve(result);
								});
								return deferred.promise;
							}]
					}
				});

				request.opened.then(function (res) {
					$(document).ready(function () {
						$('.modal-footer').addClass('remove-modal-footer');
					});
				});

				request.result.then(function (data) {

				}, function (data) {
					if (typeof (data) == 'object') {
						$state.reload();

					}
				});
			}
		}]);
})();