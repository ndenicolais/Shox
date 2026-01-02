<div align="center">
  <img src="images/shox_logo.png" title="Shox's logo" width="140" height="140" alt="Shox Logo">
  <h1>Shox</h1>
  <p><strong>Your personal shoes collection organized digitally</strong></p>

  ![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)
  ![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue?logo=dart)
  ![License](https://img.shields.io/badge/License-MIT-green)
  ![Version](https://img.shields.io/badge/Version-4.0.0-brightgreen)

</div>

---

## 📋 Table of Contents
- [Description](#-description)
- [Features](#-features)
- [Architecture](#-architecture)
- [Screenshots](#-screenshots)
- [Packages](#-packages)
- [Download](#-download)
- [Authors](#-authors)

---

## 📄 Description
This app allows you to create a personalized digital box for your shoes. Here, you can easily save, organize, and view all your shoes in one virtual place. Each pair of shoes can be cataloged with specific details such as brand, model, color, and occasion of use, making it easier to find exactly what you are looking for at any time.

With your digital wardrobe, you will always have a complete view of your shoe collection at your fingertips, making it easier to choose the perfect pair for every occasion.

---

## 🔑 Features

### 🔐 Authentication
- Login via Google Account
- Login via Email & Password

### 💾 Data Management
- **CRUD Operations**: Create, read, update, and delete shoes
- **Firestore Database**: Cloud-based data storage
- **Supabase Storage**: Cloud-based image storage
- **Database Export/Import**: Export and import your entire collection as JSON
- **Cloud Sync**: Real-time synchronization with Firestore
- **Backup & Restore**: Easy data backup functionality

### 🖼️ Storage & Media
- Photo upload and cropping
- Share shoe card as screenshot
- Remove background from images
- Share and download the shoes photos
- Generate PDF reports of your collection

### 🎨 User Interface
- Responsive design for all screen sizes
- Light and dark theme variants
- Smooth navigation with transition effects
- Multiple display layouts for shoes

### 🌍 Localization
- English, Italian, French, Spanish, and German
- Multi-language support throughout the app

### 📊 Organization & Analytics
- Custom categories and types based on gender selection
- Filter shoes by various characteristics
- Divide shoes by: brands, colors, categories, types
- View favorite shoes
- Complete operation history
- Statistical graphs showing collection breakdown
- Data visualization charts

---

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart              # App entry point
├── common/                # Shared utilities and constants
├── core/                  # Core business logic
├── features/              # Feature modules
├── screens/               # Screen widgets
├── theme/                 # Theme configuration
└── l10n/                  # Localization files
```
---

## 🎨 Screenshots
<img src="images/shox_release.png" title="Shox's release" alt="Shox Screenshots">

---

## 📌 Packages

Below is a list of the most relevant packages used in this project:

| Package | Purpose |
|---------|---------|
| [get](https://pub.dev/packages/get) | Navigation and routing |
| [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) | Responsive UI scaling |
| [google_fonts](https://pub.dev/packages/google_fonts) | Custom fonts |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore) | Database management |
| [supabase_flutter](https://pub.dev/packages/supabase_flutter) | Image storage |
| [intl](https://pub.dev/packages/intl) | Localization & internationalization |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Local storage |
| [fl_chart](https://pub.dev/packages/fl_chart) | Librart with charts & analytics |
| [image_background_remover](https://pub.dev/packages/image_background_remover) | Image background remover with ONNX model |
| [screenshot](https://pub.dev/packages/screenshot) | Utility to capture widget as image |

For a complete list of dependencies, see [pubspec.yaml](pubspec.yaml).

---

## 💎 Download

<img src="images/shox_version.png" title="Shox's version" alt="Shox Version">

[📥 Download the last release v4.0.0](https://github.com/ndenicolais/Shox/releases/download/v4.0.0/Shox_v4.0.0.apk)

---

## 🔶 Authors
- [@ndn21](https://github.com/ndenicolais)

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

<div align="center">
  Made with ❤️ by <a href="https://github.com/ndenicolais">ndenicolais</a>
</div>
