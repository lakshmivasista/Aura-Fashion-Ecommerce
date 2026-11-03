
<div align="center">

# AURA ✦

### Fashion, thoughtfully experienced

A full-stack fashion e-commerce platform that brings together  
seamless online shopping, store management and AI-powered Virtual Try-On

<br/>

![Java](https://img.shields.io/badge/Java-17-51352F?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Servlets-754D43?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-Database-8B6F61?style=for-the-badge&logo=mysql&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-Build%20Tool-51352F?style=for-the-badge&logo=apachemaven&logoColor=white)

<br/>

**[Explore Source Code](https://github.com/lakshmivasista/Aura-Fashion-Ecommerce)**

</div>

---

## ✦ About AURA

AURA is a full-stack fashion e-commerce web application designed to deliver a smooth and engaging online shopping experience

Beyond traditional shopping functionality, AURA introduces an AI-powered Virtual Try-On experience that allows customers to preview selected garments on their own photos before adding the actual product to their cart

The platform also includes a dedicated admin workspace for managing products, customers, orders and store analytics

## ✨ Features at a Glance

### 🛍️ Customer Shopping Experience

- User registration and secure login flow
- Browse and explore fashion collections
- Product details with available size variants
- Wishlist management
- Shopping cart with size-specific product variants
- Delivery address management
- Checkout and order placement
- Order history and order cancellation
- Multiple payment method selection

### 👑 Admin Control Center

- Centralized admin dashboard
- Product management — add, edit and delete products
- Customer order management
- Order status management
- Registered user overview
- Store analytics and performance insights
- Session-based login and logout functionality

---

## 🤍 AI Virtual Try-On — Experience Before You Buy

One of AURA's key highlights is its AI-powered Virtual Try-On integration

Customers can select a garment from the AURA collection, upload their personal photo and generate an AI-based preview of how the selected garment may look on them

**How it works**

1. Choose a garment from the AURA collection
2. Upload your personal photo
3. Select the garment category
4. Generate your virtual try-on preview
5. Choose the actual product size
6. Add the tried-on garment to your shopping cart

The generated preview is an estimate and may differ from the actual garment fit, fabric, colour and appearance

---

## ⚙️ Technology Stack

| Layer | Technologies |
|:--|:--|
| Backend | Java 17, Jakarta Servlets, JSP |
| Frontend | HTML5, CSS3, JavaScript |
| Database | MySQL, JDBC |
| AI Integration | Hosted FASHN Virtual Try-On service |
| Build Tool | Apache Maven |
| Application Server | Apache Tomcat 10.x |
| Development Environment | Eclipse IDE |

---

## 🏗️ Project Architecture

```text
AURA
│
├── src/main/java/com/aura
│   │
│   ├── controller/       → Servlets and request handling
│   ├── dao/              → Database operations
│   ├── model/            → Application data models
│   └── util/             → Database and AI utilities
│
├── src/main/resources/   → Local configuration
│
├── src/main/webapp/
│   │
│   ├── WEB-INF/
│   │   ├── views/        → JSP pages
│   │   └── web.xml       → Web application configuration
│   │
│   └── assets/
│       ├── css/          → Stylesheets
│       └── images/       → Product and application images
│
├── pom.xml
└── README.md
```

---

## 🚀 Run AURA Locally

### Prerequisites

- JDK 17 or later
- Apache Maven
- MySQL Server
- Apache Tomcat 10.x
- Eclipse IDE or another Java IDE

### 1. Clone the repository

```bash
git clone https://github.com/lakshmivasista/Aura-Fashion-Ecommerce.git
```

### 2. Import the project

Import the cloned folder into Eclipse as an existing Maven project

### 3. Configure the database

Create the MySQL database `aura_db` and configure the required application tables

Create a local configuration file at:

`src/main/resources/db.properties`

Add your own local database credentials:

```properties
db.url=jdbc:mysql://localhost:3306/aura_db
db.username=root
db.password=YOUR_MYSQL_PASSWORD
```

### 4. Configure AI credentials

Set the required AI service credentials through the environment variable expected by the AI integration

For the current integration, configure `HF_TOKEN` where required

### 5. Build the application

```bash
mvn clean package
```

### 6. Deploy on Apache Tomcat

Deploy the generated WAR file to your Tomcat server and start the application

### 7. Open AURA

```text
http://localhost:8080/aura/
```

The URL and port may vary depending on your Tomcat configuration

---

## 🔐 Security & Configuration

- Database credentials are kept in an ignored local configuration file
- Database credentials can also be supplied through environment variables
- AI service credentials should never be committed to the repository
- Configure your own database and service credentials before running the application

---

## 🌷 Project Highlights

| Feature | Implementation |
|:--|:--|
| E-Commerce | Complete customer shopping workflow |
| Admin Workspace | Centralized store management |
| AI Integration | Virtual garment preview |
| Database | MySQL-backed persistence |
| Architecture | Java MVC-style application structure |

---

## 👩‍💻 Developer

<div align="center">

### Lakshmi 

Full Stack Java Developer | AI & Machine Learning Enthusiast

[![GitHub](https://img.shields.io/badge/GitHub-lakshmivasista-51352F?style=for-the-badge&logo=github&logoColor=white)](https://github.com/lakshmivasista)

<br/>

*Built with creativity, curiosity and a passion for technology*

**AURA ✦**

</div>
