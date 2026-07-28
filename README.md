# Ehije Pharma Connect

A Flutter application for connecting users with pharmacies for medicine ordering, prescription uploads, and delivery.

## Features

- User authentication (sign up / sign in) via Supabase
- Browse medicines by category
- Search products
- Product details with prescription upload
- Cart and checkout flow
- Payment and order tracking
- Saved addresses, order history, notifications, chat support

## Tech Stack

- **Framework:** Flutter (Dart SDK ^3.10.1)
- **Backend:** Supabase (`supabase_flutter`)
- **HTTP:** `http` package
- **Targets:** Android, iOS, Web, Windows, macOS, Linux

## Getting Started

### Prerequisites

- Flutter SDK (Dart ^3.10.1)
- A Supabase project (URL + anon key)

### Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure Supabase credentials in `lib/main.dart` (or via your preferred config approach).

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point, Supabase init, theme
├── app_bottom_nav.dart          # Bottom navigation shell
├── cart_model.dart              # Cart state model
├── auth/                        # Auth helpers
├── home_screen.dart             # Home / landing
├── login_screen.dart            # Sign in
├── sign_up_screen.dart          # Registration
├── categories_screen.dart       # Category browse
├── search_results_screen.dart   # Search
├── product_details_screen.dart  # Product page
├── prescription_upload_screen.dart
├── cart_screen.dart             # Cart
├── checkout_screen.dart         # Checkout
├── payment_screen.dart          # Payment
├── order_tracking_screen.dart   # Live order tracking
├── orders_screen.dart           # Order history
├── addresses_screen.dart        # Saved addresses
├── notifications_screen.dart    # Notifications
├── chat_screen.dart             # In-app chat
├── help_support_screen.dart     # Help / FAQ
└── profile_screen.dart          # User profile
```

## Resources

- [Flutter docs](https://docs.flutter.dev/)
- [Supabase Flutter docs](https://supabase.com/docs/reference/dart/introduction)