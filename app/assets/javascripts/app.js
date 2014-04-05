window.App = angular.module('PhoneFinder', ['ngResource', 'ngRoute']);

App.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
	when("/devices", {templateUrl: "../../templates/devices/index.html", controller: "driversController"}).
	when("/drivers/:id", {templateUrl: "../../templates/devices/show.html", controller: "driverController"}).
	otherwise({redirectTo: '/drivers'});
}]);
