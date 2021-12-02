import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import turf from 'turf';


const animatePointAlongLine = (map, routeGeoJSON, followCam = false) => {
  const origin = routeGeoJSON.features[0].geometry.coordinates[0]
  const destination = routeGeoJSON.features[0].geometry.coordinates[-1]
  const steps = routeGeoJSON.features[0].geometry.coordinates
  let counter = 0

  const point = {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'properties': {},
        'geometry': {
          'type': 'Point',
          'coordinates': origin
        }
      }
    ]
  };

  const sourceObject = map.getSource('point');
  const layerObject = map.getLayer('point');

  if (sourceObject && layerObject) {
    map.removeLayer("point")
    map.removeSource("point")
  }

  map.addSource('point', {
    'type': 'geojson',
    'data': point
  });

  map.addLayer({
    'id': 'point',
    'source': 'point',
    'type': 'symbol',
    'layout': {
      'icon-image': 'bus',
      'icon-rotate': ['get', 'bearing'],
      'icon-rotation-alignment': 'map',
      'icon-allow-overlap': true,
      'icon-ignore-placement': true
    }
  });

  const animate = () => {
    const start =
      routeGeoJSON.features[0].geometry.coordinates[
        counter >= steps ? counter - 1 : counter
      ];

    const end =
      routeGeoJSON.features[0].geometry.coordinates[
        counter >= steps ? counter : counter + 1
      ];

    if (!start || !end) return;

    // Update point geometry to a new position based on counter denoting
    // the index to access the arc
    point.features[0].geometry.coordinates =
      routeGeoJSON.features[0].geometry.coordinates[counter];

    // Calculate the bearing to ensure the icon is rotated to match the routeGeoJSON arc
    // The bearing is calculated between the current point and the next point, except
    // at the end of the arc, which uses the previous point and the current point
    point.features[0].properties.bearing = turf.bearing(
      turf.point(start),
      turf.point(end)
    );

    if (followCam) {
      let bearing = turf.bearing(turf.point(start), turf.point(end))

      map.flyTo({
        center: point.features[0].geometry.coordinates,
        speed: 0.1,
        curve: 1,
        easing(t) {
          return t;
        }
      })

    }

    // Update the source with this new data
    map.getSource('point').setData(point);

    // Request the next frame of animation as long as the end has not been reached
    if (counter < steps) {
      requestAnimationFrame(animate);
    }

    counter = counter + 1;


    // TODO remove previous point on course

  }

  // Start the animation
  setInterval(() => {
    animate(counter);
  }, 2000)
}

const addMarkerToMap = (map, marker) => {
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
}

