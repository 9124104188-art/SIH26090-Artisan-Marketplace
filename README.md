# SIH26090 – Artisan Marketplace

## AI-Driven Market Linkage & Smart Cataloging Mobile Application for Marginalized Artisans

This project is developed for **Smart India Hackathon 2026 – SIH26090**.

The main goal is to help marginalized artisans **digitize their products, create smart catalogs using AI, and connect with buyers through an online marketplace**.

---

## 🎯 Main Goals

* Help artisans create digital product catalogs.
* Use AI to identify and classify products.
* Generate useful product information using AI.
* Help artisans reach more customers.
* Provide a marketplace for buyers.
* Store artisan and product information securely.
* Connect all modules into one complete application.

---

# 👥 Team Modules

The project is divided into 6 modules.

### M1 – Flutter Artisan App

Responsible for the **artisan mobile application**.

Main features:

* Artisan registration and login
* Artisan profile
* Dashboard
* Add product
* Upload product image
* Edit product
* Delete product
* View products
* AI-assisted catalog creation

**Technology:** Flutter + Dart

---

### M2 – Backend / API

Responsible for the **server and APIs**.

Main responsibilities:

* Authentication
* User management
* Artisan APIs
* Product APIs
* Buyer APIs
* Order APIs
* AI integration
* Data validation
* Business logic

**Technology:** Node.js + Express.js

---

### M3 – AI / ML

Responsible for the **AI features**.

Main features:

* Product image analysis
* Product classification
* Product category prediction
* Product description generation
* Product keywords/tags
* Smart catalog generation
* Recommendation support

**Technology:** Python + AI/ML models

---

### M4 – Database

Responsible for **database design and management**.

Main data:

* Users
* Artisans
* Buyers
* Products
* Categories
* Orders
* Reviews
* AI-generated product information

**Technology:** MongoDB / MongoDB Atlas

---

### M5 – Buyer Marketplace

Responsible for the **buyer-facing marketplace**.

Main features:

* Buyer registration and login
* Browse products
* Search products
* Product categories
* Product details
* View artisan information
* Shopping cart
* Place orders
* Order history
* Reviews

**Technology:** React + Vite

---

### M6 – Integration & Testing

Responsible for making sure **all modules work together**.

Responsibilities:

* Frontend and backend integration
* API testing
* AI integration testing
* Database testing
* End-to-end testing
* Bug tracking
* Final testing
* Deployment support

---

# 📁 Repository Structure

```text
SIH26090-Artisan-Marketplace/
│
├── M1_Artisan_App/
│
├── M2_Backend/
│
├── M3_AI_ML/
│
├── M4_Database/
│
├── M5_Buyer_Marketplace/
│
├── M6_Integration_Testing/
│
├── docs/
│   ├── API.md
│   ├── DATABASE.md
│   ├── AI.md
│   └── SETUP.md
│
├── .gitignore
└── README.md
```

Each team member should mainly work inside their **assigned module folder**.

---

# 🔄 How the Application Works

The basic application flow is:

```text
Artisan
   ↓
Flutter App
   ↓
Backend API
   ↓
AI Processing
   ↓
Database
   ↓
Product Catalog
   ↓
Buyer Marketplace
   ↓
Buyer
```

### Example

An artisan uploads a picture of a handmade product.

```text
Product Image
      ↓
      AI
      ↓
Product Classification
      ↓
Category + Description + Tags
      ↓
Backend
      ↓
Database
      ↓
Marketplace
```

The buyer can then view the product on the marketplace.

---

# 🔗 Module Communication

The modules should communicate through the **Backend API**.

```text
Flutter App ──────┐
                  │
Buyer Marketplace ├──→ Backend API ──→ MongoDB
                  │
AI/ML ────────────┘
```

The frontend should **not directly connect to MongoDB**.

The normal flow should be:

```text
Frontend
   ↓
Backend API
   ↓
Database / AI
   ↓
Backend Response
   ↓
Frontend
```

---

# 📋 Common Product Data

All team members should use the same field names.

Example:

```json
{
  "productId": "P001",
  "artisanId": "A001",
  "name": "Handmade Basket",
  "description": "Traditional handmade basket",
  "category": "Handicrafts",
  "price": 500,
  "images": [],
  "tags": ["handmade", "traditional", "basket"],
  "stock": 10
}
```

Do not use different names for the same field.

For example, choose **`productId`** and use it everywhere.

---

# 📚 Documentation

