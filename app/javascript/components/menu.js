const toggleInfo = () => {
    const busInfo = document.querySelector(".bus-info")
    const button = document.querySelector("#info-btn")
    button.addEventListener("click", (event) => {
        busInfo.classList.toggle("info-active")
    })
}

const toggleMenu = () => {
    const menu = document.querySelector(".menu")
    const button = document.querySelector("#pp-btn")
    button.addEventListener("click", (event) => {
        menu.classList.toggle("menu-active")
    })
}

const toggleStatus = () => {
    const button = document.querySelector(".bus-status")
    button.addEventListener("click", (event) => {
        button.classList.toggle("active")
        
    })
}


export { toggleStatus }

export { toggleInfo }

export { toggleMenu }