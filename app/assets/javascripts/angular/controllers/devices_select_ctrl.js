App.controller('DevicesSelectCtrl', ['$scope', '$location', 'DeviceSelection', function ($scope, $location, $deviceSelection) {
    $scope.steps = [
        'How much do you talk?',
        'Operating System',
        'Keyboard'
    ];
  $scope.selection = $scope.steps[0];

  $scope.selections=$deviceSelection.selections;
  $scope.operatingSystems = $deviceSelection.operatingSystems;

  $scope.submitForm = function(){
      $location.path("/devices");
  };


  $scope.toogleSelectionOS = function toogleSelectionOS(os) {
      var idx = $scope.selections.operatingSystems.indexOf(os);

      // is currently selected
      if (idx > -1) {
          $scope.selections.operatingSystems.splice(idx, 1);
      }

      // is newly selected
      else {
          $scope.selections.operatingSystems.push(os);
      }
  };

  $scope.getCurrentStepIndex = function(){
    // Get the index of the current step given selection
    return _.indexOf($scope.steps, $scope.selection);
  };

  // Go to a defined step index
  $scope.goToStep = function(index) {
    if ( !_.isUndefined($scope.steps[index]) )
    {
      $scope.selection = $scope.steps[index];
    }
  };

  $scope.hasNextStep = function(){
    var stepIndex = $scope.getCurrentStepIndex();
    var nextStep = stepIndex + 1;
    // Return true if there is a next step, false if not
    return !_.isUndefined($scope.steps[nextStep]);
  };

  $scope.hasPreviousStep = function(){
    var stepIndex = $scope.getCurrentStepIndex();
    var previousStep = stepIndex - 1;
    // Return true if there is a next step, false if not
    return !_.isUndefined($scope.steps[previousStep]);
  };

  $scope.incrementStep = function() {
    if ( $scope.hasNextStep() )
    {
      var stepIndex = $scope.getCurrentStepIndex();
      var nextStep = stepIndex + 1;
      $scope.selection = $scope.steps[nextStep];
    }
  };

  $scope.decrementStep = function() {
    if ( $scope.hasPreviousStep() )
    {
      var stepIndex = $scope.getCurrentStepIndex();
      var previousStep = stepIndex - 1;
      $scope.selection = $scope.steps[previousStep];
    }
  };
}]);
