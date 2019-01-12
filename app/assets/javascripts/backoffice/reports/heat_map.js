function heatMaps(locations) {
  var map = initMap();
  
  if (locations.length != 0) {
    var heatmapData = [];
    for (i = 0; i < locations.length; i++) {
      heatmapData.push(new google.maps.LatLng(locations[i][0], locations[i][1]))
    }
    var heatmap = new google.maps.visualization.HeatmapLayer({
      data: heatmapData
    });
    heatmap.setMap(map);
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
}
