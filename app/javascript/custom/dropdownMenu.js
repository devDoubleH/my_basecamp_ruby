document.addEventListener('turbolinks:load', function() {
  let dropdownBtn = document.querySelectorAll(".dropdown-toggle");

  for (let i = 0; i < dropdownBtn.length; i++) {
    dropdownBtn[i].addEventListener("click", (e) => {

      if(e.target.classList.contains("show")) {
        e.target.classList.remove("show");
      } else {
        for (let j = 0; j < dropdownBtn.length; j++) {
          if (dropdownBtn[j].classList.contains("show")) {
            dropdownBtn[j].classList.remove("show");
          }
        }
        e.target.classList.add("show");
      }
    });
  }
}, false);
