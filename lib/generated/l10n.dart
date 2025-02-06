// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Shox`
  String get intro_title {
    return Intl.message(
      'Shox',
      name: 'intro_title',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get onboarding_first_title {
    return Intl.message(
      'Add',
      name: 'onboarding_first_title',
      desc: '',
      args: [],
    );
  }

  /// `Add all your shoes to this digital box to always have them with you.\nEasily organize your collection and keep track of every pair you own at your fingertips.`
  String get onboarding_first_description {
    return Intl.message(
      'Add all your shoes to this digital box to always have them with you.\nEasily organize your collection and keep track of every pair you own at your fingertips.',
      name: 'onboarding_first_description',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get onboarding_second_title {
    return Intl.message(
      'Filter',
      name: 'onboarding_second_title',
      desc: '',
      args: [],
    );
  }

  /// `Quickly find your favorite shoes using advanced filters.\nSearch by brand, model, color, and more, and discover all the features of your shoes in a snap.`
  String get onboarding_second_description {
    return Intl.message(
      'Quickly find your favorite shoes using advanced filters.\nSearch by brand, model, color, and more, and discover all the features of your shoes in a snap.',
      name: 'onboarding_second_description',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get onboarding_third_title {
    return Intl.message(
      'View',
      name: 'onboarding_third_title',
      desc: '',
      args: [],
    );
  }

  /// `View detailed cards of your shoes complete with all their features.\nFrom technical specifications to photos, explore every aspect of your shoes with an intuitive interface.`
  String get onboarding_third_description {
    return Intl.message(
      'View detailed cards of your shoes complete with all their features.\nFrom technical specifications to photos, explore every aspect of your shoes with an intuitive interface.',
      name: 'onboarding_third_description',
      desc: '',
      args: [],
    );
  }

  /// `Graphs`
  String get onboarding_fourth_title {
    return Intl.message(
      'Graphs',
      name: 'onboarding_fourth_title',
      desc: '',
      args: [],
    );
  }

  /// `Explore various colorful charts that display detailed statistics about the total and the specifications of yours shoes in the database.`
  String get onboarding_fourth_description {
    return Intl.message(
      'Explore various colorful charts that display detailed statistics about the total and the specifications of yours shoes in the database.',
      name: 'onboarding_fourth_description',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get onboarding_skip {
    return Intl.message(
      'Skip',
      name: 'onboarding_skip',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get onboarding_next {
    return Intl.message(
      'Next',
      name: 'onboarding_next',
      desc: '',
      args: [],
    );
  }

  /// `Get started`
  String get onboarding_finish {
    return Intl.message(
      'Get started',
      name: 'onboarding_finish',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get welcome_text {
    return Intl.message(
      'Hello',
      name: 'welcome_text',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get welcome_login {
    return Intl.message(
      'Login',
      name: 'welcome_login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get welcome_signup {
    return Intl.message(
      'Sign Up',
      name: 'welcome_signup',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get signup_screen_title {
    return Intl.message(
      'Registration',
      name: 'signup_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup_screen_text {
    return Intl.message(
      'Sign Up',
      name: 'signup_screen_text',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get signup_screen_account {
    return Intl.message(
      'Already have an account? ',
      name: 'signup_screen_account',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get signup_screen_login {
    return Intl.message(
      'Log In',
      name: 'signup_screen_login',
      desc: '',
      args: [],
    );
  }

  /// `Successfully registered!`
  String get signup_toast_success {
    return Intl.message(
      'Successfully registered!',
      name: 'signup_toast_success',
      desc: '',
      args: [],
    );
  }

  /// `The email entered has already been registered`
  String get signup_toast_error_email_already_register {
    return Intl.message(
      'The email entered has already been registered',
      name: 'signup_toast_error_email_already_register',
      desc: '',
      args: [],
    );
  }

  /// `Error during registration:`
  String get signup_toast_error_generic {
    return Intl.message(
      'Error during registration:',
      name: 'signup_toast_error_generic',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_screen_title {
    return Intl.message(
      'Login',
      name: 'login_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get login_screen_text {
    return Intl.message(
      'Log in',
      name: 'login_screen_text',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get login_screen_remember {
    return Intl.message(
      'Remember me',
      name: 'login_screen_remember',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get login_screen_password {
    return Intl.message(
      'Forgot password?',
      name: 'login_screen_password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get login_screen_account {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'login_screen_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get login_screen_signup {
    return Intl.message(
      'Sign up',
      name: 'login_screen_signup',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get login_toast_success {
    return Intl.message(
      'Login successful!',
      name: 'login_toast_success',
      desc: '',
      args: [],
    );
  }

  /// `The email entered does not match any account`
  String get login_toast_error_email_not_found {
    return Intl.message(
      'The email entered does not match any account',
      name: 'login_toast_error_email_not_found',
      desc: '',
      args: [],
    );
  }

  /// `The password entered does not match any account`
  String get login_toast_error_invalid_password {
    return Intl.message(
      'The password entered does not match any account',
      name: 'login_toast_error_invalid_password',
      desc: '',
      args: [],
    );
  }

  /// `Error during login:`
  String get login_toast_error_generic {
    return Intl.message(
      'Error during login:',
      name: 'login_toast_error_generic',
      desc: '',
      args: [],
    );
  }

  /// `See you soon!`
  String get logout_toast_success {
    return Intl.message(
      'See you soon!',
      name: 'logout_toast_success',
      desc: '',
      args: [],
    );
  }

  /// `Error during logout`
  String get logout_toast_error_generic {
    return Intl.message(
      'Error during logout',
      name: 'logout_toast_error_generic',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password_screen_title {
    return Intl.message(
      'Reset Password',
      name: 'reset_password_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to receive the link with the procedure to reset your password`
  String get reset_password_screen_description {
    return Intl.message(
      'Enter your email to receive the link with the procedure to reset your password',
      name: 'reset_password_screen_description',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password_screen_text {
    return Intl.message(
      'Reset Password',
      name: 'reset_password_screen_text',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get reset_password_form_email {
    return Intl.message(
      'Email',
      name: 'reset_password_form_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get reset_password_form_email_field {
    return Intl.message(
      'Enter your email',
      name: 'reset_password_form_email_field',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent to: `
  String get reset_password_toast_success {
    return Intl.message(
      'Password reset email sent to: ',
      name: 'reset_password_toast_success',
      desc: '',
      args: [],
    );
  }

  /// `The email entered is not registered`
  String get reset_password_toast_error_email_not_found {
    return Intl.message(
      'The email entered is not registered',
      name: 'reset_password_toast_error_email_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Error during password reset`
  String get reset_password_toast_error_password {
    return Intl.message(
      'Error during password reset',
      name: 'reset_password_toast_error_password',
      desc: '',
      args: [],
    );
  }

  /// `Hello, `
  String get toast_signup_welcome {
    return Intl.message(
      'Hello, ',
      name: 'toast_signup_welcome',
      desc: '',
      args: [],
    );
  }

  /// `The email address is already in use by another account.`
  String get toast_signup_exist_email {
    return Intl.message(
      'The email address is already in use by another account.',
      name: 'toast_signup_exist_email',
      desc: '',
      args: [],
    );
  }

  /// `The email address is not valid.`
  String get toast_signup_invalid_email {
    return Intl.message(
      'The email address is not valid.',
      name: 'toast_signup_invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Email/password accounts are not enabled.`
  String get toast_signup_operation {
    return Intl.message(
      'Email/password accounts are not enabled.',
      name: 'toast_signup_operation',
      desc: '',
      args: [],
    );
  }

  /// `The password is too weak.`
  String get toast_signup_password {
    return Intl.message(
      'The password is too weak.',
      name: 'toast_signup_password',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get toast_signup_generic_error {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'toast_signup_generic_error',
      desc: '',
      args: [],
    );
  }

  /// `Hello, `
  String get toast_login_welcome {
    return Intl.message(
      'Hello, ',
      name: 'toast_login_welcome',
      desc: '',
      args: [],
    );
  }

  /// `No user found for that email.`
  String get toast_login_user {
    return Intl.message(
      'No user found for that email.',
      name: 'toast_login_user',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password provided.`
  String get toast_login_wrong_password {
    return Intl.message(
      'Wrong password provided.',
      name: 'toast_login_wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `The email address is badly formatted.`
  String get toast_login_invalid_email {
    return Intl.message(
      'The email address is badly formatted.',
      name: 'toast_login_invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `The supplied auth credential is incorrect, malformed or has expired.`
  String get toast_login_invalid_credential {
    return Intl.message(
      'The supplied auth credential is incorrect, malformed or has expired.',
      name: 'toast_login_invalid_credential',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get toast_login_generic_error {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'toast_login_generic_error',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully`
  String get toast_delete_success {
    return Intl.message(
      'Account deleted successfully',
      name: 'toast_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Re-authentication with Google failed.`
  String get toast_delete_google {
    return Intl.message(
      'Re-authentication with Google failed.',
      name: 'toast_delete_google',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting user data: `
  String get toast_delete_user_data {
    return Intl.message(
      'Error deleting user data: ',
      name: 'toast_delete_user_data',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting user storage: `
  String get toast_delete_user_storage {
    return Intl.message(
      'Error deleting user storage: ',
      name: 'toast_delete_user_storage',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting user history: `
  String get toast_delete_user_history {
    return Intl.message(
      'Error deleting user history: ',
      name: 'toast_delete_user_history',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please try again.`
  String get toast_delete_generic_error {
    return Intl.message(
      'An unexpected error occurred. Please try again.',
      name: 'toast_delete_generic_error',
      desc: '',
      args: [],
    );
  }

  /// `Shoes added successfully`
  String get toast_add_shoes_success {
    return Intl.message(
      'Shoes added successfully',
      name: 'toast_add_shoes_success',
      desc: '',
      args: [],
    );
  }

  /// `Error while adding the shoes: `
  String get toast_add_shoes_error {
    return Intl.message(
      'Error while adding the shoes: ',
      name: 'toast_add_shoes_error',
      desc: '',
      args: [],
    );
  }

  /// `Shoes updated successfully`
  String get toast_update_shoes_success {
    return Intl.message(
      'Shoes updated successfully',
      name: 'toast_update_shoes_success',
      desc: '',
      args: [],
    );
  }

  /// `Error while updating the shoes: `
  String get toast_update_shoes_error {
    return Intl.message(
      'Error while updating the shoes: ',
      name: 'toast_update_shoes_error',
      desc: '',
      args: [],
    );
  }

  /// `Shoes deleted successfully`
  String get toast_delete_shoes_success {
    return Intl.message(
      'Shoes deleted successfully',
      name: 'toast_delete_shoes_success',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get validator_name {
    return Intl.message(
      'Name',
      name: 'validator_name',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get validator_name_empty {
    return Intl.message(
      'Name cannot be empty',
      name: 'validator_name_empty',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get validator_name_hint {
    return Intl.message(
      'Enter your name',
      name: 'validator_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get validator_name_required {
    return Intl.message(
      'Name is required',
      name: 'validator_name_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid name: `
  String get validator_name_error {
    return Intl.message(
      'Invalid name: ',
      name: 'validator_name_error',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get validator_email {
    return Intl.message(
      'Email',
      name: 'validator_email',
      desc: '',
      args: [],
    );
  }

  /// `Missing @ symbol`
  String get validator_email_missing_special {
    return Intl.message(
      'Missing @ symbol',
      name: 'validator_email_missing_special',
      desc: '',
      args: [],
    );
  }

  /// `Missing . symbol`
  String get validator_email_missing_dot {
    return Intl.message(
      'Missing . symbol',
      name: 'validator_email_missing_dot',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get validator_email_hint {
    return Intl.message(
      'Enter your email',
      name: 'validator_email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get validator_email_required {
    return Intl.message(
      'Email is required',
      name: 'validator_email_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email: `
  String get validator_email_error {
    return Intl.message(
      'Invalid email: ',
      name: 'validator_email_error',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get validator_password {
    return Intl.message(
      'Password',
      name: 'validator_password',
      desc: '',
      args: [],
    );
  }

  /// `Missing uppercase letter`
  String get validator_password_missing_upper {
    return Intl.message(
      'Missing uppercase letter',
      name: 'validator_password_missing_upper',
      desc: '',
      args: [],
    );
  }

  /// `Missing lowercase letter`
  String get validator_password_missing_lower {
    return Intl.message(
      'Missing lowercase letter',
      name: 'validator_password_missing_lower',
      desc: '',
      args: [],
    );
  }

  /// `Missing digit`
  String get validator_password_missing_digit {
    return Intl.message(
      'Missing digit',
      name: 'validator_password_missing_digit',
      desc: '',
      args: [],
    );
  }

  /// `Missing special character`
  String get validator_password_missing_special {
    return Intl.message(
      'Missing special character',
      name: 'validator_password_missing_special',
      desc: '',
      args: [],
    );
  }

  /// `Password should be at least 8 characters long`
  String get validator_password_missing_lenght {
    return Intl.message(
      'Password should be at least 8 characters long',
      name: 'validator_password_missing_lenght',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get validator_password_hint {
    return Intl.message(
      'Enter your password',
      name: 'validator_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get validator_password_required {
    return Intl.message(
      'Password is required',
      name: 'validator_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid password: `
  String get validator_password_error {
    return Intl.message(
      'Invalid password: ',
      name: 'validator_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Crop Image`
  String get users_updater_screen_crop_image_title {
    return Intl.message(
      'Crop Image',
      name: 'users_updater_screen_crop_image_title',
      desc: '',
      args: [],
    );
  }

  /// `You did not enter the name`
  String get users_updater_screen_user_name_field_error {
    return Intl.message(
      'You did not enter the name',
      name: 'users_updater_screen_user_name_field_error',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get home_profile {
    return Intl.message(
      'Profile',
      name: 'home_profile',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get home_add {
    return Intl.message(
      'Add',
      name: 'home_add',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get home_settings {
    return Intl.message(
      'Settings',
      name: 'home_settings',
      desc: '',
      args: [],
    );
  }

  /// `Search by Brand`
  String get home_search {
    return Intl.message(
      'Search by Brand',
      name: 'home_search',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get home_filter_title {
    return Intl.message(
      'Filter',
      name: 'home_filter_title',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get home_filter_color {
    return Intl.message(
      'Color',
      name: 'home_filter_color',
      desc: '',
      args: [],
    );
  }

  /// `Season`
  String get home_filter_season {
    return Intl.message(
      'Season',
      name: 'home_filter_season',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get home_filter_category {
    return Intl.message(
      'Category',
      name: 'home_filter_category',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get home_filter_type {
    return Intl.message(
      'Type',
      name: 'home_filter_type',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get home_filter_cancel {
    return Intl.message(
      'Cancel',
      name: 'home_filter_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get home_filter_apply {
    return Intl.message(
      'Apply',
      name: 'home_filter_apply',
      desc: '',
      args: [],
    );
  }

  /// `No shoes in the box`
  String get home_empty {
    return Intl.message(
      'No shoes in the box',
      name: 'home_empty',
      desc: '',
      args: [],
    );
  }

  /// `Add Shoes`
  String get shoes_adder_screen_title {
    return Intl.message(
      'Add Shoes',
      name: 'shoes_adder_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Crop Image`
  String get shoes_adder_screen_crop_image_title {
    return Intl.message(
      'Crop Image',
      name: 'shoes_adder_screen_crop_image_title',
      desc: '',
      args: [],
    );
  }

  /// `You did not enter the brand`
  String get shoes_adder_screen_toast_error_brand {
    return Intl.message(
      'You did not enter the brand',
      name: 'shoes_adder_screen_toast_error_brand',
      desc: '',
      args: [],
    );
  }

  /// `You did not enter the size`
  String get shoes_adder_screen_toast_error_size {
    return Intl.message(
      'You did not enter the size',
      name: 'shoes_adder_screen_toast_error_size',
      desc: '',
      args: [],
    );
  }

  /// `You did not select a category`
  String get shoes_adder_screen_toast_error_category {
    return Intl.message(
      'You did not select a category',
      name: 'shoes_adder_screen_toast_error_category',
      desc: '',
      args: [],
    );
  }

  /// `You did not select a type`
  String get shoes_adder_screen_toast_error_type {
    return Intl.message(
      'You did not select a type',
      name: 'shoes_adder_screen_toast_error_type',
      desc: '',
      args: [],
    );
  }

  /// `Shoes added successfully!`
  String get shoes_adder_screen_toast_success {
    return Intl.message(
      'Shoes added successfully!',
      name: 'shoes_adder_screen_toast_success',
      desc: '',
      args: [],
    );
  }

  /// `Error during saving`
  String get shoes_adder_screen_toast_error {
    return Intl.message(
      'Error during saving',
      name: 'shoes_adder_screen_toast_error',
      desc: '',
      args: [],
    );
  }

  /// `Update Shoes`
  String get shoes_updater_screen_title {
    return Intl.message(
      'Update Shoes',
      name: 'shoes_updater_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Crop Image`
  String get shoes_updater_screen_crop_image_title {
    return Intl.message(
      'Crop Image',
      name: 'shoes_updater_screen_crop_image_title',
      desc: '',
      args: [],
    );
  }

  /// `You did not enter the brand`
  String get shoes_updater_screen_toast_error_brand {
    return Intl.message(
      'You did not enter the brand',
      name: 'shoes_updater_screen_toast_error_brand',
      desc: '',
      args: [],
    );
  }

  /// `You did not enter the size`
  String get shoes_updater_screen_toast_error_size {
    return Intl.message(
      'You did not enter the size',
      name: 'shoes_updater_screen_toast_error_size',
      desc: '',
      args: [],
    );
  }

  /// `Shoes updated successfully!`
  String get shoes_updater_screen_toast_success {
    return Intl.message(
      'Shoes updated successfully!',
      name: 'shoes_updater_screen_toast_success',
      desc: '',
      args: [],
    );
  }

  /// `Shoes Details`
  String get shoes_details_screen_title {
    return Intl.message(
      'Shoes Details',
      name: 'shoes_details_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Error:`
  String get shoes_details_screen_error_state {
    return Intl.message(
      'Error:',
      name: 'shoes_details_screen_error_state',
      desc: '',
      args: [],
    );
  }

  /// `Shoes not found.`
  String get shoes_details_screen_empty_state {
    return Intl.message(
      'Shoes not found.',
      name: 'shoes_details_screen_empty_state',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get shoes_details_screen_menu_edit {
    return Intl.message(
      'Edit',
      name: 'shoes_details_screen_menu_edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get shoes_details_screen_menu_delete {
    return Intl.message(
      'Delete',
      name: 'shoes_details_screen_menu_delete',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get field_date {
    return Intl.message(
      'Date',
      name: 'field_date',
      desc: '',
      args: [],
    );
  }

  /// `Meaning icons`
  String get field_season_title {
    return Intl.message(
      'Meaning icons',
      name: 'field_season_title',
      desc: '',
      args: [],
    );
  }

  /// `Summer`
  String get field_season_summer {
    return Intl.message(
      'Summer',
      name: 'field_season_summer',
      desc: '',
      args: [],
    );
  }

  /// `Winter`
  String get field_season_winter {
    return Intl.message(
      'Winter',
      name: 'field_season_winter',
      desc: '',
      args: [],
    );
  }

  /// `All seasons`
  String get field_season_all {
    return Intl.message(
      'All seasons',
      name: 'field_season_all',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get field_season_close {
    return Intl.message(
      'Close',
      name: 'field_season_close',
      desc: '',
      args: [],
    );
  }

  /// `Select the image`
  String get field_insert_image {
    return Intl.message(
      'Select the image',
      name: 'field_insert_image',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get field_color {
    return Intl.message(
      'Color',
      name: 'field_color',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get field_details_color {
    return Intl.message(
      'Details',
      name: 'field_details_color',
      desc: '',
      args: [],
    );
  }

  /// `Select the color`
  String get field_insert_color {
    return Intl.message(
      'Select the color',
      name: 'field_insert_color',
      desc: '',
      args: [],
    );
  }

  /// `Season`
  String get field_season {
    return Intl.message(
      'Season',
      name: 'field_season',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get field_brand {
    return Intl.message(
      'Brand',
      name: 'field_brand',
      desc: '',
      args: [],
    );
  }

  /// `Insert the brand`
  String get field_insert_brand {
    return Intl.message(
      'Insert the brand',
      name: 'field_insert_brand',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get field_size {
    return Intl.message(
      'Size',
      name: 'field_size',
      desc: '',
      args: [],
    );
  }

  /// `Insert the size`
  String get field_insert_size {
    return Intl.message(
      'Insert the size',
      name: 'field_insert_size',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get field_category {
    return Intl.message(
      'Category',
      name: 'field_category',
      desc: '',
      args: [],
    );
  }

  /// `Insert the category`
  String get field_insert_category {
    return Intl.message(
      'Insert the category',
      name: 'field_insert_category',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get field_type {
    return Intl.message(
      'Type',
      name: 'field_type',
      desc: '',
      args: [],
    );
  }

  /// `Insert the type`
  String get field_insert_type {
    return Intl.message(
      'Insert the type',
      name: 'field_insert_type',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get field_notes {
    return Intl.message(
      'Notes',
      name: 'field_notes',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_shoes_title {
    return Intl.message(
      'Delete',
      name: 'delete_shoes_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this shoes?`
  String get delete_shoes_description {
    return Intl.message(
      'Are you sure you want to delete this shoes?',
      name: 'delete_shoes_description',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get delete_shoes_cancel {
    return Intl.message(
      'Cancel',
      name: 'delete_shoes_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get delete_shoes_confirm {
    return Intl.message(
      'Confirm',
      name: 'delete_shoes_confirm',
      desc: '',
      args: [],
    );
  }

  /// `COLOR`
  String get text_color {
    return Intl.message(
      'COLOR',
      name: 'text_color',
      desc: '',
      args: [],
    );
  }

  /// `DETAILS`
  String get text_details_color {
    return Intl.message(
      'DETAILS',
      name: 'text_details_color',
      desc: '',
      args: [],
    );
  }

  /// `SEASON`
  String get text_season {
    return Intl.message(
      'SEASON',
      name: 'text_season',
      desc: '',
      args: [],
    );
  }

  /// `BRAND`
  String get text_brand {
    return Intl.message(
      'BRAND',
      name: 'text_brand',
      desc: '',
      args: [],
    );
  }

  /// `SIZE`
  String get text_size {
    return Intl.message(
      'SIZE',
      name: 'text_size',
      desc: '',
      args: [],
    );
  }

  /// `CATEGORY`
  String get text_category {
    return Intl.message(
      'CATEGORY',
      name: 'text_category',
      desc: '',
      args: [],
    );
  }

  /// `TYPE`
  String get text_type {
    return Intl.message(
      'TYPE',
      name: 'text_type',
      desc: '',
      args: [],
    );
  }

  /// `NOTES`
  String get text_notes {
    return Intl.message(
      'NOTES',
      name: 'text_notes',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile_title {
    return Intl.message(
      'Profile',
      name: 'profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Database`
  String get profile_database {
    return Intl.message(
      'Database',
      name: 'profile_database',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get profile_history {
    return Intl.message(
      'History',
      name: 'profile_history',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get profile_logout {
    return Intl.message(
      'Log Out',
      name: 'profile_logout',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get profile_delete {
    return Intl.message(
      'Delete Account',
      name: 'profile_delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit Account`
  String get profile_edit_title {
    return Intl.message(
      'Edit Account',
      name: 'profile_edit_title',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get profile_edit_save {
    return Intl.message(
      'Save',
      name: 'profile_edit_save',
      desc: '',
      args: [],
    );
  }

  /// `White`
  String get color_white {
    return Intl.message(
      'White',
      name: 'color_white',
      desc: '',
      args: [],
    );
  }

  /// `Black`
  String get color_black {
    return Intl.message(
      'Black',
      name: 'color_black',
      desc: '',
      args: [],
    );
  }

  /// `Light Grey`
  String get color_light_grey {
    return Intl.message(
      'Light Grey',
      name: 'color_light_grey',
      desc: '',
      args: [],
    );
  }

  /// `Dark Grey`
  String get color_dark_grey {
    return Intl.message(
      'Dark Grey',
      name: 'color_dark_grey',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get color_orange {
    return Intl.message(
      'Orange',
      name: 'color_orange',
      desc: '',
      args: [],
    );
  }

  /// `Pink`
  String get color_pink {
    return Intl.message(
      'Pink',
      name: 'color_pink',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get color_red {
    return Intl.message(
      'Red',
      name: 'color_red',
      desc: '',
      args: [],
    );
  }

  /// `Bordeaux`
  String get color_bordeaux {
    return Intl.message(
      'Bordeaux',
      name: 'color_bordeaux',
      desc: '',
      args: [],
    );
  }

  /// `Camel`
  String get color_camel {
    return Intl.message(
      'Camel',
      name: 'color_camel',
      desc: '',
      args: [],
    );
  }

  /// `Beige`
  String get color_beige {
    return Intl.message(
      'Beige',
      name: 'color_beige',
      desc: '',
      args: [],
    );
  }

  /// `Light Brown`
  String get color_light_brown {
    return Intl.message(
      'Light Brown',
      name: 'color_light_brown',
      desc: '',
      args: [],
    );
  }

  /// `Dark Brown`
  String get color_dark_brown {
    return Intl.message(
      'Dark Brown',
      name: 'color_dark_brown',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get color_yellow {
    return Intl.message(
      'Yellow',
      name: 'color_yellow',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get color_green {
    return Intl.message(
      'Green',
      name: 'color_green',
      desc: '',
      args: [],
    );
  }

  /// `Light Blue`
  String get color_light_blue {
    return Intl.message(
      'Light Blue',
      name: 'color_light_blue',
      desc: '',
      args: [],
    );
  }

  /// `Dark Blue`
  String get color_dark_blue {
    return Intl.message(
      'Dark Blue',
      name: 'color_dark_blue',
      desc: '',
      args: [],
    );
  }

  /// `Sneakers`
  String get category_sneakers {
    return Intl.message(
      'Sneakers',
      name: 'category_sneakers',
      desc: '',
      args: [],
    );
  }

  /// `Sandals`
  String get category_sandals {
    return Intl.message(
      'Sandals',
      name: 'category_sandals',
      desc: '',
      args: [],
    );
  }

  /// `Boots`
  String get category_boots {
    return Intl.message(
      'Boots',
      name: 'category_boots',
      desc: '',
      args: [],
    );
  }

  /// `Loafers`
  String get category_loafers {
    return Intl.message(
      'Loafers',
      name: 'category_loafers',
      desc: '',
      args: [],
    );
  }

  /// `Ballets`
  String get category_ballets {
    return Intl.message(
      'Ballets',
      name: 'category_ballets',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get category_other {
    return Intl.message(
      'Other',
      name: 'category_other',
      desc: '',
      args: [],
    );
  }

  /// `Sport`
  String get type_sport {
    return Intl.message(
      'Sport',
      name: 'type_sport',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get type_casual {
    return Intl.message(
      'Casual',
      name: 'type_casual',
      desc: '',
      args: [],
    );
  }

  /// `Lifestyle`
  String get type_lifestyle {
    return Intl.message(
      'Lifestyle',
      name: 'type_lifestyle',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get type_running {
    return Intl.message(
      'Running',
      name: 'type_running',
      desc: '',
      args: [],
    );
  }

  /// `Flat`
  String get type_flat {
    return Intl.message(
      'Flat',
      name: 'type_flat',
      desc: '',
      args: [],
    );
  }

  /// `Heeled`
  String get type_heeled {
    return Intl.message(
      'Heeled',
      name: 'type_heeled',
      desc: '',
      args: [],
    );
  }

  /// `Flip-flops`
  String get type_flip_flops {
    return Intl.message(
      'Flip-flops',
      name: 'type_flip_flops',
      desc: '',
      args: [],
    );
  }

  /// `Dressy`
  String get type_dressy {
    return Intl.message(
      'Dressy',
      name: 'type_dressy',
      desc: '',
      args: [],
    );
  }

  /// `Ankle boots`
  String get type_ankle_boots {
    return Intl.message(
      'Ankle boots',
      name: 'type_ankle_boots',
      desc: '',
      args: [],
    );
  }

  /// `High boots`
  String get type_high_boots {
    return Intl.message(
      'High boots',
      name: 'type_high_boots',
      desc: '',
      args: [],
    );
  }

  /// `Work boots`
  String get type_work_boots {
    return Intl.message(
      'Work boots',
      name: 'type_work_boots',
      desc: '',
      args: [],
    );
  }

  /// `Knee-high`
  String get type_knee_high {
    return Intl.message(
      'Knee-high',
      name: 'type_knee_high',
      desc: '',
      args: [],
    );
  }

  /// `Classic`
  String get type_classic {
    return Intl.message(
      'Classic',
      name: 'type_classic',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get type_other {
    return Intl.message(
      'Other',
      name: 'type_other',
      desc: '',
      args: [],
    );
  }

  /// `Database`
  String get database_title {
    return Intl.message(
      'Database',
      name: 'database_title',
      desc: '',
      args: [],
    );
  }

  /// `No shoes in the box`
  String get database_empty {
    return Intl.message(
      'No shoes in the box',
      name: 'database_empty',
      desc: '',
      args: [],
    );
  }

  /// `Shoes in DB`
  String get database_shoes {
    return Intl.message(
      'Shoes in DB',
      name: 'database_shoes',
      desc: '',
      args: [],
    );
  }

  /// `Colors`
  String get database_colors {
    return Intl.message(
      'Colors',
      name: 'database_colors',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get database_brands {
    return Intl.message(
      'Brands',
      name: 'database_brands',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get database_categories {
    return Intl.message(
      'Categories',
      name: 'database_categories',
      desc: '',
      args: [],
    );
  }

  /// `Types`
  String get database_types {
    return Intl.message(
      'Types',
      name: 'database_types',
      desc: '',
      args: [],
    );
  }

  /// `Account Info`
  String get database_pdf_user {
    return Intl.message(
      'Account Info',
      name: 'database_pdf_user',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get database_pdf_name {
    return Intl.message(
      'Name',
      name: 'database_pdf_name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get database_pdf_email {
    return Intl.message(
      'Email',
      name: 'database_pdf_email',
      desc: '',
      args: [],
    );
  }

  /// `Registration Date`
  String get database_pdf_date {
    return Intl.message(
      'Registration Date',
      name: 'database_pdf_date',
      desc: '',
      args: [],
    );
  }

  /// `Page`
  String get database_pdf_page {
    return Intl.message(
      'Page',
      name: 'database_pdf_page',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get database_pdf_shoes {
    return Intl.message(
      'Shoes',
      name: 'database_pdf_shoes',
      desc: '',
      args: [],
    );
  }

  /// `Download DB`
  String get database_pdf_download {
    return Intl.message(
      'Download DB',
      name: 'database_pdf_download',
      desc: '',
      args: [],
    );
  }

  /// `PDF saved to Download folder`
  String get database_pdf_confirm {
    return Intl.message(
      'PDF saved to Download folder',
      name: 'database_pdf_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Failed to generate PDF`
  String get database_pdf_error {
    return Intl.message(
      'Failed to generate PDF',
      name: 'database_pdf_error',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history_title {
    return Intl.message(
      'History',
      name: 'history_title',
      desc: '',
      args: [],
    );
  }

  /// `Empty history`
  String get history_empty {
    return Intl.message(
      'Empty history',
      name: 'history_empty',
      desc: '',
      args: [],
    );
  }

  /// `Added`
  String get history_added {
    return Intl.message(
      'Added',
      name: 'history_added',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get history_updated {
    return Intl.message(
      'Updated',
      name: 'history_updated',
      desc: '',
      args: [],
    );
  }

  /// `Deleted`
  String get history_deleted {
    return Intl.message(
      'Deleted',
      name: 'history_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_title {
    return Intl.message(
      'Delete Account',
      name: 'delete_title',
      desc: '',
      args: [],
    );
  }

  /// `On this page you can permanently delete your Account.\n\nConfirming the cancellation will also delete all the Database linked to the Account.\n\nRemember that the process is irreversible.\n\nIf you want to proceed click on the Button below:`
  String get delete_description {
    return Intl.message(
      'On this page you can permanently delete your Account.\n\nConfirming the cancellation will also delete all the Database linked to the Account.\n\nRemember that the process is irreversible.\n\nIf you want to proceed click on the Button below:',
      name: 'delete_description',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_d_title {
    return Intl.message(
      'Delete',
      name: 'delete_d_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get delete_d_description {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'delete_d_description',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get delete_d_cancel {
    return Intl.message(
      'Cancel',
      name: 'delete_d_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get delete_d_confirm {
    return Intl.message(
      'Confirm',
      name: 'delete_d_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settings_theme {
    return Intl.message(
      'Theme',
      name: 'settings_theme',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get settings_languages {
    return Intl.message(
      'Languages',
      name: 'settings_languages',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get settings_info {
    return Intl.message(
      'Info',
      name: 'settings_info',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get settings_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'settings_policy',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get settings_support {
    return Intl.message(
      'Support',
      name: 'settings_support',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme_title {
    return Intl.message(
      'Theme',
      name: 'theme_title',
      desc: '',
      args: [],
    );
  }

  /// `Select the theme of the app by choosing from the options below`
  String get theme_description {
    return Intl.message(
      'Select the theme of the app by choosing from the options below',
      name: 'theme_description',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get theme_light {
    return Intl.message(
      'Light',
      name: 'theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get theme_dark {
    return Intl.message(
      'Dark',
      name: 'theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages_title {
    return Intl.message(
      'Languages',
      name: 'languages_title',
      desc: '',
      args: [],
    );
  }

  /// `Select the language of the app by choosing from the options below`
  String get languages_description {
    return Intl.message(
      'Select the language of the app by choosing from the options below',
      name: 'languages_description',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info_screen_title {
    return Intl.message(
      'Info',
      name: 'info_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `ORIGIN`
  String get info_screen_origin_text {
    return Intl.message(
      'ORIGIN',
      name: 'info_screen_origin_text',
      desc: '',
      args: [],
    );
  }

  /// `The name of the app is a fusion between 'Shoes' and 'Box', to simulate the creation of a large box to store shoes.`
  String get info_screen_origin_description {
    return Intl.message(
      'The name of the app is a fusion between \'Shoes\' and \'Box\', to simulate the creation of a large box to store shoes.',
      name: 'info_screen_origin_description',
      desc: '',
      args: [],
    );
  }

  /// `DESCRIPTION`
  String get info_screen_description_text {
    return Intl.message(
      'DESCRIPTION',
      name: 'info_screen_description_text',
      desc: '',
      args: [],
    );
  }

  /// `This application allows you to create a digital wardrobe where you can save and view all your shoes. In this way, all your shoes will be catalogued and always at hand.`
  String get info_screen_description_description {
    return Intl.message(
      'This application allows you to create a digital wardrobe where you can save and view all your shoes. In this way, all your shoes will be catalogued and always at hand.',
      name: 'info_screen_description_description',
      desc: '',
      args: [],
    );
  }

  /// `CREDITS`
  String get info_screen_credits_text {
    return Intl.message(
      'CREDITS',
      name: 'info_screen_credits_text',
      desc: '',
      args: [],
    );
  }

  /// `Idea`
  String get info_screen_credits_a_text {
    return Intl.message(
      'Idea',
      name: 'info_screen_credits_a_text',
      desc: '',
      args: [],
    );
  }

  /// `Nicola De Nicolais`
  String get info_screen_credits_a_value {
    return Intl.message(
      'Nicola De Nicolais',
      name: 'info_screen_credits_a_value',
      desc: '',
      args: [],
    );
  }

  /// `Development`
  String get info_screen_credits_b_text {
    return Intl.message(
      'Development',
      name: 'info_screen_credits_b_text',
      desc: '',
      args: [],
    );
  }

  /// `Nicola De Nicolais`
  String get info_screen_credits_b_value {
    return Intl.message(
      'Nicola De Nicolais',
      name: 'info_screen_credits_b_value',
      desc: '',
      args: [],
    );
  }

  /// `Design`
  String get info_screen_credits_c_text {
    return Intl.message(
      'Design',
      name: 'info_screen_credits_c_text',
      desc: '',
      args: [],
    );
  }

  /// `Nicola De Nicolais`
  String get info_screen_credits_c_value {
    return Intl.message(
      'Nicola De Nicolais',
      name: 'info_screen_credits_c_value',
      desc: '',
      args: [],
    );
  }

  /// `VERSION`
  String get info_screen_version_text {
    return Intl.message(
      'VERSION',
      name: 'info_screen_version_text',
      desc: '',
      args: [],
    );
  }

  /// `3.0.0`
  String get info_screen_version_value {
    return Intl.message(
      '3.0.0',
      name: 'info_screen_version_value',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support_screen_title {
    return Intl.message(
      'Support',
      name: 'support_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get support_screen_contacts_text {
    return Intl.message(
      'Contact Us',
      name: 'support_screen_contacts_text',
      desc: '',
      args: [],
    );
  }

  /// `For any problems or questions, write to:`
  String get support_screen_contacts_decription {
    return Intl.message(
      'For any problems or questions, write to:',
      name: 'support_screen_contacts_decription',
      desc: '',
      args: [],
    );
  }

  /// `ndn21dev@gmail.com`
  String get support_screen_contacts_info {
    return Intl.message(
      'ndn21dev@gmail.com',
      name: 'support_screen_contacts_info',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get support_screen_faq_text {
    return Intl.message(
      'FAQ',
      name: 'support_screen_faq_text',
      desc: '',
      args: [],
    );
  }

  /// `Find answers to the most frequently asked questions.`
  String get support_screen_faq_decription {
    return Intl.message(
      'Find answers to the most frequently asked questions.',
      name: 'support_screen_faq_decription',
      desc: '',
      args: [],
    );
  }

  /// `How to add a pair of shoes?`
  String get support_screen_faq_q1 {
    return Intl.message(
      'How to add a pair of shoes?',
      name: 'support_screen_faq_q1',
      desc: '',
      args: [],
    );
  }

  /// `To add a pair of shoes, go to the Home and click on the '+' button. Fill in all the necessary details and save.`
  String get support_screen_faq_a1 {
    return Intl.message(
      'To add a pair of shoes, go to the Home and click on the \'+\' button. Fill in all the necessary details and save.',
      name: 'support_screen_faq_a1',
      desc: '',
      args: [],
    );
  }

  /// `How to edit a pair of shoes?`
  String get support_screen_faq_q2 {
    return Intl.message(
      'How to edit a pair of shoes?',
      name: 'support_screen_faq_q2',
      desc: '',
      args: [],
    );
  }

  /// `To edit a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the 'Edit' option. Make the changes and save.`
  String get support_screen_faq_a2 {
    return Intl.message(
      'To edit a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the \'Edit\' option. Make the changes and save.',
      name: 'support_screen_faq_a2',
      desc: '',
      args: [],
    );
  }

  /// `How to delete a pair of shoes?`
  String get support_screen_faq_q3 {
    return Intl.message(
      'How to delete a pair of shoes?',
      name: 'support_screen_faq_q3',
      desc: '',
      args: [],
    );
  }

  /// `To delete a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the 'Delete' option.`
  String get support_screen_faq_a3 {
    return Intl.message(
      'To delete a pair of shoes, select the shoe box you want to edit and click on it. Once open, click on the icon in the top right corner and select the \'Delete\' option.',
      name: 'support_screen_faq_a3',
      desc: '',
      args: [],
    );
  }

  /// `What happens if I delete a pair of shoes?`
  String get support_screen_faq_q4 {
    return Intl.message(
      'What happens if I delete a pair of shoes?',
      name: 'support_screen_faq_q4',
      desc: '',
      args: [],
    );
  }

  /// `If you delete a pair of shoes, it will be permanently removed. You will be asked to confirm before proceeding with the operation.`
  String get support_screen_faq_a4 {
    return Intl.message(
      'If you delete a pair of shoes, it will be permanently removed. You will be asked to confirm before proceeding with the operation.',
      name: 'support_screen_faq_a4',
      desc: '',
      args: [],
    );
  }

  /// `Can I see the history of added or deleted pairs of shoes?`
  String get support_screen_faq_q5 {
    return Intl.message(
      'Can I see the history of added or deleted pairs of shoes?',
      name: 'support_screen_faq_q5',
      desc: '',
      args: [],
    );
  }

  /// `Yes, you can see the entire history of actions performed in the 'History' section.`
  String get support_screen_faq_a5 {
    return Intl.message(
      'Yes, you can see the entire history of actions performed in the \'History\' section.',
      name: 'support_screen_faq_a5',
      desc: '',
      args: [],
    );
  }

  /// `Are there notifications within the application?`
  String get support_screen_faq_q6 {
    return Intl.message(
      'Are there notifications within the application?',
      name: 'support_screen_faq_q6',
      desc: '',
      args: [],
    );
  }

  /// `Not at the moment, but in the future it will be possible to activate notifications for Anniversary or Day Anniversary.`
  String get support_screen_faq_a6 {
    return Intl.message(
      'Not at the moment, but in the future it will be possible to activate notifications for Anniversary or Day Anniversary.',
      name: 'support_screen_faq_a6',
      desc: '',
      args: [],
    );
  }

  /// `What can I do if the app doesn't work properly?`
  String get support_screen_faq_q7 {
    return Intl.message(
      'What can I do if the app doesn\'t work properly?',
      name: 'support_screen_faq_q7',
      desc: '',
      args: [],
    );
  }

  /// `If you encounter problems, try restarting the app. If the problem persists, contact technical support through the 'Contact Us' section.`
  String get support_screen_faq_a7 {
    return Intl.message(
      'If you encounter problems, try restarting the app. If the problem persists, contact technical support through the \'Contact Us\' section.',
      name: 'support_screen_faq_a7',
      desc: '',
      args: [],
    );
  }

  /// `Documentation`
  String get support_screen_documentation_text {
    return Intl.message(
      'Documentation',
      name: 'support_screen_documentation_text',
      desc: '',
      args: [],
    );
  }

  /// `See the full documentation for more details.`
  String get support_screen_documentation_decription {
    return Intl.message(
      'See the full documentation for more details.',
      name: 'support_screen_documentation_decription',
      desc: '',
      args: [],
    );
  }

  /// `Go to the documentation on GitHub`
  String get support_screen_documentation_info {
    return Intl.message(
      'Go to the documentation on GitHub',
      name: 'support_screen_documentation_info',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get policy_title {
    return Intl.message(
      'Privacy Policy',
      name: 'policy_title',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support_title {
    return Intl.message(
      'Support',
      name: 'support_title',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get support_developer {
    return Intl.message(
      'Developer',
      name: 'support_developer',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get support_contacts {
    return Intl.message(
      'Contacts',
      name: 'support_contacts',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get custom_delete_dialog_confirm {
    return Intl.message(
      'Delete',
      name: 'custom_delete_dialog_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get custom_delete_dialog_cancel {
    return Intl.message(
      'Cancel',
      name: 'custom_delete_dialog_cancel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
