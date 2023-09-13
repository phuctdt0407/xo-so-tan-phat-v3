(function () {
    app.controller('Auth.Signin', ['$scope', '$rootScope', 'authService', '$state', 'notificationService',
        function ($scope, $rootScope, authService, $state, notificationService){

            var vm = this;

            const signUpButton = document.getElementById('signUp');
            const signInButton = document.getElementById('signIn');
            const container = document.getElementById('container');

            signUpButton.addEventListener('click', () => {
                container.classList.add("right-panel-active");
            });

            signInButton.addEventListener('click', () => {
                container.classList.remove("right-panel-active");
            });

            vm.login = function () {
                if ($scope.fromLogin && $scope.fromLogin.$valid) {
                    vm.isSaving = true;
                    var temp = {
                        Account: vm.loginInfo.Account,
                        Password: vm.loginInfo.Password,
                        MACAddress: "",
                        IPAddress: ""
                    }
                    authService.login(temp).then(function (checkRes) {
                        if (checkRes && checkRes.Id > 0) {
                            //$rootScope.showLoading = true;
                            $rootScope.sessionInfo = checkRes;
                            setTimeout(function () {
                                $state.go('root.home');
                                notificationService.success(checkRes.Message);
                                vm.isSaving = false;
                            }, 2000);
                        }
                        else {
                            vm.isSaving = false;
                            notificationService.error(checkRes.Message);
                          
                        }
                        setLocalStorage("bearer", checkRes.Token);
                    });
                }
            };

            
            vm.clickFg = function () {
                $("#signUp").click();
            }

            vm.backLG = function () {
                $("#signIn").click();
            }


            vm.FgPassword = function (mail) {
                var temp = {
                    Time: moment().format("DD/MM/YYYY HH:mm"),
                    SystemInfo: window.navigator.userAgent,
                    Email: mail,
                }
                authService.forgotPassword(temp).then(function (res) {
                    console.log("res",res);
                    if (res && res.Id > 0) {
                        $rootScope.sessionInfo = res;

                        notificationService.success(res.Message);
                        vm.backLG();
                        setTimeout(function () {
                            vm.isSaving = false;
                            $rootScope.$apply(vm.isSaving);
                        }, 500);
                    }
                    else {
                        $rootScope.sessionInfo = res;
                        notificationService.error(res.Message);
                    }
                })
                vm.isSaving = true;
              
            }
        }]);
})();