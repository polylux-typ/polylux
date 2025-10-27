const outlineToggle = document.getElementById("outline-toggle");
const outline = document.getElementById("outline");
const main = document.querySelector("main");

const here = document.location.href;
for (const a of outline.getElementsByTagName("a")){
    if (a.href == here) {
        a.classList.add("current");
    }
}

function toggleOutline(e) {
    outline.classList.toggle("hidden")
}

function clickAway(e) {
    if (!outline.contains(e.target)) {
        outline.classList.add("hidden");
    }
}

const smallScreen = window.matchMedia("(width < 70rem)");

if (smallScreen.matches) {
    outlineToggle.addEventListener("click", toggleOutline);
    main.addEventListener("click", clickAway);
}

smallScreen.addEventListener("change", (e) => {
    if (e.matches) {
        outlineToggle.addEventListener("click", toggleOutline);
        main.addEventListener("click", clickAway);
    } else {
        outlineToggle.removeEventListener("click", toggleOutline);
        main.removeEventListener("click", clickAway);
    }
});
