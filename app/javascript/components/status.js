const toggleInfo = () => {
    const busInfo = document.querySelector(".bus-info")
    if (busInfo != null) {
        const button = document.getElementById("info-btn")
        console.log(button)
        console.log(busInfo)
        button.addEventListener("click", (event) => {
            busInfo.classList.toggle("info-active")
        })
    }
}


export { toggleInfo }