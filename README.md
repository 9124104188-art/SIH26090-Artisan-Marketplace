# 🧵 Artisan Connect

### AI-Driven Market Linkage and Smart Cataloging Mobile Application for Marginalized Artisans

Artisan Connect is an **AI-powered digital marketplace** designed to help marginalized artisans showcase, manage, price, and sell their handmade products directly to buyers.

The application combines **Flutter, Node.js, Express.js, FastAPI, MongoDB, Cloudinary, and Generative AI** to provide a complete marketplace experience for both artisans and buyers.

---

## 📌 Problem Statement

Many traditional and marginalized artisans face difficulties in reaching customers, creating professional product catalogs, determining suitable prices, and competing in digital marketplaces.

Common challenges include:

* Limited access to online markets
* Difficulty creating professional product descriptions
* Lack of digital cataloging skills
* Difficulty determining suitable product prices
* Limited visibility to potential buyers
* Dependence on intermediaries
* Difficulty managing products and orders digitally

---

## 💡 Our Solution

**Artisan Connect** provides a digital platform where artisans can:

* Register and create their profile
* Add handmade products
* Upload product images
* Use AI to generate product information
* Get AI-assisted pricing suggestions
* Manage their products
* Receive and manage orders
* Reach buyers through a digital marketplace

Buyers can:

* Browse artisan products
* Search and filter products
* View product details
* Add products to cart
* Place orders
* Review purchased products
* Receive personalized product recommendations

---

# 🚀 Key Features

## 👨‍🎨 Artisan Features

### Authentication

* Artisan registration
* Secure login
* JWT-based authentication
* Role-based access

### Artisan Profile

* View profile
* Manage artisan information
* Update profile details

### Product Management

* Add products
* Edit products
* Delete products
* Publish products
* View personal product catalog
* Upload product images

### AI-Powered Cataloging

Artisans can use AI to simplify product catalog creation.

The system can assist with:

* Product classification
* Product tags
* Product descriptions
* Material identification
* Product information generation

Instead of manually writing detailed product information, artisans can provide basic information and let the AI assist with catalog creation.

### Smart Pricing

The application provides AI-assisted pricing suggestions based on available product information and pricing-related inputs.

This helps artisans understand a reasonable price range for their products.

### Image Processing

Uploaded product images can be processed through the AI service before being used in the marketplace.

The system supports:

* Product image processing
* Background removal
* Cloud image storage
* Optimized product presentation

### Voice Support

The AI service also provides voice transcription functionality, allowing voice-based product information to be converted into text.

---

# 🛍️ Buyer Features

### Product Marketplace

Buyers can:

* Browse products
* Search products
* Explore categories
* View product details
* Discover artisan products

### Product Details

Each product can contain information such as:

* Product name
* Description
* Materials
* Price
* Images
* Artisan information
* Reviews

### Shopping Cart

Buyers can:

* Add products to cart
* Update quantities
* Remove products
* View cart totals

### Orders

Buyers can:

* Place orders
* View order history
* Track order information

### Reviews

Buyers can provide reviews for products they have purchased.

### AI Recommendations

The application provides personalized product recommendations to help buyers discover relevant artisan products.

---

# 🤖 AI Features

The AI layer is implemented as a separate **FastAPI microservice**.

### Current AI capabilities

| AI Feature             | Purpose                                    |
| ---------------------- | ------------------------------------------ |
| Image Processing       | Process and improve product images         |
| Background Removal     | Remove unwanted image backgrounds          |
| Product Classification | Identify product categories                |
| Product Tags           | Generate useful product tags               |
| Description Generation | Generate professional product descriptions |
| Smart Pricing          | Provide pricing suggestions                |
| Voice Transcription    | Convert voice input into text              |
| Recommendations        | Suggest relevant products                  |

The project uses **Google Gemini** for generative AI functionality.

---

# 🏗️ System Architecture

