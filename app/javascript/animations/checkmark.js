import { gsap } from "gsap";

const checkAnimation = () => {
    if (document.querySelector('.check')) {
            const tl = gsap.timeline();
            tl.to('.circle', {duration: 2.5, opacity: 1, strokeDashoffset:0, strokeWidth:4})
            .to('.check',  {duration: 1.5, opacity: 1, strokeDashoffset:0}, "<0.75" );
    };
}

export { checkAnimation };
