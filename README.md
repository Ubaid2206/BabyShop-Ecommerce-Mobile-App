# 👶 BabyShopHub - Flutter E-Commerce App

A premium baby products e-commerce app built with **Flutter only** — no Firebase, no backend required!

---

## 🚀 Quick Start

```bash
git clone <repo>
cd baby_shop_hub
flutter pub get
flutter run
```

**Bus itna! Koi Firebase setup, koi google-services.json, koi configuration nahi.**

---

## 🔑 Demo Login Credentials

| Role     | Email                       | Password  |
|----------|-----------------------------|-----------|
| Admin    | admin@babyshophub.com       | admin123  |
| Customer | sara@example.com            | 123456    |
| New User | Register karo — works instantly! | —    |

---

## 📱 Features

### Customer
- 🔐 Login / Register / Forgot Password (local)
- 🏠 Home with Featured Products & Categories
- 🛍️ Product List with Search & Filter
- 📦 Product Detail with Image & Reviews
- 🛒 Shopping Cart
- 💳 Checkout with Address & Payment
- 📋 Order History & Tracking
- 👤 Profile Management

### Admin
- 📊 Dashboard with Stats
- 📦 Product Management
- 🚚 Order Status Management

---

## 🛠️ Tech Stack

| Technology         | Usage                        |
|--------------------|------------------------------|
| Flutter            | UI Framework                 |
| Provider           | State Management             |
| SharedPreferences  | Local auth persistence       |
| Google Fonts       | Typography (Poppins + Inter) |
| CachedNetworkImage | Product image loading        |
| flutter_rating_bar | Star ratings                 |
| intl               | Date formatting              |

**No Firebase. No backend. No configuration needed.**

---

## 📂 Project Structure

```
lib/
├── main.dart
├── core/theme/app_theme.dart
├── data/models/
│   ├── user_model.dart
│   ├── product_model.dart
│   └── cart_model.dart
├── providers/
│   ├── auth_provider.dart      ← Local auth (SharedPreferences)
│   ├── product_provider.dart   ← 15 dummy products (local)
│   ├── order_provider.dart     ← In-memory orders
│   ├── cart_provider.dart
│   └── user_provider.dart
└── presentation/screens/
    ├── splash_screen.dart
    ├── auth/       (login, register, forgot_password)
    ├── main/       (home, main_screen)
    ├── product/    (list, detail)
    ├── cart/
    ├── checkout/   (checkout, order_success)
    ├── orders/     (list, detail)
    ├── profile/
    └── admin/
```

---

## 🎨 Color Palette

| Color            | Hex       |
|------------------|-----------|
| Primary (Pink)   | #FFB6C1   |
| Secondary (Blue) | #B4E7FF   |
| Background       | #FFFBF7   |
| Success (Green)  | #B8E6B8   |

---

## 🌐 Web Support

```bash
flutter run -d chrome
flutter build web --release
```

---

© 2026 BabyShopHub 👶