```text
                    ┌───────────────────────┐
                    │      Flutter App      │
                    │                       │
                    │  Artisan + Buyer UI   │
                    └───────────┬───────────┘
                                │
                                │ HTTPS / REST API
                                ▼
                    ┌───────────────────────┐
                    │   Node.js + Express   │
                    │                       │
                    │      API Gateway      │
                    │ Authentication        │
                    │ Products              │
                    │ Cart                  │
                    │ Orders                │
                    │ Reviews               │
                    │ AI Proxy              │
                    └───────┬───────┬───────┘
                            │       │
                ┌───────────┘       └──────────────┐
                ▼                                  ▼
       ┌─────────────────┐                ┌─────────────────┐
       │    MongoDB      │                │  FastAPI AI     │
       │                 │                │   Microservice  │
       │ Users           │                │                 │
       │ Products        │                │ Gemini AI       │
       │ Orders          │                │ Image Processing│
       │ Reviews         │                │ Pricing         │
       └─────────────────┘                │ Classification  │
                                          │ Recommendations │
                                          └────────┬────────┘
                                                   │
                                                   ▼
                                          ┌─────────────────┐
                                          │    Cloudinary   │
                                          │                 │
                                          │ Product Images  │
                                          └─────────────────┘
```

---

# 🧩 Project Modules

The project is organized into multiple modules.

## M1 — Artisan Module

Handles the complete artisan workflow:

```text
Login/Register
      ↓
Artisan Profile
      ↓
Home
      ↓
Add Product
      ↓
Photo / Camera / Voice
      ↓
AI Processing
      ↓
AI Results
      ↓
Smart Pricing
      ↓
Edit Product
      ↓
Publish
      ↓
My Products
      ↓
Orders
```

## M5 — Buyer Module

Handles the buyer marketplace experience:

```text
Login/Register
      ↓
Home
      ↓
Search / Categories
      ↓
Product Details
      ↓
Recommendations
      ↓
Cart
      ↓
Checkout
      ↓
Order
      ↓
Review
```

## M6 — Testing, Integration & Deployment

Responsible for:

* Module integration
* API integration testing
* Authentication testing
* Feature testing
* Deployment verification
* Production APK testing
* Backend integration
* AI service integration
* Final system validation

---

# 🛠️ Technology Stack

## Frontend

* **Flutter**
* **Dart**
* Material UI
* REST API integration
* Shared Preferences

## Backend

* **Node.js**
* **Express.js**
* JWT Authentication
* REST APIs

## AI Service

* **Python**
* **FastAPI**
* Google Gemini
* Image processing
* Background removal
* Machine-learning utilities

## Database

* **MongoDB**
* MongoDB Atlas

## Image Storage

* **Cloudinary**

## Development Tools

* Visual Studio Code
* Git
* GitHub
* Android Studio
* Postman

## Deployment

* **Render**
* Vercel where applicable
* Cloudinary
* MongoDB Atlas

---

# 📁 Project Structure

```text
SIH26090-Artisan-Marketplace/
│
├── artisan_connect_buyer_full/
│   │
│   ├── android/
│   ├── ios/
│   ├── lib/
│   │   ├── services/
│   │   ├── controllers/
│   │   ├── screens/
│   │   ├── models/
│   │   └── widgets/
│   │
│   ├── ai/
│   │   ├── app/
│   │   ├── requirements.txt
│   │   └── .env.example
│   │
│   ├── server/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── models/
│   │   └── middleware/
│   │
│   ├── pubspec.yaml
│   └── README.md
│
└── README.md
```

---

# 🔌 Backend API

The Node.js backend acts as the main API gateway between the Flutter application and the backend services.

Major API areas include:

```text
/api/auth
/api/products
/api/orders
/api/reviews
/api/cart
/api/ai
```

### Authentication

JWT tokens are used to authenticate users.

The application supports role-based access for different users such as:

* Artisan
* Buyer
* Admin

---

# 🤖 AI API

The FastAPI service provides AI-related endpoints.

Major functionality includes:

```text
Voice Transcription
Image Processing
Product Catalog Generation
Product Classification
Product Tags
Smart Pricing
Recommendations
```

The Node.js backend communicates with the FastAPI service so that the Flutter application does not need to directly access the AI microservice.

---

# 🔐 Security

The project follows basic security practices including:

* JWT authentication
* Protected API routes
* Role-based authorization
* Environment variables for secrets
* No API keys committed to GitHub
* `.env` files excluded from version control
* HTTPS communication in production

### ⚠️ Environment Variables

Never commit real API keys, passwords, database credentials, or Cloudinary secrets.

