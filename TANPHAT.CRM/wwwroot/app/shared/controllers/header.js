(function () {
    app.controller('Shared.Header', ['$scope', '$rootScope', '$state', 'authService', 'notificationService','$uibModal',
        function ($scope, $rootScope, $state, authService, notificationService,$uibModal) {
            var vm = this;

            //


            $('.sidebar-toggler').click(function () {
                $('.sidebar, .navbar, .content-TP').toggleClass("open");
                $('.me-4').toggleClass("open");
                return false;
            });

            if (getLocalStorage("setting") != null) {
                vm.isShowHeader = (getLocalStorage("setting") == 'true');
                if (vm.isShowHeader == true) {
                    setTimeout(function () {
                        $('.sidebar-toggler').click();
                    }, 10);
                   
                }
            }
            else {
                setLocalStorage("setting", false);
                vm.isShowHeader = false;
            }

            vm.changeState = function (isChange = true) {
                if (isChange) {
                    vm.isShowHeader = !vm.isShowHeader;
                    setLocalStorage("setting", vm.isShowHeader);
                }
            }

            vm.shortUserName = function (fullName) {
                if (fullName) {
                    var a = fullName.split(' ').slice(0, 2).map(e => e.substring(0, 1)).join('');
                    return a;
                }
                return 'Unknown';
            }

            vm.changePassword = function (){
                var viewPath = baseAppPath + '/shared/views/modal/';
                var modalChangePassword = $uibModal.open({
                    templateUrl: viewPath + 'changePassword.html' + versionTemplate,
                    controller: 'Shared.changePassword as $vm',
                    backdrop: 'static',
                    size: 'md'
                });

                modalChangePassword.opened.then(function (res) {
                    $(document).ready(function () {
                        $('.modal-footer').addClass('remove-modal-footer');
                    });
                });

                modalChangePassword.result.then(function (data) {

                }, function (data) {
                    if (typeof (data) == 'object') {
                        
                    }
                });
            }

            vm.isFullScreen = false;
            vm.toogleFullScreen = function () {
                if (vm.isFullScreenSupport) {
                    if ($.fullscreen.isFullScreen()) {
                        $.fullscreen.exit();
                        vm.isFullScreen = false;
                    } else {
                        vm.isFullScreen = true;
                        $('html').fullscreen({
                            overflow: 'visible'
                        });
                    }
                }
            };

            var init = function () {
                vm.isFullScreenSupport = $.fullscreen.isNativelySupported();
            };
            init();

            function delete_cookie(name) {
                document.cookie = name + '=; Path=/; Expires=' + moment().add(-1,'days') ;
            }

            vm.logOut = function () {
                authService.logout().then(function (res) {
                    if (res && res.Id > 0) {
                        setTimeout(function () {
                            localStorage.removeItem('bearer');
                            deleteCookie('AUTH_');
                            $rootScope.isReloading = false;
                            notificationService.success("Đăng xuất thành công");
                            $state.go('auth.login')
                        }, 1000);
                    }
                });
            }
        }]);
})();