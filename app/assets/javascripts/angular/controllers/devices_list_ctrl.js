App.controller('DevicesListCtrl', ['$scope', 'Device', 'DeviceSelection', function ($scope, Device, DeviceSelection) {
    $scope.devices = Device.query();
    
    $scope.viewDevice = function(id) {
        $location.url = '/devices/#{id}';
    };
}]);
