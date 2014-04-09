App.factory('DeviceSelection',function() {
   var selections = {longHour: '', operatingSystems: [], keyboard: []};
   var operatingSystems = ['Windows', 'iOS', 'Android', "I don't know"];

   // New OperatingSystems with objects
   var operatingSystems = [{id: 'win', name: 'Windows'}, {id: 'ios', name: 'iOS'},
                            {id: 'android', name: 'Android'}, {id: 'dontknow', name: "I don't know"}];

   return { operatingSystems: operatingSystems, selections: selections };
});
