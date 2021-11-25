const panelTrigger = () => {

  const collapseBtn = document.querySelector('.btn-expand');
  const itineraryInfoPanel = document.querySelector('.intinerary-infos');


  collapseBtn.addEventListener('click', (e) => {
    collapseBtn.classList.toggle('btn-rotate');



    itineraryInfoPanel.classList.toggle('itinerary-collapse');
  });
}

export { panelTrigger };