The `docs` folder contains important project information.

### API.md

Contains:

* API endpoints
* Request format
* Response format
* Authentication details

### DATABASE.md

Contains:

* Collections
* Fields
* Data types
* Database structure

### AI.md

Contains:

* AI features
* AI input
* AI output
* Model/API information

### SETUP.md

Contains:

* Installation steps
* Required software
* Environment variables
* How to run the project

---

# 🌿 Git Branch Rules

The `main` branch is the **stable branch**.

Each member should create their own branch.

Example:

```text
main
 ├── yeswanth
 ├── member2
 ├── member3
 ├── member4
 ├── member5
 └── member6
```

### Important

**Do not directly work on `main`.**

---

# 🔧 Git Workflow

### 1. Get latest code

```bash
git checkout main
git pull
```

### 2. Create your branch

```bash
git checkout -b your-name
```

Example:

```bash
git checkout -b yeswanth
```

### 3. Work on your module

Make your changes inside your assigned folder.

### 4. Check changes

```bash
git status
```

### 5. Add changes

```bash
git add .
```

### 6. Commit

```bash
git commit -m "Add module changes"
```

### 7. Push

```bash
git push -u origin your-name
```

### 8. Create Pull Request

On GitHub:

```text
Your Branch → main
```

Create a Pull Request.

### 9. Review

The team lead/member reviews the changes.

### 10. Merge

After approval, merge the Pull Request into `main`.

---

# ⚠️ Git Rules

### ✅ Do

* Work on your own branch.
* Work mainly inside your assigned folder.
* Pull the latest code before starting new work.
* Commit your changes regularly.
* Use clear commit messages.
* Test your code before creating a Pull Request.
* Inform the team about important changes.

### ❌ Don't

* Don't directly push to `main`.
* Don't delete another member's work.
* Don't modify another module without informing the owner.
* Don't commit passwords or API keys.
* Don't commit `.env` files.
* Don't merge untested code.

---

# 🔐 Environment Variables

Never upload passwords, API keys, or database credentials to GitHub.

Example:

```text
MONGODB_URI=
JWT_SECRET=
AI_API_KEY=
```

Use a local `.env` file.

Add this to `.gitignore`:

```text
.env
node_modules/
dist/
build/
```

---

# 🧪 Testing

Each module must be tested before integration.

### M1

* Registration
* Login
* Add product
* Upload image
* View product

### M2

* Authentication APIs
* Product APIs
* User APIs
* Error handling

### M3

* Image processing
* Product classification
* Description generation
* AI response

### M4

* Database connection
* Create data
* Read data
* Update data
* Delete data

### M5

* Product browsing
* Search
* Product details
* Cart
* Orders

### M6

* API integration
* Frontend integration
* AI integration
* Complete application testing

---

# 🚀 MVP Development Flow

The first working version should focus on this flow:

```text
Artisan Registration
        ↓
Add Product
        ↓
Upload Product Image
        ↓
AI Smart Cataloging
        ↓
Save Product
        ↓
Product Appears in Marketplace
        ↓
Buyer Views Product
        ↓
Buyer Places Order
```

First make this basic flow work.

After that, add advanced features.

---

# 🛠️ Technology Stack

| Part              | Technology           |
| ----------------- | -------------------- |
| Artisan App       | Flutter / Dart       |
| Buyer Marketplace | React / Vite         |
| Backend           | Node.js / Express.js |
| Database          | MongoDB              |
| AI/ML             | Python / AI Models   |
| API               | REST API             |
| Authentication    | JWT                  |
| Version Control   | Git / GitHub         |
| API Testing       | Postman              |

---

# 📌 Development Rules for the Team

1. **Understand your task before coding.**
2. **Work only on your assigned module.**
3. **Keep the common data structure unchanged.**
4. **Communicate API changes with the team.**
5. **Test your module before pushing.**
6. **Create a Pull Request for integration.**
7. **Do not break existing functionality.**
8. **Keep the code clean and organized.**

---

# 🎯 Final Project Goal

The final application should allow:

**Artisan → Create Product → AI Smart Catalog → Store Product → Marketplace → Buyer → Order**

The goal is to build a **working, integrated MVP** rather than developing six separate projects.

---

## 🏆 SIH26090

**Project:** AI-Driven Market Linkage & Smart Cataloging Mobile Application for Marginalized Artisans

**Objective:** Use technology and AI to help artisans digitize their products, improve market access, and connect with buyers.
