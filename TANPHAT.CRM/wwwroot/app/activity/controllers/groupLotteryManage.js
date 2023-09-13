(function () {
    app.controller('Activity.groupLotteryManage', ['$scope', '$rootScope', '$state', 'viewModel', 'sortIcon',
        function ($scope, $rootScope, $state, viewModel, sortIcon) {
            var vm = angular.extend(this, viewModel);

            vm.listActivityMenu = [
                { Name: 'Nhập vé từ đại lý', href: '/activity/create', root: 'root.activity.create' },
                { Name: 'Chia vé cho điểm bán', href: '/activity/manage', root: 'root.activity.manage' },
                { Name: 'Chia vé cho đại lý con', href: '/activity/distributeForSubAgency', root: 'root.activity.distributeForSubAgency' },
                { Name: 'Nhận vé cào', href: '/activity/createScratchcard', root: 'root.activity.createScratchcard' },
                { Name: 'Chia vé cào', href: '/activity/manageScratchcard', root: 'root.activity.manageScratchcard' },
                { Name: 'Chia vé cào cho đại lý con', href: '/activity/manageScratchcardForSubAgency', root: 'root.activity.manageScratchcardForSubAgency' },
                { Name: 'Giá vé đại lý', href: '/activity/agencyPrice', root: 'root.activity.agencyPrice' },
                { Name: 'Giá vé đại lý con', href: '/activity/subAgencyPrice', root: 'root.activity.subAgencyPrice' },
                { Name: 'Trả ế', href: '/activity/returnAgency', root: 'root.activity.returnAgency' },
            ]

            vm.listTransferMenu = [
                { Name: 'Chuyển nhận vé', href: '/activity/inventoryManage', root: 'root.activity.inventoryManage' },
                { Name: 'Yêu cầu chuyển nhận vé', href: '/activity/checkTransfer', root: 'root.activity.checkTransfer' },
                { Name: 'Thống kê chuyển nhận vé', href: '/activity/sendAndReceive', root: 'root.activity.sendAndReceive' },
            ]
          
            vm.isShowList = function (list) {
                var checked = false;
                list.forEach(function (item) {
                    if ($rootScope.checkPermission(item.root)) {
                       
                        checked = true;
                    }
                })
       
                return checked;
            }

        }]);
})();