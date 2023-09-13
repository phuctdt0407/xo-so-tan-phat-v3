(function () {
    app.controller('User.rolePermission', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon', '$uibModal', 'dayOfWeek', 'userService', 'notificationService',
        function ($scope, $rootScope, $state, viewModel, sortIcon, $uibModal, dayOfWeek, userService, notificationService) {
            var vm = angular.extend(this, viewModel);
            var arrSortIcon = sortIcon;

            vm.update = {
                ActionBy: $rootScope.sessionInfo.Id,
                ActionByName: $rootScope.sessionInfo.FullName
            }

            vm.save = function () {
                vm.update.ListRole = JSON.stringify(vm.update.ListRole);
                userService.updatePermissionRole(vm.update).then(function (res) {
                    if (res && res.Id > 0) {
                        notificationService.success(res.Message);
                        $rootScope.connection.invoke("SendMessage", "updatePermission", vm.update.UserTitleId.toString()).catch(function (err) {
                            return console.error(err.toString());

                        });
                    } else {
                        notificationService.error(res.Message);
                    }
                })
            }

            //vm.save = () => {
            //    if (this.item === undefined) { return}
            //}

            vm.checkAllObj = function (model, boolean) {
                vm.update.ListRole = [];
                model.forEach(function (ele) {
                    vm.update.ListRole.push({ RoleId: ele.RoleId, IsCheck: boolean });
                })
                vm.save();
            }

            vm.checkAll = function (index) {
                $('.parent' + index).each(function () {
                    if (this.checked) {
                        vm.checkAllObj(vm.listTitle[index].Data, true);
                        $('.child' + index).each(function () {
                            this.checked = true;
                        });
                    }
                    else {
                        vm.checkAllObj(vm.listTitle[index].Data, false);
                        $('.child' + index).each(function () {
                            this.checked = false;
                        });
                    }
                })
            };

            var temp = 0;
            vm.checkFull = function (index) {
                temp = 0;
                $('.child' + index).each(function () {
                    if (this.checked == true)
                        temp++;
                })
                if (temp < $('.child' + index).length) {
                    $('.parent' + index).prop("checked", false);
                }
                else {
                    $('.parent' + index).prop("checked", true);
                }
            }

            vm.checkItem = function (indexArray, index) {
                vm.update.ListRole = [];
                var a = vm.listTitle[indexArray].Data[index];
                vm.update.ListRole.push({ RoleId: a.RoleId, IsCheck: !a.IsCheck });
                vm.save();
            }
            
            vm.getListRolePermission = function (id) {
                userService.getPermissionByTitle({ userTitleId: id }).then(function (res) {
                    vm.listTitle = res;
                    vm.listTitle = Enumerable.From(vm.listTitle)
                        .GroupBy(function (item) { return item.PermissionId; })
                        .Select(function (item, i) {
                            return {
                                "PermissionId": item.source[0].PermissionId,
                                "PermissionName": item.source[0].PermissionName,
                                "Data": item.source,
                                "IsChecked": item.source.length == item.source.filter(e => e.IsCheck == true).length
                            };
                        })
                        .ToArray();
                })
            }
          
            vm.selectedRow = 0;
            vm.rowHighilited = function (row, id) {
                vm.update.UserTitleId = id;
                vm.selectedRow = row;
                vm.getListRolePermission(id);
            };
            vm.rowHighilited(1, 2);

        
        }]);
})();