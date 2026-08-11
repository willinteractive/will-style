// Move Bootstrap Modals to the body so they're always on top of the overlay
import { Settings } from "will_style/core/settings";

document.addEventListener(Settings.pageChangeEvent, function(event) {
  const elements = document.querySelectorAll(".modal");
  for (let i = 0; i < elements.length; i++) {
    document.querySelector("body").append(elements[i]);
  }
});
