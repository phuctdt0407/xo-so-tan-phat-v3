(function () {
    app.controller('Activity.groupMoneyManage', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon',
        function ($scope, $rootScope, $state, viewModel, sortIcon) {
            var vm = angular.extend(this, viewModel);

            vm.listVietlottMenu = [
                { Name: 'Tiền nạp Vietlott', href: '/activity/moneyVietlott', root: 'root.activity.moneyVietlott' },
                { Name: 'Đối chiếu Vietlott', href: '/report/compare', root: 'root.report.compare' },
            ]

            vm.listOwnDebtMenu = [
                { Name: 'Quản lý nợ riêng', href: '/activity/ownDebtManage', root: 'root.activity.ownDebtManage' },
                { Name: 'Yêu cầu nợ riêng', href: '/activity/requestOwnDebt', root: 'root.activity.requestOwnDebt' },
            ]

            vm.listTransfer_DebtMenu = [
                { Name: 'Quản lý chuyển khoản', href: '/activity/managePayment', root: 'root.activity.managePayment' },
                { Name: 'Quản lý nợ', href: '/activity/manageConfirm', root: 'root.activity.manageConfirm' },
                { Name: 'Quản lý nợ nhân viên', href: '/activity/manageStaffDebt', root: 'root.activity.manageStaffDebt' },
            ]

            vm.isShowList = function (list) {
                var checked = false;
                list.forEach(function (item) {
                    if ($rootScope.checkPermission(item.root)) {
                        checked = true;
                    }
                })
                console.log(checked);
                return checked;
            }

        }]);
})();