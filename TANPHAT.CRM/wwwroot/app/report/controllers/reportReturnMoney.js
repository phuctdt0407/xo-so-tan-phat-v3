(function () {
    app.controller('Report.reportReturnMoney', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'reportService', 'dayOfWeekVN', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, reportService, dayOfWeekVN, $uibModal) {
            var vm = angular.extend(this, viewModel);
            var formatDate = ['DD/MM/YYYY', 'YYYY-MM-DD', "DD-MM-YYYY"];
            var sumShift1 = 0;
            var sumShift2 = 0;
            vm.changeDate = function () {
                
                vm.params.Date = moment(vm.params.Date, formatDate).format('YYYY-MM-DD')
              
                $state.go($state.current, vm.params, {
                    reload: true,
                    notify: true
                });

            }
            
            vm.listSalePoint.forEach(ele=>{
               ele.shift1 = vm.listReturnMoney.find(ele1=>ele1.SalePointId == ele.Id && ele1.ShiftId == 1 )?vm.listReturnMoney.find(ele1=>ele1.SalePointId == ele.Id && ele1.ShiftId == 1).TotalMoneyInADay:0
                ele.shift1Id = vm.listReturnMoney.find(ele1=>ele1.SalePointId == ele.Id && ele1.ShiftId == 1 )?vm.listReturnMoney.find(ele1=>ele1.SalePointId == ele.Id && ele1.ShiftId == 1).ReturnMoneyId:null
                ele.shift2 = vm.listReturnMoney.find(ele1=>ele1.SalePointId == ele.Id && ele1.ShiftId == 2 )?vm.listReturnMoney.find(ele1=>ele1.SalePointId == ele.Id && ele1.ShiftId == 2).TotalMoneyInADay:0
                ele.shift2Id = vm.listReturnMoney.find(ele1 => ele1.SalePointId == ele.Id && ele1.ShiftId == 2) ? vm.listReturnMoney.find(ele1 => ele1.SalePointId == ele.Id && ele1.ShiftId == 2).ReturnMoneyId : null
                
            })

            console.log("listSale",vm.listSalePoint)

            vm.listSalePoint.forEach(ele => {
                sumShift1 += ele.shift1
                sumShift2 += ele.shift2
                
            })
            $scope.sumShift1 = sumShift1
            $scope.sumShift2 = sumShift2
            console.log('123', sumShift1)
          
            vm.openUpdateReturnMoney = function (model, shiftId) {
                var viewPath = baseAppPath + '/report/views/modal/';
                var request = $uibModal.open({
                    templateUrl: viewPath + 'UpdateReturnMoney.html' + versionTemplate,
                    controller: 'Report.updateReturnMoney as $vm',
                    backdrop: 'static',
                    size: 'md',
                    resolve: {
                        viewModel: ['$q', '$uibModal', 'reportService', 'ddlService',
                            function ($q, $uibModal, reportService, ddlService) {
                                var deferred = $q.defer();

                                $q.all([

                                ]).then(function (res) {
                                    var result = {
                                        data: model,
                                        shiftId: shiftId
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

                    }
                })
            }
            
        }]);
})();