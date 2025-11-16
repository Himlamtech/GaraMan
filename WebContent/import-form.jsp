<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import Parts</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: radial-gradient(circle at 15% 20%, rgba(76, 175, 80, 0.08), transparent 35%),
                        radial-gradient(circle at 70% 10%, rgba(0, 0, 0, 0.04), transparent 30%),
                        radial-gradient(circle at 45% 75%, rgba(0, 0, 0, 0.05), transparent 40%),
                        radial-gradient(circle at 85% 70%, rgba(255, 255, 255, 0.7), transparent 30%),
                        linear-gradient(135deg, #ffffff 0%, #f5f5f5 100%);
            min-height: 100vh;
        }
        .navbar { background:#fff; box-shadow:0 2px 8px rgba(0,0,0,.08); padding:0 40px; position:sticky; top:0; z-index:100; }
        .nav-container { max-width:1400px; margin:0 auto; display:flex; justify-content:space-between; align-items:center; height:70px; }
        .nav-links { display:flex; gap:8px; align-items:center; }
        .nav-link { padding:10px 20px; border-radius:6px; text-decoration:none; color:#424242; font-weight:500; transition:.3s; }
        .nav-link:hover { background:#f5f5f5; color:#1a1a1a; }
        .nav-link.active { background:#1a1a1a; color:#fff; }
        .nav-link.search { background:#8BC34A; color:#fff; }
        .nav-link.search:hover { background:#7CB342; transform:translateY(-2px); box-shadow:0 4px 12px rgba(139,195,74,.3); }
        .user-info { display:flex; align-items:center; gap:16px; padding-left:24px; border-left:1px solid #e0e0e0; margin-left:16px; }
        .btn-logout { padding:8px 16px; background:#e0e0e0; color:#424242; border:none; border-radius:6px; font-weight:500; cursor:pointer; transition:.3s; }
        .btn-logout:hover { background:#d0d0d0; }

        .container { max-width:1400px; margin:40px auto; padding:0 20px; }
        .page-header { margin-bottom:24px; }
        .page-header h1 { font-size:32px; font-weight:700; color:#1a1a1a; margin-bottom:8px; }
        .page-header p { font-size:16px; color:#757575; }

        .layout { display:grid; grid-template-columns:1.2fr 2.2fr 1.2fr; gap:24px; align-items:flex-start; }
        .panel { background:#fff; border-radius:12px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,.06); }
        .section-title { font-size:16px; font-weight:700; color:#1a1a1a; margin-bottom:12px; }
        .form-group { margin-bottom:12px; }
        label { display:block; font-weight:600; color:#424242; margin-bottom:6px; font-size:14px; }
        select, input[type="text"], input[type="number"] {
            width:100%; padding:12px 14px; border:2px solid #e0e0e0; border-radius:8px;
            font-size:15px; transition:.2s; background:#fff;
        }
        select:focus, input:focus { outline:none; border-color:#1a1a1a; box-shadow:0 0 0 3px rgba(26,26,26,.05); }

        .supplier-list { max-height:520px; overflow-y:auto; border:1px solid #e0e0e0; border-radius:10px; }
        .supplier-row { padding:12px 14px; border-bottom:1px solid #f0f0f0; cursor:pointer; transition:.2s; }
        .supplier-row:hover { background:#f8f9fa; }
        .supplier-row.active { background:#e8f5e9; border-left:4px solid #8BC34A; }

        .items-grid { margin-top:12px; }
        .item-row {
            display:grid;
            grid-template-columns:2fr 1.2fr 1fr 1fr 1fr auto;
            gap:10px; margin-bottom:10px; padding:12px;
            background:#f8f9fa; border:1px solid #e0e0e0; border-radius:8px; transition:.2s;
        }
        .item-row:hover { background:#fff; box-shadow:0 2px 8px rgba(0,0,0,.06); }
        .inline-new { grid-column:1/-1; display:grid; grid-template-columns:repeat(3,1fr); gap:10px; }

        .btn { padding:10px 16px; border:none; border-radius:6px; font-weight:600; cursor:pointer; transition:.3s; font-size:14px; }
        .btn-add { background:#8BC34A; color:#fff; margin-top:12px; }
        .btn-add:hover { background:#7CB342; }
        .btn-remove { background:#f44336; color:#fff; }
        .btn-remove:hover { background:#d32f2f; }
        .btn-submit { background:#1a1a1a; color:#fff; width:100%; padding:14px; margin-top:16px; }
        .btn-submit:hover { background:#000; }

        .summary { margin-top:12px; padding:16px; background:#f8f9fa; border:1px solid #e0e0e0; border-radius:10px; }
        .summary-row { display:flex; justify-content:space-between; margin-bottom:8px; color:#424242; }
        .summary-total { font-weight:700; font-size:20px; color:#1a1a1a; }
        .input-error { color:#f44336; font-size:13px; margin-top:6px; display:none; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">Garage <span>Manager</span></div>
            <div class="nav-links">
                <a href="search" class="nav-link search">🔍 Search</a>
                <a href="import" class="nav-link active">📦 Import Parts</a>
                <div class="user-info">
                    <span class="user-name">👤 ${sessionScope.fullName}</span>
                    <form action="logout" method="get" style="display: inline;">
                        <button type="submit" class="btn-logout">Logout</button>
                    </form>
                </div>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h1>Import Parts</h1>
            <p>Warehouse staff imports parts, updates inventory, and prepares invoice/payment.</p>
        </div>

        <div class="layout">
            <!-- Left: Suppliers -->
            <div class="panel">
                <div class="section-title">Suppliers</div>
                <div class="form-group">
                    <input type="text" id="supplierSearch" placeholder="Search supplier..." oninput="filterSuppliers()">
                </div>
                <div class="supplier-list" id="supplierList">
                    <c:forEach var="sup" items="${suppliers}">
                        <div class="supplier-row" data-name="${sup.name}" data-phone="${sup.phone}" data-tax="${sup.taxCode}" onclick="selectSupplier('${sup.name}', this)">
                            <div><strong><c:out value="${sup.name}"/></strong></div>
                            <div style="font-size:13px;color:#666;">${sup.phone} • ${sup.taxCode}</div>
                        </div>
                    </c:forEach>
                </div>
                <button class="btn btn-add" type="button" onclick="toggleNewSupplier(true)">+ Add new supplier</button>
                <div id="newSupplierFields" style="display:none; margin-top:12px;">
                    <div class="form-group">
                        <label for="supplierName">New Supplier Name *</label>
                        <input type="text" id="supplierName" name="supplierNameNew" form="importForm" placeholder="Enter supplier name">
                    </div>
                    <div class="form-group">
                        <label for="supplierContactName">Contact Name</label>
                        <input type="text" id="supplierContactName" name="supplierContactName" form="importForm" placeholder="Contact person">
                    </div>
                    <div class="form-group">
                        <label for="supplierPhone">Phone</label>
                        <input type="text" id="supplierPhone" name="supplierPhone" form="importForm" placeholder="Enter phone number">
                    </div>
                    <div class="form-group">
                        <label for="supplierEmail">Email</label>
                        <input type="text" id="supplierEmail" name="supplierEmail" form="importForm" placeholder="Enter email">
                    </div>
                    <div class="form-group">
                        <label for="supplierAddress">Address</label>
                        <input type="text" id="supplierAddress" name="supplierAddress" form="importForm" placeholder="Enter address">
                    </div>
                    <div class="form-group">
                        <label for="supplierTaxCode">Tax Code</label>
                        <input type="text" id="supplierTaxCode" name="supplierTaxCode" form="importForm" placeholder="Enter tax code">
                    </div>
                </div>
            </div>

            <!-- Middle: Form -->
            <div class="panel">
                <form id="importForm" action="import" method="post" onsubmit="return validateForm()">
                    <div class="section-title">Import Items</div>
                    <div style="font-size:13px;color:#666;margin-bottom:8px;">Staff: ${sessionScope.fullName}</div>

                    <div id="partOptions" style="display:none;">
                        <c:forEach var="part" items="${parts}">
                            <option value="${part.code}" data-unit="${part.unit}">${part.code} - ${part.name}</option>
                        </c:forEach>
                    </div>

                    <div id="itemsContainer" class="items-grid"></div>
                    <button type="button" class="btn btn-add" onclick="addItem()">+ Add Part</button>
                    <input type="hidden" id="itemCount" name="itemCount" value="0">
                    <input type="hidden" id="supplierNameHidden" name="supplierName" />
                    <input type="hidden" id="note" name="note" value="" />
                    <button type="submit" class="btn btn-submit">Confirm Import</button>
                </form>
            </div>

            <!-- Right: Summary -->
            <div class="panel">
                <div class="section-title">Summary</div>
                <div class="summary">
                    <div class="summary-row"><span>Supplier</span><span id="summarySupplier">None</span></div>
                    <div class="summary-row"><span>Items</span><span id="summaryItems">0</span></div>
                    <div class="summary-row summary-total"><span>Total</span><span>$<span id="summaryTotal">0.00</span></span></div>
                </div>
                <div style="margin-top:14px;color:#666;font-size:13px;">
                    Confirm to print invoice and proceed payment to supplier.
                </div>
            </div>
        </div>
    </div>

    <script>
        let itemIndex = 0;

        function buildOptionsNodes() {
            const opts = [];
            const tmpl = document.querySelectorAll('#partOptions > option');
            tmpl.forEach(o => {
                const opt = document.createElement('option');
                opt.value = o.value;
                opt.textContent = o.textContent;
                opt.setAttribute('data-unit', o.getAttribute('data-unit'));
                opts.push(opt);
            });
            return opts;
        }

        function addItem() {
            const container = document.getElementById('itemsContainer');
            const idx = itemIndex++;

            const row = document.createElement('div');
            row.className = 'item-row';
            row.id = `item-${idx}`;

            // Select part
            const select = document.createElement('select');
            select.name = `partExisting_${idx}`;
            select.required = true;
            const optDefault = document.createElement('option');
            optDefault.value = '';
            optDefault.textContent = '-- Select part --';
            select.appendChild(optDefault);
            buildOptionsNodes().forEach(opt => select.appendChild(opt));
            const optNew = document.createElement('option');
            optNew.value = '__NEW__';
            optNew.textContent = '+ New part';
            select.appendChild(optNew);
            select.addEventListener('change', () => {
                toggleNewPart(select, idx);
                fillUnit(select, idx);
            });

            // Unit, qty, price
            const unitInput = document.createElement('input');
            unitInput.type = 'text';
            unitInput.name = `unit_${idx}`;
            unitInput.placeholder = 'Unit';
            unitInput.required = true;

            const qtyInput = document.createElement('input');
            qtyInput.type = 'number';
            qtyInput.name = `quantity_${idx}`;
            qtyInput.placeholder = 'Qty *';
            qtyInput.min = '1';
            qtyInput.required = true;
            qtyInput.oninput = updateSummary;

            const priceInput = document.createElement('input');
            priceInput.type = 'number';
            priceInput.name = `unitPrice_${idx}`;
            priceInput.placeholder = 'Price *';
            priceInput.step = '0.01';
            priceInput.min = '0.01';
            priceInput.required = true;
            priceInput.oninput = updateSummary;

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'btn btn-remove';
            removeBtn.textContent = 'Remove';
            removeBtn.addEventListener('click', () => removeItem(row.id));

            // Inline new part fields
            const inline = document.createElement('div');
            inline.className = 'inline-new';
            inline.id = `inlineNew_${idx}`;
            inline.style.display = 'none';
            const codeInput = document.createElement('input');
            codeInput.type = 'text';
            codeInput.name = `partCode_${idx}`;
            codeInput.placeholder = 'Part code *';
            const nameInput = document.createElement('input');
            nameInput.type = 'text';
            nameInput.name = `partName_${idx}`;
            nameInput.placeholder = 'Part name *';
            const descInput = document.createElement('input');
            descInput.type = 'text';
            descInput.name = `description_${idx}`;
            descInput.placeholder = 'Description';
            const saveBtn = document.createElement('button');
            saveBtn.type = 'button';
            saveBtn.className = 'btn btn-add';
            saveBtn.textContent = 'Use this new part';
            saveBtn.style.marginTop = '6px';
            saveBtn.addEventListener('click', () => saveNewPart(idx));
            inline.appendChild(codeInput);
            inline.appendChild(nameInput);
            inline.appendChild(descInput);
            inline.appendChild(saveBtn);

            row.appendChild(select);
            row.appendChild(unitInput);
            row.appendChild(qtyInput);
            row.appendChild(priceInput);
            row.appendChild(removeBtn);
            row.appendChild(inline);

            container.appendChild(row);
            renumberRows();
            updateItemCount();
            updateSummary();
        }

        function removeItem(id) {
            const row = document.getElementById(id);
            if (row) row.remove();
            renumberRows();
            updateItemCount();
            updateSummary();
            if (document.querySelectorAll('.item-row').length === 0) addItem();
        }

        function toggleNewPart(selectEl, idx) {
            const inline = document.getElementById(`inlineNew_${idx}`);
            const unitInput = document.querySelector(`#item-${idx} input[name="unit_${idx}"]`);
            if (selectEl.value === '__NEW__') {
                inline.style.display = 'grid';
                if (unitInput) unitInput.value = '';
                inline.querySelectorAll('input').forEach(inp => inp.required = true);
            } else {
                inline.style.display = 'none';
                inline.querySelectorAll('input').forEach(inp => { inp.required = false; inp.value = ''; });
            }
        }

        function fillUnit(selectEl, idx) {
            if (selectEl.value && selectEl.value !== '__NEW__') {
                const opt = selectEl.selectedOptions[0];
                const unit = opt.getAttribute('data-unit');
                const unitInput = document.querySelector(`#item-${idx} input[name="unit_${idx}"]`);
                if (unitInput && unit) unitInput.value = unit;
            }
        }

        function updateItemCount() {
            const count = document.querySelectorAll('.item-row').length;
            document.getElementById('itemCount').value = count;
            document.getElementById('summaryItems').textContent = count;
        }

        function updateSummary() {
            let total = 0;
            document.querySelectorAll('.item-row').forEach(row => {
                const qty = parseFloat(row.querySelector('input[name*="quantity_"]').value) || 0;
                const price = parseFloat(row.querySelector('input[name*="unitPrice_"]').value) || 0;
                total += qty * price;
            });
            document.getElementById('summaryTotal').textContent = total.toFixed(2);
        }

        function selectSupplier(name, el) {
            document.getElementById('supplierNameHidden').value = name;
            document.querySelectorAll('.supplier-row').forEach(r => r.classList.remove('active'));
            el.classList.add('active');
            document.getElementById('summarySupplier').textContent = name;
            toggleNewSupplier(false);
        }

        function filterSuppliers() {
            const term = document.getElementById('supplierSearch').value.toLowerCase();
            document.querySelectorAll('.supplier-row').forEach(r => {
                r.style.display = r.dataset.name.toLowerCase().includes(term) ? 'block' : 'none';
            });
        }

        function toggleNewSupplier(show) {
            const fields = document.getElementById('newSupplierFields');
            const hidden = document.getElementById('supplierNameHidden');
            if (show) {
                fields.style.display = 'block';
                hidden.value = "__NEW__";
                document.querySelectorAll('.supplier-row').forEach(r => r.classList.remove('active'));
                document.getElementById('summarySupplier').textContent = 'New supplier';
            } else {
                fields.style.display = 'none';
            }
        }

        function validateForm() {
            if (!document.getElementById('supplierNameHidden').value) {
                alert('Please select a supplier.');
                return false;
            }
            if (document.getElementById('supplierNameHidden').value === "__NEW__") {
                const name = document.getElementById('supplierName').value;
                if (!name || !name.trim()) {
                    alert('Please enter new supplier name.');
                    return false;
                }
            }
            if (document.querySelectorAll('.item-row').length === 0) {
                alert('Please add at least one part.');
                return false;
            }
            let valid = true;
            document.querySelectorAll('.item-row').forEach(row => {
                const select = row.querySelector('select[name^="partExisting_"]');
                if (select && select.value === '__NEW__') {
                    const code = row.querySelector('input[name^="partCode_"]')?.value || '';
                    const name = row.querySelector('input[name^="partName_"]')?.value || '';
                    const unit = row.querySelector('input[name^="unit_"]')?.value || '';
                    if (!code.trim() || !name.trim() || !unit.trim()) {
                        valid = false;
                    }
                }
            });
            if (!valid) {
                alert('Please fill code, name, unit for new parts.');
                return false;
            }
            return true;
        }

        function saveNewPart(idx) {
            const code = document.querySelector(`#item-${idx} input[name="partCode_${idx}"]`)?.value || '';
            const name = document.querySelector(`#item-${idx} input[name="partName_${idx}"]`)?.value || '';
            const desc = document.querySelector(`#item-${idx} input[name="description_${idx}"]`)?.value || '';
            const unitInput = document.querySelector(`#item-${idx} input[name="unit_${idx}"]`);
            const unit = unitInput ? unitInput.value : '';
            if (!code.trim() || !name.trim() || !unit.trim()) {
                alert('Please fill code, name, and unit for new part.');
                return;
            }
            // Add to hidden options for future rows
            const hidden = document.getElementById('partOptions');
            const newOptHidden = document.createElement('option');
            newOptHidden.value = code.trim();
            newOptHidden.setAttribute('data-unit', unit.trim());
            newOptHidden.textContent = `${code.trim()} - ${name.trim()}`;
            hidden.appendChild(newOptHidden);

            // Add to all existing selects
            document.querySelectorAll('#itemsContainer select[name^="partExisting_"]').forEach(sel => {
                const opt = document.createElement('option');
                opt.value = code.trim();
                opt.setAttribute('data-unit', unit.trim());
                opt.textContent = `${code.trim()} - ${name.trim()}`;
                sel.insertBefore(opt, sel.querySelector('option[value="__NEW__"]'));
            });

            // Set current row to new code and hide inline
            const currentSelect = document.querySelector(`#item-${idx} select[name="partExisting_${idx}"]`);
            if (currentSelect) {
                currentSelect.value = code.trim();
            }
            const inline = document.getElementById(`inlineNew_${idx}`);
            if (inline) {
                inline.style.display = 'none';
                inline.querySelectorAll('input').forEach(inp => inp.required = false);
            }
            updateSummary();
        }

        function renumberRows() {
            const rows = document.querySelectorAll('.item-row');
            rows.forEach((row, idx) => {
                row.id = `item-${idx}`;
                const select = row.querySelector('select[name^="partExisting_"]');
                const unitInput = row.querySelector('input[name^="unit_"]');
                const qtyInput = row.querySelector('input[name^="quantity_"]');
                const priceInput = row.querySelector('input[name^="unitPrice_"]');
                const inline = row.querySelector('.inline-new');
                const codeInput = inline.querySelector('input[name^="partCode_"]');
                const nameInput = inline.querySelector('input[name^="partName_"]');
                const descInput = inline.querySelector('input[name^="description_"]');
                const removeBtn = row.querySelector('.btn-remove');

                if (select) {
                    select.name = `partExisting_${idx}`;
                    select.onchange = () => { toggleNewPart(select, idx); fillUnit(select, idx); };
                }
                if (unitInput) unitInput.name = `unit_${idx}`;
                if (qtyInput) { qtyInput.name = `quantity_${idx}`; qtyInput.oninput = updateSummary; }
                if (priceInput) { priceInput.name = `unitPrice_${idx}`; priceInput.oninput = updateSummary; }
                if (inline) inline.id = `inlineNew_${idx}`;
                if (codeInput) codeInput.name = `partCode_${idx}`;
                if (nameInput) nameInput.name = `partName_${idx}`;
                if (descInput) descInput.name = `description_${idx}`;
                if (removeBtn) {
                    removeBtn.id = `removeBtn_${idx}`;
                    removeBtn.onclick = () => removeItem(`item-${idx}`);
                }
            });
            itemIndex = rows.length;
        }

        window.onload = () => { addItem(); };
    </script>
</body>
</html>
