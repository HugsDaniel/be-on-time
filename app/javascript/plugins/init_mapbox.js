import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;


    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/stanouuuu/ckwc8mhxk5ha815qnyxryrxb3',
      center: [-1.6777926, 48.11], // starting position [lng, lat]
      zoom: 13
    });
    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .addTo(map);
    });
    fitMapToMarkers(map, markers);

    setInterval(() => {
      fetch("https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-geoposition-suivi-new-billetique-tr&q=&refine.idbus=-429897408")
        .then(response => response.json())
        .then((data) => {
          const lat = data.records[0].fields.coordonnees[0]
          const lng = data.records[0].fields.coordonnees[1]

          console.log("Generaating marker")

          new mapboxgl.Marker()
            .setLngLat([lng, lat])
            .addTo(map);

          map.flyTo({
            center: [lng, lat],
            speed: 0.1
          })
        })
    }, 2000)
  }
};

export { initMapbox };
