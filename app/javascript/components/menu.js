const toggleMenu = () => {
    const menu = document.querySelector(".menu-main")
    if (menu != null) {
        const button = document.querySelector(".profile")
        button.addEventListener("click", (event) => {
            menu.classList.toggle("menu-active")
        })
    }
}


export { toggleMenu }
