import { gsap } from "gsap";

const toggleInfo = () => {
    const busInfo = document.querySelector(".bus-info")
    if (busInfo != null) {

        let animation = gsap.to('.form-check-label', {
            opacity:1,
            stagger:-0.1,
            ease: "back.out(2)",
            scale:1.2,
            paused: true,
            yoyo:true
        });

        const button = document.getElementById("info-btn");
        button.addEventListener("click", (event) => {
            animation.restart();

            busInfo.classList.toggle("info-active");
            button.classList.toggle("cross-active");
        })
    }
}


export { toggleInfo }
