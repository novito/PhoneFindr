App.factory( 'Device', [ '$resource', function( $resource ) {
   return $resource( '/api/devices/:id', { id: '@id'} );
}]);
