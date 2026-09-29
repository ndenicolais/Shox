// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get intro_title => 'Shox';

  @override
  String get intro_screen_load_data_error => 'Unable to load user data';

  @override
  String get onboarding_first_title => 'Add';

  @override
  String get onboarding_first_description =>
      'Add all your shoes to this digital box to always have them with you. Easily organize your collection and keep track of every pair you own at your fingertips.';

  @override
  String get onboarding_second_title => 'Filter';

  @override
  String get onboarding_second_description =>
      'Filter your favorite shoes using advanced filters. Search by brand, model, color, and more, and discover all the features of your shoes in a snap.';

  @override
  String get onboarding_third_title => 'View';

  @override
  String get onboarding_third_description =>
      'View detailed cards of your shoes complete with all their features. From technical specifications to photos, explore every aspect of your shoes with an intuitive interface.';

  @override
  String get onboarding_fourth_title => 'Explore';

  @override
  String get onboarding_fourth_description =>
      'Explore various colorful charts that display detailed statistics about the total and the specifications of yours shoes in the database.';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_finish => 'Get started';

  @override
  String get welcome_text => 'Hello';

  @override
  String get welcome_login => 'Login';

  @override
  String get welcome_signup => 'Signup';

  @override
  String get signup_screen_title => 'Signup';

  @override
  String get signup_screen_text => 'Signup';

  @override
  String get signup_screen_account => 'Already have an account? ';

  @override
  String get signup_screen_login => 'Login';

  @override
  String get signup_toast_success => 'Successfully registered!';

  @override
  String get signup_toast_error_email_already_register =>
      'The email entered has already been registered';

  @override
  String get signup_toast_error_generic => 'Error during registration:';

  @override
  String get login_screen_title => 'Login';

  @override
  String get login_screen_text => 'Login';

  @override
  String get login_screen_remember => 'Remember me';

  @override
  String get login_screen_password => 'Forgot password?';

  @override
  String get login_screen_account => 'Don\'t have an account? ';

  @override
  String get login_screen_signup => 'Signup';

  @override
  String get login_toast_success => 'Login successful!';

  @override
  String get login_toast_error_email_not_found =>
      'The email entered does not match any account';

  @override
  String get login_toast_error_invalid_password =>
      'The password entered does not match any account';

  @override
  String get session_expired_message =>
      'Your session has expired. Please sign in again.';

  @override
  String get startup_error_message =>
      'Unable to start the app. Check your internet connection and try again.';

  @override
  String get login_toast_error_network =>
      'Unable to reach Google. Check your internet connection and try again.';

  @override
  String get login_toast_error_generic => 'Error during login:';

  @override
  String get logout_toast_success => 'See you soon!';

  @override
  String get logout_toast_error_generic => 'Error during logout';

  @override
  String get reset_password_screen_title => 'Reset Password';

  @override
  String get reset_password_screen_description =>
      'Enter your email to receive the link with the procedure to reset your password';

  @override
  String get reset_password_screen_text => 'Reset password';

  @override
  String get reset_password_form_email => 'Email';

  @override
  String get reset_password_form_email_field => 'Enter your email';

  @override
  String get reset_password_toast_success => 'Password reset email sent to: ';

  @override
  String get reset_password_toast_error_email_not_found =>
      'The email entered is not registered';

  @override
  String get reset_password_toast_error_password =>
      'Error during password reset';

  @override
  String get gender_selection_screen_title => 'Select Gender';

  @override
  String get gender_selection_screen_subtitle => 'Choose Your Gender';

  @override
  String get gender_selection_screen_description =>
      'This will help us customize your shoe collection experience';

  @override
  String get gender_selection_button => 'Continue';

  @override
  String get gender_selection_toast_success => 'Preference saved successfully!';

  @override
  String get gender_selection_toast_error => 'Error saving preference';

  @override
  String get gender_male => 'Male';

  @override
  String get gender_female => 'Female';

  @override
  String get gender_other => 'Other';

  @override
  String get validator_name => 'Name';

  @override
  String get validator_name_empty => 'Name cannot be empty';

  @override
  String get validator_name_hint => 'Enter your name';

  @override
  String get validator_name_required => 'Name is required';

  @override
  String get validator_name_error => 'Invalid name: ';

  @override
  String get validator_email => 'Email';

  @override
  String get validator_email_missing_special => 'Missing @ symbol';

  @override
  String get validator_email_missing_dot => 'Missing . symbol';

  @override
  String get validator_email_hint => 'Enter your email';

  @override
  String get validator_email_required => 'Email is required';

  @override
  String get validator_email_error => 'Invalid email: ';

  @override
  String get validator_password => 'Password';

  @override
  String get validator_password_missing_upper => 'Missing uppercase letter';

  @override
  String get validator_password_missing_lower => 'Missing lowercase letter';

  @override
  String get validator_password_missing_digit => 'Missing digit';

  @override
  String get validator_password_missing_special => 'Missing special character';

  @override
  String get validator_password_missing_lenght =>
      'Password should be at least 8 characters long';

  @override
  String get validator_password_hint => 'Enter your password';

  @override
  String get validator_password_required => 'Password is required';

  @override
  String get validator_password_error => 'Invalid password: ';

  @override
  String get permission_storage_denied => 'Storage permission denied';

  @override
  String get permission_storage_toast =>
      'Grant storage permission from settings';

  @override
  String get permission_camera_denied => 'Camera permission denied';

  @override
  String get permission_camera_toast => 'Grant camera permission from settings';

  @override
  String get home_screen_welcome_text => 'Hello';

  @override
  String get home_screen_search_bar => 'Search by Brand';

  @override
  String get home_screen_filter_title => 'Filter';

  @override
  String get home_screen_filter_color_primary => 'Primary Color';

  @override
  String get home_screen_filter_category => 'Category';

  @override
  String get home_screen_filter_type => 'Type';

  @override
  String get home_screen_filter_season => 'Season';

  @override
  String get home_screen_filter_reset => 'Reset';

  @override
  String get home_screen_filter_apply => 'Apply';

  @override
  String get home_screen_error_state => 'Error loading data';

  @override
  String get home_screen_empty_state => 'No shoes in the box';

  @override
  String get home_screen_no_results_state =>
      'No shoes match the selected filters';

  @override
  String get home_screen_no_results_reset => 'Clear filters';

  @override
  String get shoes_adder_screen_title => 'Add Shoes';

  @override
  String get shoes_adder_screen_field_color_primary => 'Primary';

  @override
  String get shoes_adder_screen_field_brand => 'Brand';

  @override
  String get shoes_adder_screen_field_size => 'Size';

  @override
  String get shoes_adder_screen_field_category => 'Category';

  @override
  String get shoes_adder_screen_field_type => 'Type';

  @override
  String get shoes_adder_screen_select_category => 'Select a category';

  @override
  String get shoes_adder_screen_select_type => 'Select a type';

  @override
  String get shoes_adder_screen_field_season => 'Season';

  @override
  String get shoes_adder_screen_field_note => 'Notes';

  @override
  String get shoes_form_screen_section_photo => 'Photo';

  @override
  String get shoes_form_screen_section_colors => 'Colors';

  @override
  String get shoes_form_screen_section_details => 'Details';

  @override
  String get shoes_form_screen_section_notes => 'Notes';

  @override
  String get shoes_form_screen_add_photo => 'Add photo';

  @override
  String get shoes_adder_screen_crop_image_title => 'Crop Image';

  @override
  String get shoes_adder_screen_toast_error_image =>
      'You did not select an image';

  @override
  String get shoes_adder_screen_toast_error_color =>
      'You did not select the primary color';

  @override
  String get shoes_adder_screen_toast_error_brand =>
      'You did not enter the brand';

  @override
  String get shoes_adder_screen_toast_error_size =>
      'You did not enter the size';

  @override
  String get shoes_adder_screen_toast_error_category =>
      'You did not select a category';

  @override
  String get shoes_adder_screen_toast_error_type => 'You did not select a type';

  @override
  String get shoes_adder_screen_toast_success => 'Shoes added successfully!';

  @override
  String get shoes_adder_screen_toast_error => 'Error during saving';

  @override
  String get shoes_form_screen_bg_remove_loading => 'Removing background...';

  @override
  String get shoes_form_screen_bg_remove_success =>
      'Background removed successfully';

  @override
  String get shoes_form_screen_bg_remove_error => 'Error removing background: ';

  @override
  String get shoes_updater_screen_title => 'Update Shoes';

  @override
  String get shoes_updater_screen_field_color_primary => 'Primary Color';

  @override
  String get shoes_updater_screen_field_brand => 'Brand';

  @override
  String get shoes_updater_screen_field_size => 'Size';

  @override
  String get shoes_updater_screen_field_category => 'Category';

  @override
  String get shoes_updater_screen_field_type => 'Type';

  @override
  String get shoes_updater_screen_field_season => 'Season';

  @override
  String get shoes_updater_screen_field_note => 'Notes';

  @override
  String get shoes_updater_screen_crop_image_title => 'Crop Image';

  @override
  String get shoes_updater_screen_toast_error_brand =>
      'You did not enter the brand';

  @override
  String get shoes_updater_screen_toast_error_size =>
      'You did not enter the size';

  @override
  String get shoes_updater_screen_toast_success =>
      'Shoes updated successfully!';

  @override
  String get shoes_updater_screen_toast_error => 'Error during update';

  @override
  String get shoes_details_screen_title => 'Shoes Details';

  @override
  String get shoes_details_screen_field_color => 'COLORS';

  @override
  String get shoes_details_screen_field_color_primary => 'Primary';

  @override
  String get shoes_details_screen_field_brand => 'BRAND';

  @override
  String get shoes_details_screen_field_size => 'SIZE';

  @override
  String get shoes_details_screen_field_category => 'CATEGORY';

  @override
  String get shoes_details_screen_field_type => 'TYPE';

  @override
  String get shoes_details_screen_field_season => 'SEASON';

  @override
  String get shoes_details_screen_field_note => 'NOTES';

  @override
  String get shoes_details_screen_menu_edit => 'Edit';

  @override
  String get shoes_details_screen_menu_share => 'Share';

  @override
  String get shoes_details_screen_menu_delete => 'Delete';

  @override
  String get shoes_details_screen_share_success =>
      'Screenshot shared successfully!';

  @override
  String get shoes_details_screen_share_error => 'Error sharing screenshot';

  @override
  String get shoes_details_screen_error_state => 'Error loading data';

  @override
  String get shoes_details_screen_empty_state => 'No shoes found';

  @override
  String get shoes_details_screen_delete_title => 'Delete';

  @override
  String get shoes_details_screen_delete_description =>
      'Are you sure you want to delete this shoes?';

  @override
  String get shoes_details_screen_delete_toast_success => 'Shoes deleted!';

  @override
  String get user_screen_title => 'Profile';

  @override
  String get user_screen_button_database => 'Database';

  @override
  String get user_screen_button_logout => 'Log Out';

  @override
  String get user_screen_button_delete => 'Delete Account';

  @override
  String get user_updater_screen_title => 'Edit Profile';

  @override
  String get user_updater_screen_crop_image_title => 'Crop Image';

  @override
  String get user_updater_screen_save => 'Save';

  @override
  String get user_updater_screen_username_field_error =>
      'You did not enter the name';

  @override
  String get database_screen_title => 'Database';

  @override
  String get database_screen_empty => 'No shoes in the box';

  @override
  String get database_screen_colors => 'Colors';

  @override
  String get database_screen_brands => 'Brands';

  @override
  String get database_screen_categories => 'Categories';

  @override
  String get database_screen_types => 'Types';

  @override
  String get database_screen_pdf_download => 'Download PDF';

  @override
  String get database_screen_pdf_confirm => 'PDF saved to Download folder';

  @override
  String get database_screen_pdf_error => 'Failed to generate PDF';

  @override
  String get database_screen_export_menu => 'Export JSON';

  @override
  String get database_screen_import_menu => 'Import JSON';

  @override
  String get database_screen_export_success =>
      'JSON exported to Download folder';

  @override
  String get database_screen_export_error => 'Error during export';

  @override
  String get database_screen_import_success => 'JSON imported successfully!';

  @override
  String get database_screen_import_error => 'Error during import';

  @override
  String get delete_account_screen_title => 'Delete Account';

  @override
  String get delete_account_screen_toast_success => 'Account deleted!';

  @override
  String get delete_account_screen_toast_error =>
      'Error during the deletion process:';

  @override
  String get delete_account_screen_delete_dialog_title => 'Confirm Deletion';

  @override
  String get delete_account_screen_delete_dialog_text =>
      'Are you sure you want to permanently delete your account?';

  @override
  String get delete_account_screen_text_a =>
      'Are you really sure you want to delete your account?';

  @override
  String get delete_account_screen_text_b =>
      'This is an irreversible action and all data associated with this account will be permanently deleted without any possibility of recovery.';

  @override
  String get delete_account_screen_text_c =>
      'To proceed, click the button below';

  @override
  String get delete_account_screen_delete_button => 'Delete';

  @override
  String get delete_account_screen_backup_title => 'Backup Your Data';

  @override
  String get delete_account_screen_backup_text =>
      'Before deleting your account, would you like to download a backup of your shoe database in JSON format? This will help you preserve your data.';

  @override
  String get delete_account_screen_backup_button => 'Download Backup';

  @override
  String get delete_account_screen_skip_backup => 'Skip';

  @override
  String get delete_account_screen_backup_success =>
      'Database backed up successfully!';

  @override
  String get delete_account_screen_backup_error => 'Error during backup:';

  @override
  String get delete_account_screen_what_happens => 'What will happen?';

  @override
  String get delete_account_screen_item_a =>
      'Your profile and login credentials will be permanently removed';

  @override
  String get delete_account_screen_item_b =>
      'All shoes saved in your database will be deleted';

  @override
  String get delete_account_screen_item_c =>
      'Images associated with your shoes will be erased';

  @override
  String get settings_screen_language => 'Language';

  @override
  String get settings_screen_info => 'Info';

  @override
  String get settings_screen_policy => 'Privacy Policy';

  @override
  String get settings_screen_support => 'Help Desk';

  @override
  String get info_screen_title => 'Info';

  @override
  String get info_screen_origin_text => 'ORIGIN';

  @override
  String get info_screen_origin_description =>
      'The name of the app is a fusion between \'Shoes\' and \'Box\', to simulate the creation of a large box to store shoes.';

  @override
  String get info_screen_description_text => 'DESCRIPTION';

  @override
  String get info_screen_description_description =>
      'This app allows you to create a personalized digital wardrobe exclusively for your shoes. Here, you can easily save, organize, and view all your shoes in one virtual place. Each pair of shoes can be cataloged with specific details such as brand, model, color, and occasion of use, making it easier to find exactly what you are looking for at any time. With your digital wardrobe, you will always have a complete view of your shoe collection at your fingertips, making it easier to choose the perfect pair for every occasion.';

  @override
  String get info_screen_credits_text => 'CREDITS';

  @override
  String get info_screen_credits_a_text => 'Idea';

  @override
  String get info_screen_credits_a_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_b_text => 'Development';

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
  String get support_screen_contacts_text => 'Contact Us';

  @override
  String get support_screen_contacts_decription =>
      'For any problems or questions, write to:';

  @override
  String get support_screen_contacts_info => 'ndn21dev@gmail.com';

  @override
  String get support_screen_faq_text => 'FAQ';

  @override
  String get support_screen_faq_decription =>
      'Find answers to the most frequently asked questions.';

  @override
  String get support_screen_faq_q1 => 'How to add a pair of shoes?';

  @override
  String get support_screen_faq_a1 =>
      'To add a pair of shoes, go to the Home and click on the \'+\' button. Fill in all the necessary details and save.';

  @override
  String get support_screen_faq_q2 => 'How to edit a pair of shoes?';

  @override
  String get support_screen_faq_a2 =>
      'To edit a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the \'Edit\' option. Make the changes and save.';

  @override
  String get support_screen_faq_q3 => 'How to delete a pair of shoes?';

  @override
  String get support_screen_faq_a3 =>
      'To delete a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the \'Delete\' option.';

  @override
  String get support_screen_faq_q4 =>
      'What happens if I delete a pair of shoes?';

  @override
  String get support_screen_faq_a4 =>
      'If you delete a pair of shoes, it will be permanently removed. You will be asked to confirm before proceeding with the operation.';

  @override
  String get support_screen_faq_q7 =>
      'What can I do if the app doesn\'t work properly?';

  @override
  String get support_screen_faq_a7 =>
      'If you encounter problems, try restarting the app. If the problem persists, contact technical support through the \'Contact Us\' section.';

  @override
  String get support_screen_faq_q8 => 'What can I do if the app doesn\'t work?';

  @override
  String get support_screen_faq_a8 =>
      'Close the app from background > App settings > Clear data > Clear cache > Restart the app. If the problem persists, contact technical support.';

  @override
  String get support_screen_faq_q9 => 'How does PDF download work?';

  @override
  String get support_screen_faq_a9 =>
      'To download your database in PDF format go to Profile section > Database > Click on the icon at the top right > Download PDF.';

  @override
  String get support_screen_faq_q10 => 'How does JSON database import work?';

  @override
  String get support_screen_faq_a10 =>
      'You can import the database in JSON format (if previously exported from the app).';

  @override
  String get support_screen_faq_q11 => 'How does JSON database export work?';

  @override
  String get support_screen_faq_a11 =>
      'You can export the database in JSON format to preserve the current data in the database and then import it on another device via the app.';

  @override
  String get support_screen_documentation_text => 'Documentation';

  @override
  String get support_screen_documentation_decription =>
      'Refer to the full documentation on the app\'s webpage.';

  @override
  String get support_screen_documentation_info => 'Go to the webpage on GitHub';

  @override
  String get color_white => 'White';

  @override
  String get color_black => 'Black';

  @override
  String get color_light_grey => 'Light Grey';

  @override
  String get color_dark_grey => 'Dark Grey';

  @override
  String get color_orange => 'Orange';

  @override
  String get color_pink => 'Pink';

  @override
  String get color_red => 'Red';

  @override
  String get color_bordeaux => 'Bordeaux';

  @override
  String get color_camel => 'Camel';

  @override
  String get color_beige => 'Beige';

  @override
  String get color_light_brown => 'Light Brown';

  @override
  String get color_dark_brown => 'Dark Brown';

  @override
  String get color_yellow => 'Yellow';

  @override
  String get color_green => 'Green';

  @override
  String get color_light_blue => 'Light Blue';

  @override
  String get color_dark_blue => 'Dark Blue';

  @override
  String get category_sneakers => 'Sneakers';

  @override
  String get category_elegant => 'Elegant';

  @override
  String get category_heeled => 'Heeled';

  @override
  String get category_sandals => 'Sandals';

  @override
  String get category_mules => 'Mules';

  @override
  String get category_boots => 'Boots';

  @override
  String get category_other => 'Other';

  @override
  String get type_sport => 'Sport';

  @override
  String get type_casual => 'Casual';

  @override
  String get type_lifestyle => 'Lifestyle';

  @override
  String get type_running => 'Running';

  @override
  String get type_dressy => 'Dressy';

  @override
  String get type_loafers => 'Loafers';

  @override
  String get type_decollete => 'Decolleté';

  @override
  String get type_spuntas => 'Peep';

  @override
  String get type_wedge => 'Wedge';

  @override
  String get type_lace_up => 'Lace-Up';

  @override
  String get type_flat => 'Flat';

  @override
  String get type_heeled => 'Heeled';

  @override
  String get type_ankle_boots => 'Ankle boots';

  @override
  String get type_high_boots => 'High boots';

  @override
  String get type_work_boots => 'Work boots';

  @override
  String get type_knee_high => 'Knee-high';

  @override
  String get type_classic => 'Classic';

  @override
  String get type_other => 'Other';

  @override
  String get pdf_field_id => 'ID';

  @override
  String get pdf_field_date => 'Date';

  @override
  String get pdf_field_color_primary => 'Primary Color';

  @override
  String get pdf_field_color_secondary => 'Secondary Color';

  @override
  String get pdf_field_brand => 'Brand';

  @override
  String get pdf_field_size => 'Size';

  @override
  String get pdf_field_category => 'Category';

  @override
  String get pdf_field_type => 'Type';

  @override
  String get pdf_field_season => 'Season';

  @override
  String get pdf_field_notes => 'Notes';

  @override
  String get pdf_copyright => '© 2024 Nicola De Nicolais';

  @override
  String get full_screen_image_save_success_toast =>
      'Image saved successfully!';

  @override
  String get full_screen_image_save_error_toast => 'Failed to save image.';

  @override
  String get full_screen_image_download_error_toast =>
      'Failed to download image.';

  @override
  String get full_screen_image_share_success_toast =>
      'Image shared successfully!';

  @override
  String get full_screen_image_share_download_error_toast =>
      'Failed to download image for sharing.';

  @override
  String get full_screen_image_share_error_toast => 'Error';

  @override
  String get shoes_form_screen_unsaved_title => 'Unsaved changes';

  @override
  String get shoes_form_screen_unsaved_text =>
      'If you leave now, the changes to this shoe will be lost.';

  @override
  String get shoes_form_screen_unsaved_stay => 'Stay';

  @override
  String get shoes_form_screen_unsaved_leave => 'Leave';

  @override
  String get custom_delete_dialog_confirm => 'Delete';

  @override
  String get custom_delete_dialog_cancel => 'Cancel';

  @override
  String get database_screen_pdf_user => 'User';

  @override
  String get database_screen_pdf_name => 'Name';

  @override
  String get database_screen_pdf_email => 'Email';

  @override
  String get database_screen_pdf_date => 'Date';

  @override
  String get database_screen_pdf_shoes => 'Shoes';

  @override
  String get database_screen_pdf_page => 'Page';

  @override
  String get auth_or_continue_with => 'Or continue with';

  @override
  String get auth_sign_in_with_google => 'Sign in with Google';

  @override
  String get common_retry => 'Retry';

  @override
  String get dashboard_screen_title => 'Dashboard';

  @override
  String get dashboard_preferences => 'Preferences';

  @override
  String get dashboard_theme => 'Theme';

  @override
  String get theme_mode_system => 'System';

  @override
  String get theme_mode_light => 'Light';

  @override
  String get theme_mode_dark => 'Dark';

  @override
  String get dashboard_account => 'Account';

  @override
  String get dashboard_profile => 'Profile';

  @override
  String get dashboard_logout => 'Logout';

  @override
  String get dashboard_share_app => 'Share';

  @override
  String get dashboard_version => 'Version';

  @override
  String get dashboard_information => 'App';

  @override
  String get dashboard_changelog => 'Changelog';

  @override
  String get a11y_profile => 'Profile';

  @override
  String get a11y_settings => 'Settings';

  @override
  String get a11y_add_shoe => 'Add shoe';

  @override
  String get a11y_filters => 'Filters';

  @override
  String get a11y_clear_search => 'Clear search';

  @override
  String get a11y_toggle_grid => 'Change grid layout';

  @override
  String get a11y_show_only_favorites => 'Show only favorites';

  @override
  String get a11y_show_all_shoes => 'Show all shoes';

  @override
  String get a11y_add_to_favorites => 'Add to favorites';

  @override
  String get a11y_remove_from_favorites => 'Remove from favorites';

  @override
  String get a11y_open_image => 'Open image full screen';

  @override
  String get a11y_download_image => 'Download image';

  @override
  String get a11y_share_image => 'Share image';

  @override
  String get a11y_take_photo => 'Take a photo';

  @override
  String get a11y_pick_from_gallery => 'Choose from gallery';

  @override
  String get a11y_remove_image => 'Remove image';

  @override
  String get a11y_remove_background => 'Remove background';

  @override
  String get a11y_save_shoe => 'Save shoe';

  @override
  String get a11y_edit_profile => 'Edit profile';

  @override
  String get a11y_change_profile_photo => 'Change profile photo';

  @override
  String get a11y_loading => 'Loading';

  @override
  String get changelog_dialog_title => 'What\'s New';

  @override
  String get changelog_dialog_close => 'Close';

  @override
  String get changelog_v4_1_0_bullet_1 =>
      'New Material 3 look with the original warm palette: card-based shoe form, language selector, info section and more readable colors, dark mode included.';

  @override
  String get changelog_v4_1_0_bullet_2 =>
      'New System / Light / Dark theme selector that follows your phone\'s light/dark switch right away.';

  @override
  String get changelog_v4_1_0_bullet_3 =>
      'Smoother home screen: grid preview while loading, fade transitions, pull down to refresh and photos that always fill their tile.';

  @override
  String get changelog_v4_1_0_bullet_4 =>
      'Search also by type, category and notes; more reliable filters, with a dedicated message and a clear button when nothing matches.';

  @override
  String get changelog_v4_1_0_bullet_5 =>
      'Shoe form: confirmation before leaving with unsaved changes; editing a shoe no longer removes it from favorites and a photo is always required.';

  @override
  String get changelog_v4_1_0_bullet_6 =>
      'More reliable sign-in: clear Google error messages, a Retry screen if the app fails to start and a return to the welcome screen when your session expires.';

  @override
  String get changelog_v4_1_0_bullet_7 =>
      'Adaptive layout for phones and tablets with free rotation, text that follows your phone\'s font size up to 130% and buttons readable by screen readers.';

  @override
  String get changelog_v4_1_0_bullet_8 =>
      'Account deletion moved to the Profile screen.';

  @override
  String get changelog_v4_1_0_bullet_9 =>
      'Fixed overlapping charts in the database section.';

  @override
  String get changelog_v4_1_0_bullet_10 =>
      'New what\'s-new dialog that keeps you posted after every update.';

  @override
  String get dashboard_other => 'Other';

  @override
  String get user_screen_account_settings => 'Account Settings';

  @override
  String get user_screen_total_shoes => 'Total Shoes';

  @override
  String get user_screen_member_since => 'Member Since';

  @override
  String get user_screen_favorite_brand => 'Favorite Brand';

  @override
  String get user_screen_most_used_category => 'Most Used';

  @override
  String get user_screen_most_used_type => 'Most Used Type';

  @override
  String get user_screen_most_used_color => 'Most Used Color';

  @override
  String get user_screen_last_added => 'Last Added';

  @override
  String get user_screen_favorites_count => 'Favorites';

  @override
  String get full_screen_image_share_text => 'Check out this image!';

  @override
  String get extra_colors => 'Extra';

  @override
  String get select_extra_colors => 'Select Extra Colors';

  @override
  String get add_more_colors => 'Add More Colors';
}
