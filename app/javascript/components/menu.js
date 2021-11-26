const toggleMenu = () => {
    const menu = document.querySelector(".menu")
    if (menu != null) {
        const button = document.querySelector("#pp-btn")
        button.addEventListener("click", (event) => {
            menu.classList.toggle("menu-active")
        })
    }
}


export { toggleMenu }
