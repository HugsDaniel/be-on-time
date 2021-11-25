const toggleinfo = () => {
    const button = document.querySelector("#info-btn")
    const busInfo = document.querySelector(".bus-info")
    button.addEventListener("click", (event) => {
        busInfo.classList.toggle("info-active")
    })
}

export { toggleinfo }