Use `.env` locally and configure production secrets through the deployment platform.

Example:

```env
LLM_PROVIDER=gemini
LLM_API_KEY=your_gemini_api_key_here
GEMINI_MODEL=gemini-2.5-flash

MONGODB_URI=your_mongodb_connection_string

CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret
```

The values above are placeholders only.

---

# ⚙️ Local Setup

## 1. Clone the repository

```bash
git clone https://github.com/9124104188-art/SIH26090-Artisan-Marketplace.git
```

```bash
cd SIH26090-Artisan-Marketplace
```

---

## 2. Flutter Setup

Navigate to the Flutter application:

```bash
cd artisan_connect_buyer_full
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# 🌐 API Configuration

The Flutter application uses the following configuration:

```dart
String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://sih26090-artisan-marketplace.onrender.com',
);
```

For local development, the API URL can be overridden using:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

For Android emulator development, the appropriate local host configuration may be required depending on the environment.

---

# 🐍 Running the AI Service

Navigate to the AI service:

```bash
cd ai
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate it on Windows:

```powershell
venv\Scripts\activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Configure your `.env` file with the required AI and storage credentials.

Run FastAPI:

```bash
uvicorn app.main:app --reload --port 8000
```

The AI service will then be available locally on:

```text
http://localhost:8000
```

---

# 🟢 Production Deployment

The production architecture uses separate services for scalability.

### Flutter Application

The Flutter application communicates with the deployed backend through HTTPS.

### Node.js Backend

```text
https://sih26090-artisan-marketplace.onrender.com
```

### FastAPI AI Service

```text
https://sih26090-artisan-marketplace-1.onrender.com
```

### Database

MongoDB Atlas is used for cloud database storage.

### Images

Cloudinary is used for persistent product image storage.

---

# 📱 Android APK

A release APK can be generated using:

```bash
flutter build apk --release
```

Generated APK:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The Android application uses production signing for release builds.

---

# 🧪 Testing

The application was tested across major workflows including:

### Authentication

* Registration
* Login
* Logout
* JWT authentication
* Role validation

### Artisan

* Add product
* Edit product
* Delete product
* Product listing
* Image upload
* AI catalog generation
* AI pricing
* Orders

### Buyer

* Product browsing
* Search
* Product details
* Cart
* Checkout
* Orders
* Reviews
* Recommendations

### Integration

* Flutter → Express API
* Express → MongoDB
* Express → FastAPI
* FastAPI → Gemini
* Image processing → Cloudinary

---

# 🎯 Project Objectives

The main objectives of Artisan Connect are:

1. Digitize artisan products.
2. Provide direct market access to artisans.
3. Reduce the technical difficulty of online catalog creation.
4. Use AI to assist product description and classification.
5. Provide AI-assisted pricing support.
6. Improve product discoverability.
7. Connect artisans directly with buyers.
8. Provide a complete digital marketplace experience.
9. Support scalable cloud-based deployment.

---

# 🌱 Future Enhancements

Possible future improvements include:

* Multilingual AI assistance
* Regional language voice support
* Online payment gateway integration
* Advanced sales analytics
* Artisan performance dashboard
* AI-powered demand prediction
* Advanced recommendation models
* Logistics integration
* Buyer–artisan communication
* Social sharing
* Offline-first artisan workflows
* Automated inventory management
* Advanced fraud detection

---

# 🏆 Hackathon Context

This project was developed as part of **Smart India Hackathon 2026** under problem statement **SIH26090**.

### Project

**AI-Driven Market Linkage and Smart Cataloging Mobile Application for Marginalized Artisans**

### Team

**Team Name:** Code Crafters

### Project Role

**Testing + Integration + Deployment**

The project focuses on combining AI and digital marketplace technologies to improve market accessibility for marginalized artisans.

---

# 👥 Team

### Code Crafters

A collaborative team working on the design, development, AI integration, testing, and deployment of Artisan Connect.

---

# 📄 License

This project was developed for educational, hackathon, and prototype purposes.

---

# ⭐ Support

If you find this project useful, consider giving the repository a ⭐ on GitHub.

---

## 🧵 Artisan Connect

**Connecting artisans to digital markets through AI-powered technology.**
