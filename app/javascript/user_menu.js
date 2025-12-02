import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["popup"]

    connect() {
        document.addEventListener("click", this.outsideClick)
    }

    disconnect() {
        document.removeEventListener("click", this.outsideClick)
    }

    // Toggle popup on icon click
    toggle(event) {
        event.preventDefault()
        event.stopPropagation()
        this.popupTarget.classList.toggle("show")
    }

    // Close popup when clicking outside
    outsideClick = (event) => {
        if (!this.element.contains(event.target)) {
            this.popupTarget.classList.remove("show")
        }
    }
}
