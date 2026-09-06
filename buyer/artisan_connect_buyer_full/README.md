# SIH26090 – AI-Driven Market Linkage & Smart Cataloging Mobile Application for Marginalized Artisans

[![Flutter Version](https://img.shields.io/badge/Flutter-v3.3.0%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-v3.3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Hackathon](https://img.shields.io/badge/Smart%20India%20Hackathon-SIH26090-orange)](https://sih.gov.in)

**Artisan Connect** is a competition-ready, artisan-first mobile application built for **Smart India Hackathon (SIH26090)**. It solves the critical market linkage and digital cataloging challenges faced by rural and marginalized Indian artisans through AI-assisted product onboarding and direct buyer access.

---

## 🌟 Key Features

### 🛠️ For Artisans (Seller Hub)
- **Artisan Dashboard**: Key business metrics (Total Products, Active Orders, Revenue/Sales), quick action shortcuts, and real-time inventory stock management.
- **🤖 AI Smart Cataloging**: Computer vision simulation that analyzes product photos to automatically detect categories, generate craft tags, estimate fair market pricing, and draft storytelling descriptions.
- **📸 Guided Add Product Flow**: 5-step intuitive product wizard (Photo Upload $\rightarrow$ AI Auto-Fill $\rightarrow$ Review & Edit $\rightarrow$ Stock & Price Tagging $\rightarrow$ Publish).
- **Inventory Stock Badges**: Real-time stock status (`In Stock`, `Low Stock`) with quick catalog edit options.

### 🛍️ For Buyers (Marketplace)
- **20 Craft Categories**: Home Decor, Handicrafts, Textiles, Jewellery, Paintings, Pottery, Wooden Crafts, Bamboo Products, Metal Crafts, Stone Crafts, Leather Goods, and more.
- **200+ Handcrafted Products**: Authentic items sourced directly from rural craft clusters across India (Thanjavur, Jaipur, Kanchipuram, Madurai, Varanasi, Mysuru).
- **Complete Shopping Experience**:
  - Live product search & category filtering.
  - Interactive shopping cart with subtotal & shipping calculation.
  - Multi-step checkout, payment gateway simulation, and order review.
  - Real-time order history & package tracking flow.
- **Trust & Verification Badges**: Direct Artisan Support Guarantee on product details.

### 🔄 Dual Role Mode Switcher
- Instantly switch between **Artisan Seller Mode** and **Buyer Customer Mode** from the Login screen, App Drawer, or Profile Settings to demonstrate end-to-end workflows during hackathon judging.

---

## 🎨 Design System

Built using a curated, authentic handicraft-inspired color palette:

| Element | Color Code | Description |
| :--- | :--- | :--- |
| **Primary** | `#0D5C3A` | Deep Forest Emerald |
| **Secondary** | `#C85A32` | Warm Terracotta |
| **Accent** | `#D99B26` | Ochre Gold |
| **Background** | `#F9F8F6` | Warm Ivory |
| **Surface** | `#FFFFFF` | Pure White |

---

## 📁 Project Structure

```text
lib/
├── controllers/
│   ├── artisan_controller.dart     # Manages artisan products, role state, and stats
│   └── cart_controller.dart        # Manages cart items, quantities, subtotal & shipping
├── data/
│   └── catalog.dart                # Categories, product names, image pools & mock catalog
├── models/
│   └── product.dart                # Product data model with stock & copyWith support
├── screens/
│   ├── splash_screen.dart          # Branding & animated splash
│   ├── login_screen.dart           # Role selector (Artisan/Buyer) & auth
│   ├── register_screen.dart        # Craft specialization & user registration
│   ├── main_shell.dart             # Responsive tab navigation & app bar delegate
│   ├── artisan_dashboard_screen.dart # Artisan stats, quick actions & inventory
│   ├── add_product_screen.dart     # Guided 5-step product creation wizard
│   ├── ai_cataloging_screen.dart   # Vision AI analysis simulation & catalog suggestion
│   ├── home_screen.dart            # Buyer marketplace homepage
│   ├── category_screen.dart        # Category grid & filters
│   ├── product_listing_screen.dart # Product catalog with stock badges
│   ├── product_details_screen.dart # Image hero, artisan story badge & buy actions
│   ├── cart_screen.dart            # Cart item management
│   ├── checkout_screen.dart        # Shipping address form
│   ├── payment_screen.dart         # Payment method selection
│   ├── order_review_screen.dart    # Order summary before placing
│   ├── order_success_screen.dart   # Order confirmation screen
│   ├── orders_screen.dart          # Order history listing
│   ├── tracking_screen.dart        # Live delivery status tracker
│   └── profile_screen.dart         # Editable profile sheet & role toggle
├── theme/
│   └── app_theme.dart              # Theme tokens, Material 3 styles & input decorations
└── widgets/
    ├── app_bottom_nav.dart         # Dynamic role-adaptive bottom navigation
    ├── app_drawer.dart             # Side menu drawer
    ├── custom_button.dart          # Primary, secondary, outline & text buttons
    ├── custom_text_field.dart      # Standardized input fields with validation
    ├── section_title.dart          # Header component with optional action link
    ├── loading_view.dart           # Animated loading indicator
    ├── empty_state.dart            # Empty state illustration & retry button
    ├── error_state.dart            # Network & loading error display widget
    ├── product_card.dart           # Responsive card with AspectRatio image wrapper
    ├── price_rating.dart           # Star rating & price formatter
    └── product_image.dart          # Cached remote image with fallback placeholder
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.3.0`)
- [Dart SDK](https://dart.dev/get-started) (`>= 3.3.0`)
- VS Code or Android Studio

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/artisan_connect.git
   cd artisan_connect
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify codebase health**:
   ```bash
   flutter analyze
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Free-Tier & Local Demo Notes

- **Zero Paid Dependencies**: Uses pure Flutter SDK built-in widgets and standard packages. No paid cloud APIs or paid UI libraries required.
- **Offline & Demo Ready**: All state modifications (adding products, AI Smart Cataloging simulations, editing catalog details, shopping cart operations) run in memory via reactive controllers.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
