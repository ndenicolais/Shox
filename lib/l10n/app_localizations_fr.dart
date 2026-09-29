// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get intro_title => 'Shox';

  @override
  String get intro_screen_load_data_error =>
      'Impossible de charger les données utilisateur';

  @override
  String get onboarding_first_title => 'Ajouter';

  @override
  String get onboarding_first_description =>
      'Ajoutez toutes vos chaussures à cette boîte numérique pour les avoir toujours avec vous. Organisez facilement votre collection et suivez chaque paire que vous possédez à portée de main.';

  @override
  String get onboarding_second_title => 'Filtrer';

  @override
  String get onboarding_second_description =>
      'Filtrer rapidement vos chaussures préférées en utilisant des filtres avancés. Recherchez par marque, modèle, couleur et plus encore, et découvrez toutes les caractéristiques de vos chaussures en un instant.';

  @override
  String get onboarding_third_title => 'Afficher';

  @override
  String get onboarding_third_description =>
      'Affichez des cartes détaillées de vos chaussures avec toutes leurs caractéristiques. Des spécifications techniques aux photos, explorez chaque aspect de vos chaussures avec une interface intuitive.';

  @override
  String get onboarding_fourth_title => 'Explorer';

  @override
  String get onboarding_fourth_description =>
      'Explorez divers graphiques colorés qui affichent des statistiques détaillées sur le total et les spécifications de vos chaussures dans la base de données.';

  @override
  String get onboarding_next => 'Suivant';

  @override
  String get onboarding_finish => 'Commencer';

  @override
  String get welcome_text => 'Bonjour';

  @override
  String get welcome_login => 'Connexion';

  @override
  String get welcome_signup => 'Inscription';

  @override
  String get signup_screen_title => 'Inscription';

  @override
  String get signup_screen_text => 'S\'inscrire';

  @override
  String get signup_screen_account => 'Vous avez un compte? ';

  @override
  String get signup_screen_login => 'Se connecter';

  @override
  String get signup_toast_success => 'Inscription réussie!';

  @override
  String get signup_toast_error_email_already_register =>
      'L\'e-mail saisi est déjà enregistré comme e-mail personnel';

  @override
  String get signup_toast_error_generic => 'Erreur lors de l\'inscription:';

  @override
  String get login_screen_title => 'Connexion';

  @override
  String get login_screen_text => 'Se connecter';

  @override
  String get login_screen_remember => 'Se souvenir de moi';

  @override
  String get login_screen_password => 'Mot de passe oublié?';

  @override
  String get login_screen_account => 'Vous n\'avez pas de compte? ';

  @override
  String get login_screen_signup => 'S\'inscrire';

  @override
  String get login_toast_success => 'Connexion réussie!';

  @override
  String get login_toast_error_email_not_found =>
      'L\'email saisi ne correspond à aucun compte';

  @override
  String get login_toast_error_invalid_password =>
      'Le mot de passe saisi ne correspond à aucun compte';

  @override
  String get session_expired_message =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get startup_error_message =>
      'Impossible de démarrer l’application. Vérifiez votre connexion internet et réessayez.';

  @override
  String get login_toast_error_network =>
      'Impossible de joindre Google. Vérifiez votre connexion internet et réessayez.';

  @override
  String get login_toast_error_generic => 'Erreur lors de la connexion:';

  @override
  String get logout_toast_success => 'À bientôt!';

  @override
  String get logout_toast_error_generic => 'Erreur lors de la déconnexion';

  @override
  String get reset_password_screen_title => 'Réinitialiser le mot de passe';

  @override
  String get reset_password_screen_description =>
      'Entrez votre email pour recevoir le lien avec la procédure de réinitialisation du mot de passe';

  @override
  String get reset_password_screen_text => 'Réinitialiser le mot de passe';

  @override
  String get reset_password_form_email => 'Email';

  @override
  String get reset_password_form_email_field => 'Entrez l\'email';

  @override
  String get reset_password_toast_success =>
      'Email de réinitialisation du mot de passe envoyé à: ';

  @override
  String get reset_password_toast_error_email_not_found =>
      'L\'email saisi n\'est pas enregistré';

  @override
  String get reset_password_toast_error_password =>
      'Erreur lors de la réinitialisation du mot de passe';

  @override
  String get gender_selection_screen_title => 'Sélectionner le Genre';

  @override
  String get gender_selection_screen_subtitle => 'Choisissez Votre Genre';

  @override
  String get gender_selection_screen_description =>
      'Cela nous aidera à personnaliser votre expérience de collection de chaussures';

  @override
  String get gender_selection_button => 'Continuer';

  @override
  String get gender_selection_toast_success =>
      'Préférence enregistrée avec succès!';

  @override
  String get gender_selection_toast_error =>
      'Erreur lors de l\'enregistrement de la préférence';

  @override
  String get gender_male => 'Homme';

  @override
  String get gender_female => 'Femme';

  @override
  String get gender_other => 'Autre';

  @override
  String get validator_name => 'Nom';

  @override
  String get validator_name_empty => 'Le nom ne peut pas être vide';

  @override
  String get validator_name_hint => 'Entrez votre nom';

  @override
  String get validator_name_required => 'Le nom est requis';

  @override
  String get validator_name_error => 'Nom invalide : ';

  @override
  String get validator_email => 'Email';

  @override
  String get validator_email_missing_special => 'Symbole @ manquant';

  @override
  String get validator_email_missing_dot => 'Symbole . manquant';

  @override
  String get validator_email_hint => 'Entrez votre email';

  @override
  String get validator_email_required => 'L\'email est requis';

  @override
  String get validator_email_error => 'Email invalide : ';

  @override
  String get validator_password => 'Mot de passe';

  @override
  String get validator_password_missing_upper => 'Lettre majuscule manquante';

  @override
  String get validator_password_missing_lower => 'Lettre minuscule manquante';

  @override
  String get validator_password_missing_digit => 'Numéro manquant';

  @override
  String get validator_password_missing_special => 'Caractère spécial manquant';

  @override
  String get validator_password_missing_lenght =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get validator_password_hint => 'Entrez votre mot de passe';

  @override
  String get validator_password_required => 'Le mot de passe est requis';

  @override
  String get validator_password_error => 'Mot de passe invalide : ';

  @override
  String get permission_storage_denied => 'Permission de stockage refusée';

  @override
  String get permission_storage_toast =>
      'Accordez la permission de stockage depuis les paramètres';

  @override
  String get permission_camera_denied => 'Permission de la caméra refusée';

  @override
  String get permission_camera_toast =>
      'Accordez la permission de la caméra depuis les paramètres';

  @override
  String get home_screen_welcome_text => 'Bonjour';

  @override
  String get home_screen_search_bar => 'Rechercher par marque';

  @override
  String get home_screen_filter_title => 'Filtrer';

  @override
  String get home_screen_filter_color_primary => 'Couleur Primaire';

  @override
  String get home_screen_filter_category => 'Catégorie';

  @override
  String get home_screen_filter_type => 'Type';

  @override
  String get home_screen_filter_season => 'Saison';

  @override
  String get home_screen_filter_reset => 'Réinitialiser';

  @override
  String get home_screen_filter_apply => 'Appliquer';

  @override
  String get home_screen_error_state => 'Erreur de chargement des données';

  @override
  String get home_screen_empty_state => 'Aucune chaussure dans la boîte';

  @override
  String get home_screen_no_results_state =>
      'Aucune chaussure ne correspond aux filtres sélectionnés';

  @override
  String get home_screen_no_results_reset => 'Réinitialiser les filtres';

  @override
  String get shoes_adder_screen_title => 'Ajouter des chaussures';

  @override
  String get shoes_adder_screen_field_color_primary => 'Primaire';

  @override
  String get shoes_adder_screen_field_brand => 'Marque';

  @override
  String get shoes_adder_screen_field_size => 'Taille';

  @override
  String get shoes_adder_screen_field_category => 'Catégorie';

  @override
  String get shoes_adder_screen_field_type => 'Type';

  @override
  String get shoes_adder_screen_select_category => 'Sélectionner une catégorie';

  @override
  String get shoes_adder_screen_select_type => 'Sélectionner un type';

  @override
  String get shoes_adder_screen_field_season => 'Saison';

  @override
  String get shoes_adder_screen_field_note => 'Notes';

  @override
  String get shoes_form_screen_section_photo => 'Photo';

  @override
  String get shoes_form_screen_section_colors => 'Couleurs';

  @override
  String get shoes_form_screen_section_details => 'Détails';

  @override
  String get shoes_form_screen_section_notes => 'Notes';

  @override
  String get shoes_form_screen_add_photo => 'Ajouter une photo';

  @override
  String get shoes_adder_screen_crop_image_title => 'Recadrer l\'image';

  @override
  String get shoes_adder_screen_toast_error_image =>
      'Vous n\'avez pas sélectionné d\'image';

  @override
  String get shoes_adder_screen_toast_error_color =>
      'Vous n\'avez pas sélectionné la couleur primaire';

  @override
  String get shoes_adder_screen_toast_error_brand =>
      'Vous n\'avez pas entré la marque';

  @override
  String get shoes_adder_screen_toast_error_size =>
      'Vous n\'avez pas entré la taille';

  @override
  String get shoes_adder_screen_toast_error_category =>
      'Vous n\'avez pas sélectionné une catégorie';

  @override
  String get shoes_adder_screen_toast_error_type =>
      'Vous n\'avez pas sélectionné un type';

  @override
  String get shoes_adder_screen_toast_success =>
      'Chaussures ajoutées avec succès !';

  @override
  String get shoes_adder_screen_toast_error =>
      'Erreur lors de l\'enregistrement';

  @override
  String get shoes_form_screen_bg_remove_loading =>
      'Suppression de l\'arrière-plan...';

  @override
  String get shoes_form_screen_bg_remove_success =>
      'Arrière-plan supprimé avec succès';

  @override
  String get shoes_form_screen_bg_remove_error =>
      'Erreur lors de la suppression de l\'arrière-plan : ';

  @override
  String get shoes_updater_screen_title => 'Mettre à jour les chaussures';

  @override
  String get shoes_updater_screen_field_color_primary => 'Couleur Primaire';

  @override
  String get shoes_updater_screen_field_brand => 'Marque';

  @override
  String get shoes_updater_screen_field_size => 'Taille';

  @override
  String get shoes_updater_screen_field_category => 'Catégorie';

  @override
  String get shoes_updater_screen_field_type => 'Type';

  @override
  String get shoes_updater_screen_field_season => 'Saison';

  @override
  String get shoes_updater_screen_field_note => 'Notes';

  @override
  String get shoes_updater_screen_crop_image_title => 'Recadrer l\'image';

  @override
  String get shoes_updater_screen_toast_error_brand =>
      'Vous n\'avez pas entré la marque';

  @override
  String get shoes_updater_screen_toast_error_size =>
      'Vous n\'avez pas entré la taille';

  @override
  String get shoes_updater_screen_toast_success =>
      'Chaussures mises à jour avec succès !';

  @override
  String get shoes_updater_screen_toast_error =>
      'Erreur lors de la mise à jour';

  @override
  String get shoes_details_screen_title => 'Détails des Chaussures';

  @override
  String get shoes_details_screen_field_color => 'COULEURS';

  @override
  String get shoes_details_screen_field_color_primary => 'Primaire';

  @override
  String get shoes_details_screen_field_brand => 'MARQUE';

  @override
  String get shoes_details_screen_field_size => 'TAILLE';

  @override
  String get shoes_details_screen_field_category => 'CATÉGORIE';

  @override
  String get shoes_details_screen_field_type => 'TYPE';

  @override
  String get shoes_details_screen_field_season => 'SAISON';

  @override
  String get shoes_details_screen_field_note => 'NOTES';

  @override
  String get shoes_details_screen_menu_edit => 'Modifier';

  @override
  String get shoes_details_screen_menu_share => 'Partager';

  @override
  String get shoes_details_screen_menu_delete => 'Supprimer';

  @override
  String get shoes_details_screen_share_success =>
      'Capture d\'écran partagée avec succès!';

  @override
  String get shoes_details_screen_share_error =>
      'Erreur lors du partage de la capture d\'écran';

  @override
  String get shoes_details_screen_error_state =>
      'Erreur de chargement des données';

  @override
  String get shoes_details_screen_empty_state => 'Aucune chaussure trouvée';

  @override
  String get shoes_details_screen_delete_title => 'Supprimer';

  @override
  String get shoes_details_screen_delete_description =>
      'Êtes-vous sûr de vouloir supprimer ces chaussures ?';

  @override
  String get shoes_details_screen_delete_toast_success =>
      'Chaussures supprimées!';

  @override
  String get user_screen_title => 'Profil';

  @override
  String get user_screen_button_database => 'Base de données';

  @override
  String get user_screen_button_logout => 'Se déconnecter';

  @override
  String get user_screen_button_delete => 'Supprimer le compte';

  @override
  String get user_updater_screen_title => 'Modifier le Profil';

  @override
  String get user_updater_screen_crop_image_title => 'Recadrer l\'image';

  @override
  String get user_updater_screen_save => 'Enregistrer';

  @override
  String get user_updater_screen_username_field_error =>
      'Vous n\'avez pas entré le nom';

  @override
  String get database_screen_title => 'Base de données';

  @override
  String get database_screen_empty => 'Aucune chaussure présente dans la boîte';

  @override
  String get database_screen_colors => 'Couleurs';

  @override
  String get database_screen_brands => 'Marques';

  @override
  String get database_screen_categories => 'Catégories';

  @override
  String get database_screen_types => 'Types';

  @override
  String get database_screen_pdf_download => 'Télécharger PDF';

  @override
  String get database_screen_pdf_confirm =>
      'PDF enregistré dans le dossier Téléchargements';

  @override
  String get database_screen_pdf_error => 'Échec de la génération du PDF';

  @override
  String get database_screen_export_menu => 'Exporter JSON';

  @override
  String get database_screen_import_menu => 'Importer JSON';

  @override
  String get database_screen_export_success =>
      'JSON exporté dans le dossier de téléchargement';

  @override
  String get database_screen_export_error => 'Erreur lors de l\'exportation';

  @override
  String get database_screen_import_success => 'JSON importé avec succès!';

  @override
  String get database_screen_import_error => 'Erreur lors de l\'importation';

  @override
  String get delete_account_screen_title => 'Supprimer le compte';

  @override
  String get delete_account_screen_toast_success => 'Compte supprimé !';

  @override
  String get delete_account_screen_toast_error =>
      'Erreur lors du processus de suppression :';

  @override
  String get delete_account_screen_delete_dialog_title =>
      'Confirmer la suppression';

  @override
  String get delete_account_screen_delete_dialog_text =>
      'Êtes-vous sûr de vouloir supprimer définitivement votre compte ?';

  @override
  String get delete_account_screen_text_a =>
      'Êtes-vous vraiment sûr de vouloir supprimer votre compte ?';

  @override
  String get delete_account_screen_text_b =>
      'C\'est une action irréversible et toutes les données associées à ce compte seront définitivement supprimées sans possibilité de récupération.';

  @override
  String get delete_account_screen_text_c =>
      'Pour continuer, cliquez sur le bouton ci-dessous';

  @override
  String get delete_account_screen_delete_button => 'Supprimer';

  @override
  String get delete_account_screen_backup_title => 'Sauvegardez Vos Données';

  @override
  String get delete_account_screen_backup_text =>
      'Avant de supprimer votre compte, souhaitez-vous télécharger une sauvegarde de votre base de données de chaussures au format JSON ? Cela vous aidera à préserver vos données.';

  @override
  String get delete_account_screen_backup_button => 'Télécharger la Sauvegarde';

  @override
  String get delete_account_screen_skip_backup => 'Ignorer';

  @override
  String get delete_account_screen_backup_success =>
      'Base de données sauvegardée avec succès !';

  @override
  String get delete_account_screen_backup_error =>
      'Erreur lors de la sauvegarde :';

  @override
  String get delete_account_screen_what_happens => 'Que va-t-il se passer ?';

  @override
  String get delete_account_screen_item_a =>
      'Votre profil et vos identifiants de connexion seront supprimés définitivement';

  @override
  String get delete_account_screen_item_b =>
      'Toutes les chaussures enregistrées dans votre base de données seront supprimées';

  @override
  String get delete_account_screen_item_c =>
      'Les images associées à vos chaussures seront effacées';

  @override
  String get settings_screen_language => 'Langue';

  @override
  String get settings_screen_info => 'Info';

  @override
  String get settings_screen_policy => 'Privacy Policy';

  @override
  String get settings_screen_support => 'Service d\'assistance';

  @override
  String get info_screen_title => 'Info';

  @override
  String get info_screen_origin_text => 'ORIGINE';

  @override
  String get info_screen_origin_description =>
      'Le nom de l\'application est une fusion entre \'Shoes\' et \'Box\', pour simuler la création d\'une grande boîte où ranger les chaussures.';

  @override
  String get info_screen_description_text => 'DESCRIPTION';

  @override
  String get info_screen_description_description =>
      'Cette application vous permet de créer une garde-robe numérique personnalisée exclusivement pour vos chaussures. Ici, vous pouvez facilement enregistrer, organiser et visualiser toutes vos chaussures en un seul endroit virtuel. Chaque paire de chaussures peut être cataloguée avec des détails spécifiques tels que la marque, le modèle, la couleur et l\'occasion d\'utilisation, ce qui facilite la recherche de ce que vous cherchez à tout moment. Avec votre garde-robe numérique, vous aurez toujours une vue complète de votre collection de chaussures à portée de main, facilitant le choix de la paire parfaite pour chaque occasion.';

  @override
  String get info_screen_credits_text => 'CRÉDITS';

  @override
  String get info_screen_credits_a_text => 'Idée';

  @override
  String get info_screen_credits_a_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_b_text => 'Développement';

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
  String get support_screen_contacts_text => 'Contactez-nous';

  @override
  String get support_screen_contacts_decription =>
      'Pour tout problème ou question, écrivez à :';

  @override
  String get support_screen_contacts_info => 'ndn21dev@gmail.com';

  @override
  String get support_screen_faq_text => 'FAQ';

  @override
  String get support_screen_faq_decription =>
      'Trouvez des réponses aux questions les plus fréquentes.';

  @override
  String get support_screen_faq_q1 =>
      'Comment ajouter une paire de chaussures ?';

  @override
  String get support_screen_faq_a1 =>
      'Pour ajouter une paire de chaussures, allez à l\'accueil et cliquez sur le bouton \'+\'. Remplissez tous les détails nécessaires et enregistrez.';

  @override
  String get support_screen_faq_q2 =>
      'Comment modifier une paire de chaussures ?';

  @override
  String get support_screen_faq_a2 =>
      'Pour modifier une paire de chaussures, choisissez la case des chaussures que vous souhaitez modifier et cliquez dessus. Une fois ouvert, cliquez sur l\'icône en haut à droite et choisissez l\'option \'Modifier\'. Apportez les modifications et enregistrez.';

  @override
  String get support_screen_faq_q3 =>
      'Comment supprimer une paire de chaussures ?';

  @override
  String get support_screen_faq_a3 =>
      'Pour supprimer une paire de chaussures, choisissez la case des chaussures que vous souhaitez modifier et cliquez dessus. Une fois ouvert, cliquez sur l\'icône en haut à droite et choisissez l\'option \'Supprimer\'.';

  @override
  String get support_screen_faq_q4 =>
      'Que se passe-t-il si je supprime une paire de chaussures?';

  @override
  String get support_screen_faq_a4 =>
      'Si vous supprimez une paire de chaussures, il sera définitivement supprimé. Vous serez invité à confirmer avant de procéder à l\'opération.';

  @override
  String get support_screen_faq_q7 =>
      'Que puis-je faire si l\'application ne fonctionne pas correctement ?';

  @override
  String get support_screen_faq_a7 =>
      'Si vous rencontrez des problèmes, essayez de redémarrer l\'application. Si le problème persiste, contactez le support technique via la section \'Contactez-nous\'.';

  @override
  String get support_screen_faq_q8 =>
      'Que puis-je faire si l\'application ne fonctionne pas ?';

  @override
  String get support_screen_faq_a8 =>
      'Fermez l\'application depuis l\'arrière-plan > Paramètres de l\'application > Supprimer les données > Vider le cache > Redémarrer l\'application. Si le problème persiste, contactez le support technique.';

  @override
  String get support_screen_faq_q9 =>
      'Comment fonctionne le téléchargement PDF ?';

  @override
  String get support_screen_faq_a9 =>
      'Pour télécharger votre base de données au format PDF, allez dans la section Profil > Base de données > Cliquez sur l\'icône en haut à droite > Télécharger PDF.';

  @override
  String get support_screen_faq_q10 =>
      'Comment fonctionne l\'importation de la base de données JSON ?';

  @override
  String get support_screen_faq_a10 =>
      'Vous pouvez importer la base de données au format JSON (si précédemment exportée depuis l\'application).';

  @override
  String get support_screen_faq_q11 =>
      'Comment fonctionne l\'exportation de la base de données JSON ?';

  @override
  String get support_screen_faq_a11 =>
      'Vous pouvez exporter la base de données au format JSON afin de préserver les données actuelles présentes dans la base de données et pouvoir ensuite les importer sur un autre appareil via l\'application.';

  @override
  String get support_screen_documentation_text => 'Documentation';

  @override
  String get support_screen_documentation_decription =>
      'Consultez la documentation complète sur la page web de l\'application.';

  @override
  String get support_screen_documentation_info =>
      'Aller à la page web sur GitHub';

  @override
  String get color_white => 'Blanc';

  @override
  String get color_black => 'Noir';

  @override
  String get color_light_grey => 'Gris Clair';

  @override
  String get color_dark_grey => 'Gris Foncé';

  @override
  String get color_orange => 'Orange';

  @override
  String get color_pink => 'Rose';

  @override
  String get color_red => 'Rouge';

  @override
  String get color_bordeaux => 'Bordeaux';

  @override
  String get color_camel => 'Camel';

  @override
  String get color_beige => 'Beige';

  @override
  String get color_light_brown => 'Marron Clair';

  @override
  String get color_dark_brown => 'Marron Foncé';

  @override
  String get color_yellow => 'Jaune';

  @override
  String get color_green => 'Vert';

  @override
  String get color_light_blue => 'Bleu Clair';

  @override
  String get color_dark_blue => 'Bleu Foncé';

  @override
  String get category_sneakers => 'Baskets';

  @override
  String get category_elegant => 'Élégant';

  @override
  String get category_heeled => 'À talon';

  @override
  String get category_sandals => 'Sandales';

  @override
  String get category_mules => 'Mules';

  @override
  String get category_boots => 'Bottes';

  @override
  String get category_other => 'Autre';

  @override
  String get type_sport => 'Sport';

  @override
  String get type_casual => 'Décontracté';

  @override
  String get type_lifestyle => 'Style de vie';

  @override
  String get type_running => 'Course';

  @override
  String get type_dressy => 'Habillé';

  @override
  String get type_loafers => 'Mocassins';

  @override
  String get type_decollete => 'Décolleté';

  @override
  String get type_spuntas => 'Ouvert';

  @override
  String get type_wedge => 'Compensées';

  @override
  String get type_lace_up => 'À lacets';

  @override
  String get type_flat => 'Plat';

  @override
  String get type_heeled => 'À talon';

  @override
  String get type_ankle_boots => 'Bottines';

  @override
  String get type_high_boots => 'Bottes hautes';

  @override
  String get type_work_boots => 'Bottes de travail';

  @override
  String get type_knee_high => 'Au genou';

  @override
  String get type_classic => 'Classique';

  @override
  String get type_other => 'Autre';

  @override
  String get pdf_field_id => 'ID';

  @override
  String get pdf_field_date => 'Date';

  @override
  String get pdf_field_color_primary => 'Couleur Primaire';

  @override
  String get pdf_field_color_secondary => 'Couleur Secondaire';

  @override
  String get pdf_field_brand => 'Marque';

  @override
  String get pdf_field_size => 'Taille';

  @override
  String get pdf_field_category => 'Catégorie';

  @override
  String get pdf_field_type => 'Type';

  @override
  String get pdf_field_season => 'Saison';

  @override
  String get pdf_field_notes => 'Remarques';

  @override
  String get pdf_copyright => '© 2024 Nicola De Nicolais';

  @override
  String get full_screen_image_save_success_toast =>
      'Image enregistrée avec succès!';

  @override
  String get full_screen_image_save_error_toast => 'Erreur';

  @override
  String get full_screen_image_download_error_toast =>
      'Échec du téléchargement de l\'image.';

  @override
  String get full_screen_image_share_success_toast =>
      'Image partagée avec succès !';

  @override
  String get full_screen_image_share_download_error_toast =>
      'Échec du téléchargement de l\'image pour le partage.';

  @override
  String get full_screen_image_share_error_toast => 'Erreur';

  @override
  String get shoes_form_screen_unsaved_title =>
      'Modifications non enregistrées';

  @override
  String get shoes_form_screen_unsaved_text =>
      'Si vous quittez maintenant, les modifications apportées à cette chaussure seront perdues.';

  @override
  String get shoes_form_screen_unsaved_stay => 'Rester';

  @override
  String get shoes_form_screen_unsaved_leave => 'Quitter';

  @override
  String get custom_delete_dialog_confirm => 'Supprimer';

  @override
  String get custom_delete_dialog_cancel => 'Annuler';

  @override
  String get database_screen_pdf_user => 'Utilisateur';

  @override
  String get database_screen_pdf_name => 'Nom';

  @override
  String get database_screen_pdf_email => 'Email';

  @override
  String get database_screen_pdf_date => 'Date';

  @override
  String get database_screen_pdf_shoes => 'Chaussures';

  @override
  String get database_screen_pdf_page => 'Page';

  @override
  String get auth_or_continue_with => 'Ou continuer avec';

  @override
  String get auth_sign_in_with_google => 'Se connecter avec Google';

  @override
  String get common_retry => 'Réessayer';

  @override
  String get dashboard_screen_title => 'Tableau de bord';

  @override
  String get dashboard_preferences => 'Préférences';

  @override
  String get dashboard_theme => 'Thème';

  @override
  String get theme_mode_system => 'Système';

  @override
  String get theme_mode_light => 'Clair';

  @override
  String get theme_mode_dark => 'Sombre';

  @override
  String get dashboard_account => 'Compte';

  @override
  String get dashboard_profile => 'Profil';

  @override
  String get dashboard_logout => 'Déconnexion';

  @override
  String get dashboard_share_app => 'Partager';

  @override
  String get dashboard_version => 'Version';

  @override
  String get dashboard_information => 'App';

  @override
  String get dashboard_changelog => 'Changelog';

  @override
  String get a11y_profile => 'Profil';

  @override
  String get a11y_settings => 'Paramètres';

  @override
  String get a11y_add_shoe => 'Ajouter une chaussure';

  @override
  String get a11y_filters => 'Filtres';

  @override
  String get a11y_clear_search => 'Effacer la recherche';

  @override
  String get a11y_toggle_grid => 'Changer la disposition de la grille';

  @override
  String get a11y_show_only_favorites => 'Afficher uniquement les favoris';

  @override
  String get a11y_show_all_shoes => 'Afficher toutes les chaussures';

  @override
  String get a11y_add_to_favorites => 'Ajouter aux favoris';

  @override
  String get a11y_remove_from_favorites => 'Retirer des favoris';

  @override
  String get a11y_open_image => 'Ouvrir l’image en plein écran';

  @override
  String get a11y_download_image => 'Télécharger l’image';

  @override
  String get a11y_share_image => 'Partager l’image';

  @override
  String get a11y_take_photo => 'Prendre une photo';

  @override
  String get a11y_pick_from_gallery => 'Choisir dans la galerie';

  @override
  String get a11y_remove_image => 'Supprimer l’image';

  @override
  String get a11y_remove_background => 'Supprimer l’arrière-plan';

  @override
  String get a11y_save_shoe => 'Enregistrer la chaussure';

  @override
  String get a11y_edit_profile => 'Modifier le profil';

  @override
  String get a11y_change_profile_photo => 'Changer la photo de profil';

  @override
  String get a11y_loading => 'Chargement';

  @override
  String get changelog_dialog_title => 'Nouveautés';

  @override
  String get changelog_dialog_close => 'Fermer';

  @override
  String get changelog_v4_1_0_bullet_1 =>
      'Modernisation du design de l\'application avec un style Material 3, en conservant la palette de couleurs d\'origine.';

  @override
  String get changelog_v4_1_0_bullet_2 =>
      'Ajout d\'une mise en page vraiment responsive qui s\'adapte aux smartphones et tablettes, avec rotation libre de l\'écran.';

  @override
  String get changelog_v4_1_0_bullet_3 =>
      'Nouveau sélecteur de thème Système / Clair / Sombre.';

  @override
  String get changelog_v4_1_0_bullet_4 =>
      'Déplacement de la suppression du compte vers la page de profil pour un accès plus simple.';

  @override
  String get changelog_v4_1_0_bullet_5 =>
      'Refonte du sélecteur de langue pour un aspect plus clair et cohérent.';

  @override
  String get changelog_v4_1_0_bullet_6 =>
      'Ajout de cette fenêtre de nouveautés pour vous tenir informé après chaque mise à jour.';

  @override
  String get changelog_v4_1_0_bullet_7 =>
      'Correction de la lisibilité des textes en mode sombre dans le sélecteur de thème et les statistiques du profil.';

  @override
  String get changelog_v4_1_0_bullet_8 =>
      'Correction du chevauchement des graphiques dans la section base de données.';

  @override
  String get changelog_v4_1_0_bullet_9 =>
      'Redimensionnement des textes, icônes et images du formulaire d\'ajout/modification de chaussure pour un meilleur affichage sur smartphone.';

  @override
  String get changelog_v4_1_0_bullet_10 =>
      'Restructuration de la section informations de l\'application.';

  @override
  String get changelog_v4_1_0_bullet_11 =>
      'Refonte du formulaire d\'ajout/modification de chaussure avec une mise en page plus claire, en cartes et sections.';

  @override
  String get changelog_v4_1_0_bullet_12 =>
      'Restylisation du sélecteur de photo dans le formulaire chaussure, en accord avec le nouveau style de cartes.';

  @override
  String get changelog_v4_1_0_bullet_13 =>
      'La réinitialisation efface désormais tous les filtres, y compris couleur, catégorie et favoris.';

  @override
  String get changelog_v4_1_0_bullet_14 =>
      'L’icône des filtres ne s’allume que lorsqu’un filtre est réellement appliqué.';

  @override
  String get changelog_v4_1_0_bullet_15 =>
      'Correction du filtre de catégorie \"Toutes\", qui vidait la grille au lieu d’afficher toutes les chaussures.';

  @override
  String get changelog_v4_1_0_bullet_16 =>
      'Lorsqu’aucune chaussure ne correspond aux filtres, un message dédié s’affiche avec un bouton pour les réinitialiser.';

  @override
  String get changelog_v4_1_0_bullet_17 =>
      'Le bouton d’ajout ne masque plus la dernière ligne de la grille.';

  @override
  String get changelog_v4_1_0_bullet_18 =>
      'Les boutons composés uniquement d’une icône ont désormais des libellés et des infobulles, lisibles par les lecteurs d’écran.';

  @override
  String get changelog_v4_1_0_bullet_19 =>
      'Agrandissement de la zone tactile des boutons profil et paramètres dans la barre supérieure.';

  @override
  String get changelog_v4_1_0_bullet_20 =>
      'La liste des chaussures est désormais filtrée en dehors du rendu de l’écran : défilement plus fluide et plus de réorganisation des données sous-jacentes.';

  @override
  String get changelog_v4_1_0_bullet_21 =>
      'La version de l’application dans le tableau de bord est chargée une seule fois au lieu de l’être à chaque redessin.';

  @override
  String get changelog_v4_1_0_bullet_22 =>
      'La connexion avec Google affiche désormais un message d’erreur, par exemple sans connexion internet, au lieu de ne rien faire.';

  @override
  String get changelog_v4_1_0_bullet_23 =>
      'Si l’application ne parvient pas à démarrer, un écran avec un bouton Réessayer s’affiche désormais au lieu d’un arrêt brutal.';

  @override
  String get changelog_v4_1_0_bullet_24 =>
      'Si la session expire, l’application revient désormais à l’écran d’accueil au lieu de se fermer brusquement.';

  @override
  String get changelog_v4_1_0_bullet_25 =>
      'Le cœur des favoris a désormais un fond qui le rend visible même sur les photos claires.';

  @override
  String get changelog_v4_1_0_bullet_26 =>
      'La recherche trouve désormais les chaussures aussi par type, catégorie et notes, et se met à jour quand vous arrêtez de taper.';

  @override
  String get changelog_v4_1_0_bullet_27 =>
      'Tirez la grille vers le bas pour actualiser votre collection.';

  @override
  String get changelog_v4_1_0_bullet_28 =>
      'Quitter le formulaire d’une chaussure avec des modifications non enregistrées demande désormais une confirmation.';

  @override
  String get changelog_v4_1_0_bullet_29 =>
      'Transitions entre les écrans plus fluides et homogènes.';

  @override
  String get changelog_v4_1_0_bullet_30 =>
      'Pendant la connexion, l’inscription et la réinitialisation du mot de passe, le bouton affiche désormais le chargement en son sein ; le bouton de choix du genre reste désactivé tant que vous n’en sélectionnez pas un.';

  @override
  String get changelog_v4_1_0_bullet_31 =>
      'Avec le thème Système, l’application suit désormais immédiatement le passage clair/sombre du téléphone, sans redémarrage ; les icônes de la barre d’état restent lisibles en thème sombre.';

  @override
  String get changelog_v4_1_0_bullet_32 =>
      'Couleurs plus cohérentes et lisibles pour les éléments système (menus, boîtes de dialogue, interrupteurs et erreurs), thème sombre compris.';

  @override
  String get changelog_v4_1_0_bullet_33 =>
      'Les photos de la collection remplissent désormais toujours leur case et utilisent moins de mémoire ; sur tablette, l’accueil est centré comme les autres écrans.';

  @override
  String get dashboard_other => 'Autre';

  @override
  String get user_screen_account_settings => 'Paramètres du compte';

  @override
  String get user_screen_total_shoes => 'Total de chaussures';

  @override
  String get user_screen_member_since => 'Membre depuis';

  @override
  String get user_screen_favorite_brand => 'Marque préférée';

  @override
  String get user_screen_most_used_category => 'Plus utilisé';

  @override
  String get user_screen_most_used_type => 'Type Plus Utilisé';

  @override
  String get user_screen_most_used_color => 'Couleur la Plus Utilisée';

  @override
  String get user_screen_last_added => 'Dernière ajout';

  @override
  String get user_screen_favorites_count => 'Favoris';

  @override
  String get full_screen_image_share_text => 'Regarde cette image !';

  @override
  String get extra_colors => 'Supplémentaires';

  @override
  String get select_extra_colors => 'Sélectionner couleurs supplémentaires';

  @override
  String get add_more_colors => 'Ajouter plus de couleurs';
}
