(function () {
    app.controller('Shared.LeftMenu', ['$scope', '$rootScope', '$state','sessionService',
        function ($scope, $rootScope, $state, sessionService) {
            var vm = this;
            var url = window.location.pathname;
            url = url == '/auth/login' ? '/' : window.location.pathname;

          
            
            
            vm.groupMenu = sessionService.getUserRole();
            vm.init = function () {
                var a = vm.groupMenu.filter(x => x.IsShowMenu == true);
                if (a.length > 0) {
                    vm.groupMenu = Enumerable.From(a)
                        .GroupBy(function (item) { return item.ControllerName; })
                        .Select(function (item, i) {
                            return {
                                "ControllerName": item.source[0].ControllerName,
                                "data": Enumerable.From(item.source).OrderBy("$.Sort").ToArray(),
                                "content": (item.source[0].ControllerName != "home") ? ('root.' + item.source[0].ControllerName.replaceAll('-', '')) : 'root.home',
                                "root": item.source[0].root,
                                "url": item.source[0].url,
                                "PermissionName": item.source[0].PermissionName,
                                "icon": item.source[0].CssIcon,
                                "sort": item.source[0].Sort
                            };
                        })
                        .OrderBy("$.sort")
                        .ToArray();
                }
                else {
                    vm.groupMenu = Enumerable.From(vm.groupMenu)
                        .GroupBy(function (item) { return item.ControllerName; })
                        .Select(function (item, i) {
                            return {
                                "ControllerName": item.source[0].ControllerName,
                                "data": Enumerable.From(item.source).OrderBy("$.Sort").ToArray(),
                                "content": (item.source[0].ControllerName != "home") ? ('root.' + item.source[0].ControllerName.replaceAll('-', '')) : 'root.home',
                                "root": item.source[0].root,
                                "url": item.source[0].url,
                                "PermissionName": item.source[0].PermissionName,
                                "icon": item.source[0].CssIcon,
                                "sort": item.source[0].Sort
                            };
                        })
                        .OrderBy("$.sort")
                        .ToArray();
                }
                
            }
            vm.init();
            console.log("groupMenu.data", vm.groupMenu);
            vm.checkClass = function (rootName) {
                return rootName == $state.current.name;
            }

            vm.checkMenu = function (rootMenu) {
                return $state.current.name.includes(rootMenu);
            }
        }]);
})();