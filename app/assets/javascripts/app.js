window.App = angular.module('PhoneFinder', ['ngResource', 'ngRoute']);

App.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
	when("/devices", {templateUrl: "assets/devices/index.html", controller: "DevicesListCtrl"}).
	when("/devices/:id", {templateUrl: "assets/devices/show.html", controller: "DevicesShowCtrl"}).
	otherwise({redirectTo: '/devices'});
}]);
