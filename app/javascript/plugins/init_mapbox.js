import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

let marker;

const updateSource = setInterval(async () => {
  const idBus = document.getElementById('bus-id').dataset.id
  console.log(idBus)
  fetch(`https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-position-tr&q=&sort=idbus&facet=numerobus&facet=nomcourtligne&facet=sens&facet=destination&refine.idbus=${idBus}`)
    .then(response => response.json())
    .then((data) => {
      const lat = data.records[0].fields.coordonnees[0]
      const lng = data.records[0].fields.coordonnees[1]
      marker.remove()
      marker = new mapboxgl.Marker()
        .setLngLat([lng, lat])
        .addTo(map);

      map.flyTo({
        center: [lng, lat],
        speed: 30
      })
    }, 10000)
});

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  updateSource()
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
    updateSource()
    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };
