function showDailyCollectInMap(locations) {
  console.log(location);

  var myCoords = new google.maps.LatLng(locations[0][0], locations[0][1]);

  var mapOptions = {
    center: myCoords,
    zoom: 12
  };

  var map = new google.maps.Map(document.getElementById('map_to_daily_collect'), mapOptions);

  for (i = 0; i < locations.length; i++) {
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(locations[i][0], locations[i][1]),
      animation: google.maps.Animation.DROP,
      map: map
    });
  }
}
