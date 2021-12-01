
const busId = document.querySelector(".bus-id")
const url = `https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-geoposition-suivi-new-billetique-tr&q=&refine.idbus=${busId}`;

const markBus = (event) => {
  fetch(url)
    .then(response => response.json())
    .then((data) => {
      console.log(data.records[0].fields.coordonnees)
    });
};


export { markBus }
