# 🚗 Garage Management System

**Java Web Application - University Assignment**

A complete implementation of two modules using **Servlet + JSP + JDBC** without frameworks.

## 🎯 Features

### Module 1: Search Services/Parts
- Search by keyword across services and spare parts
- Display results with details (ID, name, price, stock)

### Module 2: Import Parts
- Enter supplier info (or create new)
- Add multiple spare parts (code, unit, qty, price)
- Generate import order with totals
- Update stock automatically

## 🏗️ Architecture

Clean Architecture with 4 layers:
- **View**: JSP pages for presentation
- **Controller**: Servlets handling requests/responses
- **DAO**: Data access with JDBC
- **Model**: Domain entities (Service, Part, Supplier, etc.)

## 🚀 Quick Start

### 1. Prerequisites
- JDK 8+
- MySQL 5.7+
- Apache Tomcat 9.0+

### 2. Setup Database
```bash
mysql -u root < database.sql
```

### 3. Deploy to Tomcat

**Option A: Automatic (Recommended)**
```bash
./deploy.sh
```

**Option B: Manual**
```bash
./build.sh
cp GaraManModule.war $TOMCAT_HOME/webapps/
$CATALINA_HOME/bin/startup.sh
```

### 4. Access Application
```
http://localhost:8080/GaraManModule/
```

## 📦 Required Libraries

Download and place in `WebContent/WEB-INF/lib/`:

1. **MySQL Connector** (8.0.x):
   ```
   https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar
   ```

2. **JSTL** (1.2):
   ```
   https://repo1.maven.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.jar
   ```

## 🧪 Testing

### Search Module
1. Go to "Search" → Enter "oil" → Results show services and parts

### Import Module
1. Go to "Import" → Select supplier → Add parts → Submit
2. Check invoice and verify stock updated in database

## 📁 Project Structure

```
GaraManModule/
├── src/com/garaman/
│   ├── controller/    # Servlets (controllers + business flow)
│   ├── dao/           # Data access (interfaces + impl)
│   ├── model/         # Domain entities
│   └── util/          # Database connection
├── WebContent/
│   ├── *.jsp          # Views
│   └── WEB-INF/
│       ├── web.xml    # Deployment config
│       └── lib/       # JAR libraries
├── database.sql       # Database schema
├── build.sh           # Build script
├── deploy.sh          # Deploy script
└── README.md          # This file
```

## 🐛 Troubleshooting

### Database Connection
- Update password in `src/com/garaman/util/DBConnection.java`
- Default: `PASSWORD = "";`

### Tomcat Deployment
- Check logs: `tail -f $CATALINA_HOME/logs/catalina.out`
- Ensure JAR files in `WEB-INF/lib/`

### Build Issues
- Run `./build.sh` for compilation
- Ensure CATALINA_HOME is set

## 📊 Database Schema

**Tables:**
- `user_account` - Users with roles and status
- `service` - Garage services (code, base_price, duration_min)
- `spare_part` - Spare parts inventory (code, unit, stock/min stock)
- `supplier` - Supplier master data
- `import_order` - Import header (supplier, staff, status, total)
- `import_order_item` - Import lines (quantity, unit_price, line_total)
- `supplier` - Parts suppliers
- `import_invoice` - Import transactions
- `import_item` - Invoice details

## 🎓 Assignment Info

- **Course**: Java Web Development
- **Architecture**: Clean Architecture (4 layers)
- **Technology**: Servlet + JSP + JDBC
- **No Frameworks**: Pure Java EE

---

**Ready to deploy and test!** 🚀
