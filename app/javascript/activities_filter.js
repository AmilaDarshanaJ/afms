document.addEventListener('turbo:load', function() {
    const searchInput = document.getElementById('searchInput');
    const statusFilter = document.getElementById('statusFilter');
    const dateStartInput = document.getElementById('dateStart');
    const dateEndInput = document.getElementById('dateEnd');

    // Target the Count Display Span
    const countDisplay = document.getElementById('activityCountDisplay');

    const tableRows = document.querySelectorAll('.activity-row');
    const noResults = document.getElementById('noResults');

    // Safety check: if we aren't on the activities page, stop running
    if (!searchInput || !tableRows) return;

    function filterTable() {
        const searchTerm = searchInput.value.toLowerCase().trim();
        const statusValue = statusFilter.value;
        const startDate = dateStartInput.value;
        const endDate = dateEndInput.value;

        let visibleCount = 0;

        tableRows.forEach(row => {
            const textContent = row.innerText.toLowerCase();
            const rowStatus = row.getAttribute('data-status');
            const rowDate = row.getAttribute('data-date');

            const matchesSearch = textContent.includes(searchTerm);
            const matchesStatus = (statusValue === 'all') || (rowStatus === statusValue);

            let matchesDate = true;
            if (startDate && (!rowDate || rowDate < startDate)) matchesDate = false;
            if (endDate && (!rowDate || rowDate > endDate)) matchesDate = false;

            if (matchesSearch && matchesStatus && matchesDate) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Update the Count Text
        if (countDisplay) {
            countDisplay.innerText = `(${visibleCount})`;
        }

        // Toggle No Results Message
        noResults.style.display = visibleCount === 0 ? 'block' : 'none';
    }

    // Attach Event Listeners
    if(searchInput) searchInput.addEventListener('keyup', filterTable);
    if(statusFilter) statusFilter.addEventListener('change', filterTable);
    if(dateStartInput) dateStartInput.addEventListener('change', filterTable);
    if(dateEndInput) dateEndInput.addEventListener('change', filterTable);
});


window.filterByCard = function(statusType) {
    const statusSelect = document.getElementById('statusFilter');

    if(statusSelect) {
        // 1. Set the dropdown value
        statusSelect.value = statusType;

        // 2. Trigger the change event manually so the table updates
        const event = new Event('change');
        statusSelect.dispatchEvent(event);
    }
}