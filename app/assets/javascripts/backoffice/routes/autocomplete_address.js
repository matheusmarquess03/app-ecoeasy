function autocompleteAddressGoogle() {
  var input = document.activeElement;

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

      var districtFields  = document.getElementsByClassName("district-field");
      var cityFields      = document.getElementsByClassName("city-field");
      var stateFields     = document.getElementsByClassName("state-field");
      var countryFields   = document.getElementsByClassName("country-field");
      var latitudeFields  = document.getElementsByClassName("latitude-field");
      var longitudeFields = document.getElementsByClassName("longitude-field");

      districtFields[districtFields.length - 1].value   = district
      cityFields[cityFields.length - 1].value           = city
      stateFields[stateFields.length - 1].value         = state
      countryFields[countryFields.length - 1].value     = country
      latitudeFields[latitudeFields.length - 1].value   = latitude
      longitudeFields[longitudeFields.length - 1].value = longitude
    });
  });
}
