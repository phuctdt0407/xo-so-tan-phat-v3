(function () {
    app.controller('Shared.Main', ['$scope', '$rootScope', '$state',
        function ($scope, $rootScope, $state) {
            var vm = this;

            $rootScope.openRecordingURL = function (url) {
                window.open(url, '_blank');
            }


        }]);
})();
