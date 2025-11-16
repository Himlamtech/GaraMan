-- =============================================
-- Garage Management System - Database Schema (Aligned with required ERD)
-- =============================================
DROP DATABASE IF EXISTS garaman_db;
CREATE DATABASE garaman_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE garaman_db;

-- =============================================
-- Table: user_account
-- =============================================
CREATE TABLE user_account (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    role VARCHAR(20) NOT NULL, -- MANAGER/SALES/WAREHOUSE/TECHNICIAN
    is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- =============================================
-- Table: service
-- =============================================
CREATE TABLE service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    duration_min INT NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- =============================================
-- Table: spare_part
-- =============================================
CREATE TABLE spare_part (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    unit VARCHAR(20) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    stock_qty INT NOT NULL DEFAULT 0,
    min_stock_qty INT NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- =============================================
-- Table: supplier
-- =============================================
CREATE TABLE supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    tax_code VARCHAR(20),
    is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- =============================================
-- Table: import_order
-- =============================================
CREATE TABLE import_order (
    import_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    warehouse_staff_id INT NOT NULL,
    import_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL, -- DRAFT/CONFIRMED/CANCELLED/PAID
    note VARCHAR(255),
    CONSTRAINT fk_import_order_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    CONSTRAINT fk_import_order_staff FOREIGN KEY (warehouse_staff_id) REFERENCES user_account(user_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- =============================================
-- Table: import_order_item
-- =============================================
CREATE TABLE import_order_item (
    import_item_id INT AUTO_INCREMENT PRIMARY KEY,
    import_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    line_total DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_import_item_order FOREIGN KEY (import_id) REFERENCES import_order(import_id),
    CONSTRAINT fk_import_item_part FOREIGN KEY (part_id) REFERENCES spare_part(part_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- =============================================
-- Sample Data (minimal for testing)
-- =============================================
-- Users (plain text stored in password_hash for simplicity in this sample)
INSERT INTO user_account (username, password_hash, full_name, phone, email, role, is_active) VALUES
('customer', 'customer', 'HimLam', '0901-111-111', 'customer@example.com', 'SALES', 1),
('staff', 'staff', 'HimLam', '0902-222-222', 'warehouse@example.com', 'WAREHOUSE', 1),
('manager', 'manager', 'HimLam', '0903-333-333', 'manager@example.com', 'MANAGER', 1),
('tech', 'tech', 'HimLam', '0904-444-444', 'tech@example.com', 'TECHNICIAN', 1);

-- Suppliers
INSERT INTO supplier (name, contact_name, phone, email, address, tax_code, is_active) VALUES
('Auto Parts Wholesale', 'Alice', '555-0101', 'alice@apw.com', '123 Industrial Rd, City A', 'TAX001', 1),
('Premium Parts Supply', 'Bob', '555-0102', 'bob@pps.com', '456 Commerce St, City B', 'TAX002', 1),
('Global Auto Components', 'Charlie', '555-0103', 'charlie@gac.com', '789 Trade Ave, City C', 'TAX003', 1),
('Quick Parts Distribution', 'Diana', '555-0104', 'diana@qpd.com', '321 Business Blvd, City D', 'TAX004', 1),
('Metro Auto Parts', 'Evan', '555-0105', 'evan@metroap.com', '654 Metro Rd, City E', 'TAX005', 1),
('Sunrise Motors Supply', 'Fiona', '555-0106', 'fiona@sunrise.com', '987 Sunrise St, City F', 'TAX006', 1);

-- Services
INSERT INTO service (code, name, description, base_price, duration_min, is_active) VALUES
('SV-001', 'Oil Change', 'Complete oil change service including filter', 50.00, 60, 1),
('SV-002', 'Brake Inspection', 'Full brake system inspection and testing', 35.00, 45, 1),
('SV-003', 'Tire Rotation', 'Rotate all four tires for even wear', 25.00, 40, 1),
('SV-004', 'Wheel Alignment', 'Four-wheel alignment service', 75.00, 70, 1),
('SV-005', 'Battery Replacement', 'Battery testing and replacement service', 90.00, 50, 1),
('SV-006', 'AC Service', 'AC system check and refrigerant refill', 85.00, 80, 1),
('SV-007', 'Engine Tune-Up', 'Complete engine tuning and optimization', 125.00, 90, 1),
('SV-008', 'Transmission Service', 'Transmission fluid change and inspection', 150.00, 100, 1),
('SV-009', 'Detailing', 'Interior and exterior detailing package', 180.00, 120, 1),
('SV-010', 'Cooling System Flush', 'Coolant flush and system pressure test', 95.00, 75, 1);

-- Spare Parts
INSERT INTO spare_part (code, name, description, unit, unit_price, stock_qty, min_stock_qty, is_active) VALUES
('PT-001', 'Engine Oil Filter', 'Standard oil filter', 'pcs', 12.50, 120, 10, 1),
('PT-002', 'Brake Pad Set', 'Front brake pads', 'set', 45.00, 80, 8, 1),
('PT-003', 'Air Filter', 'Cabin air filter', 'pcs', 18.00, 150, 15, 1),
('PT-004', 'Spark Plug', 'Standard spark plug', 'pcs', 8.50, 300, 30, 1),
('PT-005', 'Wiper Blade', '24-inch wiper blade', 'pcs', 15.00, 90, 10, 1),
('PT-006', 'Car Battery 12V', 'Maintenance-free battery', 'pcs', 120.00, 40, 5, 1),
('PT-007', 'Transmission Fluid', 'Synthetic ATF', 'bottle', 25.00, 60, 6, 1),
('PT-008', 'Brake Fluid', 'DOT 4 brake fluid', 'bottle', 12.00, 110, 12, 1),
('PT-009', 'Coolant', 'Pre-mixed coolant', 'bottle', 20.00, 95, 10, 1),
('PT-010', 'Power Steering Fluid', 'Hydraulic steering fluid', 'bottle', 18.00, 70, 7, 1),
('PT-011', 'Fuel Filter', 'In-line fuel filter', 'pcs', 22.00, 85, 8, 1),
('PT-012', 'Serpentine Belt', 'OEM serpentine belt', 'pcs', 35.00, 50, 5, 1),
('PT-013', 'PCV Valve', 'Positive crankcase ventilation valve', 'pcs', 14.00, 65, 6, 1),
('PT-014', 'Oxygen Sensor', 'Front oxygen sensor', 'pcs', 75.00, 30, 3, 1),
('PT-015', 'Ignition Coil', 'OEM ignition coil', 'pcs', 95.00, 25, 2, 1);

-- Import Orders (header)
INSERT INTO import_order (supplier_id, warehouse_staff_id, import_date, total_amount, status, note) VALUES
(1, 2, '2025-11-10 10:30:00', 0, 'CONFIRMED', 'Initial stock load'),
(2, 2, '2025-11-12 15:00:00', 0, 'CONFIRMED', 'Brake parts restock'),
(3, 2, '2025-11-14 09:15:00', 0, 'CONFIRMED', 'Fluids and filters'),
(4, 2, '2025-11-15 16:45:00', 0, 'CONFIRMED', 'Electrical parts'),
(5, 2, '2025-11-16 11:20:00', 0, 'CONFIRMED', 'Cooling parts'),
(6, 2, '2025-11-17 13:05:00', 0, 'CONFIRMED', 'Belts and sensors');

-- Import Order Items
INSERT INTO import_order_item (import_id, part_id, quantity, unit_price, line_total) VALUES
(1, 1, 100, 11.00, 1100.00),
(1, 3, 80, 16.50, 1320.00),
(1, 4, 200, 7.50, 1500.00),
(2, 2, 60, 42.00, 2520.00),
(2, 8, 90, 10.50, 945.00),
(2, 7, 40, 23.00, 920.00),
(3, 9, 70, 18.50, 1295.00),
(3, 10, 50, 16.00, 800.00),
(3, 11, 45, 20.00, 900.00),
(4, 14, 20, 70.00, 1400.00),
(4, 15, 25, 90.00, 2250.00),
(5, 5, 60, 13.00, 780.00),
(5, 6, 15, 110.00, 1650.00),
(5, 9, 40, 19.00, 760.00),
(6, 12, 30, 32.00, 960.00),
(6, 13, 40, 13.00, 520.00),
(6, 4, 100, 8.00, 800.00);

-- Update totals for import orders
UPDATE import_order o
JOIN (
    SELECT import_id, SUM(line_total) total_line
    FROM import_order_item
    GROUP BY import_id
) t ON o.import_id = t.import_id
SET o.total_amount = t.total_line;

-- Bump stock according to imports for sample data consistency
UPDATE spare_part p
JOIN (
    SELECT part_id, SUM(quantity) qty FROM import_order_item GROUP BY part_id
) i ON p.part_id = i.part_id
SET p.stock_qty = p.stock_qty + i.qty;

-- End of database.sql
