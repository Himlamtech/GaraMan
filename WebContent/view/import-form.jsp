<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Import Parts - Garage Manager</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="container">
                <!-- Header -->
                <header class="header">
                    <div class="header-content">
                        <h1><span class="brand">Garage</span> <span class="accent">Manager</span></h1>
                        <div class="header-buttons">
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Search</a>
                            <a href="${pageContext.request.contextPath}/import" class="btn btn-dark">Import Parts</a>
                        </div>
                    </div>
                </header>

                <!-- Import Form -->
                <main class="import-container">
                    <div class="import-header">
                        <h2>Warehouse Parts Management</h2>
                        <p>Import new parts and manage suppliers efficiently</p>
                    </div>

                    <div class="import-wrapper">
                        <!-- Left Side: Introduction -->
                        <div class="import-intro">
                            <h3>How to Import Parts</h3>
                            <p>Follow these simple steps to add new parts to your warehouse:</p>
                            <ol>
                                <li><strong>Create Supplier</strong> - Add a new supplier or select from existing ones
                                </li>
                                <li><strong>Add Parts</strong> - Select the parts you want to import</li>
                                <li><strong>Set Quantity</strong> - Specify the quantity for each part</li>
                                <li><strong>Import Price</strong> - Enter the import price per unit</li>
                                <li><strong>Process</strong> - Submit to update warehouse inventory</li>
                            </ol>

                            <hr style="margin: 1.5rem 0; border: none; border-top: 1px solid #eee;">

                            <h3 style="margin-top: 1.5rem;">Quick Tips</h3>
                            <p>✓ All suppliers must be added before processing import</p>
                            <p>✓ You can add multiple parts in one import</p>
                            <p>✓ Import prices will update product selling prices</p>
                            <p>✓ Stock quantities are accumulated on each import</p>
                        </div>

                        <!-- Right Side: Import Form -->
                        <div class="import-form-box">
                            <form id="importForm" method="POST" action="${pageContext.request.contextPath}/import">
                                <input type="hidden" name="action" value="processImport">
                                <input type="hidden" name="supplierId" id="supplierId">

                                <!-- Supplier Section -->
                                <div class="form-section">
                                    <h3>Select or Create Supplier</h3>

                                    <div class="form-group">
                                        <label>Supplier</label>
                                        <div style="display: flex; gap: 0.5rem; align-items: center;">
                                            <select id="supplierSelect" name="supplierSelect" class="form-control"
                                                style="flex: 1;" required>
                                                <option value="">-- Select Supplier --</option>
                                                <c:forEach items="${suppliers}" var="supplier">
                                                    <option value="${supplier.supplierId}">${supplier.supplierName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <button type="button" class="btn btn-primary"
                                                style="padding: 0.75rem 1.5rem;" onclick="openSupplierModal()">+
                                                New</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Parts Section -->
                                <div class="form-section">
                                    <h3>Import Items</h3>

                                    <div id="itemsContainer">
                                        <div class="import-item">
                                            <div class="item-row">
                                                <div class="form-group">
                                                    <label>Part</label>
                                                    <div style="display: flex; gap: 0.5rem; align-items: center;">
                                                        <select name="partId[]" class="form-control" style="flex: 1;"
                                                            required onchange="updatePrice(this)">
                                                            <option value="">-- Select Part --</option>
                                                            <c:forEach items="${parts}" var="part">
                                                                <option value="${part.partId}"
                                                                    data-price="${part.unitPrice}">${part.partName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="button" class="btn btn-primary"
                                                            style="padding: 0.75rem 1.5rem; white-space: nowrap;"
                                                            onclick="openPartModal()">+
                                                            New</button>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Qty</label>
                                                    <input type="number" name="quantity[]" min="1" placeholder="0"
                                                        class="form-control" required>
                                                </div>

                                                <div class="form-group">
                                                    <label>Price ($)</label>
                                                    <input type="number" name="price[]" step="0.01" placeholder="0.00"
                                                        class="form-control" required>
                                                </div>

                                                <button type="button" class="btn btn-remove"
                                                    onclick="removeItem(this)">Remove</button>
                                            </div>
                                        </div>
                                    </div>

                                    <button type="button" class="btn btn-secondary" onclick="addItem()"
                                        style="margin-top: 1rem;">+ Add Another Item</button>
                                </div>

                                <!-- Discount Section -->
                                <div class="form-section discount-section">
                                    <h3>Apply Discount (Optional)</h3>

                                    <div class="form-group">
                                        <label class="checkbox-label">
                                            <input type="checkbox" id="applyDiscountCheck" onchange="toggleDiscount()">
                                            <span>Apply discount to this import</span>
                                        </label>
                                    </div>

                                    <div id="discountOptions" style="display: none;">
                                        <div class="form-group">
                                            <label>Discount Code</label>
                                            <select name="discountId" id="discountSelect" class="form-control"
                                                onchange="calculateTotal()">
                                                <option value="">-- Select Discount --</option>
                                                <c:forEach items="${discounts}" var="discount">
                                                    <option value="${discount.discountId}"
                                                        data-type="${discount.discountType}"
                                                        data-value="${discount.discountValue}">
                                                        ${discount.displayText} - ${discount.usageInfo} used
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="price-summary">
                                            <div class="summary-row">
                                                <span>Subtotal:</span>
                                                <strong id="subtotalDisplay">$0.00</strong>
                                            </div>
                                            <div class="summary-row discount-row">
                                                <span>Discount:</span>
                                                <strong id="discountDisplay" class="discount-amount">-$0.00</strong>
                                            </div>
                                            <div class="summary-row total-row">
                                                <span>Total:</span>
                                                <strong id="totalDisplay">$0.00</strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Process Import</button>
                                    <a href="${pageContext.request.contextPath}/import"
                                        class="btn btn-secondary">Reset</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>

            <!-- Supplier Modal -->
            <div id="supplierModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Add New Supplier</h2>
                        <button type="button" class="close-btn" onclick="closeSupplierModal()">&times;</button>
                    </div>

                    <form onsubmit="submitSupplierForm(event)">
                        <div class="form-group">
                            <label>Supplier Name *</label>
                            <input type="text" id="supplierName" name="supplierName" placeholder="e.g., AutoParts Inc"
                                class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" id="supplierAddress" name="address" placeholder="Street address"
                                class="form-control">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="tel" id="supplierPhone" name="phone" placeholder="Contact number"
                                    class="form-control">
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" id="supplierEmail" name="email" placeholder="supplier@example.com"
                                    class="form-control">
                            </div>
                        </div>

                        <div class="form-actions" style="margin-top: 2rem;">
                            <button type="submit" class="btn btn-primary">Create Supplier</button>
                            <button type="button" class="btn btn-secondary"
                                onclick="closeSupplierModal()">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Part Modal -->
            <div id="partModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Add New Part</h2>
                        <button type="button" class="close-btn" onclick="closePartModal()">&times;</button>
                    </div>

                    <form id="partForm" method="POST" action="${pageContext.request.contextPath}/import"
                        style="display: none;">
                        <input type="hidden" name="action" value="createPart">
                    </form>

                    <form onsubmit="submitPartForm(event)">
                        <div class="form-group">
                            <label>Part Name *</label>
                            <input type="text" id="partName" name="partName" placeholder="e.g., Engine Oil Filter"
                                class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label>Description</label>
                            <textarea id="partDescription" name="description" placeholder="Part description..."
                                class="form-control" rows="3"></textarea>
                        </div>

                        <div class="form-group">
                            <label>Unit Price ($) *</label>
                            <input type="number" id="partPrice" name="unitPrice" step="0.01" placeholder="0.00"
                                class="form-control" required>
                        </div>

                        <div class="form-actions" style="margin-top: 2rem;">
                            <button type="submit" class="btn btn-primary">Create Part</button>
                            <button type="button" class="btn btn-secondary" onclick="closePartModal()">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                // Notification System
                function showNotification(message, type = 'success') {
                    const notification = document.createElement('div');
                    notification.className = `notification notification-${type}`;
                    notification.style.display = 'flex';
                    notification.style.alignItems = 'center';
                    notification.style.justifyContent = 'space-between';

                    const textSpan = document.createElement('span');
                    textSpan.textContent = message;
                    textSpan.style.flex = '1';
                    textSpan.style.fontSize = '1.7rem';
                    textSpan.style.fontWeight = '700';

                    const closeBtn = document.createElement('button');
                    closeBtn.className = 'notification-close';
                    closeBtn.textContent = '✕';
                    closeBtn.onclick = function () { notification.remove(); };

                    notification.appendChild(textSpan);
                    notification.appendChild(closeBtn);
                    document.body.appendChild(notification);

                    setTimeout(() => {
                        if (document.body.contains(notification)) {
                            notification.remove();
                        }
                    }, 5000);
                }

                // Supplier Modal Functions
                function openSupplierModal() {
                    document.getElementById('supplierModal').classList.add('show');
                }

                function closeSupplierModal() {
                    document.getElementById('supplierModal').classList.remove('show');
                    document.getElementById('supplierName').value = '';
                    document.getElementById('supplierAddress').value = '';
                    document.getElementById('supplierPhone').value = '';
                    document.getElementById('supplierEmail').value = '';
                }

                function submitSupplierForm(event) {
                    event.preventDefault();

                    const formData = new FormData();
                    formData.append('action', 'createSupplier');
                    formData.append('supplierName', document.getElementById('supplierName').value);
                    formData.append('address', document.getElementById('supplierAddress').value);
                    formData.append('phone', document.getElementById('supplierPhone').value);
                    formData.append('email', document.getElementById('supplierEmail').value);

                    fetch('${pageContext.request.contextPath}/import', {
                        method: 'POST',
                        body: new URLSearchParams(formData)
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showNotification('✓ Supplier created successfully!', 'success');
                                closeSupplierModal();
                                document.getElementById('supplierName').value = '';
                                document.getElementById('supplierAddress').value = '';
                                document.getElementById('supplierPhone').value = '';
                                document.getElementById('supplierEmail').value = '';
                                setTimeout(() => location.reload(), 3000);
                            } else {
                                showNotification('✗ ' + (data.message || 'Failed to create supplier'), 'error');
                            }
                        })
                        .catch(error => {
                            showNotification('✗ An error occurred', 'error');
                            console.error('Error:', error);
                        });
                }

                // Part Modal Functions
                function openPartModal() {
                    document.getElementById('partModal').classList.add('show');
                }

                function closePartModal() {
                    document.getElementById('partModal').classList.remove('show');
                    document.getElementById('partName').value = '';
                    document.getElementById('partDescription').value = '';
                    document.getElementById('partPrice').value = '';
                }

                function submitPartForm(event) {
                    event.preventDefault();

                    const formData = new FormData();
                    formData.append('action', 'createPart');
                    formData.append('partName', document.getElementById('partName').value);
                    formData.append('description', document.getElementById('partDescription').value);
                    formData.append('unitPrice', document.getElementById('partPrice').value);

                    fetch('${pageContext.request.contextPath}/import', {
                        method: 'POST',
                        body: new URLSearchParams(formData)
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showNotification('✓ Part created successfully!', 'success');
                                closePartModal();
                                document.getElementById('partName').value = '';
                                document.getElementById('partDescription').value = '';
                                document.getElementById('partPrice').value = '';
                                setTimeout(() => location.reload(), 3000);
                            } else {
                                showNotification('✗ ' + (data.message || 'Failed to create part'), 'error');
                            }
                        })
                        .catch(error => {
                            showNotification('✗ An error occurred', 'error');
                            console.error('Error:', error);
                        });
                }

                // Item Functions
                function addItem() {
                    const container = document.getElementById('itemsContainer');
                    const newItem = container.firstElementChild.cloneNode(true);
                    newItem.querySelectorAll('input, select').forEach(el => el.value = '');
                    container.appendChild(newItem);
                }

                function removeItem(btn) {
                    const container = document.getElementById('itemsContainer');
                    if (container.children.length > 1) {
                        btn.closest('.import-item').remove();
                    } else {
                        showNotification('At least one item is required', 'warning');
                    }
                }

                function updatePrice(select) {
                    const price = select.options[select.selectedIndex].dataset.price;
                    const priceInput = select.closest('.item-row').querySelector('input[name="price[]"]');
                    if (price) priceInput.value = price;
                    calculateTotal();
                }

                // Discount Functions
                function toggleDiscount() {
                    const checkbox = document.getElementById('applyDiscountCheck');
                    const discountOptions = document.getElementById('discountOptions');
                    const discountSelect = document.getElementById('discountSelect');

                    if (checkbox.checked) {
                        discountOptions.style.display = 'block';
                    } else {
                        discountOptions.style.display = 'none';
                        discountSelect.value = '';
                    }
                    calculateTotal();
                }

                function calculateTotal() {
                    // Calculate subtotal from all items
                    let subtotal = 0;
                    const items = document.querySelectorAll('.import-item');

                    items.forEach(item => {
                        const quantity = parseFloat(item.querySelector('input[name="quantity[]"]').value) || 0;
                        const price = parseFloat(item.querySelector('input[name="price[]"]').value) || 0;
                        subtotal += quantity * price;
                    });

                    // Get discount if selected
                    const discountSelect = document.getElementById('discountSelect');
                    const checkbox = document.getElementById('applyDiscountCheck');
                    let discountAmount = 0;

                    if (checkbox && checkbox.checked && discountSelect && discountSelect.value) {
                        const selectedOption = discountSelect.options[discountSelect.selectedIndex];
                        const discountType = selectedOption.getAttribute('data-type');
                        const discountValue = parseFloat(selectedOption.getAttribute('data-value'));

                        if (discountType === 'percentage') {
                            discountAmount = subtotal * discountValue / 100;
                        } else {
                            discountAmount = Math.min(discountValue, subtotal);
                        }
                    }

                    const total = subtotal - discountAmount;

                    // Update display
                    const subtotalDisplay = document.getElementById('subtotalDisplay');
                    const discountDisplay = document.getElementById('discountDisplay');
                    const totalDisplay = document.getElementById('totalDisplay');

                    if (subtotalDisplay) subtotalDisplay.textContent = '$' + subtotal.toFixed(2);
                    if (discountDisplay) discountDisplay.textContent = '-$' + discountAmount.toFixed(2);
                    if (totalDisplay) totalDisplay.textContent = '$' + total.toFixed(2);
                }

                // Add event listeners for real-time calculation
                document.addEventListener('DOMContentLoaded', function () {
                    const itemsContainer = document.getElementById('itemsContainer');
                    if (itemsContainer) {
                        itemsContainer.addEventListener('input', function (e) {
                            if (e.target.name === 'quantity[]' || e.target.name === 'price[]') {
                                calculateTotal();
                            }
                        });
                    }
                });

                // Form Submit Validation
                document.getElementById('importForm').onsubmit = function () {
                    const supplierId = document.getElementById('supplierSelect').value;
                    if (!supplierId) {
                        showNotification('Please select or create a supplier', 'warning');
                        return false;
                    }
                    document.getElementById('supplierId').value = supplierId;
                    return true;
                }

                // Close modal when clicking outside
                window.onclick = function (event) {
                    const supplierModal = document.getElementById('supplierModal');
                    const partModal = document.getElementById('partModal');
                    if (event.target == supplierModal) {
                        closeSupplierModal();
                    }
                    if (event.target == partModal) {
                        closePartModal();
                    }
                }
            </script>
        </body>

        </html>