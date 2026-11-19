// Land -> Crop -> Unit auto fill, plus "Today / Yesterday" quick buttons
const refreshUnit = () => {
    const form = document.querySelector("[data-dp-form]")
    if (!form) return
    const crop = form.querySelector("#daily_picking_crop_type")
    const unit = crop?.selectedOptions[0]?.dataset.unit || "units"
    form.querySelectorAll("[data-dp-unit]").forEach((el) => (el.textContent = unit))
}

document.addEventListener("turbo:load", refreshUnit)
document.addEventListener("turbo:render", refreshUnit)

document.addEventListener("change", (e) => {
    if (!e.target.closest("[data-dp-form]")) return

    if (e.target.id === "daily_picking_land_id") {
        const cropName = e.target.selectedOptions[0]?.dataset.crop
        const cropSelect = document.getElementById("daily_picking_crop_type")
        if (cropName && cropSelect && [...cropSelect.options].some((o) => o.value === cropName)) {
            cropSelect.value = cropName
        }
    }
    if (e.target.id === "daily_picking_land_id" || e.target.id === "daily_picking_crop_type") refreshUnit()
})

document.addEventListener("click", (e) => {
    const btn = e.target.closest("[data-dp-days]")
    if (!btn) return
    const input = document.getElementById("daily_picking_picked_on")
    const d = new Date()
    d.setDate(d.getDate() - Number(btn.dataset.dpDays))
    const pad = (n) => String(n).padStart(2, "0")
    input.value = `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
})