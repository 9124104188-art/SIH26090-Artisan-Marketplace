
# SIH26090 – AI Artisan Marketplace

An AI-powered marketplace that helps rural and marginalized artisans easily bring their handmade products to digital markets.

## 📌 About the Project

Traditional artisans often face difficulties when selling products online because creating product listings requires typing, photography, pricing, and technical knowledge.

**SIH26090 – AI Artisan Marketplace** simplifies this process using **Flutter and AI**.

An artisan can:

1. 📷 Take a photo of the product.
2. 🎙️ Describe the product using their voice.
3. 🤖 Let AI process the image and voice.
4. 📝 Generate a product title, description, category, and materials.
5. 💰 Get a suggested product price.
6. 👀 Review and edit the generated information.
7. 🛍️ Publish the product to the marketplace.

Buyers can then discover products, learn about artisans, add products to their cart, and place orders.

---

## 🎯 Project Objectives

* Connect rural artisans with digital customers.
* Reduce the technical knowledge required to sell products online.
* Make product listing creation faster and easier.
* Support voice-based product descriptions.
* Use AI to generate professional product information.
* Provide a fair and transparent pricing recommendation.
* Give buyers a simple way to discover authentic handmade products.

---

## ✨ Key Features

### 👨‍🎨 Artisan App

The Flutter Artisan App allows artisans to manage their products and marketplace activities.

* Artisan registration and login
* Artisan profile
* Product image capture
* Voice-based product description
* AI product catalog generation
* Automatic product categorization
* AI-assisted pricing
* Product preview and editing
* Product management
* Inventory management
* Order dashboard
* Order status updates

### 🛍️ Buyer App

The Buyer App is built using Flutter and provides the marketplace experience for customers.

* Buyer registration and login
* Browse products
* Search products
* Browse categories
* View product details
* View artisan information
* Explore artisan stories
* Add products to cart
* Place orders
* View order history

### 🤖 AI Features

The AI service provides the intelligence behind product creation.

* Product image processing
* Background removal
* Image enhancement
* Voice-to-text conversion
* Regional language support
* AI-generated product descriptions
* Product categorization
* Smart pricing recommendation

---

## 🔄 Product Creation Workflow

```text
Artisan
   │
   ├── Take Product Photo
   │
   └── Record Voice Description
             │
             ▼
      Flutter Artisan App
             │
             ▼
       Node.js Backend
             │
             ▼
       Python FastAPI AI
             │
      ┌──────┼───────┐
      ▼      ▼       ▼
    Image   Voice   Catalog
   Process  →Text   Generation
             │
             ▼
       Price Suggestion
             │
             ▼
      Product Preview
             │
       Artisan Reviews
             │
             ▼
        Publish Product
             │
             ▼
         Buyer App
```

---

## 🏗️ System Architecture

The project follows a backend-centered architecture.

```text
┌───────────────────────────┐
│   Flutter Artisan App     │
└─────────────┬─────────────┘
              │
              │ REST API + JWT
              │
┌─────────────▼─────────────┐
│    Node.js + Express      │
│         Backend           │
└───────┬───────────┬───────┘
        │           │
        │           │ Internal AI API
        ▼           ▼
┌─────────────┐  ┌──────────────┐
│  MongoDB    │  │ Python       │
│   Atlas     │  │ FastAPI AI   │
└─────────────┘  └──────┬───────┘
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
            Image     Whisper    LLM
           Processing  STT      Catalog
```

The Flutter applications communicate with the **Node.js backend**. AI operations are accessed through the backend rather than directly from the mobile applications.

---

## 🛠️ Technology Stack

| Layer            | Technology           |
| ---------------- | -------------------- |
| Artisan App      | Flutter / Dart       |
| Buyer App        | Flutter / Dart       |
| Backend          | Node.js / Express.js |
| AI Service       | Python / FastAPI     |
| Database         | MongoDB Atlas        |
| ODM              | Mongoose             |
| Authentication   | JWT                  |
| Speech-to-Text   | Whisper              |
| Image Processing | OpenCV / rembg       |
| Image Storage    | Cloudinary           |
| AI Generation    | LLM                  |

---

## 📂 Project Structure

```text
SIH26090-Artisan-Marketplace/
│
├── ai/
│   ├── app/
│   ├── image/
│   ├── voice/
│   ├── catalog/
│   └── pricing/
│
├── backend/
│   ├── controllers/
│   ├── middleware/
│   ├── models/
│   ├── routes/
│   ├── services/
│   └── config/
│
├── database/
│
├── docs/
│
├── mobile/
│   ├── artisan_app/
│   └── buyer_app/
│
├── README.md
└── .gitignore
```

### Folder Overview

**`ai/`**
Contains the Python FastAPI service responsible for image processing, speech-to-text, catalog generation, and pricing.

**`backend/`**
Contains the Node.js/Express API, authentication, product management, orders, and communication with the AI service.

**`database/`**
Contains database-related resources and configuration.

**`docs/`**
Contains project documentation and supporting materials.

**`mobile/artisan_app/`**
Flutter application used by artisans to create and manage products.

**`mobile/buyer_app/`**
Flutter application used by buyers to browse products and place orders.

---

## 🔐 Security

The backend acts as the main security and business-logic layer.

The system includes:

* JWT authentication
* Role-based access control
* API validation
* Rate limiting
* Protected AI communication
* User ownership checks
* Server-side order price calculation
* Secure environment variables

API keys, database credentials, and other secrets should be stored in environment variables and should **not be committed to GitHub**.

---

## 👥 Team Modules

The project can be divided into the following development modules:

| Module             | Responsibility                                |
| ------------------ | --------------------------------------------- |
| 🎨 Artisan Flutter | Artisan UI, product creation, profile, orders |
| 🛒 Buyer Flutter   | Marketplace, search, cart, checkout, orders   |
| ⚙️ Backend         | APIs, authentication, products, orders        |
| 🤖 AI/ML           | Image, voice, catalog, pricing                |
| 🗄️ Database       | MongoDB models, indexes, data management      |
| 🧪 Integration     | Testing, API integration, deployment          |

---

## 🚀 Future Scope

The platform can be expanded with:

* More Indian regional languages
* Online payment integration
* Delivery and shipment tracking
* AI-based product recommendations
* Personalized buyer experiences
* Artisan analytics
* Multilingual marketplace support
* Wider integration with digital commerce platforms

---

## 🌍 Vision

Our goal is to use **AI and mobile technology to bridge the gap between traditional artisans and the digital marketplace**.

The platform makes online selling simpler for artisans while helping buyers discover unique, authentic, and handmade products.

---

## 📌 Project Details

**Project ID:** SIH26090
**Project:** AI Artisan Marketplace
**Platform:** Flutter
**Backend:** Node.js + Express
**AI:** Python + FastAPI
**Database:** MongoDB Atlas

**Built for Smart India Hackathon (SIH)**
