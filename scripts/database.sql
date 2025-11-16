-- Create Database
DROP DATABASE IF EXISTS garaman_db;
CREATE DATABASE garaman_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE garaman_db;

-- Table: Service
CREATE TABLE tbl_service (
  serviceId INT PRIMARY KEY AUTO_INCREMENT,
  serviceName VARCHAR(255) NOT NULL,
  description TEXT,
  unitPrice DECIMAL(10, 2) NOT NULL,
  estimatedTime INT,
  status INT DEFAULT 1
);

-- Table: SparePart
CREATE TABLE tbl_spare_part (
  partId INT PRIMARY KEY AUTO_INCREMENT,
  partName VARCHAR(255) NOT NULL,
  description TEXT,
  unitPrice DECIMAL(10, 2) NOT NULL,
  stock INT DEFAULT 0,
  status INT DEFAULT 1
);

-- Table: Supplier
CREATE TABLE tbl_supplier (
  supplierId INT PRIMARY KEY AUTO_INCREMENT,
  supplierName VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  phone VARCHAR(20),
  email VARCHAR(100),
  status INT DEFAULT 1
);

-- Table: Discount
CREATE TABLE tbl_discount (
  discountId INT PRIMARY KEY AUTO_INCREMENT,
  discountName VARCHAR(255) NOT NULL,
  discountType ENUM('percentage', 'fixed') NOT NULL,
  discountValue DECIMAL(10, 2) NOT NULL,
  description TEXT,
  maxUsageCount INT DEFAULT -1,
  usageCount INT DEFAULT 0,
  startDate DATETIME,
  endDate DATETIME,
  status INT DEFAULT 1,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: ImportInvoice
CREATE TABLE tbl_import_invoice (
  invoiceId INT PRIMARY KEY AUTO_INCREMENT,
  supplierId INT NOT NULL,
  invoiceDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  totalAmount DECIMAL(15, 2),
  discountId INT,
  discountAmount DECIMAL(15, 2) DEFAULT 0,
  finalAmount DECIMAL(15, 2),
  note TEXT,
  status INT DEFAULT 1,
  FOREIGN KEY (supplierId) REFERENCES tbl_supplier(supplierId),
  FOREIGN KEY (discountId) REFERENCES tbl_discount(discountId)
);

-- Table: ImportInvoiceDetail
CREATE TABLE tbl_import_invoice_detail (
  detailId INT PRIMARY KEY AUTO_INCREMENT,
  invoiceId INT NOT NULL,
  partId INT NOT NULL,
  quantity INT NOT NULL,
  importPrice DECIMAL(10, 2) NOT NULL,
  lineTotal DECIMAL(15, 2),
  FOREIGN KEY (invoiceId) REFERENCES tbl_import_invoice(invoiceId),
  FOREIGN KEY (partId) REFERENCES tbl_spare_part(partId)
);

-- Sample Data
INSERT INTO tbl_service (serviceName, description, unitPrice, estimatedTime) VALUES
('Oil Change', 'Regular engine oil replacement with premium synthetic oil', 25.00, 30),
('Brake Inspection', 'Complete brake system check and diagnostic', 50.00, 45),
('Tire Rotation', 'Rotate vehicle tires for even wear', 35.00, 40),
('AC Service', 'Air conditioning maintenance and recharge', 75.00, 60),
('Engine Tune-up', 'Full engine diagnostic and optimization', 120.00, 90),
('Transmission Flush', 'Complete transmission fluid replacement', 150.00, 120),
('Battery Replacement', 'Replace car battery with warranty', 85.00, 30),
('Wheel Alignment', 'Four-wheel alignment and balancing', 95.00, 60),
('Oil Filter Replacement', 'Replace oil filter only', 15.00, 15),
('Coolant Flush', 'Engine coolant system flush and refill', 80.00, 50),
('Suspension Check', 'Inspect suspension components', 60.00, 45),
('Belt Replacement', 'Replace serpentine belt', 70.00, 45),
('Spark Plug Service', 'Replace all spark plugs', 40.00, 30),
('Air Conditioning Repair', 'AC system repair and service', 100.00, 75),
('Brake Pad Replacement', 'Front or rear brake pad replacement', 85.00, 50);

INSERT INTO tbl_spare_part (partName, description, unitPrice, stock) VALUES
('Engine Oil 5L', 'Synthetic engine oil premium grade', 30.00, 150),
('Brake Pad Set', 'Front brake pads ceramic material', 45.00, 85),
('Air Filter', 'Engine air filter high efficiency', 15.00, 200),
('Spark Plugs (4)', 'Spark plug set iridium', 20.00, 120),
('Oil Filter', 'Engine oil filter', 12.00, 180),
('Cabin Air Filter', 'Cabin air filter replacement', 18.00, 95),
('Coolant 1L', 'Engine coolant concentrate', 25.00, 110),
('Transmission Fluid', 'ATF transmission fluid', 35.00, 60),
('Brake Fluid', 'DOT 4 brake fluid', 22.00, 75),
('Power Steering Fluid', 'Power steering system fluid', 28.00, 65),
('Battery 12V', 'Car battery 12 volt 60Ah', 95.00, 45),
('Wiper Blades', 'Front wiper blade pair', 25.00, 100),
('Headlight Bulb', 'LED headlight bulb H7', 32.00, 55),
('Tail Light Bulb', 'LED tail light bulb', 20.00, 80),
('Serpentine Belt', 'Engine serpentine belt', 48.00, 40),
('Water Pump', 'Engine water pump assembly', 85.00, 30),
('Thermostat', 'Engine thermostat housing', 65.00, 35),
('Alternator', 'Car alternator 120A', 180.00, 25),
('Starter Motor', 'Engine starter motor', 220.00, 20),
('Shock Absorber', 'Front shock absorber pair', 140.00, 28),
('Strut Assembly', 'Complete strut assembly', 165.00, 22),
('Control Arm', 'Front control arm assembly', 125.00, 32),
('Ball Joint', 'Suspension ball joint kit', 95.00, 40),
('Sway Bar Link', 'Anti-roll bar link pair', 55.00, 50),
('Engine Mount', 'Engine mounting bracket', 75.00, 38);

INSERT INTO tbl_supplier (supplierName, address, phone, email) VALUES
('AutoParts Inc', '123 Main Street, Downtown', '555-0001', 'info@autoparts.com'),
('Brake Masters', '456 Oak Avenue, Industrial Zone', '555-0002', 'sales@brakemasters.com'),
('TechAuto Supply', '789 Elm Road, Commercial District', '555-0003', 'contact@techautosupply.com'),
('Global Motors Parts', '321 Pine Street, Business Park', '555-0004', 'orders@globalmotors.com'),
('Premium Auto Components', '654 Maple Drive, Tech Hub', '555-0005', 'support@premiumauto.com'),
('FastParts Warehouse', '987 Cedar Lane, Logistics Center', '555-0006', 'warehouse@fastparts.com');

-- Sample Discount Data
INSERT INTO tbl_discount (discountName, discountType, discountValue, description, maxUsageCount, startDate, endDate) VALUES
('New Year Sale', 'percentage', 10.00, 'Special 10% discount for New Year season', 100, '2025-01-01', '2025-01-31'),
('Supplier Special', 'fixed', 50.00, 'Fixed $50 off for bulk orders', -1, '2025-01-01', '2025-12-31'),
('Spring Promotion', 'percentage', 15.00, '15% off for spring season', 50, '2025-03-01', '2025-05-31'),
('VIP Client Discount', 'percentage', 20.00, 'Exclusive 20% discount for VIP clients', 30, '2025-01-01', '2025-12-31'),
('Early Bird Special', 'fixed', 25.00, '$25 off for early orders', 200, '2025-01-01', '2025-06-30');


