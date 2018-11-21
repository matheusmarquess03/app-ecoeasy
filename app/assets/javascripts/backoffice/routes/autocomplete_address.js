function autocompleteAddressGoogle(element) {
  var input       = document.getElementById(element),
      inputObject = $('#'+element+'');

  if (input) {
    var searchBox = new google.maps.places.SearchBox(input);
  }

  searchBox.addListener('places_changed', function() {
    var places = searchBox.getPlaces();

    places.forEach(function(place) {
      var district        = place.address_components[0]['long_name']
      var city            = place.address_components[1]['long_name']
      var state           = place.address_components[2]['short_name']
      var country         = place.address_components[3]['long_name']
      var latitude        = place.geometry.location.lat();
      var longitude       = place.geometry.location.lng();

      inputObject.parent().find('.district-field').val(district);
      inputObject.parent().find('.city-field').val(city);
      inputObject.parent().find('.state-field').val(state);
      inputObject.parent().find('.country-field').val(country);
      inputObject.parent().find('.latitude-field').val(latitude);
      inputObject.parent().find('.longitude-field').val(longitude);

      includeMarkerOnMap(place);
    });
  });
}


function includeMarkerOnMap(place) {
  if (typeof window.markers == 'undefined') { window.markers = [] }
  
  marker = new google.maps.Marker({
    animation: google.maps.Animation.DROP,
    map: window.map
  });

  marker.setPosition(place.geometry.location);
  marker.setVisible(true);
  window.markers.push(marker);
}

function listenerRemoveMarkerReplyOnMap() {
  $('#address').on('click', 'a.remove_fields', function(){
    var lat = $(this).parent().parent().find('.latitude-field').val();
    var lng = $(this).parent().parent().find('.longitude-field').val();

    var myCoords = new google.maps.LatLng(lat, lng);

    window.markers.map( function( marker ) {
      if ( (myCoords.lat() == marker.getPosition().lat()) && (myCoords.lng() == marker.getPosition().lng()) ){
        marker.setMap(null);
        marker.setVisible(false);
      }
    })
  });
}
