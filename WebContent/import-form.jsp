<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Import Parts - Simple</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: Arial, sans-serif;
                    padding: 20px;
                    background: #f5f5f5;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                }

                h1 {
                    margin-bottom: 30px;
                    color: #333;
                }

                .section {
                    margin-bottom: 30px;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 6px;
                }

                .section-title {
                    font-size: 18px;
                    font-weight: bold;
                    margin-bottom: 15px;
                    color: #333;
                }

                .supplier-list {
                    max-height: 300px;
                    overflow-y: auto;
                }

                .supplier-item {
                    padding: 12px;
                    margin-bottom: 8px;
                    border: 2px solid #e0e0e0;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .supplier-item:hover {
                    background: #f8f8f8;
                }

                .supplier-item.active {
                    border-color: #8BC34A;
                    background: #e8f5e9;
                }

                .items-container {
                    margin-top: 20px;
                }

                .item-row {
                    display: grid;
                    grid-template-columns: 2fr 1fr 1fr auto;
                    gap: 10px;
                    margin-bottom: 10px;
                    padding: 10px;
                    background: #f9f9f9;
                    border-radius: 6px;
                }

                input,
                select {
                    width: 100%;
                    padding: 10px;
                    border: 2px solid #ddd;
                    border-radius: 4px;
                    font-size: 14px;
                }

                .btn {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 6px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .btn-add {
                    background: #8BC34A;
                    color: white;
                }

                .btn-add:hover {
                    background: #7CB342;
                }

                .btn-remove {
                    background: #f44336;
                    color: white;
                    padding: 10px 15px;
                }

                .btn-remove:hover {
                    background: #d32f2f;
                }

                .btn-submit {
                    background: #1a1a1a;
                    color: white;
                    font-size: 16px;
                    padding: 15px 40px;
                }

                .btn-submit:hover {
                    background: #000;
                }

                .summary {
                    position: sticky;
                    top: 20px;
                    padding: 20px;
                    background: #f8f9fa;
                    border-radius: 8px;
                    border: 2px solid #e0e0e0;
                }

                .summary-row {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 10px;
                }

                .summary-total {
                    font-size: 24px;
                    font-weight: bold;
                    color: #8BC34A;
                    margin-top: 15px;
                }

                .modal {
                    display: none;
                    position: fixed;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
                    z-index: 1000;
                }

                .modal-backdrop {
                    display: none;
                    position: fixed;
                    inset: 0;
                    background: rgba(0, 0, 0, 0.5);
                    z-index: 999;
                }

                .show {
                    display: block !important;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h1>📦 Import Parts - Simple Version</h1>

                <div style="display: grid; grid-template-columns: 1fr 2fr 1fr; gap: 20px;">

                    <!-- Left: Suppliers -->
                    <div class="section">
                        <div class="section-title">Select Supplier</div>
                        <button type="button" class="btn btn-add" onclick="showNewSupplierModal()"
                            style="width: 100%; margin-bottom: 15px;">
                            + Add New Supplier
                        </button>
                        <div class="supplier-list">
                            <c:forEach var="sup" items="${suppliers}">
                                <div class="supplier-item" onclick="selectSupplier(this, '${sup.name}')"
                                    data-name="${sup.name}">
                                    <strong>${sup.name}</strong><br>
                                    <small>${sup.phone}</small>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Middle: Items -->
                    <div class="section">
                        <div class="section-title">Import Items</div>
                        <button type="button" class="btn btn-add" onclick="showNewPartModal()"
                            style="margin-bottom: 15px;">
                            + Add New Part
                        </button>
                        <div id="itemsContainer" class="items-container"></div>
                        <button type="button" class="btn btn-add" onclick="addItem()">+ Add Item Row</button>
                        <button type="button" class="btn btn-submit" onclick="submitForm()"
                            style="margin-top: 20px; width: 100%;">
                            Confirm Import
                        </button>
                    </div>

                    <!-- Right: Summary -->
                    <div class="summary">
                        <div class="section-title">Summary</div>
                        <div class="summary-row">
                            <span>Supplier:</span>
                            <strong id="summarySupplier">None</strong>
                        </div>
                        <div class="summary-row">
                            <span>Items:</span>
                            <strong id="summaryItems">0</strong>
                        </div>
                        <div class="summary-row summary-total">
                            <span>Total:</span>
                            <span>$<span id="summaryTotal">0.00</span></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modals -->
            <div id="modalBackdrop" class="modal-backdrop" onclick="closeAllModals()"></div>

            <!-- Message Modal -->
            <div id="modal" class="modal">
                <h3 id="modalTitle">Message</h3>
                <p id="modalMessage" style="margin: 15px 0;"></p>
                <button class="btn btn-submit" onclick="closeModal()">OK</button>
            </div>

            <!-- New Supplier Modal -->
            <div id="supplierModal" class="modal" style="min-width: 400px;">
                <h3>Add New Supplier</h3>
                <div style="margin: 20px 0;">
                    <input type="text" id="newSupplierName" placeholder="Supplier Name" style="margin-bottom: 10px;">
                    <input type="text" id="newSupplierPhone" placeholder="Phone Number" style="margin-bottom: 10px;">
                    <input type="text" id="newSupplierAddress" placeholder="Address">
                </div>
                <div style="display: flex; gap: 10px;">
                    <button class="btn btn-submit" onclick="addNewSupplier()">Add Supplier</button>
                    <button class="btn btn-remove" onclick="closeAllModals()">Cancel</button>
                </div>
            </div>

            <!-- New Part Modal -->
            <div id="partModal" class="modal" style="min-width: 400px;">
                <h3>Add New Part</h3>
                <div style="margin: 20px 0;">
                    <input type="text" id="newPartCode" placeholder="Part Code" style="margin-bottom: 10px;">
                    <input type="text" id="newPartName" placeholder="Part Name" style="margin-bottom: 10px;">
                    <input type="number" id="newPartPrice" placeholder="Unit Price" step="0.01" min="0">
                </div>
                <div style="display: flex; gap: 10px;">
                    <button class="btn btn-submit" onclick="addNewPart()">Add Part</button>
                    <button class="btn btn-remove" onclick="closeAllModals()">Cancel</button>
                </div>
            </div>

            <script>
                let selectedSupplier = '';
                let itemIndex = 0;
                const parts = [
                    <c:forEach var="part" items="${parts}" varStatus="status">
                        {code: '${part.code}', name: '${part.name}', price: ${part.unitPrice}}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ];

                console.log('Parts loaded:', parts.length, parts);

                function selectSupplier(el, name) {
                    document.querySelectorAll('.supplier-item').forEach(item => item.classList.remove('active'));
                    el.classList.add('active');
                    selectedSupplier = name;
                    document.getElementById('summarySupplier').textContent = name;
                }

                function addItem() {
                    const container = document.getElementById('itemsContainer');
                    const row = document.createElement('div');
                    row.className = 'item-row';
                    row.id = 'item-' + itemIndex;

                    // Build options string with debug
                    let options = '<option value="">Select Part</option>';
                    console.log('Building options from parts:', parts);
                    parts.forEach((p, idx) => {
                        console.log(`Part ${idx}:`, p);
                        const optionHTML = '<option value="' + p.code + '" data-price="' + p.price + '">' + p.code + ' - ' + p.name + '</option>';
                        options += optionHTML;
                    });
                    console.log('Final options HTML length:', options.length);

                    // Use single-line template to avoid parsing issues
                    row.innerHTML = '<select onchange="updatePrice(' + itemIndex + ')">' + options + '</select>' +
                        '<input type="number" placeholder="Quantity" value="1" min="1" oninput="updateTotal()">' +
                        '<input type="number" placeholder="Unit Price" value="0" step="0.01" min="0" oninput="updateTotal()">' +
                        '<button class="btn btn-remove" onclick="removeItem(' + itemIndex + ')">✕</button>';

                    container.appendChild(row);
                    itemIndex++;
                    updateItemCount();
                }

                function updatePrice(index) {
                    const row = document.getElementById('item-' + index);
                    const select = row.querySelector('select');
                    const priceInput = row.querySelectorAll('input')[1];
                    const option = select.options[select.selectedIndex];
                    if (option && option.dataset.price) {
                        priceInput.value = option.dataset.price;
                    }
                    updateTotal();
                }

                function removeItem(index) {
                    document.getElementById('item-' + index).remove();
                    updateItemCount();
                    updateTotal();
                }

                function updateItemCount() {
                    const count = document.querySelectorAll('.item-row').length;
                    document.getElementById('summaryItems').textContent = count;
                }

                function updateTotal() {
                    let total = 0;
                    document.querySelectorAll('.item-row').forEach(row => {
                        const qty = parseFloat(row.querySelectorAll('input')[0].value) || 0;
                        const price = parseFloat(row.querySelectorAll('input')[1].value) || 0;
                        total += qty * price;
                    });
                    document.getElementById('summaryTotal').textContent = total.toFixed(2);
                }

                function submitForm() {
                    // Validate
                    console.log('=== SUBMIT FORM DEBUG ===');
                    console.log('selectedSupplier:', selectedSupplier);
                    console.log('selectedSupplier type:', typeof selectedSupplier);
                    console.log('selectedSupplier length:', selectedSupplier ? selectedSupplier.length : 'null/undefined');

                    if (!selectedSupplier) {
                        showModal('Error', 'Please select a supplier');
                        return;
                    }

                    const items = [];
                    let valid = true;

                    document.querySelectorAll('.item-row').forEach(row => {
                        const select = row.querySelector('select');
                        const qty = row.querySelectorAll('input')[0].value;
                        const price = row.querySelectorAll('input')[1].value;

                        if (!select.value || !qty || !price || qty <= 0 || price <= 0) {
                            valid = false;
                        }

                        items.push({
                            code: select.value,
                            quantity: qty,
                            unitPrice: price
                        });
                    });

                    if (!valid) {
                        showModal('Error', 'Please fill all item fields correctly');
                        return;
                    }

                    if (items.length === 0) {
                        showModal('Error', 'Please add at least one item');
                        return;
                    }

                    // Build FormData
                    const formData = new FormData();
                    formData.append('supplierName', selectedSupplier);
                    formData.append('itemCount', items.length);

                    console.log('FormData contents:');
                    for (let pair of formData.entries()) {
                        console.log('  ' + pair[0] + ': [' + pair[1] + ']');
                    }

                    // CRITICAL DEBUG: Also try sending as JSON to see if FormData is the issue
                    console.log('Attempting to send FormData...');
                    console.log('FormData object:', formData);
                    console.log('FormData constructor:', formData.constructor.name);

                    items.forEach((item, idx) => {
                        formData.append('partExisting_' + idx, item.code);
                        formData.append('quantity_' + idx, item.quantity);
                        formData.append('unitPrice_' + idx, item.unitPrice);
                    });

                    // Submit
                    fetch('${pageContext.request.contextPath}/import', {
                        method: 'POST',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' },
                        body: formData
                    })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {
                                showModal('Success', 'Import completed successfully!');
                                setTimeout(() => {
                                    location.reload();
                                }, 2000);
                            } else {
                                showModal('Error', data.message || 'Import failed');
                            }
                        })
                        .catch(err => {
                            showModal('Error', 'Network error: ' + err.message);
                        });
                }

                function showModal(title, message) {
                    document.getElementById('modalTitle').textContent = title;
                    document.getElementById('modalMessage').textContent = message;
                    document.getElementById('modal').classList.add('show');
                    document.getElementById('modalBackdrop').classList.add('show');
                }

                function closeModal() {
                    document.getElementById('modal').classList.remove('show');
                    document.getElementById('modalBackdrop').classList.remove('show');
                }

                function closeAllModals() {
                    document.getElementById('modal').classList.remove('show');
                    document.getElementById('supplierModal').classList.remove('show');
                    document.getElementById('partModal').classList.remove('show');
                    document.getElementById('modalBackdrop').classList.remove('show');
                }

                function showNewSupplierModal() {
                    document.getElementById('supplierModal').classList.add('show');
                    document.getElementById('modalBackdrop').classList.add('show');
                    document.getElementById('newSupplierName').value = '';
                    document.getElementById('newSupplierPhone').value = '';
                    document.getElementById('newSupplierAddress').value = '';
                }

                function addNewSupplier() {
                    const name = document.getElementById('newSupplierName').value.trim();
                    const phone = document.getElementById('newSupplierPhone').value.trim();
                    const address = document.getElementById('newSupplierAddress').value.trim();

                    if (!name || !phone || !address) {
                        alert('Please fill all supplier fields');
                        return;
                    }

                    // Add to supplier list
                    const supplierList = document.querySelector('.supplier-list');
                    const newSupplierDiv = document.createElement('div');
                    newSupplierDiv.className = 'supplier-item';
                    newSupplierDiv.onclick = function () { selectSupplier(this, name); };
                    newSupplierDiv.setAttribute('data-name', name);
                    newSupplierDiv.innerHTML = `<strong>${name}</strong><br><small>${phone}</small>`;
                    supplierList.insertBefore(newSupplierDiv, supplierList.firstChild);

                    // Auto select new supplier
                    selectSupplier(newSupplierDiv, name);

                    closeAllModals();
                    showModal('Success', 'Supplier added! (Note: This is temporary until you submit the form)');
                }

                function showNewPartModal() {
                    document.getElementById('partModal').classList.add('show');
                    document.getElementById('modalBackdrop').classList.add('show');
                    document.getElementById('newPartCode').value = '';
                    document.getElementById('newPartName').value = '';
                    document.getElementById('newPartPrice').value = '';
                }

                function addNewPart() {
                    const code = document.getElementById('newPartCode').value.trim();
                    const name = document.getElementById('newPartName').value.trim();
                    const price = parseFloat(document.getElementById('newPartPrice').value);

                    if (!code || !name || !price || price <= 0) {
                        alert('Please fill all part fields correctly');
                        return;
                    }

                    // Add to parts array
                    parts.push({ code: code, name: name, price: price });

                    // Refresh all existing dropdowns
                    document.querySelectorAll('.item-row select').forEach(select => {
                        const currentValue = select.value;
                        const newOption = document.createElement('option');
                        newOption.value = code;
                        newOption.setAttribute('data-price', price);
                        newOption.textContent = `${code} - ${name}`;
                        select.appendChild(newOption);
                        select.value = currentValue; // Restore selection
                    });

                    closeAllModals();
                    showModal('Success', 'Part added! You can now select it from the dropdown.');
                }

                // Add first item on load
                addItem();
            </script>
        </body>

        </html>