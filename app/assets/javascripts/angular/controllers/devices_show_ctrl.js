App.controller('DevicesShowCtrl', ['$scope', 'Device', '$routeParams', function ($scope, Device, $routeParams) {
    $scope.device = Device.get({id: $routeParams.id});
}]);
