App.controller('DevicesListCtrl', ['$scope', 'Device', function ($scope, Device) {
    $scope.message = "Angular Rocks!";
    $scope.devices = Device.query();
}]);
