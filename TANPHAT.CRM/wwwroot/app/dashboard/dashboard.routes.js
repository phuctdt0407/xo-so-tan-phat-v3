(function () {
    var viewPath = baseAppPath + '/dashboard/views/';

    routes.home = {
        url: '/',
        templateUrl: viewPath + 'dashboard.html' + versionTemplate,
        controller: 'DashBoard as $vm',
        resolve: {
            viewModel: ['$q', 'dashboardService', '$rootScope','$state',
                function ($q, dashboardService, $rootScope, $state) {
                    var deferred = $q.defer();
                    $q.all([

                    ]).then(function (res) {
                        var result = {

                        };
                        deferred.resolve(result);
                    });
                    return deferred.promise;
                }]
        },
        title: 'Trang chủ'
    };
    
})();