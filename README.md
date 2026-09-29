# Shox

> App per la gestione digitale del guardaroba di scarpe per Android, sviluppata con Flutter.

**Shox** è un'app completa per catalogare la propria collezione di scarpe, con sincronizzazione cloud in tempo reale, filtri avanzati, statistiche visive, export PDF e backup JSON — il tutto con supporto a 5 lingue e tema chiaro/scuro.

## Preview

<img src="images/shox_preview.png" title="Shox's release" alt="Shox Preview">

---

---

## Funzionalità principali

- **Collezione** — Aggiungi, visualizza, modifica ed elimina le tue scarpe con foto, marca, taglia, categoria, tipo, stagione e colori
- **Filtri avanzati** — Filtra per categoria, tipo, stagione, colore primario, colore aggiuntivo o cerca per marca
- **Preferiti** — Contrassegna le scarpe preferite e visualizzale rapidamente
- **Immagini** — Selezione da fotocamera o galleria con ritaglio, compressione automatica e rimozione sfondo (ONNX)
- **Statistiche** — Grafici a torta interattivi per analizzare la collezione per colore, marca, categoria e tipo
- **Export PDF** — Genera un catalogo PDF completo con copertina, profilo utente e scheda per ogni scarpa
- **Backup JSON** — Esporta e importa l'intera collezione in formato JSON
- **Condivisione** — Condividi la scheda di una scarpa come screenshot o salva la foto in galleria
- **Autenticazione** — Login tramite Google Account o email e password
- **Sincronizzazione** — Dati in tempo reale su Cloud Firestore e immagini su Firebase Storage
- **Multilingua** — Italiano, inglese, francese, spagnolo e tedesco
- **Tema** — Supporto a tema chiaro e scuro con design Material 3
- **Layout adattivo** — Riorganizzazione reale del contenuto (non solo scaling) su smartphone e tablet, con rotazione libera dello schermo

---

## Architettura

| Livello | Tecnologia |
|---|---|
| Framework | Flutter 3 / Dart |
| State management | GetX |
| Database cloud | Cloud Firestore |
| Storage immagini | Firebase Storage |
| Autenticazione | Firebase Auth + Google Sign In |
| Persistenza locale | SharedPreferences |
| UI responsive | flutter_screenutil |
| Font | Montserrat (locale) + ShoxIcons (custom) |
| Icone | MingCute Icons |
| Grafici | fl_chart |
| Immagini | image_picker, image_cropper, flutter_image_compress, image_background_remover |
| Export | pdf, share_plus, image_gallery_saver_plus |

---

## Struttura del progetto

```
lib/
├── main.dart                  # Entry point
├── common/                    # Schermate comuni (intro, onboarding, welcome) e widget globali
├── core/                      # Route GetX e utility
├── features/                  # Feature modules
│   ├── auth/                  # Autenticazione (login, signup, reset password, gender selection)
│   ├── dashboard/             # Dashboard (impostazioni, account, info)
│   ├── database/              # Statistiche, export PDF, export/import JSON
│   ├── home/                  # Lista scarpe con filtri e ricerca
│   ├── shoes/                 # CRUD scarpe
│   └── users/                 # Profilo utente
├── l10n/                      # File ARB per localizzazione (en, it, fr, es, de)
└── theme/                     # Tema, colori e controller tema
```

---

## Requisiti

- Flutter SDK `^3.7.0`
- Dart SDK `^3.5.2`
- Android 5.0+ (API 21+)
- Connessione internet (per autenticazione e sincronizzazione Firestore)
- File `android/app/google-services.json` configurato

---

## Installazione e avvio

```bash
# Clona il repository
git clone https://github.com/ndenicolais/Shox.git
cd Shox

# Installa le dipendenze
flutter pub get

# Avvia l'app
flutter run
```

---

## Download

[📥 Download dell'ultima release v4.1.0](https://github.com/ndenicolais/Shox/releases/download/v4.1.0/Shox_v4.1.0.apk)

---

## Documentazione completa

Per una documentazione dettagliata di tutte le funzionalità, modelli dati, schermate e scelte tecniche consulta il file [DOCUMENTATION.md](DOCUMENTATION.md).

---

## Licenza

Copyright © 2026 Nicola De Nicolais — Tutti i diritti riservati.
Licenza: **MIT** — see the [LICENSE.md](LICENSE.md) file for details.

**Autore:** Nicola De Nicolais — [ndn21dev@gmail.com](mailto:ndn21dev@gmail.com) — [GitHub](https://github.com/ndenicolais)
