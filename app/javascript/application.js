// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", () => {
    const menu = document.querySelector(".nav-menu");
    const toggle = document.querySelector("#mobile-menu");

    toggle.addEventListener("click", () => {
        menu.classList.toggle("active");
    });
});

