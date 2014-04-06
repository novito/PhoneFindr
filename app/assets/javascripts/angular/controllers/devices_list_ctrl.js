App.controller('DevicesListCtrl', ['$scope', 'Device', function ($scope, Device) {
    $scope.devices = Device.query();
    
    $scope.viewDevice = function(id) {
        $location.url = '/devices/#{id}';
    };
}]);
