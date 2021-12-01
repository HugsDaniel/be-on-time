import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import turf from 'turf';

let marker;

const updateSource = (map) => {
  const bus = document.getElementById('bus-id')
  const image = document.getElementById('bus-img')
  if (bus) {
    const idBus = bus.dataset.id
    const image_url = image.dataset.url
    fetch(`https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-position-tr&q=&sort=idbus&facet=numerobus&facet=nomcourtligne&facet=sens&facet=destination&refine.idbus=${idBus}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306`)
      .then(response => response.json())
      .then((data) => {
        // Create a HTML element for your custom marker
        const element = document.createElement('div');
        element.className = 'marker';
        element.style.backgroundImage = `url('${image_url}')`;
        element.style.backgroundSize = 'contain';
        element.style.width = '30px';
        element.style.height = '30px';

        const lat = data.records[0].fields.coordonnees[0]
        const lng = data.records[0].fields.coordonnees[1]
        marker = new mapboxgl.Marker(element)
        .setLngLat([lng, lat])
        .addTo(map);


        map.flyTo({
          center: [lng, lat],
          speed: 30
        })
      })
    }
  }

  const initMapbox = () => {
    const mapElement = document.getElementById('map');
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
        const element = document.createElement('div');
        element.className = 'marker';
        element.style.backgroundImage = `url('${marker.image_url}')`;
        element.style.backgroundSize = 'contain';
        element.style.width = '20px';
        element.style.height = '20px';
        element.style.left = '-1px';
        element.style.top = '-14px';

        new mapboxgl.Marker(element)
          .setLngLat([marker.lng, marker.lat])
          .addTo(map);
      });

      const bounds = new mapboxgl.LngLatBounds();
      markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
      map.fitBounds(bounds, { padding: { top: 30, bottom: 320, left: 70, right: 70 }, maxZoom: 15, duration: 0 });

      updateSource(map)

      setInterval(async () => {
      if (marker) { marker.remove() }
      updateSource(map)
      }, 7000)

    map.on('load', () => {
      const nothing = turf.featureCollection([]);
      map.addSource('route', {
        type: 'geojson',
        data: nothing
      });

      map.addLayer(
        {
          id: 'routeline-active',
          type: 'line',
          source: 'route',
          layout: {
            'line-join': 'round',
            'line-cap': 'round',
            'visibility': 'visible'
          },
          paint: {
            'line-color': '#47B1FF',
            'line-width': ['interpolate', ['linear'], ['zoom'], 12, 3, 22, 15]
          }
        },
        'waterway-label'
      );

      const coordinatesContainer = document.getElementById("coordinates")

      if (coordinatesContainer) {
        const url = `https://api.mapbox.com/optimized-trips/v1/mapbox/walking/${coordinatesContainer.dataset.coordinates}?roundtrip=false&destination=last&overview=full&steps=true&geometries=geojson&source=first&access_token=${mapElement.dataset.mapboxApiKey}`
        fetch(url)
          .then(response => response.json())
          .then((data) => {
            const routeGeoJSON = turf.featureCollection([
              turf.feature(data.trips[0].geometry)
            ]);
            map.getSource('route').setData(routeGeoJSON);
          })
      }
    });
  }

};

export { initMapbox };
