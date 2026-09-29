import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @intro_title.
  ///
  /// In en, this message translates to:
  /// **'Shox'**
  String get intro_title;

  /// No description provided for @intro_tagline.
  ///
  /// In en, this message translates to:
  /// **'Your digital shoe wardrobe'**
  String get intro_tagline;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your whole shoe collection, always with you.'**
  String get welcome_subtitle;

  /// No description provided for @intro_screen_load_data_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to load user data'**
  String get intro_screen_load_data_error;

  /// No description provided for @onboarding_first_title.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get onboarding_first_title;

  /// No description provided for @onboarding_first_description.
  ///
  /// In en, this message translates to:
  /// **'Add all your shoes to this digital box to always have them with you. Easily organize your collection and keep track of every pair you own at your fingertips.'**
  String get onboarding_first_description;

  /// No description provided for @onboarding_second_title.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get onboarding_second_title;

  /// No description provided for @onboarding_second_description.
  ///
  /// In en, this message translates to:
  /// **'Filter your favorite shoes using advanced filters. Search by brand, model, color, and more, and discover all the features of your shoes in a snap.'**
  String get onboarding_second_description;

  /// No description provided for @onboarding_third_title.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get onboarding_third_title;

  /// No description provided for @onboarding_third_description.
  ///
  /// In en, this message translates to:
  /// **'View detailed cards of your shoes complete with all their features. From technical specifications to photos, explore every aspect of your shoes with an intuitive interface.'**
  String get onboarding_third_description;

  /// No description provided for @onboarding_fourth_title.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get onboarding_fourth_title;

  /// No description provided for @onboarding_fourth_description.
  ///
  /// In en, this message translates to:
  /// **'Explore various colorful charts that display detailed statistics about the total and the specifications of yours shoes in the database.'**
  String get onboarding_fourth_description;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_finish.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboarding_finish;

  /// No description provided for @welcome_text.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get welcome_text;

  /// No description provided for @welcome_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get welcome_login;

  /// No description provided for @welcome_signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get welcome_signup;

  /// No description provided for @signup_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup_screen_title;

  /// No description provided for @signup_screen_text.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup_screen_text;

  /// No description provided for @signup_screen_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signup_screen_account;

  /// No description provided for @signup_screen_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signup_screen_login;

  /// No description provided for @signup_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered!'**
  String get signup_toast_success;

  /// No description provided for @signup_toast_error_email_already_register.
  ///
  /// In en, this message translates to:
  /// **'The email entered has already been registered'**
  String get signup_toast_error_email_already_register;

  /// No description provided for @signup_toast_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error during registration:'**
  String get signup_toast_error_generic;

  /// No description provided for @login_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_screen_title;

  /// No description provided for @login_screen_text.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_screen_text;

  /// No description provided for @login_screen_remember.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get login_screen_remember;

  /// No description provided for @login_screen_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_screen_password;

  /// No description provided for @login_screen_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get login_screen_account;

  /// No description provided for @login_screen_signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get login_screen_signup;

  /// No description provided for @login_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get login_toast_success;

  /// No description provided for @login_toast_error_email_not_found.
  ///
  /// In en, this message translates to:
  /// **'The email entered does not match any account'**
  String get login_toast_error_email_not_found;

  /// No description provided for @login_toast_error_invalid_password.
  ///
  /// In en, this message translates to:
  /// **'The password entered does not match any account'**
  String get login_toast_error_invalid_password;

  /// No description provided for @session_expired_message.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get session_expired_message;

  /// No description provided for @startup_error_message.
  ///
  /// In en, this message translates to:
  /// **'Unable to start the app. Check your internet connection and try again.'**
  String get startup_error_message;

  /// No description provided for @login_toast_error_network.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach Google. Check your internet connection and try again.'**
  String get login_toast_error_network;

  /// No description provided for @login_toast_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error during login:'**
  String get login_toast_error_generic;

  /// No description provided for @logout_toast_success.
  ///
  /// In en, this message translates to:
  /// **'See you soon!'**
  String get logout_toast_success;

  /// No description provided for @logout_toast_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error during logout'**
  String get logout_toast_error_generic;

  /// No description provided for @reset_password_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_screen_title;

  /// No description provided for @reset_password_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive the link with the procedure to reset your password'**
  String get reset_password_screen_description;

  /// No description provided for @reset_password_screen_text.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reset_password_screen_text;

  /// No description provided for @reset_password_form_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get reset_password_form_email;

  /// No description provided for @reset_password_form_email_field.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get reset_password_form_email_field;

  /// No description provided for @reset_password_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to: '**
  String get reset_password_toast_success;

  /// No description provided for @reset_password_toast_error_email_not_found.
  ///
  /// In en, this message translates to:
  /// **'The email entered is not registered'**
  String get reset_password_toast_error_email_not_found;

  /// No description provided for @reset_password_toast_error_password.
  ///
  /// In en, this message translates to:
  /// **'Error during password reset'**
  String get reset_password_toast_error_password;

  /// No description provided for @gender_selection_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get gender_selection_screen_title;

  /// No description provided for @gender_selection_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Gender'**
  String get gender_selection_screen_subtitle;

  /// No description provided for @gender_selection_screen_description.
  ///
  /// In en, this message translates to:
  /// **'This will help us customize your shoe collection experience'**
  String get gender_selection_screen_description;

  /// No description provided for @gender_selection_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get gender_selection_button;

  /// No description provided for @gender_selection_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Preference saved successfully!'**
  String get gender_selection_toast_success;

  /// No description provided for @gender_selection_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error saving preference'**
  String get gender_selection_toast_error;

  /// No description provided for @gender_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get gender_male;

  /// No description provided for @gender_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get gender_female;

  /// No description provided for @gender_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get gender_other;

  /// No description provided for @validator_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get validator_name;

  /// No description provided for @validator_name_empty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get validator_name_empty;

  /// No description provided for @validator_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get validator_name_hint;

  /// No description provided for @validator_name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validator_name_required;

  /// No description provided for @validator_name_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid name: '**
  String get validator_name_error;

  /// No description provided for @validator_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get validator_email;

  /// No description provided for @validator_email_missing_special.
  ///
  /// In en, this message translates to:
  /// **'Missing @ symbol'**
  String get validator_email_missing_special;

  /// No description provided for @validator_email_missing_dot.
  ///
  /// In en, this message translates to:
  /// **'Missing . symbol'**
  String get validator_email_missing_dot;

  /// No description provided for @validator_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get validator_email_hint;

  /// No description provided for @validator_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validator_email_required;

  /// No description provided for @validator_email_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid email: '**
  String get validator_email_error;

  /// No description provided for @validator_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get validator_password;

  /// No description provided for @validator_password_missing_upper.
  ///
  /// In en, this message translates to:
  /// **'Missing uppercase letter'**
  String get validator_password_missing_upper;

  /// No description provided for @validator_password_missing_lower.
  ///
  /// In en, this message translates to:
  /// **'Missing lowercase letter'**
  String get validator_password_missing_lower;

  /// No description provided for @validator_password_missing_digit.
  ///
  /// In en, this message translates to:
  /// **'Missing digit'**
  String get validator_password_missing_digit;

  /// No description provided for @validator_password_missing_special.
  ///
  /// In en, this message translates to:
  /// **'Missing special character'**
  String get validator_password_missing_special;

  /// No description provided for @validator_password_missing_lenght.
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 8 characters long'**
  String get validator_password_missing_lenght;

  /// No description provided for @validator_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get validator_password_hint;

  /// No description provided for @validator_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validator_password_required;

  /// No description provided for @validator_password_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid password: '**
  String get validator_password_error;

  /// No description provided for @permission_storage_denied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get permission_storage_denied;

  /// No description provided for @permission_storage_toast.
  ///
  /// In en, this message translates to:
  /// **'Grant storage permission from settings'**
  String get permission_storage_toast;

  /// No description provided for @permission_camera_denied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get permission_camera_denied;

  /// No description provided for @permission_camera_toast.
  ///
  /// In en, this message translates to:
  /// **'Grant camera permission from settings'**
  String get permission_camera_toast;

  /// No description provided for @home_screen_welcome_text.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get home_screen_welcome_text;

  /// No description provided for @home_screen_search_bar.
  ///
  /// In en, this message translates to:
  /// **'Search brand, type, notes'**
  String get home_screen_search_bar;

  /// No description provided for @home_screen_filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get home_screen_filter_title;

  /// No description provided for @home_screen_filter_color_primary.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get home_screen_filter_color_primary;

  /// No description provided for @home_screen_filter_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get home_screen_filter_category;

  /// No description provided for @home_screen_filter_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get home_screen_filter_type;

  /// No description provided for @home_screen_filter_season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get home_screen_filter_season;

  /// No description provided for @home_screen_filter_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get home_screen_filter_reset;

  /// No description provided for @home_screen_filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get home_screen_filter_apply;

  /// No description provided for @home_screen_error_state.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get home_screen_error_state;

  /// No description provided for @home_screen_empty_state.
  ///
  /// In en, this message translates to:
  /// **'No shoes in the box'**
  String get home_screen_empty_state;

  /// No description provided for @home_screen_no_results_state.
  ///
  /// In en, this message translates to:
  /// **'No shoes match the selected filters'**
  String get home_screen_no_results_state;

  /// No description provided for @home_screen_no_results_reset.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get home_screen_no_results_reset;

  /// No description provided for @home_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Your collection'**
  String get home_screen_title;

  /// No description provided for @home_screen_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get home_screen_add;

  /// No description provided for @home_screen_chip_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get home_screen_chip_all;

  /// No description provided for @home_screen_chip_favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get home_screen_chip_favorites;

  /// No description provided for @home_screen_pairs_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pair} other{{count} pairs}}'**
  String home_screen_pairs_count(int count);

  /// No description provided for @home_screen_favorites_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 favorite} other{{count} favorites}}'**
  String home_screen_favorites_count(int count);

  /// No description provided for @home_screen_card_size.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String home_screen_card_size(String size);

  /// No description provided for @shoes_adder_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Add Shoes'**
  String get shoes_adder_screen_title;

  /// No description provided for @shoes_adder_screen_field_color_primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get shoes_adder_screen_field_color_primary;

  /// No description provided for @shoes_adder_screen_field_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get shoes_adder_screen_field_brand;

  /// No description provided for @shoes_adder_screen_field_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get shoes_adder_screen_field_size;

  /// No description provided for @shoes_adder_screen_field_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get shoes_adder_screen_field_category;

  /// No description provided for @shoes_adder_screen_field_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get shoes_adder_screen_field_type;

  /// No description provided for @shoes_adder_screen_select_category.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get shoes_adder_screen_select_category;

  /// No description provided for @shoes_adder_screen_select_type.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get shoes_adder_screen_select_type;

  /// No description provided for @shoes_adder_screen_field_season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get shoes_adder_screen_field_season;

  /// No description provided for @shoes_adder_screen_field_note.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get shoes_adder_screen_field_note;

  /// No description provided for @shoes_form_screen_section_photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get shoes_form_screen_section_photo;

  /// No description provided for @shoes_form_screen_section_colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get shoes_form_screen_section_colors;

  /// No description provided for @shoes_form_screen_section_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get shoes_form_screen_section_details;

  /// No description provided for @shoes_form_screen_section_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get shoes_form_screen_section_notes;

  /// No description provided for @shoes_form_screen_add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get shoes_form_screen_add_photo;

  /// No description provided for @shoes_form_screen_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get shoes_form_screen_save;

  /// No description provided for @shoes_adder_screen_crop_image_title.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get shoes_adder_screen_crop_image_title;

  /// No description provided for @shoes_adder_screen_toast_error_image.
  ///
  /// In en, this message translates to:
  /// **'You did not select an image'**
  String get shoes_adder_screen_toast_error_image;

  /// No description provided for @shoes_adder_screen_toast_error_color.
  ///
  /// In en, this message translates to:
  /// **'You did not select the primary color'**
  String get shoes_adder_screen_toast_error_color;

  /// No description provided for @shoes_adder_screen_toast_error_brand.
  ///
  /// In en, this message translates to:
  /// **'You did not enter the brand'**
  String get shoes_adder_screen_toast_error_brand;

  /// No description provided for @shoes_adder_screen_toast_error_size.
  ///
  /// In en, this message translates to:
  /// **'You did not enter the size'**
  String get shoes_adder_screen_toast_error_size;

  /// No description provided for @shoes_adder_screen_toast_error_category.
  ///
  /// In en, this message translates to:
  /// **'You did not select a category'**
  String get shoes_adder_screen_toast_error_category;

  /// No description provided for @shoes_adder_screen_toast_error_type.
  ///
  /// In en, this message translates to:
  /// **'You did not select a type'**
  String get shoes_adder_screen_toast_error_type;

  /// No description provided for @shoes_adder_screen_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Shoes added successfully!'**
  String get shoes_adder_screen_toast_success;

  /// No description provided for @shoes_adder_screen_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error during saving'**
  String get shoes_adder_screen_toast_error;

  /// No description provided for @shoes_form_screen_bg_remove_loading.
  ///
  /// In en, this message translates to:
  /// **'Removing background...'**
  String get shoes_form_screen_bg_remove_loading;

  /// No description provided for @shoes_form_screen_bg_remove_downloading.
  ///
  /// In en, this message translates to:
  /// **'Background removal is being set up on your device: try again in a moment.'**
  String get shoes_form_screen_bg_remove_downloading;

  /// No description provided for @shoes_form_screen_bg_remove_success.
  ///
  /// In en, this message translates to:
  /// **'Background removed successfully'**
  String get shoes_form_screen_bg_remove_success;

  /// No description provided for @shoes_form_screen_bg_remove_error.
  ///
  /// In en, this message translates to:
  /// **'Error removing background: '**
  String get shoes_form_screen_bg_remove_error;

  /// No description provided for @shoes_updater_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Update Shoes'**
  String get shoes_updater_screen_title;

  /// No description provided for @shoes_updater_screen_field_color_primary.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get shoes_updater_screen_field_color_primary;

  /// No description provided for @shoes_updater_screen_field_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get shoes_updater_screen_field_brand;

  /// No description provided for @shoes_updater_screen_field_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get shoes_updater_screen_field_size;

  /// No description provided for @shoes_updater_screen_field_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get shoes_updater_screen_field_category;

  /// No description provided for @shoes_updater_screen_field_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get shoes_updater_screen_field_type;

  /// No description provided for @shoes_updater_screen_field_season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get shoes_updater_screen_field_season;

  /// No description provided for @shoes_updater_screen_field_note.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get shoes_updater_screen_field_note;

  /// No description provided for @shoes_updater_screen_crop_image_title.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get shoes_updater_screen_crop_image_title;

  /// No description provided for @shoes_updater_screen_toast_error_brand.
  ///
  /// In en, this message translates to:
  /// **'You did not enter the brand'**
  String get shoes_updater_screen_toast_error_brand;

  /// No description provided for @shoes_updater_screen_toast_error_size.
  ///
  /// In en, this message translates to:
  /// **'You did not enter the size'**
  String get shoes_updater_screen_toast_error_size;

  /// No description provided for @shoes_updater_screen_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Shoes updated successfully!'**
  String get shoes_updater_screen_toast_success;

  /// No description provided for @shoes_updater_screen_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error during update'**
  String get shoes_updater_screen_toast_error;

  /// No description provided for @shoes_details_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Shoes Details'**
  String get shoes_details_screen_title;

  /// No description provided for @shoes_details_screen_field_color.
  ///
  /// In en, this message translates to:
  /// **'COLORS'**
  String get shoes_details_screen_field_color;

  /// No description provided for @shoes_details_screen_field_color_primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get shoes_details_screen_field_color_primary;

  /// No description provided for @shoes_details_screen_field_brand.
  ///
  /// In en, this message translates to:
  /// **'BRAND'**
  String get shoes_details_screen_field_brand;

  /// No description provided for @shoes_details_screen_field_size.
  ///
  /// In en, this message translates to:
  /// **'SIZE'**
  String get shoes_details_screen_field_size;

  /// No description provided for @shoes_details_screen_field_category.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get shoes_details_screen_field_category;

  /// No description provided for @shoes_details_screen_field_type.
  ///
  /// In en, this message translates to:
  /// **'TYPE'**
  String get shoes_details_screen_field_type;

  /// No description provided for @shoes_details_screen_field_season.
  ///
  /// In en, this message translates to:
  /// **'SEASON'**
  String get shoes_details_screen_field_season;

  /// No description provided for @shoes_details_screen_field_note.
  ///
  /// In en, this message translates to:
  /// **'NOTES'**
  String get shoes_details_screen_field_note;

  /// No description provided for @shoes_details_screen_field_added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get shoes_details_screen_field_added;

  /// No description provided for @shoes_details_screen_menu_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get shoes_details_screen_menu_edit;

  /// No description provided for @shoes_details_screen_menu_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shoes_details_screen_menu_share;

  /// No description provided for @shoes_details_screen_menu_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get shoes_details_screen_menu_delete;

  /// No description provided for @shoes_details_screen_share_success.
  ///
  /// In en, this message translates to:
  /// **'Screenshot shared successfully!'**
  String get shoes_details_screen_share_success;

  /// No description provided for @shoes_details_screen_share_error.
  ///
  /// In en, this message translates to:
  /// **'Error sharing screenshot'**
  String get shoes_details_screen_share_error;

  /// No description provided for @shoes_details_screen_error_state.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get shoes_details_screen_error_state;

  /// No description provided for @shoes_details_screen_empty_state.
  ///
  /// In en, this message translates to:
  /// **'No shoes found'**
  String get shoes_details_screen_empty_state;

  /// No description provided for @shoes_details_screen_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get shoes_details_screen_delete_title;

  /// No description provided for @shoes_details_screen_delete_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this shoes?'**
  String get shoes_details_screen_delete_description;

  /// No description provided for @shoes_details_screen_delete_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Shoes deleted!'**
  String get shoes_details_screen_delete_toast_success;

  /// No description provided for @user_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get user_screen_title;

  /// No description provided for @user_screen_button_database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get user_screen_button_database;

  /// No description provided for @user_screen_button_logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get user_screen_button_logout;

  /// No description provided for @user_screen_button_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get user_screen_button_delete;

  /// No description provided for @user_updater_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get user_updater_screen_title;

  /// No description provided for @user_updater_screen_crop_image_title.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get user_updater_screen_crop_image_title;

  /// No description provided for @user_updater_screen_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get user_updater_screen_save;

  /// No description provided for @user_updater_screen_username_field_error.
  ///
  /// In en, this message translates to:
  /// **'You did not enter the name'**
  String get user_updater_screen_username_field_error;

  /// No description provided for @database_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database_screen_title;

  /// No description provided for @database_screen_empty.
  ///
  /// In en, this message translates to:
  /// **'No shoes in the box'**
  String get database_screen_empty;

  /// No description provided for @database_screen_colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get database_screen_colors;

  /// No description provided for @database_screen_brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get database_screen_brands;

  /// No description provided for @database_screen_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get database_screen_categories;

  /// No description provided for @database_screen_types.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get database_screen_types;

  /// No description provided for @database_screen_pdf_download.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get database_screen_pdf_download;

  /// No description provided for @database_screen_pdf_confirm.
  ///
  /// In en, this message translates to:
  /// **'PDF saved to Download folder'**
  String get database_screen_pdf_confirm;

  /// No description provided for @database_screen_pdf_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF'**
  String get database_screen_pdf_error;

  /// No description provided for @database_screen_export_menu.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get database_screen_export_menu;

  /// No description provided for @database_screen_import_menu.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get database_screen_import_menu;

  /// No description provided for @database_screen_export_success.
  ///
  /// In en, this message translates to:
  /// **'JSON exported to Download folder'**
  String get database_screen_export_success;

  /// No description provided for @database_screen_export_error.
  ///
  /// In en, this message translates to:
  /// **'Error during export'**
  String get database_screen_export_error;

  /// No description provided for @database_screen_import_success.
  ///
  /// In en, this message translates to:
  /// **'JSON imported successfully!'**
  String get database_screen_import_success;

  /// No description provided for @database_screen_import_error.
  ///
  /// In en, this message translates to:
  /// **'Error during import'**
  String get database_screen_import_error;

  /// No description provided for @delete_account_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account_screen_title;

  /// No description provided for @delete_account_screen_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Account deleted!'**
  String get delete_account_screen_toast_success;

  /// No description provided for @delete_account_screen_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error during the deletion process:'**
  String get delete_account_screen_toast_error;

  /// No description provided for @delete_account_screen_delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get delete_account_screen_delete_dialog_title;

  /// No description provided for @delete_account_screen_delete_dialog_text.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account?'**
  String get delete_account_screen_delete_dialog_text;

  /// No description provided for @delete_account_screen_text_a.
  ///
  /// In en, this message translates to:
  /// **'Are you really sure you want to delete your account?'**
  String get delete_account_screen_text_a;

  /// No description provided for @delete_account_screen_text_b.
  ///
  /// In en, this message translates to:
  /// **'This is an irreversible action and all data associated with this account will be permanently deleted without any possibility of recovery.'**
  String get delete_account_screen_text_b;

  /// No description provided for @delete_account_screen_text_c.
  ///
  /// In en, this message translates to:
  /// **'To proceed, click the button below'**
  String get delete_account_screen_text_c;

  /// No description provided for @delete_account_screen_delete_button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_account_screen_delete_button;

  /// No description provided for @delete_account_screen_backup_title.
  ///
  /// In en, this message translates to:
  /// **'Backup Your Data'**
  String get delete_account_screen_backup_title;

  /// No description provided for @delete_account_screen_backup_text.
  ///
  /// In en, this message translates to:
  /// **'Before deleting your account, would you like to download a backup of your shoe database in JSON format? This will help you preserve your data.'**
  String get delete_account_screen_backup_text;

  /// No description provided for @delete_account_screen_backup_button.
  ///
  /// In en, this message translates to:
  /// **'Download Backup'**
  String get delete_account_screen_backup_button;

  /// No description provided for @delete_account_screen_skip_backup.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get delete_account_screen_skip_backup;

  /// No description provided for @delete_account_screen_backup_success.
  ///
  /// In en, this message translates to:
  /// **'Database backed up successfully!'**
  String get delete_account_screen_backup_success;

  /// No description provided for @delete_account_screen_backup_error.
  ///
  /// In en, this message translates to:
  /// **'Error during backup:'**
  String get delete_account_screen_backup_error;

  /// No description provided for @delete_account_screen_what_happens.
  ///
  /// In en, this message translates to:
  /// **'What will happen?'**
  String get delete_account_screen_what_happens;

  /// No description provided for @delete_account_screen_item_a.
  ///
  /// In en, this message translates to:
  /// **'Your profile and login credentials will be permanently removed'**
  String get delete_account_screen_item_a;

  /// No description provided for @delete_account_screen_item_b.
  ///
  /// In en, this message translates to:
  /// **'All shoes saved in your database will be deleted'**
  String get delete_account_screen_item_b;

  /// No description provided for @delete_account_screen_item_c.
  ///
  /// In en, this message translates to:
  /// **'Images associated with your shoes will be erased'**
  String get delete_account_screen_item_c;

  /// No description provided for @settings_screen_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_screen_language;

  /// No description provided for @settings_screen_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get settings_screen_info;

  /// No description provided for @settings_screen_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_screen_policy;

  /// No description provided for @settings_screen_support.
  ///
  /// In en, this message translates to:
  /// **'Help Desk'**
  String get settings_screen_support;

  /// No description provided for @info_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info_screen_title;

  /// No description provided for @policy_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get policy_screen_title;

  /// No description provided for @info_screen_version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String info_screen_version(String version);

  /// No description provided for @info_screen_about_title.
  ///
  /// In en, this message translates to:
  /// **'What is Shox'**
  String get info_screen_about_title;

  /// No description provided for @info_screen_about_text.
  ///
  /// In en, this message translates to:
  /// **'Shox is your digital shoe wardrobe: photograph every pair, note brand, size, colors and season, and find what you are looking for right away. The name blends “Shoes” and “Box”, the box that holds your whole collection.'**
  String get info_screen_about_text;

  /// No description provided for @info_screen_features_title.
  ///
  /// In en, this message translates to:
  /// **'What you can do'**
  String get info_screen_features_title;

  /// No description provided for @info_screen_feature_collection_title.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get info_screen_feature_collection_title;

  /// No description provided for @info_screen_feature_collection_text.
  ///
  /// In en, this message translates to:
  /// **'Photos with background removal, brand, size, category, colors and notes.'**
  String get info_screen_feature_collection_text;

  /// No description provided for @info_screen_feature_search_title.
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get info_screen_feature_search_title;

  /// No description provided for @info_screen_feature_search_text.
  ///
  /// In en, this message translates to:
  /// **'Search, quick category filters and favorites.'**
  String get info_screen_feature_search_text;

  /// No description provided for @info_screen_feature_stats_title.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get info_screen_feature_stats_title;

  /// No description provided for @info_screen_feature_stats_text.
  ///
  /// In en, this message translates to:
  /// **'Collection statistics and PDF export.'**
  String get info_screen_feature_stats_text;

  /// No description provided for @info_screen_feature_backup_title.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get info_screen_feature_backup_title;

  /// No description provided for @info_screen_feature_backup_text.
  ///
  /// In en, this message translates to:
  /// **'Back up and restore your collection as JSON.'**
  String get info_screen_feature_backup_text;

  /// No description provided for @info_screen_links_title.
  ///
  /// In en, this message translates to:
  /// **'Useful links'**
  String get info_screen_links_title;

  /// No description provided for @info_screen_link_source.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get info_screen_link_source;

  /// No description provided for @info_screen_link_website.
  ///
  /// In en, this message translates to:
  /// **'Developer website'**
  String get info_screen_link_website;

  /// No description provided for @info_screen_link_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact the developer'**
  String get info_screen_link_contact;

  /// No description provided for @info_screen_link_licenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get info_screen_link_licenses;

  /// No description provided for @info_screen_made_by.
  ///
  /// In en, this message translates to:
  /// **'Designed and developed by {name}'**
  String info_screen_made_by(String name);

  /// No description provided for @policy_screen_updated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String policy_screen_updated(String date);

  /// No description provided for @policy_screen_intro.
  ///
  /// In en, this message translates to:
  /// **'This policy explains which data Shox processes, why, and how you can manage it. Shox shows no ads, uses no analytics tools and does not sell or share your data.'**
  String get policy_screen_intro;

  /// No description provided for @policy_section_controller_title.
  ///
  /// In en, this message translates to:
  /// **'Data controller'**
  String get policy_section_controller_title;

  /// No description provided for @policy_section_controller_text.
  ///
  /// In en, this message translates to:
  /// **'The controller is the app developer, {name}. For any privacy request you can write to {email}.'**
  String policy_section_controller_text(String name, String email);

  /// No description provided for @policy_section_data_title.
  ///
  /// In en, this message translates to:
  /// **'Data we collect'**
  String get policy_section_data_title;

  /// No description provided for @policy_section_data_text.
  ///
  /// In en, this message translates to:
  /// **'• Account: email, name, profile photo (optional), gender, registration date. With Google sign-in we receive the name, email and profile photo of your Google account.\n• Collection: for each shoe its photo, brand, size, category, type, season, colors, notes, favorite flag and creation and update dates.\n• On your device: preferences such as language, theme, “remember me” and the screens you have already seen.'**
  String get policy_section_data_text;

  /// No description provided for @policy_section_use_title.
  ///
  /// In en, this message translates to:
  /// **'How we use data'**
  String get policy_section_use_title;

  /// No description provided for @policy_section_use_text.
  ///
  /// In en, this message translates to:
  /// **'Data is used only to make the app work: sign you in, save and show your collection, compute statistics and generate the files you export. We do not use it for profiling or advertising.'**
  String get policy_section_use_text;

  /// No description provided for @policy_section_storage_title.
  ///
  /// In en, this message translates to:
  /// **'Where it is stored'**
  String get policy_section_storage_title;

  /// No description provided for @policy_section_storage_text.
  ///
  /// In en, this message translates to:
  /// **'Account, collection and photos are stored on Google Firebase (Authentication, Cloud Firestore and Cloud Storage), a service by Google LLC that may process data outside the European Union with the safeguards set out in its terms. Your data is tied to your account and is not visible to other users.'**
  String get policy_section_storage_text;

  /// No description provided for @policy_section_device_title.
  ///
  /// In en, this message translates to:
  /// **'On-device processing'**
  String get policy_section_device_title;

  /// No description provided for @policy_section_device_text.
  ///
  /// In en, this message translates to:
  /// **'Photo background removal runs entirely on your phone: the photo is not sent to external services. The PDF and JSON files you export are saved on your device and shared only if you choose to.'**
  String get policy_section_device_text;

  /// No description provided for @policy_section_permissions_title.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get policy_section_permissions_title;

  /// No description provided for @policy_section_permissions_text.
  ///
  /// In en, this message translates to:
  /// **'• Camera and photos: to take or pick shoe and profile pictures.\n• Storage: to save photos to the gallery and exported files.\n• Internet: to sync your account and collection.'**
  String get policy_section_permissions_text;

  /// No description provided for @policy_section_retention_title.
  ///
  /// In en, this message translates to:
  /// **'Retention and deletion'**
  String get policy_section_retention_title;

  /// No description provided for @policy_section_retention_text.
  ///
  /// In en, this message translates to:
  /// **'We keep your data as long as your account exists. From Profile > Delete account you can delete the account, the whole collection and its photos at any time; you can export a copy first. Preferences on your device are removed when you uninstall the app.'**
  String get policy_section_retention_text;

  /// No description provided for @policy_section_rights_title.
  ///
  /// In en, this message translates to:
  /// **'Your rights'**
  String get policy_section_rights_title;

  /// No description provided for @policy_section_rights_text.
  ///
  /// In en, this message translates to:
  /// **'You can access and export your data (PDF and JSON), correct it by editing your profile and shoes, erase it by deleting your account, and ask for information by writing to the controller. You can also lodge a complaint with the data protection authority of your country.'**
  String get policy_section_rights_text;

  /// No description provided for @policy_section_children_title.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get policy_section_children_title;

  /// No description provided for @policy_section_children_text.
  ///
  /// In en, this message translates to:
  /// **'Shox is not intended for children under 14 and does not knowingly collect their data.'**
  String get policy_section_children_text;

  /// No description provided for @policy_section_changes_title.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get policy_section_changes_title;

  /// No description provided for @policy_section_changes_text.
  ///
  /// In en, this message translates to:
  /// **'If this policy changes, the new version will be available in the app and online, with its update date.'**
  String get policy_section_changes_text;

  /// No description provided for @policy_screen_online.
  ///
  /// In en, this message translates to:
  /// **'Read the online version'**
  String get policy_screen_online;

  /// No description provided for @support_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support_screen_title;

  /// No description provided for @support_screen_contacts_text.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get support_screen_contacts_text;

  /// No description provided for @support_screen_contacts_decription.
  ///
  /// In en, this message translates to:
  /// **'For any problems or questions, write to:'**
  String get support_screen_contacts_decription;

  /// No description provided for @support_screen_contacts_info.
  ///
  /// In en, this message translates to:
  /// **'ndn21dev@gmail.com'**
  String get support_screen_contacts_info;

  /// No description provided for @support_screen_faq_text.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get support_screen_faq_text;

  /// No description provided for @support_screen_faq_decription.
  ///
  /// In en, this message translates to:
  /// **'Find answers to the most frequently asked questions.'**
  String get support_screen_faq_decription;

  /// No description provided for @support_screen_faq_q1.
  ///
  /// In en, this message translates to:
  /// **'How to add a pair of shoes?'**
  String get support_screen_faq_q1;

  /// No description provided for @support_screen_faq_a1.
  ///
  /// In en, this message translates to:
  /// **'To add a pair of shoes, go to the Home and click on the \'+\' button. Fill in all the necessary details and save.'**
  String get support_screen_faq_a1;

  /// No description provided for @support_screen_faq_q2.
  ///
  /// In en, this message translates to:
  /// **'How to edit a pair of shoes?'**
  String get support_screen_faq_q2;

  /// No description provided for @support_screen_faq_a2.
  ///
  /// In en, this message translates to:
  /// **'To edit a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the \'Edit\' option. Make the changes and save.'**
  String get support_screen_faq_a2;

  /// No description provided for @support_screen_faq_q3.
  ///
  /// In en, this message translates to:
  /// **'How to delete a pair of shoes?'**
  String get support_screen_faq_q3;

  /// No description provided for @support_screen_faq_a3.
  ///
  /// In en, this message translates to:
  /// **'To delete a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the \'Delete\' option.'**
  String get support_screen_faq_a3;

  /// No description provided for @support_screen_faq_q4.
  ///
  /// In en, this message translates to:
  /// **'What happens if I delete a pair of shoes?'**
  String get support_screen_faq_q4;

  /// No description provided for @support_screen_faq_a4.
  ///
  /// In en, this message translates to:
  /// **'If you delete a pair of shoes, it will be permanently removed. You will be asked to confirm before proceeding with the operation.'**
  String get support_screen_faq_a4;

  /// No description provided for @support_screen_faq_q7.
  ///
  /// In en, this message translates to:
  /// **'What can I do if the app doesn\'t work properly?'**
  String get support_screen_faq_q7;

  /// No description provided for @support_screen_faq_a7.
  ///
  /// In en, this message translates to:
  /// **'If you encounter problems, try restarting the app. If the problem persists, contact technical support through the \'Contact Us\' section.'**
  String get support_screen_faq_a7;

  /// No description provided for @support_screen_faq_q8.
  ///
  /// In en, this message translates to:
  /// **'What can I do if the app doesn\'t work?'**
  String get support_screen_faq_q8;

  /// No description provided for @support_screen_faq_a8.
  ///
  /// In en, this message translates to:
  /// **'Close the app from background > App settings > Clear data > Clear cache > Restart the app. If the problem persists, contact technical support.'**
  String get support_screen_faq_a8;

  /// No description provided for @support_screen_faq_q9.
  ///
  /// In en, this message translates to:
  /// **'How does PDF download work?'**
  String get support_screen_faq_q9;

  /// No description provided for @support_screen_faq_a9.
  ///
  /// In en, this message translates to:
  /// **'To download your database in PDF format go to Profile section > Database > Click on the icon at the top right > Download PDF.'**
  String get support_screen_faq_a9;

  /// No description provided for @support_screen_faq_q10.
  ///
  /// In en, this message translates to:
  /// **'How does JSON database import work?'**
  String get support_screen_faq_q10;

  /// No description provided for @support_screen_faq_a10.
  ///
  /// In en, this message translates to:
  /// **'You can import the database in JSON format (if previously exported from the app).'**
  String get support_screen_faq_a10;

  /// No description provided for @support_screen_faq_q11.
  ///
  /// In en, this message translates to:
  /// **'How does JSON database export work?'**
  String get support_screen_faq_q11;

  /// No description provided for @support_screen_faq_a11.
  ///
  /// In en, this message translates to:
  /// **'You can export the database in JSON format to preserve the current data in the database and then import it on another device via the app.'**
  String get support_screen_faq_a11;

  /// No description provided for @support_screen_documentation_text.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get support_screen_documentation_text;

  /// No description provided for @support_screen_documentation_decription.
  ///
  /// In en, this message translates to:
  /// **'Refer to the full documentation on the app\'s webpage.'**
  String get support_screen_documentation_decription;

  /// No description provided for @support_screen_documentation_info.
  ///
  /// In en, this message translates to:
  /// **'Go to the webpage on GitHub'**
  String get support_screen_documentation_info;

  /// No description provided for @color_white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get color_white;

  /// No description provided for @color_black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get color_black;

  /// No description provided for @color_light_grey.
  ///
  /// In en, this message translates to:
  /// **'Light Grey'**
  String get color_light_grey;

  /// No description provided for @color_dark_grey.
  ///
  /// In en, this message translates to:
  /// **'Dark Grey'**
  String get color_dark_grey;

  /// No description provided for @color_orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get color_orange;

  /// No description provided for @color_pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get color_pink;

  /// No description provided for @color_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get color_red;

  /// No description provided for @color_bordeaux.
  ///
  /// In en, this message translates to:
  /// **'Bordeaux'**
  String get color_bordeaux;

  /// No description provided for @color_camel.
  ///
  /// In en, this message translates to:
  /// **'Camel'**
  String get color_camel;

  /// No description provided for @color_beige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get color_beige;

  /// No description provided for @color_light_brown.
  ///
  /// In en, this message translates to:
  /// **'Light Brown'**
  String get color_light_brown;

  /// No description provided for @color_dark_brown.
  ///
  /// In en, this message translates to:
  /// **'Dark Brown'**
  String get color_dark_brown;

  /// No description provided for @color_yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get color_yellow;

  /// No description provided for @color_green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get color_green;

  /// No description provided for @color_light_blue.
  ///
  /// In en, this message translates to:
  /// **'Light Blue'**
  String get color_light_blue;

  /// No description provided for @color_dark_blue.
  ///
  /// In en, this message translates to:
  /// **'Dark Blue'**
  String get color_dark_blue;

  /// No description provided for @category_sneakers.
  ///
  /// In en, this message translates to:
  /// **'Sneakers'**
  String get category_sneakers;

  /// No description provided for @category_elegant.
  ///
  /// In en, this message translates to:
  /// **'Elegant'**
  String get category_elegant;

  /// No description provided for @category_heeled.
  ///
  /// In en, this message translates to:
  /// **'Heeled'**
  String get category_heeled;

  /// No description provided for @category_sandals.
  ///
  /// In en, this message translates to:
  /// **'Sandals'**
  String get category_sandals;

  /// No description provided for @category_mules.
  ///
  /// In en, this message translates to:
  /// **'Mules'**
  String get category_mules;

  /// No description provided for @category_boots.
  ///
  /// In en, this message translates to:
  /// **'Boots'**
  String get category_boots;

  /// No description provided for @category_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get category_other;

  /// No description provided for @type_sport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get type_sport;

  /// No description provided for @type_casual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get type_casual;

  /// No description provided for @type_lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get type_lifestyle;

  /// No description provided for @type_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get type_running;

  /// No description provided for @type_dressy.
  ///
  /// In en, this message translates to:
  /// **'Dressy'**
  String get type_dressy;

  /// No description provided for @type_loafers.
  ///
  /// In en, this message translates to:
  /// **'Loafers'**
  String get type_loafers;

  /// No description provided for @type_decollete.
  ///
  /// In en, this message translates to:
  /// **'Decolleté'**
  String get type_decollete;

  /// No description provided for @type_spuntas.
  ///
  /// In en, this message translates to:
  /// **'Peep'**
  String get type_spuntas;

  /// No description provided for @type_wedge.
  ///
  /// In en, this message translates to:
  /// **'Wedge'**
  String get type_wedge;

  /// No description provided for @type_lace_up.
  ///
  /// In en, this message translates to:
  /// **'Lace-Up'**
  String get type_lace_up;

  /// No description provided for @type_flat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get type_flat;

  /// No description provided for @type_heeled.
  ///
  /// In en, this message translates to:
  /// **'Heeled'**
  String get type_heeled;

  /// No description provided for @type_ankle_boots.
  ///
  /// In en, this message translates to:
  /// **'Ankle boots'**
  String get type_ankle_boots;

  /// No description provided for @type_high_boots.
  ///
  /// In en, this message translates to:
  /// **'High boots'**
  String get type_high_boots;

  /// No description provided for @type_work_boots.
  ///
  /// In en, this message translates to:
  /// **'Work boots'**
  String get type_work_boots;

  /// No description provided for @type_knee_high.
  ///
  /// In en, this message translates to:
  /// **'Knee-high'**
  String get type_knee_high;

  /// No description provided for @type_classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get type_classic;

  /// No description provided for @type_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get type_other;

  /// No description provided for @pdf_field_id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get pdf_field_id;

  /// No description provided for @pdf_field_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pdf_field_date;

  /// No description provided for @pdf_field_color_primary.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get pdf_field_color_primary;

  /// No description provided for @pdf_field_color_secondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary Color'**
  String get pdf_field_color_secondary;

  /// No description provided for @pdf_field_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get pdf_field_brand;

  /// No description provided for @pdf_field_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get pdf_field_size;

  /// No description provided for @pdf_field_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get pdf_field_category;

  /// No description provided for @pdf_field_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get pdf_field_type;

  /// No description provided for @pdf_field_season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get pdf_field_season;

  /// No description provided for @pdf_field_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get pdf_field_notes;

  /// No description provided for @pdf_copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2024 Nicola De Nicolais'**
  String get pdf_copyright;

  /// No description provided for @full_screen_image_save_success_toast.
  ///
  /// In en, this message translates to:
  /// **'Image saved successfully!'**
  String get full_screen_image_save_success_toast;

  /// No description provided for @full_screen_image_save_error_toast.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image.'**
  String get full_screen_image_save_error_toast;

  /// No description provided for @full_screen_image_download_error_toast.
  ///
  /// In en, this message translates to:
  /// **'Failed to download image.'**
  String get full_screen_image_download_error_toast;

  /// No description provided for @full_screen_image_share_success_toast.
  ///
  /// In en, this message translates to:
  /// **'Image shared successfully!'**
  String get full_screen_image_share_success_toast;

  /// No description provided for @full_screen_image_share_download_error_toast.
  ///
  /// In en, this message translates to:
  /// **'Failed to download image for sharing.'**
  String get full_screen_image_share_download_error_toast;

  /// No description provided for @full_screen_image_share_error_toast.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get full_screen_image_share_error_toast;

  /// No description provided for @shoes_form_screen_unsaved_title.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get shoes_form_screen_unsaved_title;

  /// No description provided for @shoes_form_screen_unsaved_text.
  ///
  /// In en, this message translates to:
  /// **'If you leave now, the changes to this shoe will be lost.'**
  String get shoes_form_screen_unsaved_text;

  /// No description provided for @shoes_form_screen_unsaved_stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get shoes_form_screen_unsaved_stay;

  /// No description provided for @shoes_form_screen_unsaved_leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get shoes_form_screen_unsaved_leave;

  /// No description provided for @custom_delete_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get custom_delete_dialog_confirm;

  /// No description provided for @custom_delete_dialog_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get custom_delete_dialog_cancel;

  /// No description provided for @database_screen_pdf_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get database_screen_pdf_user;

  /// No description provided for @database_screen_pdf_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get database_screen_pdf_name;

  /// No description provided for @database_screen_pdf_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get database_screen_pdf_email;

  /// No description provided for @database_screen_pdf_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get database_screen_pdf_date;

  /// No description provided for @database_screen_pdf_shoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get database_screen_pdf_shoes;

  /// No description provided for @database_screen_pdf_page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get database_screen_pdf_page;

  /// No description provided for @auth_or_continue_with.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get auth_or_continue_with;

  /// No description provided for @auth_sign_in_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get auth_sign_in_with_google;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @dashboard_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard_screen_title;

  /// No description provided for @dashboard_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get dashboard_preferences;

  /// No description provided for @dashboard_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get dashboard_theme;

  /// No description provided for @theme_mode_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_mode_system;

  /// No description provided for @theme_mode_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_mode_light;

  /// No description provided for @theme_mode_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_mode_dark;

  /// No description provided for @dashboard_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get dashboard_account;

  /// No description provided for @dashboard_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashboard_profile;

  /// No description provided for @dashboard_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dashboard_logout;

  /// No description provided for @dashboard_share_app.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get dashboard_share_app;

  /// No description provided for @dashboard_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get dashboard_version;

  /// No description provided for @dashboard_information.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get dashboard_information;

  /// No description provided for @dashboard_changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get dashboard_changelog;

  /// No description provided for @a11y_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get a11y_profile;

  /// No description provided for @a11y_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get a11y_settings;

  /// No description provided for @a11y_add_shoe.
  ///
  /// In en, this message translates to:
  /// **'Add shoe'**
  String get a11y_add_shoe;

  /// No description provided for @a11y_filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get a11y_filters;

  /// No description provided for @a11y_clear_search.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get a11y_clear_search;

  /// No description provided for @a11y_toggle_grid.
  ///
  /// In en, this message translates to:
  /// **'Change grid layout'**
  String get a11y_toggle_grid;

  /// No description provided for @a11y_show_only_favorites.
  ///
  /// In en, this message translates to:
  /// **'Show only favorites'**
  String get a11y_show_only_favorites;

  /// No description provided for @a11y_show_all_shoes.
  ///
  /// In en, this message translates to:
  /// **'Show all shoes'**
  String get a11y_show_all_shoes;

  /// No description provided for @a11y_add_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get a11y_add_to_favorites;

  /// No description provided for @a11y_remove_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get a11y_remove_from_favorites;

  /// No description provided for @a11y_open_image.
  ///
  /// In en, this message translates to:
  /// **'Open image full screen'**
  String get a11y_open_image;

  /// No description provided for @a11y_download_image.
  ///
  /// In en, this message translates to:
  /// **'Download image'**
  String get a11y_download_image;

  /// No description provided for @a11y_share_image.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get a11y_share_image;

  /// No description provided for @a11y_take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get a11y_take_photo;

  /// No description provided for @a11y_pick_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get a11y_pick_from_gallery;

  /// No description provided for @a11y_remove_image.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get a11y_remove_image;

  /// No description provided for @a11y_remove_background.
  ///
  /// In en, this message translates to:
  /// **'Remove background'**
  String get a11y_remove_background;

  /// No description provided for @a11y_save_shoe.
  ///
  /// In en, this message translates to:
  /// **'Save shoe'**
  String get a11y_save_shoe;

  /// No description provided for @a11y_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get a11y_edit_profile;

  /// No description provided for @a11y_change_profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get a11y_change_profile_photo;

  /// No description provided for @a11y_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get a11y_loading;

  /// No description provided for @changelog_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get changelog_dialog_title;

  /// No description provided for @changelog_dialog_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get changelog_dialog_close;

  /// No description provided for @changelog_v5_0_0_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'A brand-new look across the whole app, keeping the original warm palette: home with quick category filters, redesigned shoe details and add form, new profile, statistics, settings and sign-in screens.'**
  String get changelog_v5_0_0_bullet_1;

  /// No description provided for @changelog_v5_0_0_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'New System / Light / Dark theme selector that follows your phone\'s light/dark switch right away.'**
  String get changelog_v5_0_0_bullet_2;

  /// No description provided for @changelog_v5_0_0_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'Smoother home screen: grid preview while loading, fade transitions, pull down to refresh and photos that always fill their tile.'**
  String get changelog_v5_0_0_bullet_3;

  /// No description provided for @changelog_v5_0_0_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'Search also by type, category and notes; more reliable filters, with a dedicated message and a clear button when nothing matches.'**
  String get changelog_v5_0_0_bullet_4;

  /// No description provided for @changelog_v5_0_0_bullet_5.
  ///
  /// In en, this message translates to:
  /// **'Shoe form: confirmation before leaving with unsaved changes; editing a shoe no longer removes it from favorites and a photo is always required.'**
  String get changelog_v5_0_0_bullet_5;

  /// No description provided for @changelog_v5_0_0_bullet_6.
  ///
  /// In en, this message translates to:
  /// **'More reliable sign-in: clear Google error messages, a Retry screen if the app fails to start and a return to the welcome screen when your session expires.'**
  String get changelog_v5_0_0_bullet_6;

  /// No description provided for @changelog_v5_0_0_bullet_7.
  ///
  /// In en, this message translates to:
  /// **'Adaptive layout for phones and tablets with free rotation, text that follows your phone\'s font size up to 130% and buttons readable by screen readers.'**
  String get changelog_v5_0_0_bullet_7;

  /// No description provided for @changelog_v5_0_0_bullet_8.
  ///
  /// In en, this message translates to:
  /// **'Account deletion moved to the Profile screen.'**
  String get changelog_v5_0_0_bullet_8;

  /// No description provided for @changelog_v5_0_0_bullet_9.
  ///
  /// In en, this message translates to:
  /// **'Fixed overlapping charts in the database section.'**
  String get changelog_v5_0_0_bullet_9;

  /// No description provided for @changelog_v5_0_0_bullet_10.
  ///
  /// In en, this message translates to:
  /// **'New what\'s-new dialog that keeps you posted after every update.'**
  String get changelog_v5_0_0_bullet_10;

  /// No description provided for @changelog_v5_0_0_bullet_11.
  ///
  /// In en, this message translates to:
  /// **'New Info section and an updated privacy policy, readable right in the app in every language.'**
  String get changelog_v5_0_0_bullet_11;

  /// No description provided for @changelog_v5_0_0_bullet_12.
  ///
  /// In en, this message translates to:
  /// **'More precise background removal: no more rim or halo around the shoe.'**
  String get changelog_v5_0_0_bullet_12;

  /// No description provided for @changelog_v5_0_0_bullet_13.
  ///
  /// In en, this message translates to:
  /// **'A lighter app: it takes about half the space of the previous version.'**
  String get changelog_v5_0_0_bullet_13;

  /// No description provided for @changelog_v5_0_0_bullet_14.
  ///
  /// In en, this message translates to:
  /// **'Red is now recognized correctly in statistics and shoe details (it used to show up as white).'**
  String get changelog_v5_0_0_bullet_14;

  /// No description provided for @dashboard_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dashboard_other;

  /// No description provided for @user_screen_account_settings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get user_screen_account_settings;

  /// No description provided for @user_screen_total_shoes.
  ///
  /// In en, this message translates to:
  /// **'Total Shoes'**
  String get user_screen_total_shoes;

  /// No description provided for @user_screen_member_since.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get user_screen_member_since;

  /// No description provided for @user_screen_favorite_brand.
  ///
  /// In en, this message translates to:
  /// **'Favorite Brand'**
  String get user_screen_favorite_brand;

  /// No description provided for @user_screen_most_used_category.
  ///
  /// In en, this message translates to:
  /// **'Most Used'**
  String get user_screen_most_used_category;

  /// No description provided for @user_screen_most_used_type.
  ///
  /// In en, this message translates to:
  /// **'Most Used Type'**
  String get user_screen_most_used_type;

  /// No description provided for @user_screen_most_used_color.
  ///
  /// In en, this message translates to:
  /// **'Most Used Color'**
  String get user_screen_most_used_color;

  /// No description provided for @user_screen_last_added.
  ///
  /// In en, this message translates to:
  /// **'Last Added'**
  String get user_screen_last_added;

  /// No description provided for @user_screen_favorites_count.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get user_screen_favorites_count;

  /// No description provided for @full_screen_image_share_text.
  ///
  /// In en, this message translates to:
  /// **'Check out this image!'**
  String get full_screen_image_share_text;

  /// No description provided for @extra_colors.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get extra_colors;

  /// No description provided for @select_extra_colors.
  ///
  /// In en, this message translates to:
  /// **'Select Extra Colors'**
  String get select_extra_colors;

  /// No description provided for @add_more_colors.
  ///
  /// In en, this message translates to:
  /// **'Add More Colors'**
  String get add_more_colors;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
