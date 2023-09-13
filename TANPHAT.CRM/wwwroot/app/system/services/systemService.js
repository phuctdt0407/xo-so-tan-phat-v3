(function () {
    app.service('systemService', ['baseService',
        function (baseService) {
            var baseUrl = baseService.baseUrl + '/System';

            this.getSalePoint = function (params) {
                var url = baseUrl + '/GetSalePoint';
                return baseService.getData(url, params);
            };

            this.createSalePoint = function (params) {
                var url = baseUrl + '/CreateSalePoint';
                return baseService.postData(url, params);
            };

        }]);
})();