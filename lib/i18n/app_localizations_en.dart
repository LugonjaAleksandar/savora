// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Savora';

  @override
  String get nav_discover => 'Discover';

  @override
  String get nav_favorites => 'Saved';

  @override
  String get nav_settings => 'Settings';

  @override
  String get greeting_morning => 'Good morning';

  @override
  String get greeting_afternoon => 'Good afternoon';

  @override
  String get greeting_evening => 'Good evening';

  @override
  String get meals_header_title_prefix => 'What are we';

  @override
  String get meals_header_title_highlight => 'cooking';

  @override
  String get meals_header_title_suffix => ' today?';

  @override
  String get meals_surprise_me => 'Surprise me';

  @override
  String get meals_search_hint => 'Search 300+ recipes…';

  @override
  String meals_section_category(String category) {
    return '$category recipes';
  }

  @override
  String meals_section_search(String query) {
    return 'Results for “$query”';
  }

  @override
  String meals_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count recipes', one: '1 recipe', zero: 'No recipes');
    return '$_temp0';
  }

  @override
  String get meals_empty_title => 'Nothing on the menu';

  @override
  String get meals_empty_subtitle => 'Try a different search or pick another category.';

  @override
  String get detail_ingredients => 'Ingredients';

  @override
  String detail_ingredients_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count ingredients', one: '1 ingredient');
    return '$_temp0';
  }

  @override
  String get detail_instructions => 'Instructions';

  @override
  String detail_step(int number) {
    return 'Step $number';
  }

  @override
  String get detail_watch_video => 'Watch on YouTube';

  @override
  String get detail_source => 'Original recipe';

  @override
  String get review_section_title => 'Your review';

  @override
  String get review_cta_title => 'Cooked this one?';

  @override
  String get review_cta_subtitle => 'Rate it and leave a note for future you.';

  @override
  String get review_cta_button => 'Rate recipe';

  @override
  String get review_sheet_title => 'How was it?';

  @override
  String get review_comment_hint => 'What would you change next time?';

  @override
  String get review_save => 'Save review';

  @override
  String get review_edit => 'Edit';

  @override
  String get review_delete => 'Delete';

  @override
  String get review_saved => 'Review saved';

  @override
  String get review_deleted => 'Review removed';

  @override
  String get review_rating_label_1 => 'Not for me';

  @override
  String get review_rating_label_2 => 'It was okay';

  @override
  String get review_rating_label_3 => 'Pretty good';

  @override
  String get review_rating_label_4 => 'Really tasty';

  @override
  String get review_rating_label_5 => 'Absolutely loved it';

  @override
  String review_updated_at(String date) {
    return 'Updated $date';
  }

  @override
  String get favorites_title => 'Saved recipes';

  @override
  String favorites_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes in your cookbook',
      one: '1 recipe in your cookbook',
      zero: 'Your cookbook is waiting',
    );
    return '$_temp0';
  }

  @override
  String get favorites_empty_title => 'No saved recipes yet';

  @override
  String get favorites_empty_subtitle => 'Tap the heart on any recipe to keep it here — it works offline too.';

  @override
  String get favorites_removed => 'Removed from saved';

  @override
  String get favorites_undo => 'Undo';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_language_system => 'System';

  @override
  String get settings_theme => 'Appearance';

  @override
  String get settings_theme_system => 'System';

  @override
  String get settings_theme_light => 'Light';

  @override
  String get settings_theme_dark => 'Dark';

  @override
  String get settings_about => 'About';

  @override
  String get settings_about_body =>
      'Recipe data is provided by TheMealDB public API. Reviews and saved recipes are stored only on this device.';

  @override
  String get error_network => 'You appear to be offline. Check your connection and try again.';

  @override
  String get error_server => 'The kitchen is busy right now. Please try again in a moment.';

  @override
  String get error_not_found => 'We couldn\'t find that recipe.';

  @override
  String get error_unknown => 'Something went wrong. Please try again.';

  @override
  String get action_retry => 'Try again';
}
