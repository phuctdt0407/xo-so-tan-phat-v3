(function () {
    app.controller('Shared.changePassword', ['$scope', '$rootScope', '$state', '$uibModalInstance', 'authService', 'notificationService',
        function ($scope, $rootScope, $state, $uibModalInstance, authService, notificationService) {
            var vm = this;
            vm.isSaving = false;

            vm.userInfo = {
                UserId: $rootScope.sessionInfo.UserId
            };

            vm.errorMsg = "";
            vm.isShowOldPassword = false;
            vm.toggleShowOldPassword = function () {
                var passwordField = document.getElementById('oldPassword');
                var togglePassword = document.getElementById('oldPasswordToggle');
                if (!vm.isShowOldPassword) {
                    vm.isShowOldPassword = !vm.isShowOldPassword;
                    passwordField.type = 'text';
                    togglePassword.classList.remove("fa-eye");
                    togglePassword.classList.add("fa-eye-slash");
                }
                else {
                    vm.isShowOldPassword = !vm.isShowOldPassword;
                    passwordField.type = 'password';
                    togglePassword.classList.remove("fa-eye-slash");
                    togglePassword.classList.add("fa-eye");

                }
            };

            vm.isShowNewPassword = false;
            vm.toggleShowNewPassword = function () {
                var passwordField = document.getElementById('newPassword');
                var togglePassword = document.getElementById('newPasswordToggle');
                if (!vm.isShowNewPassword) {
                    vm.isShowNewPassword = !vm.isShowNewPassword;
                    passwordField.type = 'text';
                    togglePassword.classList.remove("fa-eye");
                    togglePassword.classList.add("fa-eye-slash");
                }
                else {
                    vm.isShowNewPassword = !vm.isShowNewPassword;
                    passwordField.type = 'password';
                    togglePassword.classList.remove("fa-eye-slash");
                    togglePassword.classList.add("fa-eye");
                }
            };

            vm.isShowReNewPassword = false;
            vm.toggleShowReNewPassword = function () {
                var passwordField = document.getElementById('reNewPassword');
                var togglePassword = document.getElementById('reNewPasswordToggle');
                if (!vm.isShowReNewPassword) {
                    vm.isShowReNewPassword = !vm.isShowReNewPassword;
                    passwordField.type = 'text';
                    togglePassword.classList.remove("fa-eye");
                    togglePassword.classList.add("fa-eye-slash");
                }
                else {
                    vm.isShowReNewPassword = !vm.isShowReNewPassword;
                    passwordField.type = 'password';
                    togglePassword.classList.remove("fa-eye-slash");
                    togglePassword.classList.add("fa-eye");
                }
            };

            vm.save = function () {
                if ($scope.formChangePassword.$valid && !vm.isSaving) {
                    if (vm.userInfo.NewPassword !== vm.userInfo.reNewPassword) {
                        vm.errorMsg = "Nhập lại mật khẩu không đúng.";
                    }
                    else if (!$rootScope.passPattern.test(vm.userInfo.NewPassword)) {
                        vm.errorMsg = "Mật khẩu không đúng định dạng.";
                    }
                    else {
                        authService.changePassword(vm.userInfo).then(function (res) {
                            if (res && res.Id > 0) {
                                notificationService.success(res.Message);
                                $uibModalInstance.dismiss(res);
                            }
                            else {
                                //notificationService.error(res.Message);
                                vm.errorMsg = res.Message;
                            }
                        });
                    };
                }
            };

            vm.cancel = function () {
                $uibModalInstance.close()
            }

        }]);
})();
