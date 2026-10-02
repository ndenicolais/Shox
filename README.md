# Shox

> A digital shoe wardrobe app for Android, built with Flutter.

**Shox** lets you catalogue your whole shoe collection, with real-time cloud sync, advanced filters, visual statistics, PDF export and JSON backup — all in 5 languages with light and dark themes.

## Preview

<img src="images/shox_preview.png" title="Shox 5.0.0" alt="Shox Preview">

| Collection | Details | Add shoe | Statistics | Dashboard |
|:---:|:---:|:---:|:---:|:---:|
| <img src="images/screenshots/home.png" width="160" alt="Home"> | <img src="images/screenshots/details.png" width="160" alt="Shoe details"> | <img src="images/screenshots/form.png" width="160" alt="Add shoe"> | <img src="images/screenshots/database.png" width="160" alt="Database"> | <img src="images/screenshots/dashboard.png" width="160" alt="Dashboard"> |

---

## Main features

- **Collection** — Add, view, edit and delete your shoes with photo, brand, size, category, type, season and colors
- **Advanced filters** — Filter by category, type, season, primary color, extra color or favorites, and search by brand, type, category or notes
- **Favorites** — Mark your favorite shoes and find them quickly
- **Images** — Pick from camera or gallery with cropping, automatic compression and on-device background removal (Google ML Kit)
- **Statistics** — Interactive pie charts to analyse the collection by color, brand, category and type
- **PDF export** — Generate a full PDF catalogue with cover, user profile and a page for each shoe
- **JSON backup** — Export and import the whole collection as JSON
- **Sharing** — Share a shoe card as a screenshot or save its photo to the gallery
- **Authentication** — Sign in with a Google account or email and password
- **Sync** — Real-time data on Cloud Firestore and images on Firebase Storage
- **Multilingual** — Italian, English, French, Spanish and German
- **Theme** — System / Light / Dark theme with Material 3 design
- **Adaptive layout** — Content that actually reorganizes (not just scales) on phones and tablets, with free screen rotation

---

## Architecture

| Layer | Technology |
|---|---|
| Framework | Flutter 3 / Dart |
| State management | GetX |
| Cloud database | Cloud Firestore |
| Image storage | Firebase Storage |
| Authentication | Firebase Auth + Google Sign In |
| Local persistence | SharedPreferences |
| Responsive UI | flutter_screenutil |
| Fonts | Montserrat (bundled) |
| Icons | MingCute Icons |
| Charts | fl_chart |
| Images | image_picker, image_cropper, flutter_image_compress, google_mlkit_subject_segmentation |
| Export | pdf, share_plus, image_gallery_saver_plus |

---

## Project structure

```
lib/
├── main.dart                  # Entry point
├── common/                    # Shared screens (intro, onboarding, welcome) and global widgets
├── core/                      # GetX routes, constants, services and utilities
├── features/                  # Feature modules
│   ├── auth/                  # Authentication (login, signup, reset password, gender selection)
│   ├── dashboard/             # Dashboard (settings, account, info, privacy, support)
│   ├── database/              # Statistics, PDF export, JSON export/import
│   ├── home/                  # Shoe list with filters and search
│   ├── shoes/                 # Shoe CRUD
│   └── users/                 # User profile
├── l10n/                      # ARB localization files (en, it, fr, es, de)
└── theme/                     # Theme, colors, spacing and theme controller
```

---

## Requirements

- Flutter SDK 3.44 or later (stable channel)
- Dart SDK 3.12 or later (bundled with Flutter)
- Android 7.0+ (API 24+), 64-bit (arm64), with Google Play services
- Internet connection (for authentication and Firestore sync)
- A configured `android/app/google-services.json` file

---

## Installation and launch

```bash
# Clone the repository
git clone https://github.com/ndenicolais/Shox.git
cd Shox

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Download

[📥 Download the latest release v5.0.0](https://github.com/ndenicolais/Shox/releases/download/v5.0.0/Shox_v5.0.0.apk)

---

## Full documentation

For detailed documentation of every feature, data model, screen and technical choice, see [DOCUMENTATION.md](DOCUMENTATION.md).

---

## License

Copyright © 2025–2026 Nicola De Nicolais.
License: **MIT** — see the [LICENSE.md](LICENSE.md) file for details.

**Author:** Nicola De Nicolais — [ndn21dev@gmail.com](mailto:ndn21dev@gmail.com) — [GitHub](https://github.com/ndenicolais)
