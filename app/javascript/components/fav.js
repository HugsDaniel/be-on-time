const addFavorites = () => {
  const csrfToken = document.querySelector("[name='csrf-token']").content
    const btn = document.getElementById("star")
    if (btn) {
      btn.addEventListener( "click", (event) => {
        fetch(`/itineraries/${btn.dataset.id}/mark_as_favorite`, {
          method: 'PATCH',
          headers: { 
            "X-CSRF-Token": csrfToken,
            'Accept': 'text/plain' 
          },
        })
          .then(response => response.text())
          .then((data) => {
              btn.innerHTML = data
          })
      })
    }
  }

export { addFavorites }