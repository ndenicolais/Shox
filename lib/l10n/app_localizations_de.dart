// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get intro_title => 'Shox';

  @override
  String get intro_screen_load_data_error =>
      'Benutzerdaten konnten nicht geladen werden';

  @override
  String get onboarding_first_title => 'Füge';

  @override
  String get onboarding_first_description =>
      'Füge alle deine Schuhe zu dieser digitalen Box hinzu, um sie immer bei dir zu haben. Organisiere deine Sammlung einfach und behalte den Überblick über jedes Paar, das du besitzt.';

  @override
  String get onboarding_second_title => 'Filtern';

  @override
  String get onboarding_second_description =>
      'Filtern schnell deine Lieblingsschuhe mit erweiterten Filtern. Suche nach Marke, Modell, Farbe und mehr und entdecke alle Merkmale deiner Schuhe im Handumdrehen.';

  @override
  String get onboarding_third_title => 'Anzeigen';

  @override
  String get onboarding_third_description =>
      'Anzeigen dir detaillierte Karten deiner Schuhe mit allen ihren Merkmalen an. Von technischen Spezifikationen bis zu Fotos, erkunde jeden Aspekt deiner Schuhe mit einer intuitiven Benutzeroberfläche.';

  @override
  String get onboarding_fourth_title => 'Erkunde';

  @override
  String get onboarding_fourth_description =>
      'Erkunde verschiedene farbige Diagramme, die detaillierte Statistiken über die Gesamtanzahl und die Spezifikationen deiner Schuhe in der Datenbank anzeigen.';

  @override
  String get onboarding_next => 'Weiter';

  @override
  String get onboarding_finish => 'Starten';

  @override
  String get welcome_text => 'Hallo';

  @override
  String get welcome_login => 'Anmelden';

  @override
  String get welcome_signup => 'Registrieren';

  @override
  String get signup_screen_title => 'Registrierung';

  @override
  String get signup_screen_text => 'Registrieren';

  @override
  String get signup_screen_account => 'Haben Sie ein Konto? ';

  @override
  String get signup_screen_login => 'Anmelden';

  @override
  String get signup_toast_success => 'Registrierung erfolgreich!';

  @override
  String get signup_toast_error_email_already_register =>
      'Die eingegebene E-Mail ist bereits als persönliche E-Mail registriert';

  @override
  String get signup_toast_error_generic => 'Fehler bei der Registrierung:';

  @override
  String get login_screen_title => 'Anmeldung';

  @override
  String get login_screen_text => 'Anmelden';

  @override
  String get login_screen_remember => 'Erinnere dich an mich';

  @override
  String get login_screen_password => 'Passwort vergessen?';

  @override
  String get login_screen_account => 'Haben Sie kein Konto? ';

  @override
  String get login_screen_signup => 'Registrieren';

  @override
  String get login_toast_success => 'Erfolgreich angemeldet!';

  @override
  String get login_toast_error_email_not_found =>
      'Die eingegebene E-Mail entspricht keinem Konto';

  @override
  String get login_toast_error_invalid_password =>
      'Das eingegebene Passwort entspricht keinem Konto';

  @override
  String get session_expired_message =>
      'Deine Sitzung ist abgelaufen. Bitte melde dich erneut an.';

  @override
  String get startup_error_message =>
      'Die App konnte nicht gestartet werden. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get login_toast_error_network =>
      'Google ist nicht erreichbar. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get login_toast_error_generic => 'Fehler bei der Anmeldung:';

  @override
  String get logout_toast_success => 'Bis bald!';

  @override
  String get logout_toast_error_generic => 'Fehler beim Abmelden';

  @override
  String get reset_password_screen_title => 'Passwort zurücksetzen';

  @override
  String get reset_password_screen_description =>
      'Geben Sie Ihre E-Mail ein, um den Link zum Zurücksetzen des Passworts zu erhalten';

  @override
  String get reset_password_screen_text => 'Passwort zurücksetzen';

  @override
  String get reset_password_form_email => 'E-Mail';

  @override
  String get reset_password_form_email_field => 'Geben Sie die E-Mail ein';

  @override
  String get reset_password_toast_success =>
      'E-Mail zum Zurücksetzen des Passworts gesendet an: ';

  @override
  String get reset_password_toast_error_email_not_found =>
      'Die eingegebene E-Mail ist nicht registriert';

  @override
  String get reset_password_toast_error_password =>
      'Fehler beim Zurücksetzen des Passworts';

  @override
  String get gender_selection_screen_title => 'Geschlecht Auswählen';

  @override
  String get gender_selection_screen_subtitle => 'Wählen Sie Ihr Geschlecht';

  @override
  String get gender_selection_screen_description =>
      'Dies hilft uns, Ihre Schuhsammlung zu personalisieren';

  @override
  String get gender_selection_button => 'Fortsetzen';

  @override
  String get gender_selection_toast_success =>
      'Präferenz erfolgreich gespeichert!';

  @override
  String get gender_selection_toast_error =>
      'Fehler beim Speichern der Präferenz';

  @override
  String get gender_male => 'Männlich';

  @override
  String get gender_female => 'Weiblich';

  @override
  String get gender_other => 'Andere';

  @override
  String get validator_name => 'Name';

  @override
  String get validator_name_empty => 'Der Name darf nicht leer sein';

  @override
  String get validator_name_hint => 'Gib deinen Namen ein';

  @override
  String get validator_name_required => 'Name ist erforderlich';

  @override
  String get validator_name_error => 'Ungültiger Name: ';

  @override
  String get validator_email => 'Email';

  @override
  String get validator_email_missing_special => 'Fehlendes @-Symbol';

  @override
  String get validator_email_missing_dot => 'Fehlendes .-Symbol';

  @override
  String get validator_email_hint => 'Gib deine Email-Adresse ein';

  @override
  String get validator_email_required => 'Email ist erforderlich';

  @override
  String get validator_email_error => 'Ungültige Email-Adresse: ';

  @override
  String get validator_password => 'Passwort';

  @override
  String get validator_password_missing_upper => 'Fehlender Großbuchstabe';

  @override
  String get validator_password_missing_lower => 'Fehlender Kleinbuchstabe';

  @override
  String get validator_password_missing_digit => 'Fehlende Ziffer';

  @override
  String get validator_password_missing_special => 'Fehlendes Sonderzeichen';

  @override
  String get validator_password_missing_lenght =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get validator_password_hint => 'Gib dein Passwort ein';

  @override
  String get validator_password_required => 'Passwort ist erforderlich';

  @override
  String get validator_password_error => 'Ungültiges Passwort: ';

  @override
  String get permission_storage_denied => 'Speicherberechtigung verweigert';

  @override
  String get permission_storage_toast =>
      'Erteilen Sie die Speicherberechtigung in den Einstellungen';

  @override
  String get permission_camera_denied => 'Kameraberechtigung verweigert';

  @override
  String get permission_camera_toast =>
      'Erteilen Sie die Kameraberechtigung in den Einstellungen';

  @override
  String get home_screen_welcome_text => 'Hallo';

  @override
  String get home_screen_search_bar => 'Nach Marke suchen';

  @override
  String get home_screen_filter_title => 'Filtern';

  @override
  String get home_screen_filter_color_primary => 'Primärfarbe';

  @override
  String get home_screen_filter_category => 'Kategorie';

  @override
  String get home_screen_filter_type => 'Typ';

  @override
  String get home_screen_filter_season => 'Saison';

  @override
  String get home_screen_filter_reset => 'Zurücksetzen';

  @override
  String get home_screen_filter_apply => 'Anwenden';

  @override
  String get home_screen_error_state => 'Fehler beim Laden der Daten';

  @override
  String get home_screen_empty_state => 'Keine Schuhe im Kasten vorhanden';

  @override
  String get home_screen_no_results_state =>
      'Keine Schuhe entsprechen den ausgewählten Filtern';

  @override
  String get home_screen_no_results_reset => 'Filter zurücksetzen';

  @override
  String get shoes_adder_screen_title => 'Schuhe hinzufügen';

  @override
  String get shoes_adder_screen_field_color_primary => 'Primär';

  @override
  String get shoes_adder_screen_field_brand => 'Marke';

  @override
  String get shoes_adder_screen_field_size => 'Größe';

  @override
  String get shoes_adder_screen_field_category => 'Kategorie';

  @override
  String get shoes_adder_screen_field_type => 'Typ';

  @override
  String get shoes_adder_screen_select_category => 'Wählen Sie eine Kategorie';

  @override
  String get shoes_adder_screen_select_type => 'Wählen Sie einen Typ';

  @override
  String get shoes_adder_screen_field_season => 'Saison';

  @override
  String get shoes_adder_screen_field_note => 'Notizen';

  @override
  String get shoes_form_screen_section_photo => 'Foto';

  @override
  String get shoes_form_screen_section_colors => 'Farben';

  @override
  String get shoes_form_screen_section_details => 'Details';

  @override
  String get shoes_form_screen_section_notes => 'Notizen';

  @override
  String get shoes_form_screen_add_photo => 'Foto hinzufügen';

  @override
  String get shoes_adder_screen_crop_image_title => 'Bild zuschneiden';

  @override
  String get shoes_adder_screen_toast_error_image =>
      'Du hast kein Bild ausgewählt';

  @override
  String get shoes_adder_screen_toast_error_color =>
      'Du hast keine Primärfarbe ausgewählt';

  @override
  String get shoes_adder_screen_toast_error_brand =>
      'Du hast keine Marke eingegeben';

  @override
  String get shoes_adder_screen_toast_error_size =>
      'Du hast keine Größe eingegeben';

  @override
  String get shoes_adder_screen_toast_error_category =>
      'Du hast keine Kategorie ausgewählt';

  @override
  String get shoes_adder_screen_toast_error_type =>
      'Du hast keinen Typ ausgewählt';

  @override
  String get shoes_adder_screen_toast_success =>
      'Schuhe erfolgreich hinzugefügt!';

  @override
  String get shoes_adder_screen_toast_error => 'Fehler beim Speichern';

  @override
  String get shoes_form_screen_bg_remove_loading =>
      'Hintergrund wird entfernt...';

  @override
  String get shoes_form_screen_bg_remove_success =>
      'Hintergrund erfolgreich entfernt';

  @override
  String get shoes_form_screen_bg_remove_error =>
      'Fehler beim Entfernen des Hintergrunds: ';

  @override
  String get shoes_updater_screen_title => 'Schuhe aktualisieren';

  @override
  String get shoes_updater_screen_field_color_primary => 'Primär';

  @override
  String get shoes_updater_screen_field_brand => 'Marke';

  @override
  String get shoes_updater_screen_field_size => 'Größe';

  @override
  String get shoes_updater_screen_field_category => 'Kategorie';

  @override
  String get shoes_updater_screen_field_type => 'Typ';

  @override
  String get shoes_updater_screen_field_season => 'Saison';

  @override
  String get shoes_updater_screen_field_note => 'Notizen';

  @override
  String get shoes_updater_screen_crop_image_title => 'Bild zuschneiden';

  @override
  String get shoes_updater_screen_toast_error_brand =>
      'Du hast keine Marke eingegeben';

  @override
  String get shoes_updater_screen_toast_error_size =>
      'Du hast keine Größe eingegeben';

  @override
  String get shoes_updater_screen_toast_success =>
      'Schuhe erfolgreich aktualisiert!';

  @override
  String get shoes_updater_screen_toast_error => 'Fehler beim Aktualisieren';

  @override
  String get shoes_details_screen_title => 'Schuhdetails';

  @override
  String get shoes_details_screen_field_color => 'FARBEN';

  @override
  String get shoes_details_screen_field_color_primary => 'Primärfarbe';

  @override
  String get shoes_details_screen_field_brand => 'MARKE';

  @override
  String get shoes_details_screen_field_size => 'GRÖSSE';

  @override
  String get shoes_details_screen_field_category => 'KATEGORIE';

  @override
  String get shoes_details_screen_field_type => 'TYP';

  @override
  String get shoes_details_screen_field_season => 'SAISON';

  @override
  String get shoes_details_screen_field_note => 'NOTIZEN';

  @override
  String get shoes_details_screen_menu_edit => 'Bearbeiten';

  @override
  String get shoes_details_screen_menu_share => 'Teilen';

  @override
  String get shoes_details_screen_menu_delete => 'Löschen';

  @override
  String get shoes_details_screen_share_success =>
      'Screenshot erfolgreich geteilt!';

  @override
  String get shoes_details_screen_share_error =>
      'Fehler beim Teilen des Screenshots';

  @override
  String get shoes_details_screen_error_state => 'Fehler beim Laden der Daten';

  @override
  String get shoes_details_screen_empty_state => 'Keine Schuhe gefunden';

  @override
  String get shoes_details_screen_delete_title => 'Löschen';

  @override
  String get shoes_details_screen_delete_description =>
      'Bist du sicher, dass du diese Schuhe löschen möchtest?';

  @override
  String get shoes_details_screen_delete_toast_success => 'Schuhe gelöscht!';

  @override
  String get user_screen_title => 'Profil';

  @override
  String get user_screen_button_database => 'Datenbank';

  @override
  String get user_screen_button_logout => 'Abmelden';

  @override
  String get user_screen_button_delete => 'Konto löschen';

  @override
  String get user_updater_screen_title => 'Profil bearbeiten';

  @override
  String get user_updater_screen_crop_image_title => 'Bild zuschneiden';

  @override
  String get user_updater_screen_save => 'Speichern';

  @override
  String get user_updater_screen_username_field_error =>
      'Du hast keinen Namen eingegeben';

  @override
  String get database_screen_title => 'Datenbank';

  @override
  String get database_screen_empty => 'Keine Schuhe in der Box';

  @override
  String get database_screen_colors => 'Farben';

  @override
  String get database_screen_brands => 'Marken';

  @override
  String get database_screen_categories => 'Kategorien';

  @override
  String get database_screen_types => 'Typen';

  @override
  String get database_screen_pdf_download => 'PDF herunterladen';

  @override
  String get database_screen_pdf_confirm =>
      'PDF im Download-Ordner gespeichert';

  @override
  String get database_screen_pdf_error => 'PDF konnte nicht erstellt werden';

  @override
  String get database_screen_export_menu => 'JSON exportieren';

  @override
  String get database_screen_import_menu => 'JSON importieren';

  @override
  String get database_screen_export_success =>
      'JSON im Download-Ordner exportiert';

  @override
  String get database_screen_export_error => 'Fehler beim Exportieren';

  @override
  String get database_screen_import_success => 'JSON erfolgreich importiert!';

  @override
  String get database_screen_import_error => 'Fehler beim Importieren';

  @override
  String get delete_account_screen_title => 'Konto löschen';

  @override
  String get delete_account_screen_toast_success => 'Konto gelöscht!';

  @override
  String get delete_account_screen_toast_error =>
      'Fehler beim Löschen des Kontos:';

  @override
  String get delete_account_screen_delete_dialog_title => 'Löschung bestätigen';

  @override
  String get delete_account_screen_delete_dialog_text =>
      'Sind Sie sicher, dass Sie Ihr Konto dauerhaft löschen möchten?';

  @override
  String get delete_account_screen_text_a =>
      'Sind Sie wirklich sicher, dass Sie Ihr Konto löschen möchten?';

  @override
  String get delete_account_screen_text_b =>
      'Dies ist eine unumkehrbare Aktion und alle mit diesem Konto verbundenen Daten werden dauerhaft gelöscht und können nicht wiederhergestellt werden.';

  @override
  String get delete_account_screen_text_c =>
      'Um fortzufahren, klicken Sie auf die Schaltfläche unten';

  @override
  String get delete_account_screen_delete_button => 'Löschen';

  @override
  String get delete_account_screen_backup_title => 'Sichern Sie Ihre Daten';

  @override
  String get delete_account_screen_backup_text =>
      'Bevor Sie Ihr Konto löschen, möchten Sie eine Sicherung Ihrer Schuhdatenbank im JSON-Format herunterladen? Dies hilft Ihnen, Ihre Daten zu bewahren.';

  @override
  String get delete_account_screen_backup_button => 'Sicherung Herunterladen';

  @override
  String get delete_account_screen_skip_backup => 'Überspringen';

  @override
  String get delete_account_screen_backup_success =>
      'Datenbank erfolgreich gesichert!';

  @override
  String get delete_account_screen_backup_error => 'Fehler bei der Sicherung:';

  @override
  String get delete_account_screen_what_happens => 'Was wird passieren?';

  @override
  String get delete_account_screen_item_a =>
      'Ihr Profil und Ihre Anmeldedaten werden dauerhaft entfernt';

  @override
  String get delete_account_screen_item_b =>
      'Alle in Ihrer Datenbank gespeicherten Schuhe werden gelöscht';

  @override
  String get delete_account_screen_item_c =>
      'Die mit Ihren Schuhen verknüpften Bilder werden gelöscht';

  @override
  String get settings_screen_language => 'Sprache';

  @override
  String get settings_screen_info => 'Info';

  @override
  String get settings_screen_policy => 'Privacy Policy';

  @override
  String get settings_screen_support => 'Helpdesk';

  @override
  String get info_screen_title => 'Info';

  @override
  String get info_screen_origin_text => 'HERKUNFT';

  @override
  String get info_screen_origin_description =>
      'Der Name der App ist eine Verschmelzung von \'Shoes\' und \'Box\', um die Erstellung einer großen Schachtel zu simulieren, in der die Schuhe aufbewahrt werden können.';

  @override
  String get info_screen_description_text => 'BESCHREIBUNG';

  @override
  String get info_screen_description_description =>
      'Diese Anwendung ermöglicht es Ihnen, eine personalisierte digitale Garderobe ausschließlich für Ihre Schuhe zu erstellen. Hier können Sie ganz einfach alle Ihre Schuhe an einem virtuellen Ort speichern, organisieren und anzeigen. Jedes Paar Schuhe kann mit spezifischen Details wie Marke, Modell, Farbe und Verwendungszweck katalogisiert werden, was es einfacher macht, jederzeit genau das zu finden, wonach Sie suchen. Mit Ihrer digitalen Garderobe haben Sie stets einen vollständigen Überblick über Ihre Schuhsammlung, was die Auswahl des perfekten Paares für jeden Anlass erleichtert.';

  @override
  String get info_screen_credits_text => 'CREDITS';

  @override
  String get info_screen_credits_a_text => 'Idee';

  @override
  String get info_screen_credits_a_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_b_text => 'Entwicklung';

  @override
  String get info_screen_credits_b_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_c_text => 'Design';

  @override
  String get info_screen_credits_c_value => 'Nicola De Nicolais';

  @override
  String get policy_screen_title => 'Privacy Policy';

  @override
  String get support_screen_title => 'Support';

  @override
  String get support_screen_contacts_text => 'Kontaktiere uns';

  @override
  String get support_screen_contacts_decription =>
      'Bei Problemen oder Fragen schreiben Sie an:';

  @override
  String get support_screen_contacts_info => 'ndn21dev@gmail.com';

  @override
  String get support_screen_faq_text => 'FAQ';

  @override
  String get support_screen_faq_decription =>
      'Finden Sie Antworten auf häufig gestellte Fragen.';

  @override
  String get support_screen_faq_q1 => 'Wie füge ich ein Paar Schuhe hinzu?';

  @override
  String get support_screen_faq_a1 =>
      'Um ein Paar Schuhe hinzuzufügen, gehe zur Startseite und klicke auf die Schaltfläche \'+\'. Fülle alle erforderlichen Details aus und speichere.';

  @override
  String get support_screen_faq_q2 => 'Wie bearbeite ich ein Paar Schuhe?';

  @override
  String get support_screen_faq_a2 =>
      'Um ein Paar Schuhe zu bearbeiten, wähle das Feld der Schuhe aus, die du bearbeiten möchtest, und klicke darauf. Nach dem Öffnen klicke auf das Symbol oben rechts und wähle die Option \'Bearbeiten\'. Nimm die Änderungen vor und speichere.';

  @override
  String get support_screen_faq_q3 => 'Wie lösche ich ein Paar Schuhe?';

  @override
  String get support_screen_faq_a3 =>
      'Um ein Paar Schuhe zu löschen, wähle das Feld der Schuhe aus, die du bearbeiten möchtest, und klicke darauf. Nach dem Öffnen klicke auf das Symbol oben rechts und wähle die Option \'Löschen\'.';

  @override
  String get support_screen_faq_q4 =>
      'Was passiert, wenn ich ein Paar Schuhe lösche?';

  @override
  String get support_screen_faq_a4 =>
      'Wenn du ein Ereignis oder ein Paar Schuhe lösche, wird es dauerhaft entfernt. Du wirst aufgefordert, die Aktion zu bestätigen, bevor du fortfährst.';

  @override
  String get support_screen_faq_q7 =>
      'Was kann ich tun, wenn die App nicht richtig funktioniert?';

  @override
  String get support_screen_faq_a7 =>
      'Wenn du Probleme hast, versuche die App neu zu starten. Wenn das Problem weiterhin besteht, kontaktiere den technischen Support über den Abschnitt \'Kontaktiere uns\'.';

  @override
  String get support_screen_faq_q8 =>
      'Was kann ich tun, wenn die App nicht funktioniert?';

  @override
  String get support_screen_faq_a8 =>
      'App auch im Hintergrund schließen > App-Einstellungen > Daten löschen > Cache leeren > App neu starten. Wenn das Problem weiterhin besteht, wenden Sie sich an den technischen Support.';

  @override
  String get support_screen_faq_q9 => 'Wie funktioniert der PDF-Download?';

  @override
  String get support_screen_faq_a9 =>
      'Um Ihre Datenbank im PDF-Format herunterzuladen, gehen Sie zum Profilbereich > Datenbank > Klicken Sie auf das Symbol oben rechts > PDF herunterladen.';

  @override
  String get support_screen_faq_q10 =>
      'Wie funktioniert der JSON-Datenbank-Import?';

  @override
  String get support_screen_faq_a10 =>
      'Sie können die Datenbank im JSON-Format importieren (falls zuvor aus der App exportiert).';

  @override
  String get support_screen_faq_q11 =>
      'Wie funktioniert der JSON-Datenbank-Export?';

  @override
  String get support_screen_faq_a11 =>
      'Sie können die Datenbank im JSON-Format exportieren, um die aktuellen Daten in der Datenbank zu erhalten und sie dann über die App auf ein anderes Gerät zu importieren.';

  @override
  String get support_screen_documentation_text => 'Dokumentation';

  @override
  String get support_screen_documentation_decription =>
      'Vollständige Dokumentation auf der Webseite der App einsehen.';

  @override
  String get support_screen_documentation_info =>
      'Zur Webseite auf GitHub gehen';

  @override
  String get color_white => 'Weiß';

  @override
  String get color_black => 'Schwarz';

  @override
  String get color_light_grey => 'Hellgrau';

  @override
  String get color_dark_grey => 'Dunkelgrau';

  @override
  String get color_orange => 'Orange';

  @override
  String get color_pink => 'Rosa';

  @override
  String get color_red => 'Rot';

  @override
  String get color_bordeaux => 'Bordeaux';

  @override
  String get color_camel => 'Kamel';

  @override
  String get color_beige => 'Beige';

  @override
  String get color_light_brown => 'Hellbraun';

  @override
  String get color_dark_brown => 'Dunkelbraun';

  @override
  String get color_yellow => 'Gelb';

  @override
  String get color_green => 'Grün';

  @override
  String get color_light_blue => 'Hellblau';

  @override
  String get color_dark_blue => 'Dunkelblau';

  @override
  String get category_sneakers => 'Sneakers';

  @override
  String get category_elegant => 'Elegante';

  @override
  String get category_heeled => 'Mit Absatz';

  @override
  String get category_sandals => 'Sandalen';

  @override
  String get category_mules => 'Pantoletten';

  @override
  String get category_boots => 'Stiefel';

  @override
  String get category_other => 'Sonstiges';

  @override
  String get type_sport => 'Sport';

  @override
  String get type_casual => 'Lässig';

  @override
  String get type_lifestyle => 'Lebensstil';

  @override
  String get type_running => 'Laufen';

  @override
  String get type_dressy => 'Elegant';

  @override
  String get type_loafers => 'Slipper';

  @override
  String get type_decollete => 'Dekolleté';

  @override
  String get type_spuntas => 'Offen';

  @override
  String get type_wedge => 'Mit Keilabsatz';

  @override
  String get type_lace_up => 'Schnürschuhe';

  @override
  String get type_flat => 'Flach';

  @override
  String get type_heeled => 'Mit Absatz';

  @override
  String get type_ankle_boots => 'Stiefeletten';

  @override
  String get type_high_boots => 'Hohe Stiefel';

  @override
  String get type_work_boots => 'Arbeitsschuhe';

  @override
  String get type_knee_high => 'Über das Knie';

  @override
  String get type_classic => 'Klassisch';

  @override
  String get type_other => 'Andere';

  @override
  String get pdf_field_id => 'ID';

  @override
  String get pdf_field_date => 'Datum';

  @override
  String get pdf_field_color_primary => 'Primärfarbe';

  @override
  String get pdf_field_color_secondary => 'Sekundärfarbe';

  @override
  String get pdf_field_brand => 'Marke';

  @override
  String get pdf_field_size => 'Größe';

  @override
  String get pdf_field_category => 'Kategorie';

  @override
  String get pdf_field_type => 'Typ';

  @override
  String get pdf_field_season => 'Saison';

  @override
  String get pdf_field_notes => 'Notizen';

  @override
  String get pdf_copyright => '© 2024 Nicola De Nicolais';

  @override
  String get full_screen_image_save_success_toast =>
      'Bild erfolgreich gespeichert!';

  @override
  String get full_screen_image_save_error_toast => 'Fehler';

  @override
  String get full_screen_image_download_error_toast =>
      'Bild konnte nicht heruntergeladen werden.';

  @override
  String get full_screen_image_share_success_toast =>
      'Bild erfolgreich geteilt!';

  @override
  String get full_screen_image_share_download_error_toast =>
      'Bild konnte nicht zum Teilen heruntergeladen werden.';

  @override
  String get full_screen_image_share_error_toast => 'Fehler';

  @override
  String get shoes_form_screen_unsaved_title => 'Nicht gespeicherte Änderungen';

  @override
  String get shoes_form_screen_unsaved_text =>
      'Wenn du jetzt gehst, gehen die Änderungen an diesem Schuh verloren.';

  @override
  String get shoes_form_screen_unsaved_stay => 'Bleiben';

  @override
  String get shoes_form_screen_unsaved_leave => 'Verlassen';

  @override
  String get custom_delete_dialog_confirm => 'Löschen';

  @override
  String get custom_delete_dialog_cancel => 'Abbrechen';

  @override
  String get database_screen_pdf_user => 'Benutzer';

  @override
  String get database_screen_pdf_name => 'Name';

  @override
  String get database_screen_pdf_email => 'E-Mail';

  @override
  String get database_screen_pdf_date => 'Datum';

  @override
  String get database_screen_pdf_shoes => 'Schuhe';

  @override
  String get database_screen_pdf_page => 'Seite';

  @override
  String get auth_or_continue_with => 'Oder fortfahren mit';

  @override
  String get auth_sign_in_with_google => 'Mit Google anmelden';

  @override
  String get common_retry => 'Wiederholen';

  @override
  String get dashboard_screen_title => 'Dashboard';

  @override
  String get dashboard_preferences => 'Einstellungen';

  @override
  String get dashboard_theme => 'Design';

  @override
  String get theme_mode_system => 'System';

  @override
  String get theme_mode_light => 'Hell';

  @override
  String get theme_mode_dark => 'Dunkel';

  @override
  String get dashboard_account => 'Konto';

  @override
  String get dashboard_profile => 'Profil';

  @override
  String get dashboard_logout => 'Abmelden';

  @override
  String get dashboard_share_app => 'Teilen';

  @override
  String get dashboard_version => 'Version';

  @override
  String get dashboard_information => 'App';

  @override
  String get dashboard_changelog => 'Changelog';

  @override
  String get a11y_profile => 'Profil';

  @override
  String get a11y_settings => 'Einstellungen';

  @override
  String get a11y_add_shoe => 'Schuh hinzufügen';

  @override
  String get a11y_filters => 'Filter';

  @override
  String get a11y_clear_search => 'Suche löschen';

  @override
  String get a11y_toggle_grid => 'Rasteransicht ändern';

  @override
  String get a11y_show_only_favorites => 'Nur Favoriten anzeigen';

  @override
  String get a11y_show_all_shoes => 'Alle Schuhe anzeigen';

  @override
  String get a11y_add_to_favorites => 'Zu Favoriten hinzufügen';

  @override
  String get a11y_remove_from_favorites => 'Aus Favoriten entfernen';

  @override
  String get a11y_open_image => 'Bild im Vollbild öffnen';

  @override
  String get a11y_download_image => 'Bild herunterladen';

  @override
  String get a11y_share_image => 'Bild teilen';

  @override
  String get a11y_take_photo => 'Foto aufnehmen';

  @override
  String get a11y_pick_from_gallery => 'Aus Galerie wählen';

  @override
  String get a11y_remove_image => 'Bild entfernen';

  @override
  String get a11y_remove_background => 'Hintergrund entfernen';

  @override
  String get a11y_save_shoe => 'Schuh speichern';

  @override
  String get a11y_edit_profile => 'Profil bearbeiten';

  @override
  String get a11y_change_profile_photo => 'Profilbild ändern';

  @override
  String get a11y_loading => 'Wird geladen';

  @override
  String get changelog_dialog_title => 'Neuigkeiten';

  @override
  String get changelog_dialog_close => 'Schließen';

  @override
  String get changelog_v4_1_0_bullet_1 =>
      'Neues Material-3-Design mit der ursprünglichen warmen Farbpalette: Schuhformular mit Karten, Sprachauswahl, Info-Bereich und besser lesbare Farben, auch im dunklen Design.';

  @override
  String get changelog_v4_1_0_bullet_2 =>
      'Neue Design-Auswahl System / Hell / Dunkel, die dem Hell-/Dunkel-Wechsel des Telefons sofort folgt.';

  @override
  String get changelog_v4_1_0_bullet_3 =>
      'Flüssigerer Startbildschirm: Rastervorschau beim Laden, Überblendungen, Nach-unten-Ziehen zum Aktualisieren und Fotos, die ihre Kachel immer ausfüllen.';

  @override
  String get changelog_v4_1_0_bullet_4 =>
      'Suche auch nach Typ, Kategorie und Notizen; zuverlässigere Filter, mit eigenem Hinweis und einer Schaltfläche zum Zurücksetzen, wenn nichts passt.';

  @override
  String get changelog_v4_1_0_bullet_5 =>
      'Schuhformular: Bestätigung vor dem Verlassen mit ungespeicherten Änderungen; das Bearbeiten eines Schuhs entfernt ihn nicht mehr aus den Favoriten, und ein Foto ist immer erforderlich.';

  @override
  String get changelog_v4_1_0_bullet_6 =>
      'Zuverlässigere Anmeldung: klare Google-Fehlermeldungen, ein Wiederholen-Bildschirm, wenn die App nicht startet, und Rückkehr zum Startbildschirm, wenn die Sitzung abläuft.';

  @override
  String get changelog_v4_1_0_bullet_7 =>
      'Anpassungsfähiges Layout für Smartphones und Tablets mit freier Drehung, Text, der der Schriftgröße des Telefons bis 130 % folgt, und Schaltflächen, die Screenreader vorlesen können.';

  @override
  String get changelog_v4_1_0_bullet_8 =>
      'Die Kontolöschung befindet sich jetzt im Profil.';

  @override
  String get changelog_v4_1_0_bullet_9 =>
      'Überlappende Diagramme im Datenbankbereich behoben.';

  @override
  String get changelog_v4_1_0_bullet_10 =>
      'Neues Neuigkeiten-Fenster, das dich nach jedem Update informiert.';

  @override
  String get dashboard_other => 'Andere';

  @override
  String get user_screen_account_settings => 'Kontoeinstellungen';

  @override
  String get user_screen_total_shoes => 'Schuhe gesamt';

  @override
  String get user_screen_member_since => 'Mitglied seit';

  @override
  String get user_screen_favorite_brand => 'Lieblingsmarke';

  @override
  String get user_screen_most_used_category => 'Am meisten verwendet';

  @override
  String get user_screen_most_used_type => 'Meistverwendeter Typ';

  @override
  String get user_screen_most_used_color => 'Meistverwendete Farbe';

  @override
  String get user_screen_last_added => 'Zuletzt hinzugefügt';

  @override
  String get user_screen_favorites_count => 'Favoriten';

  @override
  String get full_screen_image_share_text => 'Schau dir dieses Bild an!';

  @override
  String get extra_colors => 'Zusätzliche';

  @override
  String get select_extra_colors => 'Zusätzliche Farben auswählen';

  @override
  String get add_more_colors => 'Weitere Farben hinzufügen';
}
