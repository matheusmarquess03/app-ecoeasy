function showCollectsOnMaps(locations) {
  var map = initMap();

  if (locations.length != 0) {
    for (i = 0; i < locations.length; i++) {
      addMarkerOnMap(locations, i, map);
    }
  }


  // private methods
  function initMap() {
    var lat = '-22.5174049'
    var lng = '-41.9463168'

    var myCoords = new google.maps.LatLng(lat, lng);

    var mapOptions = {
      center: myCoords,
      zoom: 13
    };

    return new google.maps.Map(document.getElementById('map-collect-reports'), mapOptions);
  }

  function addMarkerOnMap(locations, i) {
    var statuses = {
      "requested": "blue",
      "proposed_date": "blue",
      "confirmed": "blue",
      "cancelled": "yellow",
      "collected": "green",
      "dumped": "green"
    }

    var status = statuses[locations[i][2]];

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(locations[i][0], locations[i][1]),
      map: map,
      icon: 'http://maps.google.com/mapfiles/ms/icons/'+status+'-dot.png'
    });
  }
  // heatMaps();
}
