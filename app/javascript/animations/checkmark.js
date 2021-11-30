import { gsap } from "gsap";

const checkAnimation = () => {
    if (document.querySelector('.check')) {
            const tl = gsap.timeline();
            tl.to('.circle', {duration: 4, opacity: 1, strokeDashoffset:0, strokeWidth:4})
            .to('.check',  {duration: 1.6, opacity: 1, strokeDashoffset:0}, "<1" );
    };
}

export { checkAnimation };
