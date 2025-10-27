const outlineToggle = document.getElementById("outline-toggle");
const outline = document.getElementById("outline");

outlineToggle.addEventListener("click", (e) => {
    if (outline.style.display == "none") {
        outline.style.display = "flex";
    } else {
        outline.style.display = "none";
    }
});

document.querySelector("main").addEventListener("click", (e) => {
    if (!outline.contains(e.target)) {
        outline.style.display = "none";
    }
});
