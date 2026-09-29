# Shox — Full documentation

> Copyright © 2026 Nicola De Nicolais — All rights reserved.

---

## Table of contents

1. [App overview](#1-app-overview)
2. [Architecture and tech stack](#2-architecture-and-tech-stack)
3. [Project structure](#3-project-structure)
4. [Data models](#4-data-models)
5. [Screens and features](#5-screens-and-features)
   - [Intro, Onboarding and Welcome](#51-intro-onboarding-and-welcome)
   - [Auth — Authentication](#52-auth--authentication)
   - [Home — Shoe collection](#53-home--shoe-collection)
   - [Shoe details](#54-shoe-details)
   - [Add shoe](#55-add-shoe)
   - [Edit shoe](#56-edit-shoe)
   - [Dashboard](#57-dashboard)
   - [Database — Statistics](#58-database--statistics)
   - [User profile](#59-user-profile)
   - [Edit profile](#510-edit-profile)
   - [Account deletion](#511-account-deletion)
6. [Controllers (State Management)](#6-controllers-state-management)
7. [Services](#7-services)
   - [ImageService](#71-imageservice)
   - [ShoesFilter](#72-shoesfilter)
   - [ShoesCategoriesMixin](#73-shoescategoriesmixin)
   - [ShoesFormData and ShoesFormService](#74-shoesformdata-and-shoesformservice)
   - [PdfService](#75-pdfservice)
   - [JSON export and import](#76-json-export-and-import)
8. [Theme and style](#8-theme-and-style)
9. [Navigation](#9-navigation)
10. [Localization](#10-localization)
11. [Dependencies](#11-dependencies)
12. [System requirements](#12-system-requirements)
13. [Build and distribution](#13-build-and-distribution)

---

## 1. App overview

**Shox** is a digital shoe wardrobe app, built with Flutter for Android. It lets the user:

- Catalogue the whole shoe collection with photo, brand, size, category, type, season and colors
- Filter and search shoes by any attribute (category, type, season, color, favorites)
- View collection statistics through interactive pie charts
- Export the full collection to PDF or back it up / restore it as JSON
- Share shoe cards as screenshots
- Save shoe photos to the device gallery
- Remove image backgrounds on the device (Google ML Kit Subject Segmentation)
- Sign in with a Google account or email and password, with real-time cloud sync

The app is fully localized in 5 languages (Italian, English, French, Spanish, German) with light and dark themes.

---

## 2. Architecture and tech stack

| Component | Technology / Library |
|---|---|
| Framework | Flutter 3 / Dart `^3.5.2` |
| State management | [get](https://pub.dev/packages/get) `^4.6.6` (GetX) |
| Backend — Database | [cloud_firestore](https://pub.dev/packages/cloud_firestore) `^5.5.0` |
| Backend — Auth | [firebase_auth](https://pub.dev/packages/firebase_auth) `^5.3.4` |
| Backend — Storage | [firebase_storage](https://pub.dev/packages/firebase_storage) `^12.3.7` |
| Google authentication | [google_sign_in](https://pub.dev/packages/google_sign_in) `^6.1.5` |
| Local persistence | [shared_preferences](https://pub.dev/packages/shared_preferences) `^2.3.4` |
| Responsive UI | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) `^5.9.3` |
| UI icons | [ming_cute_icons](https://pub.dev/packages/ming_cute_icons) `^0.0.7` |
| Charts | [fl_chart](https://pub.dev/packages/fl_chart) `^0.69.0` |
| Internationalization | [intl](https://pub.dev/packages/intl) `^0.20.2` |
| Unique IDs | [uuid](https://pub.dev/packages/uuid) `^4.5.1` |
| Images — picking | [image_picker](https://pub.dev/packages/image_picker) `^1.1.2` |
| Images — cropping | [image_cropper](https://pub.dev/packages/image_cropper) `^11.0.0` |
| Images — compression | [flutter_image_compress](https://pub.dev/packages/flutter_image_compress) `^2.4.0` |
| Images — processing | [image](https://pub.dev/packages/image) `^4.2.0` |
| Images — background removal | [google_mlkit_subject_segmentation](https://pub.dev/packages/google_mlkit_subject_segmentation) `^0.2.1` (on-device, model downloaded by Google Play services) |
| Images — cache | [cached_network_image](https://pub.dev/packages/cached_network_image) `^3.4.1` |
| Images — viewer | [photo_view](https://pub.dev/packages/photo_view) `^0.15.0` |
| Images — save to gallery | [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) `^4.0.1` |
| Widget screenshots | [screenshot](https://pub.dev/packages/screenshot) `^3.0.0` |
| PDF export | [pdf](https://pub.dev/packages/pdf) `^3.11.0` |
| File picker | [file_picker](https://pub.dev/packages/file_picker) `^9.0.2` |
| Sharing | [share_plus](https://pub.dev/packages/share_plus) `^10.1.3` |
| Permissions | [permission_handler](https://pub.dev/packages/permission_handler) `^11.3.1` |
| Device info | [device_info_plus](https://pub.dev/packages/device_info_plus) `^11.2.0` |
| App info | [package_info_plus](https://pub.dev/packages/package_info_plus) `^9.0.0` |
| Filesystem paths | [path_provider](https://pub.dev/packages/path_provider) `^2.1.4` |
| Links | [url_launcher](https://pub.dev/packages/url_launcher) `^6.3.0` |
| HTTP | [http](https://pub.dev/packages/http) `^1.3.0` |
| Logging | [logger](https://pub.dev/packages/logger) `^2.5.0` |

**Architectural pattern:** MVC with GetX. Controllers act as ViewModels; models are plain Dart objects; repositories handle data access; screens are `GetView`, `StatefulWidget` or `StatelessWidget` classes that talk to the controllers through GetX.

---

## 3. Project structure

```
shox/
├── android/                        # Native Android configuration
├── assets/
│   ├── fonts/                      # Montserrat (regular + bold) + ShoxIcons
│   └── images/                     # App logo, launcher icon sources and other static images
├── images/                         # README preview images
├── lib/
│   ├── main.dart                   # Entry point: initializes Firebase (with error screen and retry), theme, locale
│   ├── common/
│   │   ├── screens/                # Shared screens (intro, onboarding, welcome)
│   │   └── widgets/                # Global reusable widgets
│   ├── core/
│   │   ├── constants/              # App constants and changelog entries
│   │   ├── routes/                 # GetX routes (AppRoutes, AppPages, AuthMiddleware); default `rightToLeftWithFade` transition (300ms) set on GetMaterialApp
│   │   ├── services/               # App-wide services (changelog)
│   │   └── utils/                  # Utilities, helpers, bg_remover, mask_refinement
│   ├── features/
│   │   ├── auth/                   # Authentication (login, signup, reset password, gender selection)
│   │   ├── dashboard/              # Dashboard (settings, info, privacy, support)
│   │   ├── database/               # Statistics, PDF export, JSON export/import
│   │   ├── home/                   # Main screen with shoe list and filters
│   │   ├── shoes/                  # Shoe CRUD (models, controller, repository, screens)
│   │   └── users/                  # User profile management
│   ├── l10n/                       # ARB localization files (en, it, fr, es, de)
│   └── theme/                      # Theme, colors, spacing, breakpoints, theme controller
├── test/                           # Unit and widget tests
├── tool/preview/                   # README preview generator
├── PRIVACY.md
├── pubspec.yaml
├── README.md
└── DOCUMENTATION.md
```

Each feature follows this internal structure:
```
feature/
├── bindings/         # GetX Binding for dependency injection
├── controller/       # GetX controllers (business logic)
├── models/           # Data models
├── repository/       # Data access (Firestore, Firebase Storage)
├── screens/          # UI screens
├── services/         # Specialized services (image, pdf, etc.)
└── widgets/          # Feature-specific widgets
```

**Widget naming convention:** every file is named after its class in snake_case. Generic widgets in `lib/common/widgets/` use the `Widget` suffix (`ButtonWidget`, `ToastWidget`, `ChangelogDialogWidget`…), which avoids clashes with Flutter classes (`AppBar`, `Dialog`…). Feature widgets have descriptive names without a suffix (`LoginForm`, `FilterBar`, `FilterSheet`, `TopBar`, `DashboardMenuItem`, `ShoesPieChart`, `ColorChip`…), avoiding names already used by Flutter.

**Widgets extracted from the largest screens:** `ShoePhotoArea`, `BackgroundRemovalDialog` and `showImageSourceSheet` (`shoes/widgets/form/shoe_photo_picker.dart`); `showFilterSheet`/`FilterSelection` (the filter sheet owns its temporary selection and returns the result), `ShoesGridLayout`, `ShoesGridSkeleton`, `ShoesCountRow` (`home/widgets/shoes_grid.dart`); database charts in `database/widgets/database_charts.dart` and the shared progress overlay `ProgressOverlayWidget`; account deletion sections and backup dialogs in `users/widgets/delete_account_info.dart`; `ExportResult`/`ImportResult` in `database/models/database_results.dart`; "what's new" dialog logic in `core/services/changelog_service.dart`.

**`GetView<T>`:** screens without state of their own extend `GetView` and read the binding's controller through `controller`: login, signup and reset password (the `GlobalKey<FormState>` lives in the controller) and gender selection (`GenderSelectionController.selectedGender` is an `RxnString`). The others stay `StatefulWidget` because they have real local state (streams, animations, shoe form data, loaded statistics, app version). Since the form keys live in the controllers, login and signup link to each other with `Get.offNamed`: the two screens never stack (two forms with the same `GlobalKey` would throw).

---

## 4. Data models

All persistent data is stored in **Cloud Firestore**. Images are stored in **Firebase Storage**.

### ShoesModel

A pair of shoes in the digital wardrobe.

| Field | Type | Description |
|---|---|---|
| `id` | `String?` | Firestore document ID (UUID) |
| `imageUrl` | `String` | Image URL on Firebase Storage |
| `colorPrimary` | `Color` | Main color of the shoe |
| `colorExtra` | `List<int>?` | Extra colors (ARGB32 values) |
| `brand` | `String` | Brand |
| `size` | `String` | Size |
| `category` | `String` | Category (e.g. Sneakers, Boots, Heeled…) |
| `type` | `String` | Specific type within the category (e.g. Sport, Casual…) |
| `season` | `String?` | Season: `All` / `Spring` / `Summer` / `Autumn` / `Winter` |
| `notes` | `String?` | Optional notes |
| `isFavorite` | `bool` | Marked as favorite |
| `dateAdded` | `DateTime` | Date added |
| `dateUpdated` | `DateTime` | Date of the last change |

**Categories for male users:** Sneakers, Elegant, Sandals, Loafers, Other  
**Categories for female users:** Sneakers, Elegant, Heeled, Sandals, Boots, Mules, Flats, Other  
**Default categories (everyone):** Sneakers, Elegant, Heeled, Sandals, Boots, Mules, Other

**Colors:** the palette is `colorList` in `lib/core/utils/utils.dart`; `DbLocalizedValues.getColorName` maps each hex value to its localized name. Red is `#CF2B19`; the legacy value `#FF2810`, which older shoes may still store, is also recognized as red.

---

### UserModel

The profile of the signed-in user.

| Field | Type | Description |
|---|---|---|
| `userEmail` | `String` | User email |
| `userName` | `String` | Full name |
| `userImage` | `String?` | Profile image URL (Firebase Storage) |
| `gender` | `String?` | Gender: `male` / `female` / `other` |
| `userDate` | `DateTime` | Registration date |

---

## 5. Screens and features

### 5.1 Intro, Onboarding and Welcome

**Path:** `lib/common/screens/`

The app's entry flow.

**Features:**
- **IntroScreen:** splash/loading screen (logo, name, tagline); checks whether the user is already signed in and redirects to the right screen (`home` if signed in, otherwise `onboarding` or `welcome`)
- **OnboardingScreen:** introductory pages presenting the main features (shown only on first launch); illustrations in cards, pill indicators and a Skip button that marks onboarding as completed
- **WelcomeScreen:** welcome screen with full-width Sign in / Sign up buttons
- **StartupErrorScreen:** shown instead of the app if `Firebase.initializeApp` fails at startup; the "Retry" button runs the initialization again (`_bootstrap()` in `main.dart`). A failure reading `SharedPreferences` does not block startup: the device language is used

---

### 5.2 Auth — Authentication

**Path:** `lib/features/auth/`

Full authentication flow through Firebase Auth.

**Features:**
- **LoginScreen:** sign-in with a Google account (OAuth2) or email and password. Error handling (invalid email, wrong password, user not found)
- **SignupScreen:** registration with email, password and name. Creates the user document on Firestore
- **ResetPasswordScreen:** sends a password reset email through Firebase Auth
- **GenderSelectionScreen:** gender selection (`male` / `female` / `other`) on first sign-in; it determines the shoe categories shown in the app. Saved in the user document on Firestore
- The Google button is a full-width `GoogleSignInSection`; `AuthSwitchPrompt` links login and signup

**Shared service:** `lib/features/auth/services/auth_service.dart` (`AuthService`) centralizes the logic shared by the login, signup, reset password and user repositories:
- `findUserByEmail(email)` — looks up the user document on Firestore by `userEmail`
- `saveSession(userId)` / `clearSession()` — saves and removes the local session (`remember_me`, `user_id` in `SharedPreferences`)

**Session protection:**
- `AuthGuardService` (`lib/features/auth/services/auth_guard_service.dart`, a permanent `GetxService` registered in `main.dart`) listens to `authStateChanges()`: if the session drops unexpectedly on a protected route, it clears the local session and redirects to `/welcome` with a toast. Logout and account deletion call `expectSignOut()` first so they are not mistaken for an expired session
- `AuthMiddleware` (`lib/core/routes/auth_middleware.dart`) is applied to every route that needs a user (home, shoes, dashboard, database, user, gender selection) and redirects to `/welcome` if `currentUser` is null
- With "remember me" on, `IntroScreen` waits for the first `authStateChanges()` event before opening the home screen: if the Firebase user is gone, it clears the session and goes to `/welcome`

---

### 5.3 Home — Shoe collection

**Path:** `lib/features/home/`

The main screen, showing the user's whole shoe collection.

**Features:**
- **Real-time stream** from Firestore: the list updates automatically on every change
- **Configurable, adaptive grid:** 1, 2 or 3 columns selectable with a quick toggle; the column count grows automatically with the actual screen width (tablet/landscape). Cells are square (explicit `childAspectRatio`), the image always fills the cell and is decoded at the cell's actual width (`memCacheWidth`/`cacheWidth`), not at the original resolution. On tablets the content is centered with `ResponsiveCenterWidget` and a maximum width of `AppBreakpoints.maxGridWidth` (1080), so 4 columns remain reachable
- **Text search** on brand, type, category (including the translated name) and notes, with a 300ms debounce: the grid refilters only when typing stops
- **Pull-to-refresh:** dragging the grid down (`RefreshIndicator`) resubscribes to the Firestore stream
- **Loading and transitions:** while loading, a grid skeleton is shown (pulsing `SkeletonWidget`, `lib/common/widgets/skeleton_widget.dart`) with the same column count as the real grid; loading photos also use `SkeletonWidget` as placeholder. Switching between loading, error, empty collection, no results and grid uses an `AnimatedSwitcher` (250ms); the grid also fades when columns or filters change (key `_gridViewKey`), but not on normal stream updates. The filter/grid/favorite icons in the bar change with a `ScaleTransition`
- **Available filters:**
  - Category (depends on the user's gender)
  - Type (depends on the selected category)
  - Season
  - Primary color
  - Extra color
- **Header and quick filters (redesign A):** `TopBar` with avatar, greeting and the "Your collection" title; `FilterBar` with a pill search field and a filled filter button (a `Badge` dot when a filter is active); `CategoryChips` with All / Favorites / one chip per category (translated) that set `selectedCategory` and `showOnlyFavorites` directly; an "N pairs · M favorites" row (ICU plurals) with the grid toggle. Cards (`ShoeCard`) show a square photo with a heart on a translucent background, brand and "Size 42 · type"; the cell height is photo + caption scaled with the system text size (`ShoeCard.captionHeight`)
- **Filter indicator:** the dot on the filter button is driven by `ShoesFilter.isActive`, derived from the filters' actual content (color, extra color, category, type, season, favorites); text search is excluded because it has its own clear button
- **Filter reset:** `_resetFilters()` clears all filters, the search and the favorites toggle; it is shared by the search bar's clear button and the "no results" action
- **Empty state:** an informative message when the collection is empty
- **"No results" state:** if filters or search leave no results, `EmptyStateWidget` shows a dedicated message and a "Clear filters" action
- **Extended "Add" FAB:** opens the add shoe screen (style from `floatingActionButtonTheme`: peach, pill shape); the grid has 96 bottom padding so the last row is never covered
- **Accessibility:** every icon-only button exposes a localized `tooltip` (`a11y_*` keys); the favorites and filter toggles use a label reflecting the current state. In the top bar the avatar is an `InkWell` with `Semantics(button: true)` and the settings icon an `IconButton`, guaranteeing ripple and a 48dp minimum touch target

---

### 5.4 Shoe details

**Path:** `lib/features/shoes/screens/shoes_details_screen.dart`

Full view of every detail of a single shoe.

**Features:**
- Full-size image with **zoom and pan** support (`photo_view`)
- Top bar with back and favorite buttons; photo with `AppRadius.hero`; `InfoTileWidget` tiles for size, season and date added; colors and notes cards
- Details: brand, size, category, type, season, colors, notes, dates added and updated
- **Favorite toggle** updated in real time on Firestore
- **Share card:** captures the screen as a screenshot and shares it through `share_plus`
- **Save photo:** downloads the original image to the device gallery (`image_gallery_saver_plus`)
- **Edit / Share / Delete** actions at the bottom of the screen; deletion asks for confirmation and removes the shoe from Firestore and its image from Firebase Storage
- Streaming updates: if the data changes from another device, the screen updates automatically

---

### 5.5 Add shoe

**Path:** `lib/features/shoes/screens/shoes_form_screen.dart` (ADD mode when `shoes == null`)

Form to add a new shoe to the collection, organized in sections (Photo, Colors, Details, Notes) with their own headers; every field is wrapped in a `Card` by the shared `FormFieldCard` widget (`lib/features/shoes/widgets/form/form_field_card.dart`), which unifies icon, label and content style across the form. Options use `OptionCircle`/`ColorDot`; the Save button sits at the bottom.

**Features:**
- **Image picking:** from camera or gallery (`image_picker`)
- **Image cropping:** built-in crop editor with aspect ratio presets (`image_cropper`)
- **Automatic compression:** the image is compressed before upload (`flutter_image_compress`, 70% quality)
- **Background removal:** option to remove the background on the device with Google ML Kit Subject Segmentation. Pipeline in `core/utils/bg_remover.dart`: EXIF orientation applied and resize to max 1024px, ML Kit confidence mask at the same resolution, confidence → alpha conversion with a 0.35–0.65 ramp (`MaskRefinement.alphaFromConfidence`), 1px erosion (`MaskRefinement.erode`) and edge color decontamination (`MaskRefinement.decontaminateEdges`, no halo). If the model has not been downloaded yet, `BackgroundModelDownloadingException` is thrown and the form shows a dedicated message. The functions in `core/utils/mask_refinement.dart` are pure and covered by tests
- **Primary color:** picker for the shoe's main color
- **Extra colors:** extra colors can be added
- **Required fields:** photo, primary color, brand, size, category, type
- **Optional fields:** season, notes
- **Saving:** the shoe is saved to Firestore, the image is uploaded to Firebase Storage and its URL is stored in the document
- **Unsaved changes:** `PopScope` intercepts the back action (system and app bar); if the fields differ from the initial state, `DeleteDialogWidget` asks for confirmation (custom "Stay" / "Leave" labels)

---

### 5.6 Edit shoe

**Path:** `lib/features/shoes/screens/shoes_form_screen.dart` (EDIT mode when an existing `ShoesModel` is passed)

The same sectioned screen as add mode, prefilled with the existing shoe's data.

**Features:**
- Every field of the add screen can be edited
- **Image replacement:** a new image goes through the same crop/compression/background removal flow; the old image is deleted from Firebase Storage
- The favorite flag and date added are preserved; `dateUpdated` is set automatically on save

---

### 5.7 Dashboard

**Path:** `lib/features/dashboard/`

Settings screen and entry point to the account features. Sections are cards of `DashboardMenuItem` rows.

**Sections:**

| Section | Entry | Feature |
|---|---|---|
| **Preferences** | Theme | 3-way System / Light / Dark selector (`SegmentedButton`) |
| **Preferences** | Language | Flag selector for the app language (5 languages) |
| **Account** | Profile | View and edit the user profile |
| **Account** | Database | Statistics and data management |
| **Account** | Logout | Sign out of the app |
| **App** | Info | App information, links and privacy policy |
| **App** | Help Desk | Support: contact email, documentation link and FAQ |
| **App** | Changelog | Opens the dialog with the history of changes per version |
| **App** | Share | Shares the GitHub project link |
| **App** | Version | Current app version |

**Changelog dialog:** entries are defined in `lib/core/constants/changelog.dart` (`ChangelogEntry`, one per version, with localized bullets) and shown by `lib/common/widgets/changelog_dialog.dart`. Besides being opened manually from the Dashboard, the dialog appears automatically once after an update: `HomeScreen` compares the current version (`package_info_plus`) with the last one seen, stored in `SharedPreferences` (`AppConstants.prefsLastSeenChangelogVersion`), and shows only the unseen entries. On a fresh install the current version is just recorded, without showing the dialog.

**Info and privacy:** `InfoScreen` shows logo, name, subtitle and version (`PackageInfo`), "What is Shox", four main features in cards, useful links (source code, website, email, privacy, `showLicensePage` for open source licenses) and credits (`AppConstants.developerName`). `PrivacyPolicyScreen` is native: 10 `policy_section_*` sections localized in the 5 languages, update date `AppConstants.privacyPolicyUpdatedAt`, and a link to the public `PRIVACY.md` on GitHub (`AppConstants.uriPrivacyPolicy`, also to be set in the Play Store). The text of `PRIVACY.md` (Italian and English) must be kept in line with the ARB keys. The privacy policy is reachable only from Info.

---

### 5.8 Database — Statistics

**Path:** `lib/features/database/`

Statistical analysis of the collection and data management.

**Features:**
- Summary tiles: total shoes, brands and categories
- **Interactive pie charts** (`fl_chart`) in cards for:
  - Distribution by primary **color**
  - Distribution by **brand**
  - Distribution by **category**
  - Distribution by **type**
- **PDF export:** generates a full PDF document with cover, user profile page and a page per shoe with image and details; saved in the Downloads folder
- **JSON export:** exports the whole collection as a JSON file
- **JSON import:** imports a collection from a previous JSON backup with a progress bar

---

### 5.9 User profile

**Path:** `lib/features/users/screens/user_screen.dart`

The personal profile with collection statistics.

**Features:**
- Header with user avatar (profile image or name initial), name and email
- **Collection statistics** in a grid of `InfoTileWidget`:
  - Total number of shoes
  - Number of favorites
  - Most common brand
  - Most used category
  - Most used type
  - Most common color
  - Date of the last shoe added
- Quick navigation buttons: edit profile, database
- "Delete account" button (highlighted in red) leading to the deletion flow

---

### 5.10 Edit profile

**Path:** `lib/features/users/screens/user_update_screen.dart`

Form to update the user profile.

**Features:**
- Edit name
- Edit email (email/password users only)
- Edit password (email/password users only)
- Update the profile image with the same pick/crop/compress flow used for shoes

---

### 5.11 Account deletion

**Path:** `lib/features/users/screens/user_delete_screen.dart`

Permanent account deletion flow.

**Features:**
- Confirmation dialog, with the option to back up the collection first
- Deletion of all the user's Firestore documents (shoes + profile)
- Deletion of all images from Firebase Storage
- Deletion of the Firebase Auth account
- Redirect to the welcome screen

---

## 6. Controllers (State Management)

The app uses **GetX** for state management and dependency injection. Every controller is registered through a Binding.

| Controller | Path | Responsibility |
|---|---|---|
| `ShoesController` | `features/shoes/controller/` | Shoe CRUD, streams for the list and a single shoe, favorite toggle |
| `UserController` | `features/users/controller/` | User profile (name, email, image), Google sign-in, logout, account deletion |
| `DatabaseController` | `features/database/controller/` | Aggregate statistics (counts by color/brand/category/type), user data, export/import |
| `ThemeController` | `theme/` | Light/dark/system theme, persisted in `SharedPreferences` |
| `LoginController` | `features/auth/login/controller/` | Login logic (Google + email/password), validation, form key |
| `SignupController` | `features/auth/signup/controller/` | Signup logic, profile creation, form key |
| `ResetPasswordController` | `features/auth/reset_password/controller/` | Sends the password reset email, form key |
| `GenderSelectionController` | `features/auth/gender_selection/controller/` | Selected gender (`RxnString`) and saving it |

---

## 7. Services

### 7.1 ImageService

**Path:** `lib/features/shoes/services/image_service.dart`

Handles every image operation before upload.

- **`pickImage(source)`:** opens the image picker (camera or gallery) and automatically starts cropping and compression
- **`cropImage(imageFile)`:** opens the `ImageCropper` editor with aspect ratio presets (original, square, 3:2, 4:3, 16:9)
- **`compressImage(imageFile)`:** compresses the image to 70% quality with `FlutterImageCompress`; supports JPEG and PNG

---

### 7.2 ShoesFilter

**Path:** `lib/features/shoes/models/shoes_filter.dart`

Immutable value object describing the filters applied to the shoe list. Pure logic: no `BuildContext`, no Firestore access, no side effects on the source list.

- **`apply(List<ShoesModel>)`:** returns a **new** list, newest first, with only the shoes matching every filter (search on brand/type/category/notes, favorites, primary color, extra color, category, type, season)
- **`isActive`:** true when at least one filter actually narrows the list; text search is excluded because it has its own clear button
- The `ShoesFilter.all` constant (`'All'`) is the sentinel used by the pickers for "no filter on this field"

Covered by unit tests in `test/features/shoes/models/shoes_filter_test.dart`.

---

### 7.3 ShoesCategoriesMixin

**Path:** `lib/features/shoes/widgets/shoes_categories_mixin.dart`

A mixin on `State` holding the state shared by the screens that show categories/types/seasons, whose options depend both on the user's gender and on the active language. Used by `HomeScreen` and `ShoesFormScreen`, where the same logic used to be duplicated.

- **`loadUserGender(uid)`:** call it in `initState`; loads the gender and narrows the available categories
- **`refreshTranslations()`:** call it in `didChangeDependencies`; rereads the language and rebuilds the translated option lists
- The pure part lives in `ShoesTextTranslations.categoryOptionsFor(...)`, covered by tests in `test/core/utils/shoes_text_translations_test.dart`

---

### 7.4 ShoesFormData and ShoesFormService

**Paths:** `lib/features/shoes/models/shoes_form_data.dart`, `lib/features/shoes/services/shoes_form_service.dart`

Saving the add/edit shoe form, outside the UI.

- **`ShoesFormData`** (immutable value object, pure logic): a snapshot of the form fields.
  - `validate()` returns the first blocking error (`ShoesFormError.missingImage` / `missingColor`) or `null`: a photo is required both when adding and when editing (if the saved one is removed, a new one is needed)
  - `toShoesModel(imageUrl:, existing:)` builds the `ShoesModel` normalizing the fields (trimmed brand, empty season → `All`, empty notes → `null`) and, when editing, keeps id, favorite flag and date added
  - Covered by tests in `test/features/shoes/models/shoes_form_data_test.dart`
- **`ShoesFormService.save(data, existing:)`**: prepares the background-free image if any (temporary PNG file) and delegates to `ShoesController.addShoes` or `updateShoes`; when editing, it deletes the previous photo from Storage only if the user removed it
- `ShoesFormScreen._saveForm()` only orchestrates: field validators, `ShoesFormData.validate()` → toast, save, navigation

---

### 7.5 PdfService

**Path:** `lib/features/database/services/pdf_service.dart`

Generates a PDF document of the whole shoe collection.

**PDF structure:**
- **Cover page:** app logo, title, generation date
- **User profile page:** name, email, registration date, total number of shoes
- **One page per shoe:** image, brand, size, category, type, season, colors, notes, dates

**Details:**
- The Montserrat font is loaded from the bundled asset files for consistent rendering
- Shoe images are downloaded from their Firebase Storage URL during generation
- Progress callback (`onProgress`) for the progress bar in the UI
- Saved in the `Downloads` folder with a timestamped name (`shox_YYYY-MM-DD_HH-mm-ss.pdf`)
- Requires the `MANAGE_EXTERNAL_STORAGE` permission on Android

---

### 7.6 JSON export and import

**Path:** `lib/features/database/controller/database_controller.dart` + `lib/features/database/repository/`

Collection backup and restore.

**JSON export:**
- Fetches all the user's shoes from Firestore
- Serializes each `ShoesModel` with `toFirestore()` as JSON
- Saves the file through `file_picker` at the path chosen by the user
- Progress callback for the progress bar

**JSON import:**
- Opens `file_picker` to select a previously exported JSON file
- Parses the JSON and rebuilds the `ShoesModel` objects with `fromJson()`
- Inserts the imported shoes into Firestore (duplicates are handled)
- Progress callback for the progress bar

---

## 8. Theme and style

**Path:** `lib/theme/`

**Font:** Montserrat (regular 400 + bold 700), bundled as a local asset and registered in `pubspec.yaml` as a single `Montserrat` family with both weights, used by the theme (`ThemeData.fontFamily` and `TextTheme`); bold text uses `FontWeight.w700`. No `google_fonts` dependency or runtime download. The PDF export loads the font files by path.

**Custom icon font:** `ShoxIcons.ttf` — a custom vector font bundled in assets.

**App icon:** generated with [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) from the `assets/images/app_logo.png` logo (a shoe on a box). There are two derived variants:
- `assets/images/app_icon_legacy.png` — flat icon (Android < 8.0), logo at 86% of the canvas
- `assets/images/app_icon_foreground.png` — foreground for the adaptive icon (Android 8.0+), logo at 62% of the canvas to respect the system mask's safe zone

Configuration in `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  min_sdk_android: 21
  image_path: "assets/images/app_icon_legacy.png"
  adaptive_icon_background: "#F6EFE5"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
```
Regenerate after changing the logo: `dart run flutter_launcher_icons`.

**Supported themes:**
- **Light** (`AppTheme.lightTheme()`)
- **Dark** (`AppTheme.darkTheme()`)

The active theme is managed by `ThemeController` (GetX), selectable between System / Light / Dark (`ThemeModeApp`) from the Dashboard selector, and persisted in `SharedPreferences` under the `theme_mode` key. In System mode `ThemeController` (through `WidgetsBindingObserver.didChangePlatformBrightness`) updates the theme at runtime when the device theme changes. The system bar style (status bar and navigation bar icons) is computed by `AppTheme.overlayStyle(isDark:)` and applied with an `AnnotatedRegion` around `GetMaterialApp` in `main.dart`; the `lightTheme()`/`darkTheme()` factories have no side effects.

**Main color palette (`AppColors`):**

| Name | Value | Usage |
|---|---|---|
| `whiteSmoke` | `#F6EFE5` | Light background, main background |
| `darkGray` | `#342E25` | Primary text, dark background |
| `darkPeach` | `#DA7C72` | Accent color |
| `champagne` | `#F0D8B6` | Accent in dark theme |
| `darkSalamon` | `#E09F7A` | Details, text in dark theme |
| `valspar` | `#E7D8C4` | Light surfaces |
| `valsparDark` | `#463E30` | Surfaces (cards) in dark theme |
| `confirmColor` | `#449777` | Success, confirmation |
| `errorColor` | `#D80032` | Errors, deletion |
| `mutedText` / `mutedTextDark` | `#6B6158` / `#CDBFAF` | Secondary text (`onSurfaceVariant`) |
| `outline` / `outlineDark` | `#D9CBB8` / `#6A5F52` | Thin borders, unselected chips |
| `cardLight` | `#FFFFFF` | Raised cards in light theme (`surfaceContainerLowest`) |

**`ColorScheme` roles (semantic):** `surface` = page background, `onSurface` = main text, `onSurfaceVariant` = secondary text, `secondary` = warm accent (peach / champagne), `primary` = main actions (filled buttons, selected chips: darkGray in light, champagne in dark), `surfaceContainerLowest` = raised cards, `outline` = thin borders, `error` = `errorColor`. Screens reference only these roles; `progressIndicatorTheme` and `switchTheme` use the accent.

**Typography and components (redesign A):** `AppTheme._textTheme` defines a single scale (headlineMedium 28 detail title, headlineSmall 22 screen titles, titleMedium 16 app bar, titleSmall 15 card title, body 14/16, bodySmall 12 secondary text, labelLarge 15 buttons, labelMedium 13 chips, labelSmall 11 uppercase labels). Component themes align buttons (filled `primary`, pill-shaped, height 52), fields (filled with `surfaceContainerLowest`, no border, `primary` border on focus), cards, chips, FAB, dialogs and bottom sheets (with drag handle). `ButtonWidget` inherits colors, shape and text style from the theme.

**Redesigned screens (redesign A):** splash, onboarding, welcome, home, shoe details, shoe form, profile, edit and delete account, database (totals summary + charts in cards), dashboard (card sections with `DashboardMenuItem` and a themed `SegmentedButton`), login/signup/reset, gender selection, info and support (FAQ in cards). `AppBarWidget` and `TextFieldWidget` inherit from the theme. The `DeleteDialogWidget` confirmation dialog no longer has a colored band.

**Spacing (`AppSpacing`, `lib/theme/app_spacing.dart`):** a single scale for padding, margins and gaps — `grid` 2, `xxs` 4, `xs` 8, `s` 12, `m` 16, `l` 20, `xl` 24, `xxl` 32, plus `screen` 30 for the outer page padding. Like `AppRadius` these are raw values: each call picks the ScreenUtil scaling that fits the axis (`AppSpacing.m.r`, `AppSpacing.xs.h`). The few remaining off-scale values (e.g. 88 of space for the FAB, 72 at the bottom of the form) are intentional special cases.

**UI scaling:** the whole layout uses `flutter_screenutil` with a `390×844` px design size (adapted dynamically to the actual screen size on tablets) to keep proportions across screen sizes.

**System text size:** `Text` widgets apply the operating system's font size setting on top of ScreenUtil's `.sp` values; `main.dart` clamps it to `AppFontSizes.maxTextScaleFactor` (1.3) with `MediaQuery.withClampedTextScaling`, beyond which fixed-height containers would clip text. `ButtonWidget` labels shrink (`FittedBox`) instead of overflowing. Shared widgets are checked at 1.3 scale in German (the longest labels) in `test/common/widgets/text_scaling_test.dart`.

**Adaptive layout (responsive):** besides proportional scaling, some screens actually reorganize their content based on the available width, through `LayoutBuilder`:
- `AppBreakpoints` (`lib/theme/app_breakpoints.dart`) — centralized thresholds (tablet ≥ 600px, desktop ≥ 900px) and column count computed from the actual width
- `ResponsiveCenterWidget` (`lib/common/widgets/responsive_center_widget.dart`) — constrains content to a maximum width and centers it, so forms/lists don't stretch edge-to-edge on large tablets (used in the Profile screen and, with the `maxGridWidth` limit, in Home)
- The shoe grid (Home) computes the column count from the actual screen width, keeping the user's manual choice (1/2/3 columns) as the minimum
- The pie charts (Database) size canvas and section radius in proportion to the card's actual width (square box), avoiding overlaps between pie, title and legend
- The app orientation is no longer locked to portrait (`android:screenOrientation="unspecified"` in `AndroidManifest.xml`), allowing rotation on tablets

**Shared button (`ButtonWidget`, `lib/common/widgets/button_widget.dart`):**
- Optional colors: by default colors come from the theme (filled `primary`, or outlined with `isOutline: true`); shape and elevation come from the theme's `elevatedButtonTheme`/`outlinedButtonTheme`
- `onPressed: null` → disabled button (dimmed background and text)
- `isLoading: true` → replaces the label with a spinner keeping the same size and blocks taps (used by login, signup and reset password instead of a separate loader)
- 48dp minimum height (`ButtonWidget.minTouchTarget`) even when the scaled `height` is smaller

---

## 9. Navigation

The app uses **GetX** routing with named routes.

| Route | Screen | Description |
|---|---|---|
| `/` | IntroScreen | Splash / authentication check |
| `/onboarding` | OnboardingScreen | App introduction (first launch) |
| `/welcome` | WelcomeScreen | Welcome with access to login/signup |
| `/login` | LoginScreen | Google or email/password sign-in |
| `/signup` | SignupScreen | New user registration |
| `/reset-password` | ResetPasswordScreen | Password recovery |
| `/gender-selection` | GenderSelectionScreen | Gender selection (first sign-in) |
| `/home` | HomeScreen | Shoe list with filters |
| `/shoes/add` | ShoesAdderScreen | Add a new shoe |
| `/shoes/details` | ShoesDetailsScreen | Shoe details |
| `/shoes/update` | ShoesUpdaterScreen | Edit a shoe |
| `/dashboard` | DashboardScreen | Settings and account |
| `/database` | DatabaseScreen | Statistics and data management |
| `/info` | InfoScreen | Logo, version, description, main features, links (GitHub, website, contacts, privacy, open source licenses) and credits |
| `/privacy-policy` | PrivacyPolicyScreen | Native privacy policy (10 localized sections) |
| `/support` | SupportScreen | Help Desk: contacts, documentation and FAQ |
| `/user` | UserScreen | User profile with statistics |
| `/user/update` | UserUpdateScreen | Edit profile |
| `/user/delete` | UserDeleteScreen | Account deletion |

---

## 10. Localization

The app supports **5 languages** through `flutter_localizations` + ARB files.

| Code | Language |
|---|---|
| `en` | English |
| `it` | Italian |
| `fr` | French |
| `es` | Spanish |
| `de` | German |

The ARB files live in `lib/l10n/`; the Dart code is generated with `flutter gen-l10n` into the same folder. The user picks the active language in the Dashboard with the flag selector; it is persisted in `SharedPreferences` under the `language_code` key.

`L10n.parseLocale(String?)` (in `lib/l10n/l10n.dart`) converts the saved code into a supported `Locale`, returning `null` if the value is missing, empty or unsupported: in that case `MyApp` falls back to the system locale. The initial locale is resolved **only once** per `MyApp` instance, not on every rebuild. Pure function, covered by tests in `test/l10n/l10n_test.dart`.

---

## 11. Dependencies

```yaml
dependencies:
  get: ^4.6.6                              # State management and routing
  flutter_screenutil: ^5.9.3               # Responsive UI
  ming_cute_icons: ^0.0.7                  # UI icons
  fl_chart: ^0.69.0                        # Charts
  photo_view: ^0.15.0                      # Zoomable image viewer
  screenshot: ^3.0.0                       # Widget screenshots
  google_sign_in: ^6.1.5                   # Google authentication
  cloud_firestore: ^5.5.0                  # Cloud database
  firebase_auth: ^5.3.4                    # Firebase authentication
  firebase_core: ^3.9.0                    # Firebase core
  firebase_storage: ^12.3.7                # Image storage
  http: ^1.3.0                             # HTTP requests
  url_launcher: ^6.3.0                     # Opening URLs
  shared_preferences: ^2.3.4               # Local persistence
  path_provider: ^2.1.4                    # Filesystem paths
  path: ^1.9.0                             # Path handling
  image: ^4.2.0                            # Image processing
  image_picker: ^1.1.2                     # Image picking
  image_cropper: ^11.0.0                   # Image cropping
  flutter_image_compress: ^2.4.0           # Image compression
  cached_network_image: ^3.4.1             # Network image cache
  image_gallery_saver_plus: ^4.0.1         # Save to gallery
  pdf: ^3.11.0                             # PDF generation
  file_picker: ^9.0.2                      # File picker
  share_plus: ^10.1.3                      # File sharing
  permission_handler: ^11.3.1              # Permissions
  device_info_plus: ^11.2.0                # Device info
  package_info_plus: ^9.0.0                # App info (version)
  logger: ^2.5.0                           # Logging
  uuid: ^4.5.1                             # UUID generation
  intl: ^0.20.2                            # Date formatting / localization
  google_mlkit_subject_segmentation: ^0.2.1  # On-device background removal (ML Kit)
  flutter_localizations:                   # Flutter localization
    sdk: flutter
```

```yaml
dev_dependencies:
  flutter_lints: ^5.0.0                    # Lint rules
  flutter_launcher_icons: ^0.14.2          # Launcher icon generation
  change_app_package_name: ^1.4.0          # Android package renaming
  intl_utils: ^2.8.7                       # Localization utilities
  mocktail: ^1.0.5                         # Test mocks (Firebase, Google Sign-In, controllers)
```

**Tests (`flutter test`):** 100 tests in `test/`.
- Pure logic: `ShoesFilter`, `ShoesFormData`, `ShoesTextTranslations`, `L10n.parseLocale`, `ShoesGridLayout` (grid columns and sizes), `ChangelogService` (which changes to show after an update), `MaskRefinement` (background removal alpha, erosion and edge decontamination)
- With mocks (`mocktail`): `AuthService` (user lookup on Firestore, session in `SharedPreferences` via `setMockInitialValues`), `LoginRepository` (email/password and Google Sign-In error mapping), `ShoesFormService` (add, edit, photo replacement and removal, favorite preserved), `AuthGuardService` (widget test with real GetX navigation: redirect on expired session, voluntary sign-out, public routes), controllers `ShoesController` (add, edit, delete, JSON import/export with a fake HTTP client), `DatabaseController` (counts and statistics, empty collection, errors) and `UserController` (profile and name loading)
- Layout: shared widgets at 1.3 text scale (`test/common/widgets/text_scaling_test.dart`)

`ShoesController` (repository, Firebase Auth, `http.Client`), `UserController` (repository), `LoginRepository`, `AuthGuardService` and `AuthService` take their dependencies (Firebase, Google Sign-In, Firestore) as optional constructor parameters, defaulting to the real instances, so tests can replace them.

**Lint (`analysis_options.yaml`):** on top of `flutter_lints`, `avoid_print`, `prefer_const_constructors`, `prefer_const_declarations`, `use_super_parameters` and `require_trailing_commas` are enabled; the files generated by `flutter gen-l10n` (`lib/l10n/app_localizations*.dart`) are excluded from analysis. Fixable issues can be applied with `dart fix --apply`.

---

## 12. System requirements

| Requirement | Value |
|---|---|
| Flutter SDK | `^3.7.0` |
| Dart SDK | `^3.5.2` |
| Minimum Android | API 24 (Android 7.0), required by ML Kit |
| Recommended Android | API 26+ (Android 8.0) |
| Architecture | 64-bit only (`arm64-v8a`) |
| Android for storage permissions | API 33+ (Android 13) — `READ_MEDIA_IMAGES` |
| Google Play services | Required (Google sign-in and background removal model) |
| Main platform | Android |
| Internet connection | Required for authentication and Firestore sync |
| Firebase account | Required (`google-services.json` configuration) |

---

## 13. Build and distribution

```bash
# Install dependencies
flutter pub get

# Check for problems
flutter doctor

# Run in debug mode
flutter run

# Release APK (arm64, obfuscated, as in deploy_android.ps1)
flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=symbols/v<version>

# App Bundle (recommended for Google Play)
flutter build appbundle --release
```

**Firebase configuration:**
- Make sure `android/app/google-services.json` is present and up to date
- `google-services.json` must not be committed with production credentials to public repositories

**APK signing:** configure `android/app/build.gradle` with the production keystore before a release build.

**Notes:**
- `android/local.properties` must not be committed (it contains local SDK paths)
- The `build/` folder must not be committed (build output)
- The version in `pubspec.yaml` is the single source of truth: the app reads it at runtime through `PackageInfo`
- Background removal uses ML Kit Subject Segmentation: the model is not in the APK but is downloaded by Google Play services (at install time from the Play Store thanks to the `com.google.mlkit.vision.DEPENDENCIES` meta-data, otherwise on first use; meanwhile the app shows a dedicated message). Obfuscated arm64 release APK: ~23 MB (previously ~46 MB with ONNX). Builds with `--obfuscate --split-debug-info=symbols/v<version>` (see `deploy_android.ps1`) require keeping the symbols folder to decode stack traces
- README previews: `flutter test tool/preview/generate_preview_test.dart` regenerates `images/shox_preview.png` (tilted phones) and the screens without system bars (540 px wide) in `images/screenshots/<name>.png` from `images/screenshots/<name>_raw.png` (1080x2392, git-ignored and kept locally). The script lives outside `test/`, so it does not run with `flutter test`

---

## License

Copyright © 2026 **Nicola De Nicolais** — All rights reserved.

License: **MIT**

- **Author:** Nicola De Nicolais
- **Email:** [ndn21dev@gmail.com](mailto:ndn21dev@gmail.com)
- **GitHub:** [https://github.com/ndenicolais](https://github.com/ndenicolais)
