App.controller('DevicesListCtrl', ['$scope', 'Device', 'DeviceSelection', function ($scope, Device, DeviceSelection) {
    var selectionParams = DeviceSelection.selections;
    console.log(selectionParams);

    $scope.devices = Device.query({ 'os[]': selectionParams.operatingSystems, 
                                    longHour: selectionParams.longHour, 
                                    keyboard: selectionParams.keyboard });
    
    $scope.viewDevice = function(id) {
        $location.url = '/devices/#{id}';
    };
}]);
