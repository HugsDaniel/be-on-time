const toggleMenu = () => {
    const menu = document.querySelector(".menu")
    const button = document.querySelector(".profile")
    button.addEventListener("click", (event) => {
        menu.classList.toggle("menu-active")
    })
}

export { toggleMenu }