(function () {
    
    routes.error = {
        url: '/error/{code:401|403|404|500}',
        templateProvider: ['$stateParams', '$templateRequest', function ($stateParams, templateRequest) {
            var viewPath = baseAppPath + '/error/views/';
            var tplName = viewPath + $stateParams.code + ".html";
            return templateRequest(tplName);
        }],
        title: 'Page not found'
    };

})();