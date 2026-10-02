// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get intro_title => 'Shox';

  @override
  String get intro_tagline => 'Il tuo guardaroba di scarpe digitale';

  @override
  String get onboarding_skip => 'Salta';

  @override
  String get welcome_subtitle =>
      'Tutta la tua collezione di scarpe, sempre con te.';

  @override
  String get intro_screen_load_data_error =>
      'Impossibile caricare i dati utente';

  @override
  String get onboarding_first_title => 'Aggiungi';

  @override
  String get onboarding_first_description =>
      'Aggiungi tutte le tue scarpe a questa scatola digitale per averle sempre con te. Organizza facilmente la tua collezione e tieni traccia di ogni paio che possiedi a portata di mano.';

  @override
  String get onboarding_second_title => 'Filtra';

  @override
  String get onboarding_second_description =>
      'Filtra rapidamente le tue scarpe preferite utilizzando filtri avanzati. Cerca per marca, modello, colore e altro ancora, e scopri tutte le caratteristiche delle tue scarpe in un attimo.';

  @override
  String get onboarding_third_title => 'Visualizza';

  @override
  String get onboarding_third_description =>
      'Visualizza schede dettagliate delle tue scarpe complete di tutte le loro caratteristiche. Dalle specifiche tecniche alle foto, esplora ogni aspetto delle tue scarpe con un\'interfaccia intuitiva.';

  @override
  String get onboarding_fourth_title => 'Esplora';

  @override
  String get onboarding_fourth_description =>
      'Esplora vari grafici colorati che mostrano statistiche dettagliate sul totale e le specifiche delle tue scarpe nel database.';

  @override
  String get onboarding_next => 'Avanti';

  @override
  String get onboarding_finish => 'Inizia';

  @override
  String get welcome_text => 'Ciao';

  @override
  String get welcome_login => 'Accedi';

  @override
  String get welcome_signup => 'Registrati';

  @override
  String get signup_screen_title => 'Registrazione';

  @override
  String get signup_screen_text => 'Registrati';

  @override
  String get signup_screen_account => 'Hai un account? ';

  @override
  String get signup_screen_login => 'Accedi';

  @override
  String get signup_toast_success => 'Registrazione effettuata con successo!';

  @override
  String get signup_toast_error_email_already_register =>
      'L\'email inserita è già stata registrata come email personale';

  @override
  String get login_screen_title => 'Accesso';

  @override
  String get login_screen_text => 'Accedi';

  @override
  String get login_screen_remember => 'Ricordami';

  @override
  String get login_screen_password => 'Password dimenticata?';

  @override
  String get login_screen_account => 'Non hai un account? ';

  @override
  String get login_screen_signup => 'Registrati';

  @override
  String get login_toast_success => 'Accesso effettuato con successo!';

  @override
  String get login_toast_error_email_not_found =>
      'L\'email inserita non corrisponde ad alcun account';

  @override
  String get login_toast_error_invalid_password =>
      'La password inserita non corrisponde ad alcun account';

  @override
  String get session_expired_message =>
      'La sessione è scaduta. Accedi di nuovo.';

  @override
  String get startup_error_message =>
      'Impossibile avviare l\'app. Controlla la connessione a internet e riprova.';

  @override
  String get login_toast_error_network =>
      'Impossibile contattare Google. Controlla la connessione a internet e riprova.';

  @override
  String get login_toast_error_generic => 'Errore durante il login:';

  @override
  String get logout_toast_success => 'A presto!';

  @override
  String get reset_password_screen_title => 'Reimposta Password';

  @override
  String get reset_password_screen_description =>
      'Inserisci la tua email per ricevere il link con la procedura per il reset della password';

  @override
  String get reset_password_screen_text => 'Reimposta password';

  @override
  String get reset_password_form_email => 'Email';

  @override
  String get reset_password_form_email_field => 'Inserisci l\'email';

  @override
  String get reset_password_toast_success =>
      'Email per il reset della password inviata a: ';

  @override
  String get reset_password_toast_error_email_not_found =>
      'L\'email inserita non è registrata';

  @override
  String get reset_password_toast_error_password =>
      'Errore durante il reset della password';

  @override
  String get gender_selection_screen_title => 'Seleziona Genere';

  @override
  String get gender_selection_screen_description =>
      'Questo ci aiuterà a personalizzare la tua esperienza di gestione della collezione di scarpe';

  @override
  String get gender_selection_button => 'Continua';

  @override
  String get gender_selection_toast_success =>
      'Preferenza salvata con successo!';

  @override
  String get gender_selection_toast_error =>
      'Errore durante il salvataggio della preferenza';

  @override
  String get gender_male => 'Uomo';

  @override
  String get gender_female => 'Donna';

  @override
  String get validator_name => 'Nome';

  @override
  String get validator_name_empty => 'Il nome non può essere vuoto';

  @override
  String get validator_name_hint => 'Inserisci il tuo nome';

  @override
  String get validator_name_required => 'Nome è richiesto';

  @override
  String get validator_email => 'Email';

  @override
  String get validator_email_missing_special => 'Simbolo @ mancante';

  @override
  String get validator_email_missing_dot => 'Simbolo . mancante';

  @override
  String get validator_email_hint => 'Inserisci la tua email';

  @override
  String get validator_email_required => 'Email è richiesta';

  @override
  String get validator_password => 'Password';

  @override
  String get validator_password_missing_upper => 'Lettera maiuscola mancante';

  @override
  String get validator_password_missing_lower => 'Lettera minuscola mancante';

  @override
  String get validator_password_missing_digit => 'Numero mancante';

  @override
  String get validator_password_missing_special =>
      'Carattere speciale mancante';

  @override
  String get validator_password_missing_lenght =>
      'La password deve avere una lunghezza di almeno 8 caratteri';

  @override
  String get validator_password_hint => 'Inserisci la tua password';

  @override
  String get validator_password_required => 'Password è richiesta';

  @override
  String get permission_storage_denied => 'Permesso di archiviazione negato';

  @override
  String get permission_storage_toast =>
      'Concedi il permesso di archiviazione dalle impostazioni';

  @override
  String get home_screen_welcome_text => 'Ciao';

  @override
  String get home_screen_search_bar => 'Cerca marca, tipo, note';

  @override
  String get home_screen_filter_title => 'Filtra';

  @override
  String get home_screen_filter_color_primary => 'Colore Primario';

  @override
  String get home_screen_filter_category => 'Categoria';

  @override
  String get home_screen_filter_type => 'Tipo';

  @override
  String get home_screen_filter_season => 'Stagione';

  @override
  String get home_screen_filter_reset => 'Azzera';

  @override
  String get home_screen_filter_apply => 'Applica';

  @override
  String get home_screen_error_state => 'Errore nel caricamento dei dati';

  @override
  String get home_screen_empty_state => 'Nessuna scarpa presente nel box';

  @override
  String get home_screen_no_results_state =>
      'Nessuna scarpa corrisponde ai filtri selezionati';

  @override
  String get home_screen_no_results_reset => 'Azzera filtri';

  @override
  String get home_screen_title => 'La tua collezione';

  @override
  String get home_screen_add => 'Aggiungi';

  @override
  String get home_screen_chip_all => 'Tutte';

  @override
  String get home_screen_chip_favorites => 'Preferite';

  @override
  String home_screen_pairs_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paia',
      one: '1 paio',
    );
    return '$_temp0';
  }

  @override
  String home_screen_favorites_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preferite',
      one: '1 preferita',
    );
    return '$_temp0';
  }

  @override
  String home_screen_card_size(String size) {
    return 'Tg. $size';
  }

  @override
  String get shoes_adder_screen_title => 'Aggiungi Scarpe';

  @override
  String get shoes_adder_screen_field_color_primary => 'Primario';

  @override
  String get shoes_adder_screen_field_brand => 'Brand';

  @override
  String get shoes_adder_screen_field_size => 'Taglia';

  @override
  String get shoes_adder_screen_field_category => 'Categoria';

  @override
  String get shoes_adder_screen_field_type => 'Tipo';

  @override
  String get shoes_adder_screen_select_category => 'Seleziona una categoria';

  @override
  String get shoes_adder_screen_select_type => 'Seleziona un tipo';

  @override
  String get shoes_adder_screen_field_season => 'Stagione';

  @override
  String get shoes_adder_screen_field_note => 'Note';

  @override
  String get shoes_form_screen_section_colors => 'Colori';

  @override
  String get shoes_form_screen_section_details => 'Dettagli';

  @override
  String get shoes_form_screen_section_notes => 'Note';

  @override
  String get shoes_form_screen_add_photo => 'Aggiungi foto';

  @override
  String get shoes_form_screen_save => 'Salva';

  @override
  String get shoes_adder_screen_crop_image_title => 'Ritaglia Immagine';

  @override
  String get shoes_adder_screen_toast_error_image =>
      'Non hai selezionato un\'immagine';

  @override
  String get shoes_adder_screen_toast_error_color =>
      'Non hai selezionato il colore primario';

  @override
  String get shoes_adder_screen_toast_error_brand =>
      'Non hai inserito il brand';

  @override
  String get shoes_adder_screen_toast_error_category =>
      'Non hai selezionato una categoria';

  @override
  String get shoes_adder_screen_toast_error_type =>
      'Non hai selezionato un tipo';

  @override
  String get shoes_adder_screen_toast_success =>
      'Scarpe aggiunte con successo!';

  @override
  String get shoes_adder_screen_toast_error => 'Errore dureante il salvataggio';

  @override
  String get shoes_form_screen_bg_remove_loading => 'Rimozione dello sfondo...';

  @override
  String get shoes_form_screen_bg_remove_downloading =>
      'Sto preparando la rimozione dello sfondo sul dispositivo: riprova tra qualche istante.';

  @override
  String get shoes_form_screen_bg_remove_success =>
      'Sfondo rimosso con successo';

  @override
  String get shoes_form_screen_bg_remove_error => 'Errore rimozione sfondo: ';

  @override
  String get shoes_updater_screen_title => 'Aggiorna Scarpe';

  @override
  String get shoes_updater_screen_toast_success =>
      'Scarpe modificate con successo!';

  @override
  String get shoes_details_screen_title => 'Dettagli Scarpe';

  @override
  String get shoes_details_screen_field_color => 'COLORI';

  @override
  String get shoes_details_screen_field_color_primary => 'Primario';

  @override
  String get shoes_details_screen_field_size => 'TAGLIA';

  @override
  String get shoes_details_screen_field_season => 'STAGIONE';

  @override
  String get shoes_details_screen_field_note => 'NOTE';

  @override
  String get shoes_details_screen_field_added => 'Aggiunta';

  @override
  String get shoes_details_screen_menu_edit => 'Modifica';

  @override
  String get shoes_details_screen_menu_share => 'Condividi';

  @override
  String get shoes_details_screen_menu_delete => 'Elimina';

  @override
  String get shoes_details_screen_share_success =>
      'Screenshot condiviso con successo!';

  @override
  String get shoes_details_screen_share_error =>
      'Errore durante la condivisione dello screenshot';

  @override
  String get shoes_details_screen_error_state =>
      'Errore nel caricamento dei dati';

  @override
  String get shoes_details_screen_empty_state => 'Nessun scarpa trovata';

  @override
  String get shoes_details_screen_delete_title => 'Elimina';

  @override
  String get shoes_details_screen_delete_description =>
      'Sei sicuro di voler eliminare queste scarpe?';

  @override
  String get shoes_details_screen_delete_toast_success => 'Scarpe eliminate!';

  @override
  String get user_screen_title => 'Profilo';

  @override
  String get user_screen_button_database => 'Database';

  @override
  String get user_screen_button_delete => 'Elimina Account';

  @override
  String get user_updater_screen_title => 'Modifica Profilo';

  @override
  String get user_updater_screen_crop_image_title => 'Ritaglia Immagine';

  @override
  String get user_updater_screen_save => 'Salva';

  @override
  String get user_updater_screen_username_field_error =>
      'Non hai inserito il nome';

  @override
  String get database_screen_title => 'Database';

  @override
  String get database_screen_empty => 'Nessuna scarpa presente nel box';

  @override
  String get database_screen_colors => 'Colori';

  @override
  String get database_screen_brands => 'Brands';

  @override
  String get database_screen_categories => 'Categorie';

  @override
  String get database_screen_types => 'Tipi';

  @override
  String get database_screen_pdf_download => 'Scarica PDF';

  @override
  String get database_screen_pdf_confirm => 'PDF salvato in Download/Shox';

  @override
  String get database_screen_pdf_error => 'Impossibile generare il PDF';

  @override
  String get database_screen_export_menu => 'Esporta JSON';

  @override
  String get database_screen_import_menu => 'Importa JSON';

  @override
  String get database_screen_export_success =>
      'JSON esportato nella cartella Download';

  @override
  String get database_screen_export_error => 'Errore durante l\'esportazione';

  @override
  String get database_screen_import_success => 'JSON importato con successo!';

  @override
  String get database_screen_import_error => 'Errore durante l\'importazione';

  @override
  String get delete_account_screen_title => 'Elimina Account';

  @override
  String get delete_account_screen_toast_success => 'Account eliminato!';

  @override
  String get delete_account_screen_toast_error =>
      'Errore durante il processo di eliminazione:';

  @override
  String get delete_account_screen_delete_dialog_title =>
      'Conferma eliminazione';

  @override
  String get delete_account_screen_delete_dialog_text =>
      'Sei sicuro di voler eliminare in modo permanente il tuo account?';

  @override
  String get delete_account_screen_text_a =>
      'Sei davvero sicuro di voler eliminare il tuo account?';

  @override
  String get delete_account_screen_text_b =>
      'Questa è un azione irreversibile e tutti i dati legati a questo account verranno eliminati in modo permanente senza possibilità di recupero.';

  @override
  String get delete_account_screen_text_c =>
      'Per proseguire clicca sul pulsante qui sotto';

  @override
  String get delete_account_screen_delete_button => 'Elimina';

  @override
  String get delete_account_screen_backup_title => 'Esporta i Tuoi Dati';

  @override
  String get delete_account_screen_backup_text =>
      'Prima di eliminare il tuo account, desideri scaricare un backup del tuo database di scarpe in formato JSON? Questo ti aiuterà a preservare i tuoi dati.';

  @override
  String get delete_account_screen_backup_button => 'Scarica Backup';

  @override
  String get delete_account_screen_skip_backup => 'Salta';

  @override
  String get delete_account_screen_backup_success =>
      'Database esportato con successo!';

  @override
  String get delete_account_screen_backup_error =>
      'Errore durante l\'esportazione:';

  @override
  String get delete_account_screen_what_happens => 'Cosa succederà?';

  @override
  String get delete_account_screen_item_a =>
      'Il tuo profilo e le credenziali di accesso verranno rimossi definitivamente';

  @override
  String get delete_account_screen_item_b =>
      'Tutte le scarpe salvate nel tuo database verranno eliminate';

  @override
  String get delete_account_screen_item_c =>
      'Le immagini associate alle tue scarpe verranno cancellate';

  @override
  String get settings_screen_language => 'Lingua';

  @override
  String get settings_screen_info => 'Info';

  @override
  String get settings_screen_policy => 'Privacy Policy';

  @override
  String get settings_screen_support => 'Help Desk';

  @override
  String get info_screen_title => 'Info';

  @override
  String get policy_screen_title => 'Privacy Policy';

  @override
  String info_screen_version(String version) {
    return 'Versione $version';
  }

  @override
  String get info_screen_about_title => 'Cos\'è Shox';

  @override
  String get info_screen_about_text =>
      'Shox è il tuo guardaroba di scarpe digitale: fotografa ogni paio, annota marca, taglia, colori e stagione e ritrova subito quello che cerchi. Il nome unisce «Shoes» e «Box», la scatola che contiene tutta la tua collezione.';

  @override
  String get info_screen_features_title => 'Cosa puoi fare';

  @override
  String get info_screen_feature_collection_title => 'Cataloga';

  @override
  String get info_screen_feature_collection_text =>
      'Foto con rimozione dello sfondo, marca, taglia, categoria, colori e note.';

  @override
  String get info_screen_feature_search_title => 'Ritrova';

  @override
  String get info_screen_feature_search_text =>
      'Ricerca, filtri rapidi per categoria e preferiti.';

  @override
  String get info_screen_feature_stats_title => 'Analizza';

  @override
  String get info_screen_feature_stats_text =>
      'Statistiche della collezione ed esportazione in PDF.';

  @override
  String get info_screen_feature_backup_title => 'Conserva';

  @override
  String get info_screen_feature_backup_text =>
      'Backup e ripristino della collezione in formato JSON.';

  @override
  String get info_screen_links_title => 'Link utili';

  @override
  String get info_screen_link_source => 'Codice sorgente';

  @override
  String get info_screen_link_website => 'Sito dello sviluppatore';

  @override
  String get info_screen_link_contact => 'Contatta lo sviluppatore';

  @override
  String get info_screen_link_licenses => 'Licenze open source';

  @override
  String info_screen_made_by(String name) {
    return 'Ideato e sviluppato da $name';
  }

  @override
  String policy_screen_updated(String date) {
    return 'Ultimo aggiornamento: $date';
  }

  @override
  String get policy_screen_intro =>
      'Questa informativa spiega quali dati tratta Shox, perché e come puoi gestirli. Shox non mostra pubblicità, non usa strumenti di analisi e non vende né cede i tuoi dati.';

  @override
  String get policy_section_controller_title => 'Titolare del trattamento';

  @override
  String policy_section_controller_text(String name, String email) {
    return 'Il titolare è lo sviluppatore dell\'app, $name. Per qualsiasi richiesta sulla privacy puoi scrivere a $email.';
  }

  @override
  String get policy_section_data_title => 'Dati che raccogliamo';

  @override
  String get policy_section_data_text =>
      '• Account: email, nome, foto del profilo (facoltativa), genere, data di registrazione. Con l\'accesso Google riceviamo nome, email e foto del profilo del tuo account Google.\n• Collezione: per ogni scarpa foto, marca, taglia, categoria, tipo, stagione, colori, note, preferito e date di inserimento e modifica.\n• Sul dispositivo: preferenze come lingua, tema, «ricordami» e le schermate già viste.';

  @override
  String get policy_section_use_title => 'Come usiamo i dati';

  @override
  String get policy_section_use_text =>
      'I dati servono solo a far funzionare l\'app: accedere al tuo account, salvare e mostrare la tua collezione, calcolare le statistiche e generare i file che esporti. Non li usiamo per profilazione o pubblicità.';

  @override
  String get policy_section_storage_title => 'Dove sono conservati';

  @override
  String get policy_section_storage_text =>
      'Account, collezione e foto sono conservati su Google Firebase (Authentication, Cloud Firestore e Cloud Storage), un servizio di Google LLC che può trattare i dati anche fuori dall\'Unione Europea con le garanzie previste dalle sue condizioni. I dati sono collegati al tuo account e non sono visibili ad altri utenti.';

  @override
  String get policy_section_device_title => 'Elaborazione sul dispositivo';

  @override
  String get policy_section_device_text =>
      'La rimozione dello sfondo delle foto avviene interamente sul tuo telefono: la foto non viene inviata a servizi esterni. I file PDF e JSON che esporti vengono salvati sul dispositivo e condivisi solo se lo scegli tu.';

  @override
  String get policy_section_permissions_title => 'Permessi';

  @override
  String get policy_section_permissions_text =>
      '• Fotocamera e foto: per scattare o scegliere le immagini delle scarpe e del profilo.\n• Memoria: per salvare le foto in galleria e i file esportati.\n• Internet: per sincronizzare account e collezione.';

  @override
  String get policy_section_retention_title => 'Conservazione e cancellazione';

  @override
  String get policy_section_retention_text =>
      'Conserviamo i dati finché il tuo account esiste. Da Profilo > Elimina account puoi cancellare in qualsiasi momento l\'account, tutta la collezione e le foto; prima puoi esportarne una copia. Le preferenze sul dispositivo vengono rimosse disinstallando l\'app.';

  @override
  String get policy_section_rights_title => 'I tuoi diritti';

  @override
  String get policy_section_rights_text =>
      'Puoi accedere ai tuoi dati ed esportarli (PDF e JSON), correggerli modificando profilo e scarpe, cancellarli eliminando l\'account e chiedere informazioni scrivendo al titolare. Puoi anche presentare reclamo all\'autorità per la protezione dei dati del tuo paese.';

  @override
  String get policy_section_children_title => 'Minori';

  @override
  String get policy_section_children_text =>
      'Shox non è rivolta a minori di 14 anni e non raccoglie consapevolmente i loro dati.';

  @override
  String get policy_section_changes_title => 'Modifiche';

  @override
  String get policy_section_changes_text =>
      'Se questa informativa cambia, la nuova versione sarà disponibile nell\'app e online, con la data di aggiornamento.';

  @override
  String get policy_screen_online => 'Leggi la versione online';

  @override
  String get support_screen_title => 'Supporto';

  @override
  String get support_screen_contacts_text => 'Contattaci';

  @override
  String get support_screen_contacts_decription =>
      'Per qualsiasi problema o domanda, scrivi a:';

  @override
  String get support_screen_contacts_info => 'ndn21dev@gmail.com';

  @override
  String get support_screen_faq_text => 'FAQ';

  @override
  String get support_screen_faq_decription =>
      'Trova risposte alle domande più frequenti.';

  @override
  String get support_screen_faq_q1 => 'Come aggiungere un paio di scarpe?';

  @override
  String get support_screen_faq_a1 =>
      'Per aggiungere un paio di scarpe, vai nella Home e clicca sul pulsante \'+\'. Compila tutti i dettagli necessari e salva.';

  @override
  String get support_screen_faq_q2 => 'Come modificare un paio di scarpe?';

  @override
  String get support_screen_faq_a2 =>
      'Per modificare un paio di scarpe, scegli il riquadro delle scarpe che desideri modificare e cliccalo. Una volta aperto clicca sull icona in alto a destra e scegli l\'opzione \'Modifica\'. Apporta le modifiche e salva.';

  @override
  String get support_screen_faq_q3 => 'Come eliminare un paio di scarpe?';

  @override
  String get support_screen_faq_a3 =>
      'Per eliminare un paio di scarpe, scegli il riquadro delle scarpe che desideri modificare e cliccalo. Una volta aperto clicca sull icona in alto a destra e scegli l\'opzione \'Elimina\'.';

  @override
  String get support_screen_faq_q4 =>
      'Cosa succede se elimino un paio di scarpe?';

  @override
  String get support_screen_faq_a4 =>
      'Se elimini un paio di scarpe, questo verrà rimosso permanentemente. Ti verrà chiesto di confermare prima di procedere all\'operazione.';

  @override
  String get support_screen_faq_q8 => 'Come posso fare se l\'app non funziona?';

  @override
  String get support_screen_faq_a8 =>
      'Chiudi l\'app anche da background > Impostazioni app > Elimina dati > Svuota la cache > Riavvia l\'app. Se il problema persiste contatta il supporto tecnico.';

  @override
  String get support_screen_faq_q9 => 'Come funziona il download del PDF?';

  @override
  String get support_screen_faq_a9 =>
      'Per scaricare il tuo database in formato PDF vai nella sezione Profilo > Database > Clicca sull\'icona in alto a destra > Scarica PDF.';

  @override
  String get support_screen_faq_q10 =>
      'Come funziona l\'import del JSON database?';

  @override
  String get support_screen_faq_a10 =>
      'Puoi importare il database in formato JSON (se precedentemente esportato dall\'app).';

  @override
  String get support_screen_faq_q11 =>
      'Come funziona l\'export del JSON database?';

  @override
  String get support_screen_faq_a11 =>
      'Puoi esportare il database in formato JSON in modo da preservare i dati attuali presenti in database e poi poterli importare su un altro dispositivo tramite l\'app.';

  @override
  String get support_screen_documentation_text => 'Documentazione';

  @override
  String get support_screen_documentation_decription =>
      'Consulta la documentazione completa nella pagina web dell\'app.';

  @override
  String get support_screen_documentation_info =>
      'Vai alla pagina web su GitHub';

  @override
  String get color_white => 'Bianco';

  @override
  String get color_black => 'Nero';

  @override
  String get color_light_grey => 'Grigio Chiaro';

  @override
  String get color_dark_grey => 'Grigio Scuro';

  @override
  String get color_orange => 'Arancione';

  @override
  String get color_pink => 'Rosa';

  @override
  String get color_red => 'Rosso';

  @override
  String get color_bordeaux => 'Bordeaux';

  @override
  String get color_camel => 'Cammello';

  @override
  String get color_beige => 'Beige';

  @override
  String get color_light_brown => 'Marrone Chiaro';

  @override
  String get color_dark_brown => 'Marrone Scuro';

  @override
  String get color_yellow => 'Giallo';

  @override
  String get color_green => 'Verde';

  @override
  String get color_light_blue => 'Blu Chiaro';

  @override
  String get color_dark_blue => 'Blu Scuro';

  @override
  String get category_sneakers => 'Sneakers';

  @override
  String get category_elegant => 'Eleganti';

  @override
  String get category_heeled => 'Con tacco';

  @override
  String get category_sandals => 'Sandali';

  @override
  String get category_mules => 'Ciabatte';

  @override
  String get category_boots => 'Stivali';

  @override
  String get category_other => 'Altro';

  @override
  String get type_sport => 'Sportive';

  @override
  String get type_casual => 'Informali';

  @override
  String get type_lifestyle => 'Lifestyle';

  @override
  String get type_running => 'Da corsa';

  @override
  String get type_dressy => 'Eleganti';

  @override
  String get type_loafers => 'Mocassini';

  @override
  String get type_decollete => 'Decolleté';

  @override
  String get type_spuntas => 'Spuntate';

  @override
  String get type_wedge => 'Con zeppa';

  @override
  String get type_lace_up => 'Francesine';

  @override
  String get type_flat => 'Basse';

  @override
  String get type_heeled => 'Con tacco';

  @override
  String get type_ankle_boots => 'Stivaletti';

  @override
  String get type_high_boots => 'Stivali alti';

  @override
  String get type_work_boots => 'Stivali da lavoro';

  @override
  String get type_knee_high => 'Al ginocchio';

  @override
  String get type_classic => 'Classiche';

  @override
  String get type_other => 'Altro';

  @override
  String get pdf_field_color_primary => 'Colore Primario';

  @override
  String get pdf_field_size => 'Taglia';

  @override
  String get pdf_field_notes => 'Note';

  @override
  String get pdf_copyright => '© 2024 Nicola De Nicolais';

  @override
  String get pdf_cover_title => 'La mia collezione';

  @override
  String pdf_cover_generated(String date) {
    return 'Generato il $date';
  }

  @override
  String get pdf_summary_title => 'Riepilogo';

  @override
  String get pdf_summary_top_brands => 'Brand più presenti';

  @override
  String get pdf_summary_top_colors => 'Colori più presenti';

  @override
  String get pdf_field_extra_colors => 'Colori extra';

  @override
  String get full_screen_image_save_success_toast =>
      'Immagine salvata con successo!';

  @override
  String get full_screen_image_save_error_toast => 'Errore';

  @override
  String get full_screen_image_download_error_toast =>
      'Download dell\'immagine non riuscito.';

  @override
  String get full_screen_image_share_success_toast =>
      'Immagine condivisa con successo!';

  @override
  String get full_screen_image_share_download_error_toast =>
      'Download dell\'immagine per la condivisione non riuscito.';

  @override
  String get full_screen_image_share_error_toast => 'Errore';

  @override
  String get shoes_form_screen_unsaved_title => 'Modifiche non salvate';

  @override
  String get shoes_form_screen_unsaved_text =>
      'Se esci ora perderai le modifiche fatte a questa scarpa.';

  @override
  String get shoes_form_screen_unsaved_stay => 'Resta';

  @override
  String get shoes_form_screen_unsaved_leave => 'Esci';

  @override
  String get custom_delete_dialog_confirm => 'Elimina';

  @override
  String get custom_delete_dialog_cancel => 'Annulla';

  @override
  String get auth_or_continue_with => 'O continua con';

  @override
  String get auth_sign_in_with_google => 'Accedi con Google';

  @override
  String get common_retry => 'Riprova';

  @override
  String get dashboard_screen_title => 'Dashboard';

  @override
  String get dashboard_preferences => 'Preferenze';

  @override
  String get dashboard_theme => 'Tema';

  @override
  String get theme_mode_system => 'Sistema';

  @override
  String get theme_mode_light => 'Chiaro';

  @override
  String get theme_mode_dark => 'Scuro';

  @override
  String get dashboard_account => 'Account';

  @override
  String get dashboard_profile => 'Profilo';

  @override
  String get dashboard_logout => 'Esci';

  @override
  String get dashboard_share_app => 'Condividi';

  @override
  String get dashboard_version => 'Versione';

  @override
  String get dashboard_information => 'App';

  @override
  String get dashboard_changelog => 'Changelog';

  @override
  String get a11y_profile => 'Profilo';

  @override
  String get a11y_settings => 'Impostazioni';

  @override
  String get a11y_add_shoe => 'Aggiungi scarpa';

  @override
  String get a11y_filters => 'Filtri';

  @override
  String get a11y_clear_search => 'Cancella ricerca';

  @override
  String get a11y_toggle_grid => 'Cambia disposizione griglia';

  @override
  String get a11y_add_to_favorites => 'Aggiungi ai preferiti';

  @override
  String get a11y_remove_from_favorites => 'Rimuovi dai preferiti';

  @override
  String get a11y_open_image => 'Apri immagine a schermo intero';

  @override
  String get a11y_download_image => 'Scarica immagine';

  @override
  String get a11y_share_image => 'Condividi immagine';

  @override
  String get a11y_take_photo => 'Scatta una foto';

  @override
  String get a11y_pick_from_gallery => 'Scegli dalla galleria';

  @override
  String get a11y_remove_image => 'Rimuovi immagine';

  @override
  String get a11y_remove_background => 'Rimuovi sfondo';

  @override
  String get a11y_edit_profile => 'Modifica profilo';

  @override
  String get a11y_change_profile_photo => 'Cambia foto profilo';

  @override
  String get a11y_loading => 'Caricamento in corso';

  @override
  String get changelog_dialog_title => 'Novità';

  @override
  String get changelog_dialog_close => 'Chiudi';

  @override
  String get changelog_v5_0_0_bullet_1 =>
      'Nuova veste grafica per tutta l\'app, con la calda palette originale: home con filtri rapidi per categoria, schede scarpa e modulo di aggiunta ridisegnati, nuovi profilo, statistiche, impostazioni e schermate di accesso.';

  @override
  String get changelog_v5_0_0_bullet_2 =>
      'Nuovo selettore di tema Sistema / Chiaro / Scuro, che segue subito il passaggio chiaro/scuro del telefono.';

  @override
  String get changelog_v5_0_0_bullet_3 =>
      'Home più fluida: anteprima della griglia durante il caricamento, dissolvenze, trascina in basso per aggiornare e foto che riempiono sempre la casella.';

  @override
  String get changelog_v5_0_0_bullet_4 =>
      'Ricerca anche per tipo, categoria e note; filtri più affidabili, con un messaggio dedicato e un pulsante per azzerarli quando non c\'è nessun risultato.';

  @override
  String get changelog_v5_0_0_bullet_5 =>
      'Modulo scarpa: conferma prima di uscire con modifiche non salvate; modificare una scarpa non la toglie più dai preferiti e la foto è sempre obbligatoria.';

  @override
  String get changelog_v5_0_0_bullet_6 =>
      'Accesso più affidabile: messaggi d\'errore chiari con Google, schermata Riprova se l\'app non si avvia e ritorno alla schermata di benvenuto se la sessione scade.';

  @override
  String get changelog_v5_0_0_bullet_7 =>
      'Layout adattivo per smartphone e tablet con rotazione libera, testo che segue la dimensione dei caratteri del telefono fino al 130% e pulsanti leggibili dagli screen reader.';

  @override
  String get changelog_v5_0_0_bullet_8 =>
      'Eliminazione dell\'account spostata nella schermata Profilo.';

  @override
  String get changelog_v5_0_0_bullet_9 =>
      'Corretti i grafici sovrapposti nella sezione database.';

  @override
  String get changelog_v5_0_0_bullet_10 =>
      'Nuova finestra delle novità, che mostra cosa cambia dopo ogni aggiornamento.';

  @override
  String get changelog_v5_0_0_bullet_11 =>
      'Nuova sezione Info e informativa privacy aggiornata, leggibile direttamente nell\'app in tutte le lingue.';

  @override
  String get changelog_v5_0_0_bullet_12 =>
      'Rimozione dello sfondo più precisa: niente più bordino o alone attorno alla scarpa.';

  @override
  String get changelog_v5_0_0_bullet_13 =>
      'App più leggera: occupa circa la metà dello spazio rispetto alla versione precedente.';

  @override
  String get changelog_v5_0_0_bullet_14 =>
      'Il colore rosso ora viene riconosciuto correttamente nelle statistiche e nei dettagli (prima appariva come bianco).';

  @override
  String get changelog_v5_0_0_bullet_15 =>
      'In tema scuro lo sfondo delle foto delle scarpe ora è un tono più tenue e meno invadente.';

  @override
  String get changelog_v5_0_0_bullet_16 =>
      'Tradotti alcuni testi che comparivano ancora in inglese.';

  @override
  String get changelog_v5_0_0_bullet_17 =>
      'L\'esportazione in PDF ora funziona anche con scarpe che hanno colori extra, una foto non disponibile non blocca più l\'intero documento e il file viene salvato in Download/Shox, visibile nell\'app File.';

  @override
  String get changelog_v5_0_0_bullet_18 =>
      'Mentre scrivi il brand, l\'app suggerisce quelli già presenti nella tua collezione per inserirli più velocemente.';

  @override
  String get changelog_v5_0_0_bullet_19 =>
      'Nuovo PDF della collezione: copertina, pagina di riepilogo con statistiche e una scheda ridisegnata per ogni scarpa, in un file fino a 8 volte più leggero e più veloce da generare.';

  @override
  String get user_screen_total_shoes => 'Scarpe totali';

  @override
  String get user_screen_member_since => 'Iscritto dal';

  @override
  String get user_screen_favorite_brand => 'Marca preferita';

  @override
  String get user_screen_most_used_category => 'Categoria preferita';

  @override
  String get user_screen_most_used_type => 'Tipo preferito';

  @override
  String get user_screen_most_used_color => 'Colore preferito';

  @override
  String get user_screen_last_added => 'Ultima aggiunta';

  @override
  String get user_screen_favorites_count => 'Preferiti';

  @override
  String get full_screen_image_share_text => 'Guarda questa immagine!';

  @override
  String get extra_colors => 'Extra';
}
