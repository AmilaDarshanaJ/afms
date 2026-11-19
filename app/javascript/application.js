// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as Turbo from "@hotwired/turbo-rails"
window.Turbo = Turbo

import "controllers"
import "daily_picking_form"

// Mobile menu: one delegated listener, works after every Turbo navigation
document.addEventListener("click", (e) => {
    const menu = document.querySelector(".nav-menu")
    if (!menu) return
    if (e.target.closest("#mobile-menu")) {
        menu.classList.toggle("active")
    } else if (!e.target.closest(".nav-menu")) {
        menu.classList.remove("active")
    }
})

// Don't cache the page with the menu open
document.addEventListener("turbo:before-cache", () => {
    document.querySelector(".nav-menu")?.classList.remove("active")
    document.querySelector(".dropdown-menu")?.classList.remove("show")
})