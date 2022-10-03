document.addEventListener('turbolinks:load', function() {
  var fileInput = document.querySelector(".custom-file-input");
  var fileLabel = document.querySelector(".custom-file-label");

  fileInput.addEventListener("change", (e) => {
    // use e.path for Firefox compatibility.
    let targetFiles = e.target.files || e.path[0].files;
    if (targetFiles.length == 1) {
      fileLabel.textContent = targetFiles[0].name;
    } else if (targetFiles.length > 1) {
      fileLabel.textContent = targetFiles.length + " files";
    } else {
      fileLabel.textContent = "No file chosen"
    }
  });
}, false);