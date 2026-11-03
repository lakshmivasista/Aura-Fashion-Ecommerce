\# AURA — Fashion E-Commerce Platform



AURA is a full-stack fashion e-commerce web application designed to provide a smooth online shopping experience with AI-powered Virtual Try-On functionality



\## ✨ Features



\### Customer Features

\- User registration and login

\- Browse fashion products

\- Product details and size selection

\- Wishlist management

\- Shopping cart with size-specific variants

\- Delivery address management

\- Checkout and order placement

\- Order history and order cancellation

\- AI-powered Virtual Try-On to preview selected garments



\### Admin Features

\- Admin dashboard

\- Product management — add, edit and delete products

\- Customer order management

\- Order status updates

\- Registered user management

\- Store analytics



\### AI Virtual Try-On

\- Upload a personal photo

\- Select a garment from the AURA collection

\- Generate an AI-based virtual try-on preview

\- Select the garment size and add the tried-on product to the cart



The generated preview is an estimate and may differ from the actual garment fit and appearance



\## 🛠️ Technology Stack



| Area | Technologies |

|---|---|

| Backend | Java 17, Jakarta Servlets, JSP, JDBC |

| Frontend | HTML5, CSS3, JavaScript |

| Database | MySQL |

| AI Integration | Hosted FASHN Virtual Try-On service |

| Build Tool | Apache Maven |

| Server | Apache Tomcat 10.x |

| IDE | Eclipse IDE |



\## 📂 Project Structure



```text

aura/

├── src/

│   └── main/

│       ├── java/

│       │   └── com/aura/

│       │       ├── controller/

│       │       ├── dao/

│       │       ├── model/

│       │       └── util/

│       ├── resources/

│       └── webapp/

│           ├── WEB-INF/

│           │   └── views/

│           └── assets/

├── pom.xml

└── README.md

```



\## ⚙️ Prerequisites



\- JDK 17 or later

\- Apache Maven

\- MySQL Server

\- Apache Tomcat 10.x

\- Eclipse IDE or another Java IDE



\## 🚀 Local Setup



1\. Clone the repository



```bash

git clone https://github.com/lakshmivasista/Aura-Fashion-Ecommerce.git

```



2\. Open the project in Eclipse as an existing Maven project



3\. Create and configure the MySQL database named `aura\_db`



4\. Configure database credentials locally using `src/main/resources/db.properties`



```properties

db.url=jdbc:mysql://localhost:3306/aura\_db

db.username=root

db.password=YOUR\_MYSQL\_PASSWORD

```



5\. Configure the required AI service credentials through the appropriate environment variable



6\. Build the project using Maven



```bash

mvn clean package

```



7\. Deploy the generated WAR file to Apache Tomcat



8\. Start Tomcat and open the application in your browser



```text

http://localhost:8080/aura/

```



\*\*Note:\*\* The database schema and sample data must be configured before running the application. Database credentials and AI service tokens should never be committed to GitHub



\## 🔐 Security



\- Database credentials are kept outside the tracked source files

\- Environment variables can be used for database configuration

\- Private API credentials should be configured through environment variables



\## 👩‍💻 Developer



\*\*Lakshmi\*\*



GitHub: https://github.com/lakshmivasista



\## 📌 Project Status



Core customer shopping features, admin management modules and AI Virtual Try-On integration have been implemented

