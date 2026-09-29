# Shox — Documentazione completa

> Copyright © 2026 Nicola De Nicolais — Tutti i diritti riservati.

---

## Indice

1. [Panoramica dell'app](#1-panoramica-dellapp)
2. [Architettura e stack tecnologico](#2-architettura-e-stack-tecnologico)
3. [Struttura del progetto](#3-struttura-del-progetto)
4. [Modelli dati](#4-modelli-dati)
5. [Schermate e funzionalità](#5-schermate-e-funzionalità)
   - [Intro, Onboarding e Welcome](#51-intro-onboarding-e-welcome)
   - [Auth — Autenticazione](#52-auth--autenticazione)
   - [Home — Collezione scarpe](#53-home--collezione-scarpe)
   - [Dettaglio scarpa](#54-dettaglio-scarpa)
   - [Aggiunta scarpa](#55-aggiunta-scarpa)
   - [Modifica scarpa](#56-modifica-scarpa)
   - [Dashboard](#57-dashboard)
   - [Database — Statistiche](#58-database--statistiche)
   - [Profilo utente](#59-profilo-utente)
   - [Modifica profilo](#510-modifica-profilo)
   - [Eliminazione account](#511-eliminazione-account)
6. [Controller (State Management)](#6-controller-state-management)
7. [Servizi](#7-servizi)
   - [ImageService](#71-imageservice)
   - [ShoesFormData e ShoesFormService](#74-shoesformdata-e-shoesformservice)
   - [PdfService](#73-pdfservice)
   - [Export e Import JSON](#74-export-e-import-json)
8. [Tema e stile](#8-tema-e-stile)
9. [Navigazione](#9-navigazione)
10. [Localizzazione](#10-localizzazione)
11. [Dipendenze](#11-dipendenze)
12. [Requisiti di sistema](#12-requisiti-di-sistema)
13. [Build e distribuzione](#13-build-e-distribuzione)

---

## 1. Panoramica dell'app

**Shox** è un'app per la gestione del guardaroba digitale di scarpe, sviluppata in Flutter per Android. Permette all'utente di:

- Catalogare l'intera collezione di scarpe con foto, marca, taglia, categoria, tipo, stagione e colori
- Filtrare e cercare le scarpe per qualsiasi caratteristica (categoria, tipo, stagione, colore, preferiti)
- Visualizzare statistiche della collezione tramite grafici a torta interattivi
- Esportare la collezione completa in PDF o effettuare backup/ripristino in JSON
- Condividere le schede delle scarpe come screenshot
- Salvare le foto delle scarpe nella galleria del dispositivo
- Rimuovere lo sfondo dalle immagini tramite modello ONNX integrato
- Accedere tramite account Google o email e password con sincronizzazione cloud in tempo reale

L'app è completamente localizzata in 5 lingue (italiano, inglese, francese, spagnolo, tedesco) con tema chiaro e scuro.

---

## 2. Architettura e stack tecnologico

| Componente | Tecnologia / Libreria |
|---|---|
| Framework | Flutter 3 / Dart `^3.5.2` |
| State management | [get](https://pub.dev/packages/get) `^4.6.6` (GetX) |
| Backend — Database | [cloud_firestore](https://pub.dev/packages/cloud_firestore) `^5.5.0` |
| Backend — Auth | [firebase_auth](https://pub.dev/packages/firebase_auth) `^5.3.4` |
| Backend — Storage | [firebase_storage](https://pub.dev/packages/firebase_storage) `^12.3.7` |
| Autenticazione Google | [google_sign_in](https://pub.dev/packages/google_sign_in) `^6.1.5` |
| Persistenza locale | [shared_preferences](https://pub.dev/packages/shared_preferences) `^2.3.4` |
| UI responsive | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) `^5.9.3` |
| Icone UI | [ming_cute_icons](https://pub.dev/packages/ming_cute_icons) `^0.0.7` |
| Grafici | [fl_chart](https://pub.dev/packages/fl_chart) `^0.69.0` |
| Internazionalizzazione | [intl](https://pub.dev/packages/intl) `^0.20.2` |
| ID univoci | [uuid](https://pub.dev/packages/uuid) `^4.5.1` |
| Immagini — selezione | [image_picker](https://pub.dev/packages/image_picker) `^1.1.2` |
| Immagini — ritaglio | [image_cropper](https://pub.dev/packages/image_cropper) `^11.0.0` |
| Immagini — compressione | [flutter_image_compress](https://pub.dev/packages/flutter_image_compress) `^2.4.0` |
| Immagini — rimozione sfondo | [image_background_remover](https://pub.dev/packages/image_background_remover) `^2.0.0` |
| Immagini — cache | [cached_network_image](https://pub.dev/packages/cached_network_image) `^3.4.1` + [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager) `^3.4.1` |
| Immagini — visualizzazione | [photo_view](https://pub.dev/packages/photo_view) `^0.15.0` |
| Immagini — salvataggio galleria | [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) `^4.0.1` |
| Screenshot widget | [screenshot](https://pub.dev/packages/screenshot) `^3.0.0` |
| Export PDF | [pdf](https://pub.dev/packages/pdf) `^3.11.0` |
| Selettore file | [file_picker](https://pub.dev/packages/file_picker) `^9.0.2` |
| Condivisione | [share_plus](https://pub.dev/packages/share_plus) `^10.1.3` |
| Permessi | [permission_handler](https://pub.dev/packages/permission_handler) `^11.3.1` |
| Info dispositivo | [device_info_plus](https://pub.dev/packages/device_info_plus) `^11.2.0` |
| Info app | [package_info_plus](https://pub.dev/packages/package_info_plus) `^9.0.0` |
| Percorsi filesystem | [path_provider](https://pub.dev/packages/path_provider) `^2.1.4` |
| HTTP | [http](https://pub.dev/packages/http) `^1.3.0` |
| Log | [logger](https://pub.dev/packages/logger) `^2.5.0` |

**Pattern architetturale:** MVC con GetX. I controller fungono da ViewModel; i modelli sono plain Dart objects; i repository gestiscono l'accesso ai dati; le schermate sono StatefulWidget/StatelessWidget che interagiscono con i controller tramite GetX.

---

## 3. Struttura del progetto

```
shox/
├── android/                        # Configurazione Android nativa
├── assets/
│   ├── fonts/                      # Font Montserrat (regular + bold) + ShoxIcons
│   └── images/                     # Logo app, sorgenti icona launcher e altre immagini statiche
├── lib/
│   ├── main.dart                   # Entry point: inizializza Firebase (con schermata di errore e retry), tema, locale
│   ├── common/
│   │   ├── screens/                # Schermate comuni (intro, onboarding, welcome)
│   │   └── widgets/                # Widget riutilizzabili globali
│   ├── core/
│   │   ├── routes/                 # Definizione route GetX (AppRoutes, AppPages, AuthMiddleware); transizione di default `rightToLeftWithFade` (300ms) impostata su GetMaterialApp
│   │   └── utils/                  # Utility, costanti, helper, bg_remover
│   ├── features/
│   │   ├── auth/                   # Autenticazione (login, signup, reset password, gender selection)
│   │   ├── dashboard/              # Dashboard (impostazioni, info, privacy, supporto)
│   │   ├── database/               # Statistiche, export PDF, export/import JSON
│   │   ├── home/                   # Schermata principale con lista scarpe e filtri
│   │   ├── shoes/                  # CRUD scarpe (modelli, controller, repository, schermate)
│   │   └── users/                  # Gestione profilo utente
│   ├── l10n/                       # File ARB per localizzazione (en, it, fr, es, de)
│   └── theme/                      # Tema, colori, dimensioni font, controller tema
├── pubspec.yaml
├── README.md
└── DOCUMENTATION.md
```

Ogni feature segue la struttura interna:
```
feature/
├── bindings/         # GetX Binding per dependency injection
├── controller/       # Controller GetX (business logic)
├── models/           # Modelli dati
├── repository/       # Accesso dati (Firestore, Firebase Storage)
├── screens/          # Schermate UI
├── services/         # Servizi specializzati (image, pdf, ecc.)
└── widgets/          # Widget specifici della feature
```

**Convenzione di naming dei widget:** ogni file ha il nome della sua classe in snake_case. I widget generici in `lib/common/widgets/` usano il suffisso `Widget` (`ButtonWidget`, `ToastWidget`, `ChangelogDialogWidget`…), che evita collisioni con le classi di Flutter (`AppBar`, `Dialog`…). I widget di una feature hanno nomi descrittivi senza suffisso (`LoginForm`, `FilterBar`, `FilterSheet`, `TopBar`, `DashboardMenuItem`, `ShoesPieChart`, `ColorChip`…), evitando nomi già usati da Flutter.

**Widget estratti dalle schermate più grandi:** `ShoePhotoArea`, `BackgroundRemovalDialog` e `showImageSourceSheet` (`shoes/widgets/form/shoe_photo_picker.dart`); `showFilterSheet`/`FilterSelection` (il pannello filtri gestisce da solo la selezione temporanea e restituisce il risultato), `ShoesGridLayout`, `ShoesGridSkeleton`, `ShoesCountRow` (`home/widgets/shoes_grid.dart`); grafici del database in `database/widgets/database_charts.dart` e overlay di avanzamento condiviso `ProgressOverlayWidget`; sezioni e dialog di backup dell'eliminazione account in `users/widgets/delete_account_info.dart`; `ExportResult`/`ImportResult` in `database/models/database_results.dart`; logica del dialog novità in `core/services/changelog_service.dart`.

---

## 4. Modelli dati

Tutti i dati persistenti sono salvati su **Cloud Firestore**. Le immagini sono archiviate su **Firebase Storage**.

### ShoesModel

Rappresenta un paio di scarpe nel guardaroba digitale.

| Campo | Tipo | Descrizione |
|---|---|---|
| `id` | `String?` | ID documento Firestore (UUID) |
| `imageUrl` | `String` | URL immagine su Firebase Storage |
| `colorPrimary` | `Color` | Colore principale della scarpa |
| `colorExtra` | `List<int>?` | Colori aggiuntivi (valori ARGB32) |
| `brand` | `String` | Marca della scarpa |
| `size` | `String` | Taglia |
| `category` | `String` | Categoria (es. Sneakers, Boots, Heeled…) |
| `type` | `String` | Tipo specifico nella categoria (es. Sport, Casual…) |
| `season` | `String?` | Stagione: `All` / `Spring` / `Summer` / `Autumn` / `Winter` |
| `notes` | `String?` | Note opzionali |
| `isFavorite` | `bool` | Contrassegnata come preferita |
| `dateAdded` | `DateTime` | Data di aggiunta |
| `dateUpdated` | `DateTime` | Data dell'ultima modifica |

**Categorie per genere maschile:** Sneakers, Elegant, Sandals, Loafers, Other  
**Categorie per genere femminile:** Sneakers, Elegant, Heeled, Sandals, Boots, Mules, Flats, Other  
**Categorie predefinite (tutti):** Sneakers, Elegant, Heeled, Sandals, Boots, Mules, Other

---

### UserModel

Rappresenta il profilo dell'utente autenticato.

| Campo | Tipo | Descrizione |
|---|---|---|
| `userEmail` | `String` | Email dell'utente |
| `userName` | `String` | Nome completo |
| `userImage` | `String?` | URL immagine profilo (Firebase Storage) |
| `gender` | `String?` | Genere: `male` / `female` / `other` |
| `userDate` | `DateTime` | Data di registrazione |

---

## 5. Schermate e funzionalità

### 5.1 Intro, Onboarding e Welcome

**Percorso:** `lib/common/screens/`

Flusso iniziale di accesso all'app.

**Funzionalità:**
- **IntroScreen:** Schermata di splash/caricamento; verifica se l'utente è già autenticato e reindirizza alla schermata appropriata (`home` se autenticato, altrimenti `onboarding` o `welcome`)
- **OnboardingScreen:** Sequenza di schermate introduttive che presentano le funzionalità principali dell'app (mostrata solo al primo avvio)
- **WelcomeScreen:** Schermata di benvenuto con accesso rapido a login e registrazione
- **StartupErrorScreen:** Mostrata al posto dell'app se `Firebase.initializeApp` fallisce all'avvio; il pulsante "Riprova" ripete l'inizializzazione (`_bootstrap()` in `main.dart`). Un errore nella lettura di `SharedPreferences` non blocca l'avvio: viene usata la lingua del dispositivo

---

### 5.2 Auth — Autenticazione

**Percorso:** `lib/features/auth/`

Gestione completa del flusso di autenticazione tramite Firebase Auth.

**Funzionalità:**
- **LoginScreen:** Accesso tramite Google Account (OAuth2) o email e password. Gestione errori (email non valida, password errata, utente non trovato)
- **SignupScreen:** Registrazione con email, password e nome. Creazione documento utente su Firestore
- **ResetPasswordScreen:** Invio email di reset password tramite Firebase Auth
- **GenderSelectionScreen:** Selezione del genere (`male` / `female` / `other`) al primo accesso; determina le categorie di scarpe mostrate nell'app. Salvato nel documento utente su Firestore

**Servizio condiviso:** `lib/features/auth/services/auth_service.dart` (`AuthService`) centralizza la logica comune ai repository di login, signup, reset password e utente:
- `findUserByEmail(email)` — ricerca del documento utente su Firestore per `userEmail`
- `saveSession(userId)` / `clearSession()` — salvataggio e rimozione della sessione locale (`remember_me`, `user_id` in `SharedPreferences`)

**Protezione della sessione:**
- `AuthGuardService` (`lib/features/auth/services/auth_guard_service.dart`, `GetxService` permanente registrato in `main.dart`) ascolta `authStateChanges()`: se la sessione cade in modo inatteso su una route protetta, pulisce la sessione locale e reindirizza a `/welcome` con un toast. Logout ed eliminazione account chiamano prima `expectSignOut()` per non essere scambiati per una sessione scaduta
- `AuthMiddleware` (`lib/core/routes/auth_middleware.dart`) è applicato a tutte le route che richiedono un utente (home, scarpe, dashboard, database, utente, gender selection) e reindirizza a `/welcome` se `currentUser` è null
- `IntroScreen`, con "ricordami" attivo, attende il primo evento di `authStateChanges()` prima di aprire la home: se l'utente Firebase non c'è più, pulisce la sessione e va a `/welcome`

---

### 5.3 Home — Collezione scarpe

**Percorso:** `lib/features/home/`

Schermata principale che mostra l'intera collezione di scarpe dell'utente.

**Funzionalità:**
- **Stream real-time** da Firestore: la lista si aggiorna automaticamente a ogni modifica
- **Griglia configurabile e adattiva:** 1, 2 o 3 colonne selezionabili tramite toggle rapido, con numero di colonne che aumenta automaticamente in base alla larghezza reale dello schermo (tablet/landscape). Le celle sono quadrate (`childAspectRatio` esplicito), l'immagine riempie sempre la cella ed è decodificata alla larghezza reale della cella (`memCacheWidth`/`cacheWidth`), non alla risoluzione originale. Su tablet il contenuto è centrato con `ResponsiveCenterWidget` e larghezza massima `AppBreakpoints.maxGridWidth` (1080), così restano raggiungibili le 4 colonne
- **Ricerca testuale** su marca, tipo, categoria (anche nel nome tradotto) e note, con debounce di 300ms: la griglia si rifiltra solo quando si smette di scrivere
- **Pull-to-refresh:** trascinando la griglia verso il basso (`RefreshIndicator`) lo stream Firestore viene ri-sottoscritto
- **Caricamento e transizioni:** durante il caricamento viene mostrato uno skeleton della griglia (`SkeletonWidget` pulsante, `lib/common/widgets/skeleton_widget.dart`) con lo stesso numero di colonne della griglia reale; anche le foto in caricamento usano `SkeletonWidget` come placeholder. Il passaggio fra caricamento, errore, collezione vuota, nessun risultato e griglia avviene con un `AnimatedSwitcher` (250ms); la griglia sfuma anche al cambio di colonne o filtri (chiave `_gridViewKey`), ma non ai normali aggiornamenti dello stream. Le icone filtri/griglia/preferiti della barra cambiano con un `ScaleTransition`
- **Filtri attivi:**
  - Categoria (dipende dal genere utente)
  - Tipo (dipende dalla categoria selezionata)
  - Stagione
  - Colore primario
  - Colore aggiuntivo
- **Intestazione e filtri rapidi (redesign A):** `TopBar` con avatar, saluto e titolo "La tua collezione"; `FilterBar` con campo di ricerca a pillola e pulsante filtri pieno (pallino `Badge` quando un filtro è attivo); `CategoryChips` con chip Tutte / Preferite / una per categoria (tradotte) che impostano direttamente `selectedCategory` e `showOnlyFavorites`; riga "N paia · M preferite" (plurali ICU) con il cambio griglia. Le card (`ShoeCard`) mostrano foto quadrata con cuore su sfondo semitrasparente, marca e "Tg. 42 · tipo"; l'altezza della cella è foto + didascalia scalata con il testo di sistema (`ShoeCard.captionHeight`)
- **Indicatore filtri:** il pallino sul pulsante filtri è acceso tramite `ShoesFilter.isActive`, derivato dal contenuto effettivo dei filtri (colore, colore extra, categoria, tipo, stagione, preferiti); la ricerca testuale è esclusa perché dispone del proprio pulsante di pulizia
- **Reset filtri:** `_resetFilters()` azzera tutti i filtri, la ricerca e il toggle preferiti; è condiviso fra il pulsante di pulizia della barra di ricerca e l'azione dello stato "nessun risultato"
- **Stato vuoto:** messaggio informativo se la collezione è vuota
- **Stato "nessun risultato":** se i filtri o la ricerca azzerano i risultati viene mostrato `EmptyStateWidget` con messaggio dedicato e azione "Azzera filtri"
- **FAB esteso "Aggiungi":** navigazione alla schermata di aggiunta scarpa (stile da `floatingActionButtonTheme`: pesca, forma a pillola); la griglia ha un padding inferiore di 96 per non farsi coprire l'ultima riga
- **Accessibilità:** tutti i pulsanti solo-icona espongono un `tooltip` localizzato (chiavi `a11y_*`); i toggle preferiti e filtri usano un'etichetta che riflette lo stato corrente. Nella top bar l'avatar è un `InkWell` con `Semantics(button: true)` e l'icona impostazioni un `IconButton`, per garantire ripple e area di tocco minima di 48dp.

---

### 5.4 Dettaglio scarpa

**Percorso:** `lib/features/shoes/screens/shoes_details_screen.dart`

Visualizzazione completa di tutti i dettagli di una singola scarpa.

**Funzionalità:**
- Immagine a piena visualizzazione con supporto **zoom e pan** (`photo_view`)
- Dettagli: marca, taglia, categoria, tipo, stagione, colori, note, date aggiunta e modifica
- **Toggle preferita** (stellina) aggiornato in tempo reale su Firestore
- **Condividi scheda:** cattura la schermata come screenshot e la condivide tramite `share_plus`
- **Salva foto:** scarica l'immagine originale nella galleria del dispositivo (`image_gallery_saver_plus`)
- **Modifica:** navigazione alla schermata di modifica
- **Eliminazione** con dialogo di conferma; rimuove la scarpa da Firestore e l'immagine da Firebase Storage
- Aggiornamento in streaming: se i dati cambiano da un altro dispositivo, la schermata si aggiorna automaticamente

---

### 5.5 Aggiunta scarpa

**Percorso:** `lib/features/shoes/screens/shoes_form_screen.dart` (modalità ADD quando `shoes == null`)

Form per l'inserimento di una nuova scarpa nella collezione, organizzato in sezioni (Foto, Colori, Dettagli, Note) con intestazioni dedicate; ogni campo è racchiuso in una `Card` tramite il widget condiviso `FormFieldCard` (`lib/features/shoes/widgets/form/form_field_card.dart`), che uniforma icona, etichetta e stile del contenuto per tutti i campi del form.

**Funzionalità:**
- **Selezione immagine:** da fotocamera o galleria (`image_picker`)
- **Ritaglio immagine:** editor di ritaglio integrato con preset di proporzioni (`image_cropper`)
- **Compressione automatica:** l'immagine viene compressa prima del caricamento (`flutter_image_compress`, qualità 70%)
- **Rimozione sfondo:** opzione per rimuovere lo sfondo dell'immagine tramite modello ONNX locale (`image_background_remover`)
- **Colore primario:** selettore colore principale della scarpa
- **Colori aggiuntivi:** possibilità di aggiungere fino a N colori extra
- **Campi obbligatori:** marca, taglia, categoria, tipo
- **Campi opzionali:** stagione, note
- **Salvataggio:** la scarpa viene prima salvata su Firestore, poi l'immagine viene caricata su Firebase Storage e l'URL aggiornato nel documento
- **Modifiche non salvate:** `PopScope` intercetta il tasto indietro (sistema e app bar); se i campi differiscono dallo stato iniziale viene chiesta conferma con `DeleteDialogWidget` (etichette personalizzate "Resta" / "Esci")

---

### 5.6 Modifica scarpa

**Percorso:** `lib/features/shoes/screens/shoes_form_screen.dart` (modalità EDIT quando viene passata una `ShoesModel` esistente)

Stessa schermata a sezioni della modalità aggiunta, precompilata con i dati della scarpa esistente.

**Funzionalità:**
- Tutti i campi della schermata di aggiunta sono modificabili
- **Sostituzione immagine:** selezione di una nuova immagine con lo stesso flusso di crop/compressione/rimozione sfondo; la vecchia immagine viene eliminata da Firebase Storage
- Aggiornamento `dateUpdated` automatico al salvataggio

---

**Info e privacy:** `InfoScreen` mostra logo, nome, sottotitolo e versione (`PackageInfo`), "Cos'è Shox", quattro funzioni principali in card, i link utili (codice sorgente, sito, email, privacy, `showLicensePage` per le licenze open source) e i crediti (`AppConstants.developerName`). `PrivacyPolicyScreen` è nativa: 10 sezioni `policy_section_*` localizzate nelle 5 lingue, data di aggiornamento `AppConstants.privacyPolicyUpdatedAt`, link alla versione pubblica `PRIVACY.md` su GitHub (`AppConstants.uriPrivacyPolicy`, da indicare anche nel Play Store). Il testo di `PRIVACY.md` (italiano e inglese) va mantenuto allineato alle chiavi ARB. `webview_flutter` è stato rimosso perché non più usato.

### 5.7 Dashboard

**Percorso:** `lib/features/dashboard/`

Schermata di configurazione e accesso alle funzionalità di account.

**Sezioni:**

| Sezione | Voce | Funzionalità |
|---|---|---|
| **Preferenze** | Tema | Selettore a 3 vie Sistema / Chiaro / Scuro (`SegmentedButton`) |
| **Preferenze** | Lingua | Selettore delle bandiere per la lingua dell'app (5 lingue) |
| **Account** | Profilo | Visualizzazione e modifica profilo utente |
| **Account** | Database | Accesso alle statistiche e alla gestione dati |
| **Account** | Logout | Disconnessione dall'app |
| **Informazioni** | Info | Informazioni sull'app e versione |
| **Informazioni** | Privacy Policy | Informativa privacy nativa e localizzata (stesso testo di `PRIVACY.md`, link alla versione online) |
| **Informazioni** | Supporto | Modulo di supporto / contatto (WebView) |
| **Informazioni** | Changelog | Apre il dialog con lo storico delle novità per versione |

**Changelog dialog:** le voci sono definite in `lib/core/constants/changelog.dart` (`ChangelogEntry`, una per versione, con bullet localizzati) e mostrate da `lib/common/widgets/changelog_dialog.dart`. Oltre all'apertura manuale dalla Dashboard, il dialog compare automaticamente una sola volta dopo un aggiornamento: `HomeScreen` confronta la versione corrente (`package_info_plus`) con l'ultima vista, salvata in `SharedPreferences` (`AppConstants.prefsLastSeenChangelogVersion`), e mostra solo le voci non ancora viste. Su una nuova installazione la versione corrente viene solo registrata, senza mostrare il dialog.

---

### 5.8 Database — Statistiche

**Percorso:** `lib/features/database/`

Schermata di analisi statistica della collezione e gestione dei dati.

**Funzionalità:**
- **Grafici a torta interattivi** (`fl_chart`) per:
  - Distribuzione per **colore** primario
  - Distribuzione per **marca**
  - Distribuzione per **categoria**
  - Distribuzione per **tipo**
- Contatore totale scarpe in collezione
- **Export PDF:** genera un documento PDF completo con copertina, pagina profilo utente e una pagina per ogni scarpa con immagine e dettagli; salvato nella cartella Downloads
- **Export JSON:** esporta l'intera collezione come file JSON scaricabile
- **Import JSON:** importa una collezione da un backup JSON precedente con barra di avanzamento

---

### 5.9 Profilo utente

**Percorso:** `lib/features/users/screens/user_screen.dart`

Visualizzazione del profilo personale con statistiche sulla collezione.

**Funzionalità:**
- Avatar utente (immagine profilo o iniziale del nome)
- Nome, email
- **Statistiche collezione:**
  - Numero totale di scarpe
  - Numero di preferite
  - Marca più presente
  - Categoria più usata
  - Tipo più usato
  - Colore più presente
  - Data dell'ultima scarpa aggiunta
- Pulsanti di navigazione rapida: modifica profilo, accesso al database
- Pulsante "Elimina account" (evidenziato in rosso) con accesso diretto alla procedura di eliminazione

---

### 5.10 Modifica profilo

**Percorso:** `lib/features/users/screens/user_update_screen.dart`

Form di aggiornamento delle informazioni del profilo utente.

**Funzionalità:**
- Modifica nome
- Modifica email (solo per utenti con autenticazione email/password)
- Modifica password (solo per utenti con autenticazione email/password)
- Aggiornamento immagine profilo con stesso flusso di selezione/ritaglio/compressione delle scarpe

---

### 5.11 Eliminazione account

**Percorso:** `lib/features/users/screens/user_delete_screen.dart`

Procedura di eliminazione definitiva dell'account.

**Funzionalità:**
- Conferma dell'intenzione tramite dialogo
- Eliminazione di tutti i documenti Firestore dell'utente (scarpe + profilo)
- Eliminazione di tutte le immagini da Firebase Storage
- Eliminazione dell'account da Firebase Auth
- Reindirizzamento alla schermata di benvenuto

---

## 6. Controller (State Management)

L'app usa **GetX** come sistema di state management e dependency injection. Tutti i controller sono registrati tramite Binding.

| Controller | Percorso | Responsabilità |
|---|---|---|
| `ShoesController` | `features/shoes/controller/` | CRUD scarpe, stream per lista e singola scarpa, toggle preferito |
| `UserController` | `features/users/controller/` | Profilo utente (nome, email, immagine), login Google, logout, eliminazione account |
| `DatabaseController` | `features/database/controller/` | Statistiche aggregazione (conteggi per colore/marca/categoria/tipo), dati utente, export/import |
| `ThemeController` | `theme/` | Gestione tema chiaro/scuro, persistenza in `SharedPreferences` |
| `LoginController` | `features/auth/login/controller/` | Logica login (Google + email/password), validazione |
| `SignupController` | `features/auth/signup/controller/` | Logica registrazione, creazione profilo |
| `ResetPasswordController` | `features/auth/reset_password/controller/` | Invio email di reset password |
| `GenderSelectionController` | `features/auth/gender_selection/controller/` | Salvataggio genere selezionato |

---

## 7. Servizi

### 7.1 ImageService

**Percorso:** `lib/features/shoes/services/image_service.dart`

Gestisce tutte le operazioni sulle immagini prima del caricamento.

- **`pickImage(source)`:** Apre il selettore immagine (fotocamera o galleria), avvia automaticamente il crop e la compressione
- **`cropImage(imageFile)`:** Apre l'editor `ImageCropper` con preset di proporzioni (originale, quadrato, 3:2, 4:3, 16:9)
- **`compressImage(imageFile)`:** Comprime l'immagine al 70% di qualità tramite `FlutterImageCompress`; supporta JPEG e PNG

---

### 7.2 ShoesFilter

**Percorso:** `lib/features/shoes/models/shoes_filter.dart`

Value object immutabile che descrive i filtri applicati alla lista scarpe. Logica pura: nessun `BuildContext`, nessun accesso a Firestore, nessun effetto collaterale sulla lista di partenza.

- **`apply(List<ShoesModel>)`:** restituisce una **nuova** lista, ordinata dal più recente, con le sole scarpe che soddisfano tutti i filtri (ricerca su marca/tipo/categoria/note, preferiti, colore primario, colore extra, categoria, tipo, stagione)
- **`isActive`:** true quando almeno un filtro restringe davvero la lista; la ricerca testuale è esclusa perché ha il proprio pulsante di pulizia
- La costante `ShoesFilter.all` (`'All'`) è il sentinella usato dai dropdown per "nessun filtro su questo campo"

Coperto da test unitari in `test/features/shoes/models/shoes_filter_test.dart`.

---

### 7.3 ShoesCategoriesMixin

**Percorso:** `lib/features/shoes/widgets/shoes_categories_mixin.dart`

Mixin su `State` che raccoglie lo stato condiviso fra le schermate che mostrano categorie/tipi/stagioni, le cui opzioni dipendono sia dal genere dell'utente sia dalla lingua attiva. Usato da `HomeScreen` e `ShoesFormScreen`, dove la stessa logica era duplicata.

- **`loadUserGender(uid)`:** da chiamare in `initState`; carica il genere e restringe le categorie disponibili
- **`refreshTranslations()`:** da chiamare in `didChangeDependencies`; rilegge la lingua e ricostruisce le liste di opzioni tradotte
- La parte pura vive in `ShoesTextTranslations.categoryOptionsFor(...)`, coperta da test in `test/core/utils/shoes_text_translations_test.dart`

---

### 7.4 ShoesFormData e ShoesFormService

**Percorsi:** `lib/features/shoes/models/shoes_form_data.dart`, `lib/features/shoes/services/shoes_form_service.dart`

Salvataggio della form di aggiunta/modifica scarpa, fuori dalla UI.

- **`ShoesFormData`** (value object immutabile, logica pura): fotografia dei campi della form.
  - `validate()` restituisce il primo errore bloccante (`ShoesFormError.missingImage` / `missingColor`) o `null`: la foto è obbligatoria sia in aggiunta sia in modifica (se quella salvata viene rimossa ne serve una nuova)
  - `toShoesModel(imageUrl:, existing:)` costruisce il `ShoesModel` normalizzando i campi (marca senza spazi, stagione vuota → `All`, note vuote → `null`) e, in modifica, conserva id, preferito e data di aggiunta
  - Coperto da test in `test/features/shoes/models/shoes_form_data_test.dart`
- **`ShoesFormService.save(data, existing:)`**: prepara l'eventuale immagine senza sfondo (file PNG temporaneo) e delega a `ShoesController.addShoes` o `updateShoes`; in modifica elimina da Storage la foto precedente solo se l'utente l'ha rimossa
- `ShoesFormScreen._saveForm()` si limita all'orchestrazione: validatori dei campi, `ShoesFormData.validate()` → toast, salvataggio, navigazione
---

### 7.5 PdfService

**Percorso:** `lib/features/database/services/pdf_service.dart`

Genera un documento PDF professionale dell'intera collezione di scarpe.

**Struttura del PDF:**
- **Pagina di copertina:** logo dell'app, titolo, data di generazione
- **Pagina profilo utente:** nome, email, data registrazione, numero totale scarpe
- **Una pagina per ogni scarpa:** immagine, marca, taglia, categoria, tipo, stagione, colori, note, date

**Caratteristiche:**
- Font Montserrat incluso come asset locale per rendering uniforme
- Le immagini delle scarpe vengono scaricate dall'URL Firebase Storage durante la generazione
- Callback di progresso (`onProgress`) per la barra di avanzamento nell'UI
- Salvato nella cartella `Downloads` con nome timestamp (`shox_YYYY-MM-DD_HH-mm-ss.pdf`)
- Richiede il permesso `MANAGE_EXTERNAL_STORAGE` su Android

---

### 7.6 Export e Import JSON

**Percorso:** `lib/features/database/controller/database_controller.dart` + `lib/features/database/repository/`

Backup e ripristino della collezione.

**Export JSON:**
- Recupera tutte le scarpe dell'utente da Firestore
- Serializza ogni `ShoesModel` tramite `toFirestore()` in formato JSON
- Salva il file tramite `file_picker` nel percorso scelto dall'utente
- Callback di progresso per la barra di avanzamento

**Import JSON:**
- Apre `file_picker` per selezionare un file JSON precedentemente esportato
- Analizza il JSON e ricrea i `ShoesModel` tramite `fromJson()`
- Inserisce le scarpe importate in Firestore (i duplicati vengono gestiti)
- Callback di progresso per la barra di avanzamento

---

## 8. Tema e stile

**Percorso:** `lib/theme/`

**Font:** Montserrat (regular 400 + bold 700), incluso come asset locale e registrato in `pubspec.yaml` sia come famiglia unica `Montserrat` con i due pesi (usata dal tema: `ThemeData.fontFamily` e `TextTheme`) (le vecchie famiglie `CustomFont`/`CustomFontBold` sono state rimosse; il PDF carica i file per percorso) (nessuna dipendenza `google_fonts` o download a runtime). Utilizzato tramite `TextStyle(fontFamily: 'CustomFont')` per il peso regular e `TextStyle(fontFamily: 'CustomFontBold')` per il peso bold.

**Font icone personalizzate:** `ShoxIcons.ttf` — font vettoriale custom incluso in assets.

**Icona dell'app:** generata con [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) a partire dal logo `assets/images/app_logo.png` (scarpa su scatola). Sono presenti due varianti derivate:
- `assets/images/app_icon_legacy.png` — icona piatta (Android < 8.0), logo al 86% del canvas
- `assets/images/app_icon_foreground.png` — foreground per l'icona adattiva (Android 8.0+), logo al 62% del canvas per rispettare la safe-zone della maschera di sistema

Configurazione in `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  min_sdk_android: 21
  image_path: "assets/images/app_icon_legacy.png"
  adaptive_icon_background: "#F6EFE5"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
```
Rigenerazione dopo modifiche al logo: `dart run flutter_launcher_icons`.

**Temi supportati:**
- **Chiaro** (`AppTheme.lightTheme()`)
- **Scuro** (`AppTheme.darkTheme()`)

Il tema attivo è gestito da `ThemeController` (GetX), selezionabile tra Sistema / Chiaro / Scuro (`ThemeModeApp`) dal selettore nella Dashboard, e persistito in `SharedPreferences` con la chiave `theme_mode`. In modalità Sistema `ThemeController` (con `WidgetsBindingObserver.didChangePlatformBrightness`) aggiorna il tema a runtime quando cambia il tema del dispositivo. Lo stile delle barre di sistema (icone status bar e navigation bar) è calcolato da `AppTheme.overlayStyle(isDark:)` e applicato con un `AnnotatedRegion` attorno a `GetMaterialApp` in `main.dart`; le factory `lightTheme()`/`darkTheme()` non hanno più side effect.

**Palette colori principali (`AppColors`):**

| Nome | Valore | Utilizzo |
|---|---|---|
| `whiteSmoke` | `#F6EFE5` | Sfondo chiaro, background principale |
| `darkGray` | `#342E25` | Testo primario, sfondo scuro |
| `darkPeach` | `#DA7C72` | Colore accent, pulsanti primari |
| `champagne` | `#F0D8B6` | Accent scuro |
| `darkSalamon` | `#E09F7A` | Dettagli, testo in tema scuro |
| `valspar` | `#E7D8C4` | Superfici chiare |
| `valsparDark` | `#463E30` | Superfici (card) in tema scuro |
| `confirmColor` | `#449777` | Successo, conferma |
| `errorColor` | `#D80032` | Errori, eliminazione |
| `mutedText` / `mutedTextDark` | `#6B6158` / `#CDBFAF` | Testo secondario (`onSurfaceVariant`) |
| `outline` / `outlineDark` | `#D9CBB8` / `#6A5F52` | Bordi sottili, chip non selezionati |
| `cardLight` | `#FFFFFF` | Card rialzate in tema chiaro (`surfaceContainerLowest`) |

**Ruoli del `ColorScheme` (semantici):** `surface` = sfondo pagina, `onSurface` = testo principale, `onSurfaceVariant` = testo secondario, `secondary` = accento caldo (pesca / champagne), `primary` = azioni principali (pulsanti pieni, chip selezionati: darkGray in chiaro, champagne in scuro), `surfaceContainerLowest` = card rialzate, `outline` = bordi sottili, `error` = `errorColor`. Le schermate referenziano solo questi ruoli; `progressIndicatorTheme` e `switchTheme` usano l'accento.

**Tipografia e componenti (redesign A):** `AppTheme._textTheme` definisce un'unica scala (headlineMedium 28 titolo dettaglio, headlineSmall 22 titoli schermata, titleMedium 16 app bar, titleSmall 15 titolo card, body 14/16, bodySmall 12 testo secondario, labelLarge 15 pulsanti, labelMedium 13 chip, labelSmall 11 etichette in maiuscolo). I temi dei componenti allineano pulsanti (pieni `primary`, a pillola, altezza 52), campi (riempiti con `surfaceContainerLowest`, senza bordo, bordo `primary` al focus), card, chip, FAB, dialog e bottom sheet (con maniglia). `ButtonWidget` eredita colori, forma e stile del testo dal tema.

**Schermate ridisegnate (redesign A):** splash (logo, nome, tagline), onboarding (illustrazione in card, indicatori a pillola, pulsante Salta che segna l'onboarding come completato), benvenuto (pulsanti Accedi/Registrati a tutta larghezza), home, dettaglio scarpa (top bar con indietro e preferito, foto `AppRadius.hero`, riquadri `InfoTileWidget` taglia/stagione/data aggiunta, card colori e note, azioni Modifica/Condividi/Elimina in basso al posto del menu), form scarpa (area foto grande con Rimuovi sfondo e rimozione, campi in `FormFieldCard` con `OptionCircle`/`ColorDot`, pulsante Salva in basso), profilo (header con avatar, statistiche in griglia di `InfoTileWidget`), modifica ed eliminazione account, database (riepilogo totali + grafici in card). `AppBarWidget` e `TextFieldWidget` ereditano dal tema. Allineate anche dashboard (sezioni in card con `DashboardMenuItem` e `SegmentedButton` a tema), login/registrazione/reset (pulsante Google a tutta larghezza in `GoogleSignInSection`, `AuthSwitchPrompt`), scelta genere, info e supporto (FAQ in card). Il dialog di conferma `DeleteDialogWidget` non ha più la fascia colorata.

**Spaziature (`AppSpacing`, `lib/theme/app_spacing.dart`):** scala unica per padding, margini e gap — `grid` 2, `xxs` 4, `xs` 8, `s` 12, `m` 16, `l` 20, `xl` 24, `xxl` 32, più `screen` 30 per il padding esterno delle pagine. Come `AppRadius` sono valori grezzi: ogni chiamata sceglie lo scaling ScreenUtil adatto all'asse (`AppSpacing.m.r`, `AppSpacing.xs.h`). I pochi valori fuori scala rimasti (es. 88 di spazio per il FAB, 72 in fondo al form) sono casi specifici voluti.

**UI scaling:** Tutto il layout usa `flutter_screenutil` con design size `390×844` px (adattato dinamicamente alle dimensioni reali dello schermo sui tablet) per garantire la proporzionalità su schermi di diverse dimensioni.

**Dimensione del testo di sistema:** i `Text` applicano la dimensione caratteri impostata nel sistema operativo sopra i valori `.sp` di ScreenUtil; `main.dart` la limita a `AppFontSizes.maxTextScaleFactor` (1.3) con `MediaQuery.withClampedTextScaling`, oltre la quale i contenitori ad altezza fissa taglierebbero il testo. Le etichette di `ButtonWidget` si riducono (`FittedBox`) invece di andare in overflow. I widget condivisi sono verificati a scala 1.3 in lingua tedesca (le etichette più lunghe) in `test/common/widgets/text_scaling_test.dart`.

**Layout adattivo (responsive):** oltre allo scaling proporzionale, alcune schermate riorganizzano realmente il contenuto in base alla larghezza disponibile, tramite `LayoutBuilder`:
- `AppBreakpoints` (`lib/theme/app_breakpoints.dart`) — soglie centralizzate (tablet ≥ 600px, desktop ≥ 900px) e calcolo del numero di colonne in base alla larghezza reale
- `ResponsiveCenterWidget` (`lib/common/widgets/responsive_center_widget.dart`) — vincola il contenuto a una larghezza massima e lo centra, evitando che form/liste si stirino edge-to-edge su tablet grandi (usato nella schermata Profilo e, con limite `maxGridWidth`, nella Home)
- La griglia scarpe (Home) calcola il numero di colonne dalla larghezza reale dello schermo, mantenendo come minimo la scelta manuale dell'utente (1/2/3 colonne)
- I grafici a torta (Database) dimensionano canvas e raggio delle sezioni in proporzione alla larghezza reale della card (box quadrato), evitando sovrapposizioni tra torta, titolo e legenda
- L'orientamento dell'app non è più bloccato in verticale (`android:screenOrientation="unspecified"` in `AndroidManifest.xml`), permettendo la rotazione su tablet

**Pulsante condiviso (`ButtonWidget`, `lib/common/widgets/button_widget.dart`):**
- Colori opzionali: di default sfondo `colorScheme.secondary` e testo `colorScheme.primary` (pieno) oppure testo/bordo `secondary` (`isOutline: true`); forma ed elevazione dai `elevatedButtonTheme`/`outlinedButtonTheme` del tema
- `onPressed: null` → pulsante disabilitato (sfondo e testo attenuati)
- `isLoading: true` → sostituisce l'etichetta con uno spinner mantenendo le dimensioni e blocca il tap (usato da login, signup e reset password al posto di un loader separato)
- Altezza minima di 48dp (`ButtonWidget.minTouchTarget`) anche quando `height` scalato è inferiore

---

## 9. Navigazione

L'app usa il sistema di routing di **GetX** con route nominate.

| Route | Schermata | Descrizione |
|---|---|---|
| `/` | IntroScreen | Splash / verifica autenticazione |
| `/onboarding` | OnboardingScreen | Presentazione app (primo avvio) |
| `/welcome` | WelcomeScreen | Benvenuto con accesso a login/signup |
| `/login` | LoginScreen | Accesso Google o email/password |
| `/signup` | SignupScreen | Registrazione nuovo utente |
| `/reset-password` | ResetPasswordScreen | Recupero password |
| `/gender-selection` | GenderSelectionScreen | Selezione genere (primo accesso) |
| `/home` | HomeScreen | Lista scarpe con filtri |
| `/shoes/add` | ShoesAdderScreen | Aggiunta nuova scarpa |
| `/shoes/details` | ShoesDetailsScreen | Dettaglio scarpa |
| `/shoes/update` | ShoesUpdaterScreen | Modifica scarpa |
| `/dashboard` | DashboardScreen | Impostazioni e account |
| `/database` | DatabaseScreen | Statistiche e gestione dati |
| `/info` | InfoScreen | Logo, versione, descrizione, funzioni principali, link (GitHub, sito, contatti, privacy, licenze open source) e crediti |
| `/privacy-policy` | PrivacyPolicyScreen | Informativa privacy nativa (10 sezioni localizzate) |
| `/support` | SupportScreen | Supporto (WebView) |
| `/user` | UserScreen | Profilo utente con statistiche |
| `/user/update` | UserUpdateScreen | Modifica profilo |
| `/user/delete` | UserDeleteScreen | Eliminazione account |

---

## 10. Localizzazione

L'app supporta **5 lingue** tramite il sistema `flutter_localizations` + ARB.

| Codice | Lingua |
|---|---|
| `en` | Inglese |
| `it` | Italiano |
| `fr` | Francese |
| `es` | Spagnolo |
| `de` | Tedesco |

I file ARB si trovano in `lib/l10n/`. La lingua attiva è selezionabile dall'utente nella Dashboard tramite un dropdown ed è persistita in `SharedPreferences` con la chiave `language_code`.

`L10n.parseLocale(String?)` (in `lib/l10n/l10n.dart`) converte il codice salvato in un `Locale` supportato, restituendo `null` se il valore è assente, vuoto o non supportato: in quel caso `MyApp` ricade sul locale di sistema. Il locale iniziale viene risolto **una volta sola** per istanza di `MyApp`, non a ogni rebuild. Funzione pura, coperta da test in `test/l10n/l10n_test.dart`.

---

## 11. Dipendenze

```yaml
dependencies:
  get: ^4.6.6                              # State management e routing
  flutter_screenutil: ^5.9.3               # UI responsive
  ming_cute_icons: ^0.0.7                  # Icone UI
  google_sign_in: ^6.1.5                   # Autenticazione Google
  cloud_firestore: ^5.5.0                  # Database cloud
  firebase_auth: ^5.3.4                    # Autenticazione Firebase
  firebase_core: ^3.9.0                    # Core Firebase
  firebase_storage: ^12.3.7               # Storage immagini
  logger: ^2.5.0                           # Logging
  uuid: ^4.5.1                             # Generazione UUID
  intl: ^0.20.2                            # Formattazione date/localizzazione
  shared_preferences: ^2.3.4              # Persistenza locale
  image: ^4.2.0                            # Manipolazione immagini
  image_picker: ^1.1.2                     # Selezione immagini
  image_cropper: ^11.0.0                   # Ritaglio immagini
  flutter_image_compress: ^2.4.0          # Compressione immagini
  cached_network_image: ^3.4.1            # Cache immagini di rete
  photo_view: ^0.15.0                      # Visualizzazione immagini con zoom
  image_gallery_saver_plus: ^4.0.1        # Salvataggio in galleria
  flutter_cache_manager: ^3.4.1           # Gestione cache
  http: ^1.3.0                             # Richieste HTTP
  fl_chart: ^0.69.0                        # Grafici
  path: ^1.9.0                             # Gestione percorsi
  path_provider: ^2.1.4                    # Percorsi filesystem
  url_launcher: ^6.3.0                     # Apertura URL
  share_plus: ^10.1.3                      # Condivisione file
  permission_handler: ^11.3.1              # Gestione permessi
  pdf: ^3.11.0                             # Generazione PDF
  device_info_plus: ^11.2.0               # Info dispositivo
  file_picker: ^9.0.2                      # Selettore file
  screenshot: ^3.0.0                       # Screenshot widget
  package_info_plus: ^9.0.0               # Info app (versione)
  image_background_remover: ^2.0.0        # Rimozione sfondo con ONNX
  flutter_localizations:                   # Localizzazione Flutter
    sdk: flutter
```

```yaml
dev_dependencies:
  flutter_lints: ^5.0.0                    # Regole di lint
  flutter_launcher_icons: ^0.14.2          # Generazione icone launcher
  change_app_package_name: ^1.4.0          # Rinomina package Android
  intl_utils: ^2.8.7                       # Utility localizzazione
  mocktail: ^1.0.5                         # Mock per i test (Firebase, Google Sign-In, controller)
```

**Test (`flutter test`):** 94 test in `test/`.
- Logica pura: `ShoesFilter`, `ShoesFormData`, `ShoesTextTranslations`, `L10n.parseLocale`, `ShoesGridLayout` (colonne e dimensioni della griglia), `ChangelogService` (quali novità mostrare dopo un aggiornamento)
- Con mock (`mocktail`): `AuthService` (ricerca utente su Firestore, sessione in `SharedPreferences` via `setMockInitialValues`), `LoginRepository` (mappatura errori email/password e Google Sign-In), `ShoesFormService` (aggiunta, modifica, sostituzione e rimozione foto, conservazione del preferito), `AuthGuardService` (widget test con navigazione GetX reale: redirect su sessione scaduta, sign-out volontario, route pubbliche), controller `ShoesController` (aggiunta, modifica, eliminazione, import/export JSON con client HTTP finto), `DatabaseController` (conteggi e statistiche, collezione vuota, errori) e `UserController` (caricamento profilo e nome)
- Layout: widget condivisi a scala testo 1.3 (`test/common/widgets/text_scaling_test.dart`)

`ShoesController` (repository, Firebase Auth, `http.Client`), `UserController` (repository), `LoginRepository`, `AuthGuardService` e `AuthService` accettano le dipendenze (Firebase, Google Sign-In, Firestore) come parametri opzionali del costruttore, con le istanze reali come default, per poterle sostituire nei test.

**Lint (`analysis_options.yaml`):** oltre a `flutter_lints` sono attive `avoid_print`, `prefer_const_constructors`, `prefer_const_declarations`, `use_super_parameters` e `require_trailing_commas`; i file generati da `flutter gen-l10n` (`lib/l10n/app_localizations*.dart`) sono esclusi dall'analisi. Le segnalazioni correggibili si applicano con `dart fix --apply`.

---

## 12. Requisiti di sistema

| Requisito | Valore |
|---|---|
| Flutter SDK | `^3.7.0` |
| Dart SDK | `^3.5.2` |
| Android minimo | API 21 (Android 5.0) |
| Android consigliato | API 26+ (Android 8.0) |
| Android per permessi storage | API 33+ (Android 13) — `READ_MEDIA_IMAGES` |
| Piattaforma principale | Android |
| Connessione internet | Richiesta per autenticazione e sincronizzazione Firestore |
| Account Firebase | Necessario (configurazione `google-services.json`) |

---

## 13. Build e distribuzione

```bash
# Installa le dipendenze
flutter pub get

# Controlla eventuali problemi
flutter doctor

# Avvia in modalità debug
flutter run

# Build APK release
flutter build apk --release

# Build App Bundle (consigliato per Google Play)
flutter build appbundle --release
```

**Configurazione Firebase:**
- Assicurarsi che il file `android/app/google-services.json` sia presente e aggiornato
- Il file `google-services.json` non va committato con credenziali di produzione in repository pubblici

**Firma APK:** Configurare `android/app/build.gradle` con il keystore di produzione prima del build release.

**Note:**
- Il file `android/local.properties` non va committato (contiene percorsi locali SDK)
- La cartella `build/` non va committata (output di compilazione)
- Il modello ONNX per la rimozione dello sfondo (`image_background_remover`) aumenta la dimensione dell'APK

---

## Licenza

Copyright © 2026 **Nicola De Nicolais** — Tutti i diritti riservati.

Licenza: **MIT**

- **Autore:** Nicola De Nicolais
- **Email:** [ndn21dev@gmail.com](mailto:ndn21dev@gmail.com)
- **GitHub:** [https://github.com/ndenicolais](https://github.com/ndenicolais)
