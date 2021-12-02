const addFavorites = () => {
    const form = document.querySelector("edit_itinerary")
    if (form) {
      const btn = document.querySelectorAll(".favorite")
      btn.forEach((button) => {
        button.addEventListener( "click", (event) => {
          const url = form.action
          fetch(url, {
            method: 'PATCH',
            headers: { 'Accept': 'text/plain' },
            body: new FormData(form)
          })
            .then(response => response.text())
            .then((data) => {
                console.log(data);
            })
        })
      })
    }
  }

export { addFavorites }