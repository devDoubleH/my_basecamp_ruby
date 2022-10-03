document.addEventListener('turbolinks:load', function() {
  let contentToogleBtn = document.querySelectorAll(".content-toggle-btn");

  for (let i = 0; i < contentToogleBtn.length; i++) {
    contentToogleBtn[i].addEventListener("click", (e) => {
      e.preventDefault();
      let parent = contentToogleBtn[i].closest(".list-group-item");
      let content = parent.querySelector(".content-toggle");

      content.classList.toggle("show");
    });
  }
}, false);