const initShowMapbox = () => {
  const mapElement = document.getElementById('map');
  const showElement = document.getElementById('show')

  if (mapElement && showElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;

    const markers = JSON.parse(mapElement.dataset.markers);

    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/stanouuuu/ckwc8mhxk5ha815qnyxryrxb3',
      center: [markers[0].lng, markers[0].lat], // starting position [lng, lat]
      zoom: 13
    });

    if (markers && markers.length > 0) {
      markers.forEach((marker) => {
        addMarkerToMap(map, marker)
      });
    }


    // setInterval(async () => {
    //   updateSource(map)
    // }, 7000)

    let routeGeoJSON;

    map.on('load', () => {
      const nothing = turf.featureCollection([]);
      map.addSource(`route`, {
        type: 'geojson',
        data: nothing
      });

      map.addLayer(
        {
          id: `routeline-active`,
          type: 'line',
          source: `route`,
          layout: {
            'line-join': 'round',
            'line-cap': 'round',
            'visibility': 'visible'
          },
          paint: {
            'line-color': `#47B1FF`,
            'line-width': ['interpolate', ['linear'], ['zoom'], 12, 3, 22, 15]
          }
        },
        'waterway-label'
      );

      const geometry = JSON.parse(document.getElementById("routeGeo").dataset.route)
      const approachingRouteGeoJSON = turf.featureCollection([
        turf.feature(geometry)
      ]);
      map.getSource(`route`).setData(approachingRouteGeoJSON);
      // A single point that animates along the route.
      // Coordinates are initially set to origin.
      animatePointAlongLine(map, approachingRouteGeoJSON)


      const coordinatesContainers = document.querySelectorAll(".itineraryCoordinates")

      if (coordinatesContainers && coordinatesContainers.length > 0) {
        coordinatesContainers.forEach((container) => {
          let id = container.dataset.id
          let colour = container.dataset.colour
          let coordinates = container.dataset.coordinates

          const nothing = turf.featureCollection([]);
          map.addSource(`route-${id}`, {
            type: 'geojson',
            data: nothing
          });

          map.addLayer(
            {
              id: `routeline-active-${id}`,
              type: 'line',
              source: `route-${id}`,
              layout: {
                'line-join': 'round',
                'line-cap': 'round',
                'visibility': 'visible'
              },
              paint: {
                'line-color': `${colour}`,
                'line-width': ['interpolate', ['linear'], ['zoom'], 12, 3, 22, 15]
              }
            },
            'waterway-label'
          );

          const url = `https://api.mapbox.com/optimized-trips/v1/mapbox/walking/${coordinates}?roundtrip=false&destination=last&overview=full&steps=true&geometries=geojson&source=first&access_token=${mapElement.dataset.mapboxApiKey}`
          fetch(url)
            .then(response => response.json())
            .then((data) => {
              routeGeoJSON = turf.featureCollection([
                turf.feature(data.trips[0].geometry)
              ]);
              map.getSource(`route-${id}`).setData(routeGeoJSON);
            })
        })
      }
    });

    const startBtn = document.getElementById("startTrip")

    if (startBtn) {
      startBtn.addEventListener("click", (event) => {
        event.preventDefault()
        let lastIndex = routeGeoJSON.features[0].geometry.coordinates.length - 1
        const bearing = turf.bearing(
          turf.point(routeGeoJSON.features[0].geometry.coordinates[0]),
          turf.point(routeGeoJSON.features[0].geometry.coordinates[lastIndex])
        );

        map.flyTo({
          center: [markers[0].lng, markers[0].lat],
          pitch: 65,
          bearing: bearing,
          zoom: 16,
          speed: 1,
          curve: 1,
          easing(t) {
            return t;
          }
        });

        const startBtn = document.getElementById("startTrip")
        startBtn.classList.add("d-none")
        const endBtn = document.getElementById("endTrip")
        endBtn.classList.remove("d-none")

        document.getElementById("info-btn").classList.remove("d-none")
        map.getSource(`route`).setData(turf.featureCollection([]));
        animatePointAlongLine(map, routeGeoJSON, true)
      })
    }
  }
}

const initIndexMapbox = () => {
  const mapElement = document.getElementById('map');
  const indexElement = document.getElementById('index')

  if (mapElement && indexElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;

    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/stanouuuu/ckwc8mhxk5ha815qnyxryrxb3',
      center: [-1.6777926, 48.11], // starting position [lng, lat]
      zoom: 13
    });

    const markers = JSON.parse(mapElement.dataset.markers);
    if (markers && markers.length > 0) {
      markers.forEach((marker) => {
        addMarkerToMap(map, marker)
      });
      const bounds = new mapboxgl.LngLatBounds();
      markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
      map.fitBounds(bounds, { padding: { top: 30, bottom: 320, left: 70, right: 70 }, maxZoom: 15, duration: 0 });
    }

    // updateSource(map)

    // setInterval(async () => {
    //   updateSource(map)
    // }, 7000)

    map.on('load', () => {
      const coordinatesContainers = document.querySelectorAll(".itineraryCoordinates")

      if (coordinatesContainers && coordinatesContainers.length > 0) {
        coordinatesContainers.forEach((container) => {
          let id = container.dataset.id
          let colour = container.dataset.colour
          let coordinates = container.dataset.coordinates

          const nothing = turf.featureCollection([]);
          map.addSource(`route-${id}`, {
            type: 'geojson',
            data: nothing
          });

          map.addLayer(
            {
              id: `routeline-active-${id}`,
              type: 'line',
              source: `route-${id}`,
              layout: {
                'line-join': 'round',
                'line-cap': 'round',
                'visibility': 'visible'
              },
              paint: {
                'line-color': `${colour}`,
                'line-width': ['interpolate', ['linear'], ['zoom'], 12, 3, 22, 15]
              }
            },
            'waterway-label'
          );

          const url = `https://api.mapbox.com/optimized-trips/v1/mapbox/walking/${coordinates}?roundtrip=false&destination=last&overview=full&steps=true&geometries=geojson&source=first&access_token=${mapElement.dataset.mapboxApiKey}`
          fetch(url)
            .then(response => response.json())
            .then((data) => {
              const routeGeoJSON = turf.featureCollection([
                turf.feature(data.trips[0].geometry)
              ]);
              map.getSource(`route-${id}`).setData(routeGeoJSON);

            })
        })
      }
    });
  }

};

export { initIndexMapbox, initShowMapbox };
