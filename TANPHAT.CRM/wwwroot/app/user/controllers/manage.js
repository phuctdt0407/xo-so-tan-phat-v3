(function () {
    app.controller('User.manage', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService','$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, userService, $uibModal) {
            var vm = angular.extend(this, viewModel);
            //vm.totalRow = vm.listUser && vm.listUser.length > 0 ? vm.listUser[0].TotalCount : 0;
            //vm.listUserTitle = listUserTitle;

           /* vm.submitSearch = function () {
                vm.params.p = 1;
                $state.go($state.current, vm.params, { reload: false, notify: true });
            };
            vm.listUserTitle.unshift({ Id: 0, Name: "All" });
            */
            vm.tabName = [
                { Id: 1, Name: "Nhân viên bán hàng" },
                { Id: 2, Name: "Trưởng nhóm" },
                { Id: 3, Name: "Quản lý nhân sự" },
                { Id: 4, Name: "Nhân viên đã nghỉ việc" }
            ]

            vm.listUser.forEach(val => {
                var tmp = vm.listSalePoint.filter(x => x.Id == val.SalePointId);
                val.SalePointName = tmp && tmp.length > 0 && tmp[0].Name;
                if (val.SalePointName == false)
                    val.SalePointName = '';
            })
            console.log("vm.listUser: ", vm.listUser)
            vm.curTab = 1
            vm.listUserBK = vm.listUser.filter(x => x.UserTitleId == 5 && x.IsActive == true)
            vm.changeTab = function (i) {
                vm.curTab = i
                if(i == 1)
                    vm.listUserBK = vm.listUser.filter(x => x.UserTitleId == 5 && x.IsActive == true)
                else if (i == 2)
                    vm.listUserBK = vm.listUser.filter(x => x.UserTitleId == 4 && x.IsActive == true)
                else if (i == 3)
                    vm.listUserBK = vm.listUser.filter(x => x.UserTitleId == 6 && x.IsActive == true)
                else if (i == 4)
                    vm.listUserBK = vm.listUser.filter(x => x.UserTitleId == 5 && x.IsActive == false)
            }

            vm.openModal = function (model = {},name) {
                var viewPath = baseAppPath + '/user/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'updateInfo.html' + versionTemplate,
                    controller: 'User.updateInfo as $vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'userService','ddlService',
                            function ($q, $uibModal, userService, ddlService ) {
                                var deferred = $q.defer();
                                var modelBK = angular.copy(model)
                                $q.all([
                                    ddlService.salePointDDL()
                                ]).then(function (res) {
                                    var result = {
                                        userInfo: modelBK,
                                        listSalePoint: res[0]
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