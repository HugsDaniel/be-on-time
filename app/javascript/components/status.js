const toggleInfo = () => {
    const busInfo = document.querySelector(".bus-info")
    if (busInfo != null) {
        const button = document.getElementById("info-btn")
        button.addEventListener("click", (event) => {
            busInfo.classList.toggle("info-active")
            button.classList.toggle("cross-active")

        })
    }
}


export { toggleInfo }