import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i18n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('sr')];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Savora'**
  String get app_name;

  /// No description provided for @nav_discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get nav_discover;

  /// No description provided for @nav_favorites.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get nav_favorites;

  /// No description provided for @nav_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get nav_settings;

  /// No description provided for @greeting_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greeting_morning;

  /// No description provided for @greeting_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greeting_afternoon;

  /// No description provided for @greeting_evening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greeting_evening;

  /// No description provided for @meals_header_title_prefix.
  ///
  /// In en, this message translates to:
  /// **'What are we'**
  String get meals_header_title_prefix;

  /// No description provided for @meals_header_title_highlight.
  ///
  /// In en, this message translates to:
  /// **'cooking'**
  String get meals_header_title_highlight;

  /// No description provided for @meals_header_title_suffix.
  ///
  /// In en, this message translates to:
  /// **' today?'**
  String get meals_header_title_suffix;

  /// No description provided for @meals_surprise_me.
  ///
  /// In en, this message translates to:
  /// **'Surprise me'**
  String get meals_surprise_me;

  /// No description provided for @meals_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search 300+ recipes…'**
  String get meals_search_hint;

  /// No description provided for @meals_section_category.
  ///
  /// In en, this message translates to:
  /// **'{category} recipes'**
  String meals_section_category(String category);

  /// No description provided for @meals_section_search.
  ///
  /// In en, this message translates to:
  /// **'Results for “{query}”'**
  String meals_section_search(String query);

  /// No description provided for @meals_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No recipes} =1{1 recipe} other{{count} recipes}}'**
  String meals_count(int count);

  /// No description provided for @meals_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Nothing on the menu'**
  String get meals_empty_title;

  /// No description provided for @meals_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or pick another category.'**
  String get meals_empty_subtitle;

  /// No description provided for @detail_ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get detail_ingredients;

  /// No description provided for @detail_ingredients_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ingredient} other{{count} ingredients}}'**
  String detail_ingredients_count(int count);

  /// No description provided for @detail_instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get detail_instructions;

  /// No description provided for @detail_step.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String detail_step(int number);

  /// No description provided for @detail_watch_video.
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get detail_watch_video;

  /// No description provided for @detail_source.
  ///
  /// In en, this message translates to:
  /// **'Original recipe'**
  String get detail_source;

  /// No description provided for @review_section_title.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get review_section_title;

  /// No description provided for @review_cta_title.
  ///
  /// In en, this message translates to:
  /// **'Cooked this one?'**
  String get review_cta_title;

  /// No description provided for @review_cta_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Rate it and leave a note for future you.'**
  String get review_cta_subtitle;

  /// No description provided for @review_cta_button.
  ///
  /// In en, this message translates to:
  /// **'Rate recipe'**
  String get review_cta_button;

  /// No description provided for @review_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'How was it?'**
  String get review_sheet_title;

  /// No description provided for @review_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'What would you change next time?'**
  String get review_comment_hint;

  /// No description provided for @review_save.
  ///
  /// In en, this message translates to:
  /// **'Save review'**
  String get review_save;

  /// No description provided for @review_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get review_edit;

  /// No description provided for @review_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get review_delete;

  /// No description provided for @review_saved.
  ///
  /// In en, this message translates to:
  /// **'Review saved'**
  String get review_saved;

  /// No description provided for @review_deleted.
  ///
  /// In en, this message translates to:
  /// **'Review removed'**
  String get review_deleted;

  /// No description provided for @review_rating_label_1.
  ///
  /// In en, this message translates to:
  /// **'Not for me'**
  String get review_rating_label_1;

  /// No description provided for @review_rating_label_2.
  ///
  /// In en, this message translates to:
  /// **'It was okay'**
  String get review_rating_label_2;

  /// No description provided for @review_rating_label_3.
  ///
  /// In en, this message translates to:
  /// **'Pretty good'**
  String get review_rating_label_3;

  /// No description provided for @review_rating_label_4.
  ///
  /// In en, this message translates to:
  /// **'Really tasty'**
  String get review_rating_label_4;

  /// No description provided for @review_rating_label_5.
  ///
  /// In en, this message translates to:
  /// **'Absolutely loved it'**
  String get review_rating_label_5;

  /// No description provided for @review_updated_at.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String review_updated_at(String date);

  /// No description provided for @favorites_title.
  ///
  /// In en, this message translates to:
  /// **'Saved recipes'**
  String get favorites_title;

  /// No description provided for @favorites_subtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Your cookbook is waiting} =1{1 recipe in your cookbook} other{{count} recipes in your cookbook}}'**
  String favorites_subtitle(int count);

  /// No description provided for @favorites_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No saved recipes yet'**
  String get favorites_empty_title;

  /// No description provided for @favorites_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any recipe to keep it here — it works offline too.'**
  String get favorites_empty_subtitle;

  /// No description provided for @favorites_removed.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved'**
  String get favorites_removed;

  /// No description provided for @favorites_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get favorites_undo;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_language_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_language_system;

  /// No description provided for @settings_theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_theme;

  /// No description provided for @settings_theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_theme_system;

  /// No description provided for @settings_theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// No description provided for @settings_theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// No description provided for @settings_about_body.
  ///
  /// In en, this message translates to:
  /// **'Recipe data is provided by TheMealDB public API. Reviews and saved recipes are stored only on this device.'**
  String get settings_about_body;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Check your connection and try again.'**
  String get error_network;

  /// No description provided for @error_server.
  ///
  /// In en, this message translates to:
  /// **'The kitchen is busy right now. Please try again in a moment.'**
  String get error_server;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that recipe.'**
  String get error_not_found;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_unknown;

  /// No description provided for @action_retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get action_retry;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
