function initMapOnNewForm() {
  var lat = '-22.5273041'
  var lng = '-41.9463158'

  var myCoords = new google.maps.LatLng(lat, lng);

  var mapOptions = {
    center: myCoords,
    zoom: 13
  };

  window.map = new google.maps.Map(document.getElementById('map_to_daily_collect'), mapOptions);
}
