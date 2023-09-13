(function () {
	angular.module('KTHubApp').service('sessionService', ['$rootScope', function ($rootScope) {
		var userRole = [];

		this.setUserRole = function (data) {
			userRole = data;
			$rootScope.$broadcast('event:role-change', { some: 'data' });
		};

		this.getUserRole = function () {
			return userRole;
		};
	}]);
})();