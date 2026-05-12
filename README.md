# 👶 BabyShopHub

A premium baby products e-commerce app built with **Flutter** — no Firebase, no backend required.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 🚀 Getting Started

```bash
git clone https://github.com/Ubaid2206/BabyShopHub.git
cd BabyShopHub
flutter pub get
flutter run
```

> No Firebase setup. No `google-services.json`. No configuration needed.

---

## 🔑 Demo Credentials

| Role     | Email                   | Password |
|----------|-------------------------|----------|
| Admin    | admin@babyshophub.com   | admin123 |
| Customer | sara@example.com        | 123456   |

---

## ✨ Features

**Customer**
- Login / Register / Forgot Password (local auth)
- Home with featured products & categories
- Product list with search & filter
- Product detail with images & reviews
- Shopping cart & checkout
- Order history & tracking
- Profile management

**Admin**
- Dashboard with stats
- Product management (add/edit/delete)
- Order status management

---

## 🛠️ Tech Stack

| Package              | Purpose                  |
|----------------------|--------------------------|
| `provider`           | State management         |
| `shared_preferences` | Local auth persistence   |
| `google_fonts`       | Poppins + Inter fonts    |
| `cached_network_image` | Product image loading  |
| `flutter_rating_bar` | Star ratings             |
| `lottie`             | Animations               |
| `intl`               | Date formatting          |
| `uuid`               | Unique ID generation     |

---

## 📂 Project Structure

```
lib/
├── main.dart
├── core/theme/          # App theme & colors
├── data/models/         # User, Product, Cart models
├── providers/           # Auth, Product, Cart, Order, User
└── presentation/screens/
    ├── auth/            # Login, Register, Forgot Password
    ├── main/            # Home, Main Screen
    ├── product/         # List, Detail
    ├── cart/
    ├── checkout/        # Checkout, Order Success
    ├── orders/          # List, Detail
    ├── profile/
    └── admin/           # Dashboard, Products, Orders
```

---

## 🎨 Color Palette

| Color              | Hex       |
|--------------------|-----------|
| Primary (Pink)     | `#FFB6C1` |
| Secondary (Blue)   | `#B4E7FF` |
| Background (Cream) | `#FFFBF7` |
| Success (Green)    | `#B8E6B8` |

---

## 🌐 Web Support

```bash
flutter run -d chrome
flutter build web --release
```

---

## 📋 Requirements

- Flutter SDK `>=3.2.0`
- Dart SDK `>=3.2.0`

---

## 📄 License

MIT © 2026 BabyShopHub
