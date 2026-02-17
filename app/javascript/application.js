// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as Turbo from "@hotwired/turbo-rails"
window.Turbo = Turbo

import "controllers"


document.addEventListener("DOMContentLoaded", () => {
    const menu = document.querySelector(".nav-menu");
    const toggle = document.querySelector("#mobile-menu");

    toggle.addEventListener("click", () => {
        menu.classList.toggle("active");
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const settingsBtn = document.getElementById('settings-btn');
    const popup = document.getElementById('settings-popup');

    // Toggle popup on button click
    settingsBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation(); // Prevent click from bubbling to document
        popup.classList.toggle('active');
    });

    // Close popup when clicking outside
    document.addEventListener('click', function(e) {
        if (!popup.contains(e.target) && e.target !== settingsBtn) {
            popup.classList.remove('active');
        }
    });
});

import "@hotwired/turbo-rails"
