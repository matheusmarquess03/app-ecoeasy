function showDailyCollectInMap(locations) {
  initWaypoits();
  initMap();

  for (i = 0; i < locations.length; i++) {
    window.allpoints.push({
      location: new google.maps.LatLng(locations[i][0], locations[i][1])
    });

    window.waypts.push({
      location: new google.maps.LatLng(locations[i][0], locations[i][1])
    });

    if (i == locations.length - 1) {
      window.waypts.pop();
      calculateRoute();
    }
  }
}
