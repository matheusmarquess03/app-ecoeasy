function showDailyCollectInMap(locations) {
  var myCoords = new google.maps.LatLng(locations[0][0], locations[0][1]);

  var mapOptions = {
    center: myCoords,
    zoom: 13
  };

  window.map = new google.maps.Map(document.getElementById('map_to_daily_collect'), mapOptions);
  window.markers = [];

  for (i = 0; i < locations.length; i++) {
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(locations[i][0], locations[i][1]),
      animation: google.maps.Animation.DROP,
      map: window.map
    });
    window.markers.push(marker);
  }
}
