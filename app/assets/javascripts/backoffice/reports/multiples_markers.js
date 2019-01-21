function showCollectsOnMaps(locations) {
  var map = initMap();

  if (locations.length != 0) {
    for (i = 0; i < locations.length; i++) {
      var marker = addMarkerOnMap(locations, i, map);

      if (locations[i][3] != undefined) {
        addInfoWindows(map, marker, locations, i);
      }
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
      "dumped": "green",
      "infringement": "red"
    }

    var status = statuses[locations[i][2]];

    if (status == undefined) {
      var status = statuses['requested']
    }

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(locations[i][0], locations[i][1]),
      map: map,
      icon: 'http://maps.google.com/mapfiles/ms/icons/'+status+'-dot.png'
    });

    return marker
  }

  function addInfoWindows(map, marker, locations, i) {
    var serviceTypes = {
      "mulcts": "Multa aplicada",
      "incidents": "Ocorrência na varredura",
      "rubble_collects": "Coleta de entulho atendida",
      "daily_collect": "Coleta de lixo concluída"
    }

    var contentString = serviceTypes[locations[i][3]]

    var infowindow = new google.maps.InfoWindow({
      content: contentString
    });

    marker.addListener('mouseover', function() {
      infowindow.open(map, marker);
    });

    marker.addListener('mouseout', function() {
      infowindow.close(map, marker);
    });
  }
}
