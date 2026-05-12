# 🚀 BabyShopHub Setup Guide (No Firebase!)

## Step 1: Flutter Install

```bash
flutter doctor  # check karo sab theek hai
```

## Step 2: Run Karo

```bash
cd BabyShopHub
flutter pub get
flutter run
```

**Bas! Koi Firebase setup nahi, koi google-services.json nahi.**

---

## Platforms

| Platform        | Command                    |
|-----------------|----------------------------|
| Android         | `flutter run -d android`   |
| iOS             | `flutter run -d ios`       |
| Chrome (Web)    | `flutter run -d chrome`    |

---

## Demo Accounts

| Role     | Email                 | Password |
|----------|-----------------------|----------|
| Admin    | admin@babyshophub.com | admin123 |
| Customer | sara@example.com      | 123456   |

Ya koi bhi naya account register kar sakte hain.

---

## Web Production Build

```bash
flutter build web --release
# Files: build/web/
```

---

## Android APK Build

```bash
flutter build apk --release
# File: build/app/outputs/flutter-apk/app-release.apk
```
