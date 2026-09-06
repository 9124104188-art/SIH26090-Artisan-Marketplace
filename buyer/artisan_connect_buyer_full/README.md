# Artisan Connect — Buyer Marketplace

Flutter implementation of the Buyer-only marketplace shown in the supplied reference images.

## Included
- 20 buyer screens / flows
- 20 categories
- 200 products (10 per category)
- Search, category filtering, sorting
- Product details, artisan details
- Wishlist toggle
- Cart quantity controls
- Checkout + payment + order review
- Order success, order history, tracking
- Recommendations and buyer profile
- Green/white visual theme matching the references

## Run
```bash
flutter pub get
flutter run
```

The app uses only Flutter SDK widgets plus Material Icons; no Firebase/backend is required for this demo.
Product images use remote Unsplash image URLs with local placeholder fallbacks. Replace the URLs in `lib/data/catalog.dart` with your own storage URLs for production.
