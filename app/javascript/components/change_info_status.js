const changeStatus = () => {
  const form = document.querySelector(".edit_bus")
  if (form) {
    const btns = document.querySelectorAll(".bus-status")
    btns.forEach((button) => {
      button.addEventListener( "click", (event) => {
        const url = form.action
        fetch(url, {
          method: 'PATCH',
          headers: { 'Accept': 'text/plain' },
          body: new FormData(form)
        })
          .then(response => response.text())
          .then((data) => {
          document.getElementById("bus-status-container").innerHTML = data
          })
      })
    })
  }
}


export { changeStatus }
