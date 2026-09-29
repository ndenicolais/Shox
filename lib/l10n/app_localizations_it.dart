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
  String get signup_toast_error_generic => 'Errore durante la registrazione:';

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
  String get logout_toast_error_generic => 'Errore durante il logout';

  @override
  String get reset_password_screen_title => 'Reset Password';

  @override
  String get reset_password_screen_description =>
      'Inserisci la tua email per ricevere il link con la procedura per il reset della password';

  @override
  String get reset_password_screen_text => 'Reset password';

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
  String get gender_selection_screen_subtitle => 'Scegli il Tuo Genere';

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
  String get gender_other => 'Altro';

  @override
  String get validator_name => 'Nome';

  @override
  String get validator_name_empty => 'Il nome non può essere vuoto';

  @override
  String get validator_name_hint => 'Inserisci il tuo nome';

  @override
  String get validator_name_required => 'Nome è richiesto';

  @override
  String get validator_name_error => 'Nome non valido: ';

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
  String get validator_email_error => 'Email non valida: ';

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
  String get validator_password_error => 'Password non valida: ';

  @override
  String get permission_storage_denied => 'Permesso di archiviazione negato';

  @override
  String get permission_storage_toast =>
      'Concedi il permesso di archiviazione dalle impostazioni';

  @override
  String get permission_camera_denied => 'Permesso fotocamera negato';

  @override
  String get permission_camera_toast =>
      'Concedi il permesso della fotocamera dalle impostazioni';

  @override
  String get home_screen_welcome_text => 'Ciao';

  @override
  String get home_screen_search_bar => 'Cerca per Brand';

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
  String get home_screen_filter_reset => 'Reset';

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
  String get shoes_form_screen_section_photo => 'Foto';

  @override
  String get shoes_form_screen_section_colors => 'Colori';

  @override
  String get shoes_form_screen_section_details => 'Dettagli';

  @override
  String get shoes_form_screen_section_notes => 'Note';

  @override
  String get shoes_form_screen_add_photo => 'Aggiungi foto';

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
  String get shoes_adder_screen_toast_error_size =>
      'Non hai inserito la taglia';

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
  String get shoes_form_screen_bg_remove_success =>
      'Sfondo rimosso con successo';

  @override
  String get shoes_form_screen_bg_remove_error => 'Errore rimozione sfondo: ';

  @override
  String get shoes_updater_screen_title => 'Aggiorna Scarpe';

  @override
  String get shoes_updater_screen_field_color_primary => 'Colore Primario';

  @override
  String get shoes_updater_screen_field_brand => 'Brand';

  @override
  String get shoes_updater_screen_field_size => 'Taglia';

  @override
  String get shoes_updater_screen_field_category => 'Categoria';

  @override
  String get shoes_updater_screen_field_type => 'Tipo';

  @override
  String get shoes_updater_screen_field_season => 'Stagione';

  @override
  String get shoes_updater_screen_field_note => 'Note';

  @override
  String get shoes_updater_screen_crop_image_title => 'Ritaglia Immagine';

  @override
  String get shoes_updater_screen_toast_error_brand =>
      'Non hai inserito il brand';

  @override
  String get shoes_updater_screen_toast_error_size =>
      'Non hai inserito la taglia';

  @override
  String get shoes_updater_screen_toast_success =>
      'Scarpe modificate con successo!';

  @override
  String get shoes_updater_screen_toast_error =>
      'Errore durante l\'aggiornamento';

  @override
  String get shoes_details_screen_title => 'Dettagli Scarpe';

  @override
  String get shoes_details_screen_field_color => 'COLORI';

  @override
  String get shoes_details_screen_field_color_primary => 'Primario';

  @override
  String get shoes_details_screen_field_brand => 'BRAND';

  @override
  String get shoes_details_screen_field_size => 'TAGLIA';

  @override
  String get shoes_details_screen_field_category => 'CATEGORIA';

  @override
  String get shoes_details_screen_field_type => 'TIPO';

  @override
  String get shoes_details_screen_field_season => 'STAGIONE';

  @override
  String get shoes_details_screen_field_note => 'NOTE';

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
  String get user_screen_button_logout => 'Log Out';

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
  String get database_screen_pdf_confirm =>
      'PDF salvato nella cartella Download';

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
  String get info_screen_origin_text => 'ORIGINE';

  @override
  String get info_screen_origin_description =>
      'Il nome dell\'app è una fusione tra \'Shoes\' e \'Box\', proprio per simulare la creazione di una grande scatola dove contenere le scarpe.';

  @override
  String get info_screen_description_text => 'DESCRIZIONE';

  @override
  String get info_screen_description_description =>
      'Questa applicazione consente di creare un guardaroba digitale personalizzato, dedicato esclusivamente alle vostre scarpe. Qui, potrete facilmente salvare, organizzare e visualizzare tutte le vostre scarpe in un unico luogo virtuale. Ogni paio di scarpe potrà essere catalogato con dettagli specifici come marca, modello, colore, e occasione d\'uso, rendendo più semplice trovare esattamente quello che cercate in qualsiasi momento. Con il vostro guardaroba digitale, avrete sempre a portata di mano una visione completa della vostra collezione di scarpe, facilitando la scelta del paio perfetto per ogni occasione.';

  @override
  String get info_screen_credits_text => 'CREDITI';

  @override
  String get info_screen_credits_a_text => 'Ideazione';

  @override
  String get info_screen_credits_a_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_b_text => 'Sviluppo';

  @override
  String get info_screen_credits_b_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_c_text => 'Design';

  @override
  String get info_screen_credits_c_value => 'Nicola De Nicolais';

  @override
  String get policy_screen_title => 'Privacy Policy';

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
  String get support_screen_faq_q7 =>
      'Cosa posso fare se l\'app non funziona correttamente?';

  @override
  String get support_screen_faq_a7 =>
      'Se riscontri problemi, prova a riavviare l\'app. Se il problema persiste, contatta il supporto tecnico tramite la sezione \'Contattaci\'.';

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
  String get pdf_field_id => 'ID';

  @override
  String get pdf_field_date => 'Data';

  @override
  String get pdf_field_color_primary => 'Colore Primario';

  @override
  String get pdf_field_color_secondary => 'Colore Secondario';

  @override
  String get pdf_field_brand => 'Brand';

  @override
  String get pdf_field_size => 'Taglia';

  @override
  String get pdf_field_category => 'Categoria';

  @override
  String get pdf_field_type => 'Tipo';

  @override
  String get pdf_field_season => 'Stagione';

  @override
  String get pdf_field_notes => 'Note';

  @override
  String get pdf_copyright => '© 2024 Nicola De Nicolais';

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
  String get custom_delete_dialog_confirm => 'Elimina';

  @override
  String get custom_delete_dialog_cancel => 'Annulla';

  @override
  String get database_screen_pdf_user => 'Utente';

  @override
  String get database_screen_pdf_name => 'Nome';

  @override
  String get database_screen_pdf_email => 'Email';

  @override
  String get database_screen_pdf_date => 'Data';

  @override
  String get database_screen_pdf_shoes => 'Scarpe';

  @override
  String get database_screen_pdf_page => 'Pagina';

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
  String get a11y_show_only_favorites => 'Mostra solo i preferiti';

  @override
  String get a11y_show_all_shoes => 'Mostra tutte le scarpe';

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
  String get a11y_save_shoe => 'Salva scarpa';

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
  String get changelog_v4_1_0_bullet_1 =>
      'Rinnovata la grafica dell\'app in stile Material 3, mantenendo la palette di colori originale.';

  @override
  String get changelog_v4_1_0_bullet_2 =>
      'Aggiunto un layout davvero responsive che si adatta a smartphone e tablet, con rotazione libera dello schermo.';

  @override
  String get changelog_v4_1_0_bullet_3 =>
      'Nuovo selettore del tema Sistema / Chiaro / Scuro.';

  @override
  String get changelog_v4_1_0_bullet_4 =>
      'Spostata l\'eliminazione dell\'account nella pagina del profilo per un accesso più semplice.';

  @override
  String get changelog_v4_1_0_bullet_5 =>
      'Rinnovato il selettore della lingua per un aspetto più chiaro e coerente.';

  @override
  String get changelog_v4_1_0_bullet_6 =>
      'Aggiunto questo dialog delle novità per tenerti aggiornato dopo ogni aggiornamento.';

  @override
  String get changelog_v4_1_0_bullet_7 =>
      'Corretta la leggibilità dei testi in modalità scura nel selettore del tema e nelle statistiche del profilo.';

  @override
  String get changelog_v4_1_0_bullet_8 =>
      'Risolta la sovrapposizione dei grafici nella sezione database.';

  @override
  String get changelog_v4_1_0_bullet_9 =>
      'Ridimensionati testi, icone e immagini nel form di aggiunta/modifica scarpa per una migliore visualizzazione su smartphone.';

  @override
  String get changelog_v4_1_0_bullet_10 =>
      'Ristrutturata la sezione informazioni dell\'app.';

  @override
  String get changelog_v4_1_0_bullet_11 =>
      'Rinnovato il form di aggiunta/modifica scarpa con un layout più chiaro, a schede e sezioni.';

  @override
  String get changelog_v4_1_0_bullet_12 =>
      'Rinnovato il placeholder per la scelta della foto nel form scarpa, in linea con il nuovo stile a schede.';

  @override
  String get changelog_v4_1_0_bullet_13 =>
      'Il reset dei filtri ora azzera tutti i filtri, compresi colore, categoria e preferiti.';

  @override
  String get changelog_v4_1_0_bullet_14 =>
      'L\'icona dei filtri si accende solo quando un filtro è davvero applicato.';

  @override
  String get changelog_v4_1_0_bullet_15 =>
      'Corretto il filtro categoria \"Tutte\", che svuotava la griglia invece di mostrare tutte le scarpe.';

  @override
  String get changelog_v4_1_0_bullet_16 =>
      'Quando nessuna scarpa corrisponde ai filtri compare un messaggio dedicato con un pulsante per azzerarli.';

  @override
  String get changelog_v4_1_0_bullet_17 =>
      'Il pulsante di aggiunta non copre più l\'ultima riga della griglia.';

  @override
  String get changelog_v4_1_0_bullet_18 =>
      'I pulsanti con la sola icona ora hanno etichette e suggerimenti, leggibili dagli screen reader.';

  @override
  String get changelog_v4_1_0_bullet_19 =>
      'Ingrandita l\'area di tocco dei pulsanti profilo e impostazioni nella barra superiore.';

  @override
  String get changelog_v4_1_0_bullet_20 =>
      'La lista delle scarpe viene ora filtrata fuori dal disegno della schermata: scorrimento più fluido e nessun riordino dei dati sottostanti.';

  @override
  String get changelog_v4_1_0_bullet_21 =>
      'La versione dell\'app nella dashboard viene caricata una volta sola invece che a ogni ridisegno.';

  @override
  String get changelog_v4_1_0_bullet_22 =>
      'Il login con Google ora mostra un messaggio d\'errore, ad esempio in assenza di connessione, invece di non fare nulla.';

  @override
  String get changelog_v4_1_0_bullet_23 =>
      'Se l\'avvio dell\'app non riesce, ora compare una schermata con il pulsante Riprova invece di un arresto improvviso.';

  @override
  String get changelog_v4_1_0_bullet_24 =>
      'Se la sessione scade, l\'app ora torna alla schermata di benvenuto invece di chiudersi improvvisamente.';

  @override
  String get dashboard_other => 'Altro';

  @override
  String get user_screen_account_settings => 'Impostazioni Account';

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

  @override
  String get select_extra_colors => 'Seleziona Colori Extra';

  @override
  String get add_more_colors => 'Aggiungi altri colori';
}
