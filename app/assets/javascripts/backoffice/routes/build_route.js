function buildRoute() {
  initMap();

  window.map.addListener('click', function(event) {
    addMarker(event.latLng);
    completeFormAddress(event.latLng);
  });
}

function addMarker(location) {
  var marker = new google.maps.Marker({
    position: location,
    map: window.map
  });

  if (window.allpoints.length >= 3) {
    window.waypts.push(window.allpoints[window.allpoints.length-1]);
  }

  window.allpoints.push({
    location: location
  });

  if (window.allpoints.length >= 2) {
    window.waypts.push({
      location: location
    });
    marker.setMap(null);
    marker.setVisible(false);
    calculateRoute();
  }

  if (window.allpoints.length >= 3) {
    window.waypts.pop();
  }
}

function calculateRoute(){
  var directionsDisplay = new google.maps.DirectionsRenderer({ suppressMarkers: true });
  var directionsService = new google.maps.DirectionsService();

  directionsDisplay.setMap(window.map);

  var request = {
    origin: window.allpoints[0],
    destination: window.allpoints[window.allpoints.length-1],
    waypoints: window.waypts,
    optimizeWaypoints: false,
    travelMode: 'DRIVING'
  };

  directionsService.route(request, function(result, status){
    if (status == 'OK') {
      directionsDisplay.setDirections(result);
    } else {
      if (status == 'MAX_WAYPOINTS_EXCEEDED') {
        window.alert('Você selecionou o máximo de pontos permitidos');
      }else {
        window.alert('Directions request failed due to ' + status);
      }
    }
  });
}

function completeFormAddress(location) {
  var geocoder = new google.maps.Geocoder;

  geocoder.geocode({'location': location}, function(results, status) {
    var place             = results[0].address_components;
        formatted_address = results[0].formatted_address

    if (place[0]['types'][0] == 'street_number')               { var number   = place[0]['long_name'] }
    if (place[1]['types'][0] == 'route')                       { var street   = place[1]['long_name'] }
    if (place[2]['types'][2] == 'sublocality_level_1')         { var district = place[2]['long_name'] }
    if (place[3]['types'][0] == 'administrative_area_level_2') { var city     = place[3]['long_name'] }
    if (place[4]['types'][0] == 'administrative_area_level_1') { var state    = place[4]['long_name'] }
    if (place[5]['types'][0] == 'country')                     { var country  = place[5]['long_name'] }
    if (place[6]['types'][0] == 'postal_code')                 { var zip_code = place[6]['long_name'] }

    var latitude        = location.lat();
    var longitude       = location.lng();

    $('#address input.number-field-field:last').val(number);
    $('#address input.street-field:last').val(street);
    $('#address input.district-field:last').val(district);
    $('#address input.city-field:last').val(city);
    $('#address input.state-field:last').val(state);
    $('#address input.country-field:last').val(country);
    $('#address input.zip-code-field:last').val(zip_code);
    $('#address input.latitude-field:last').val(latitude);
    $('#address input.longitude-field:last').val(longitude);

    $('#address input.formatted-address-field:last').val(formatted_address);

    addNestedField($('.add_fields'));
  })
}

function listenerRemoveAddressReplyOnMap() {
  $('#address').on('click', 'a.remove_fields', function(){
    var lat = $(this).parent().parent().find('.latitude-field').val();
    var lng = $(this).parent().parent().find('.longitude-field').val();

    var myCoords = new google.maps.LatLng(lat, lng);

    window.waypts.map( function( waypoint ) {
      if ( (myCoords.lat() == waypoint.location.lat()) && (myCoords.lng() == waypoint.location.lng()) ){
        remove(window.waypts, waypoint);
      }
    });

    window.allpoints.map( function( waypoint ) {
      if ( (myCoords.lat() == waypoint.location.lat()) && (myCoords.lng() == waypoint.location.lng()) ){
        remove(window.allpoints, waypoint);
        buildRoute();
        calculateRoute();
      }
    })
  });
}


// Privates Methods

function initMap() {
  // var lat = '-22.5273041'
  // var lng = '-41.9463158'

  var lat = '-2.501836'
  var lng = '-44.165189'

  var myCoords = new google.maps.LatLng(lat, lng);

  var mapOptions = {
    center: myCoords,
    zoom: 18
  };

  window.map = new google.maps.Map(document.getElementById('map_to_daily_collect'), mapOptions);
}

function initWaypoits() {
  window.allpoints = [];
  window.waypts = [];
  window.count = 0
}

function remove(array, element) {
  const index = array.indexOf(element);
  array.splice(index, 1);
}
