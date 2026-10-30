// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get app_name => 'Savora';

  @override
  String get nav_discover => 'Istraži';

  @override
  String get nav_favorites => 'Sačuvano';

  @override
  String get nav_settings => 'Podešavanja';

  @override
  String get greeting_morning => 'Dobro jutro';

  @override
  String get greeting_afternoon => 'Dobar dan';

  @override
  String get greeting_evening => 'Dobro veče';

  @override
  String get meals_header_title_prefix => 'Šta danas';

  @override
  String get meals_header_title_highlight => 'kuvamo';

  @override
  String get meals_header_title_suffix => '?';

  @override
  String get meals_surprise_me => 'Iznenadi me';

  @override
  String get meals_search_hint => 'Pretraži 300+ recepata…';

  @override
  String meals_section_category(String category) {
    return '$category recepti';
  }

  @override
  String meals_section_search(String query) {
    return 'Rezultati za „$query”';
  }

  @override
  String meals_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepata',
      few: '$count recepta',
      one: '$count recept',
      zero: 'Nema recepata',
    );
    return '$_temp0';
  }

  @override
  String get meals_empty_title => 'Meni je prazan';

  @override
  String get meals_empty_subtitle => 'Probaj drugačiju pretragu ili izaberi drugu kategoriju.';

  @override
  String get detail_ingredients => 'Sastojci';

  @override
  String detail_ingredients_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sastojaka',
      few: '$count sastojka',
      one: '$count sastojak',
    );
    return '$_temp0';
  }

  @override
  String get detail_instructions => 'Priprema';

  @override
  String detail_step(int number) {
    return 'Korak $number';
  }

  @override
  String get detail_watch_video => 'Pogledaj na YouTube-u';

  @override
  String get detail_source => 'Originalni recept';

  @override
  String get review_section_title => 'Tvoja ocena';

  @override
  String get review_cta_title => 'Spremio si ovo?';

  @override
  String get review_cta_subtitle => 'Oceni recept i ostavi belešku za sledeći put.';

  @override
  String get review_cta_button => 'Oceni recept';

  @override
  String get review_sheet_title => 'Kako je ispalo?';

  @override
  String get review_comment_hint => 'Šta bi promenio sledeći put?';

  @override
  String get review_save => 'Sačuvaj ocenu';

  @override
  String get review_edit => 'Izmeni';

  @override
  String get review_delete => 'Obriši';

  @override
  String get review_saved => 'Ocena je sačuvana';

  @override
  String get review_deleted => 'Ocena je obrisana';

  @override
  String get review_rating_label_1 => 'Nije za mene';

  @override
  String get review_rating_label_2 => 'Bilo je okej';

  @override
  String get review_rating_label_3 => 'Prilično dobro';

  @override
  String get review_rating_label_4 => 'Baš ukusno';

  @override
  String get review_rating_label_5 => 'Oduševljenje';

  @override
  String review_updated_at(String date) {
    return 'Izmenjeno $date';
  }

  @override
  String get favorites_title => 'Sačuvani recepti';

  @override
  String favorites_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepata u kuvarici',
      few: '$count recepta u kuvarici',
      one: '$count recept u kuvarici',
      zero: 'Tvoja kuvarica čeka',
    );
    return '$_temp0';
  }

  @override
  String get favorites_empty_title => 'Još nema sačuvanih recepata';

  @override
  String get favorites_empty_subtitle => 'Dodirni srce na bilo kom receptu da ga sačuvaš ovde — radi i bez interneta.';

  @override
  String get favorites_removed => 'Uklonjeno iz sačuvanih';

  @override
  String get favorites_undo => 'Poništi';

  @override
  String get settings_title => 'Podešavanja';

  @override
  String get settings_language => 'Jezik';

  @override
  String get settings_language_system => 'Sistemski';

  @override
  String get settings_theme => 'Izgled';

  @override
  String get settings_theme_system => 'Sistemski';

  @override
  String get settings_theme_light => 'Svetla';

  @override
  String get settings_theme_dark => 'Tamna';

  @override
  String get settings_about => 'O aplikaciji';

  @override
  String get settings_about_body =>
      'Podatke o receptima obezbeđuje javni TheMealDB API. Ocene i sačuvani recepti čuvaju se samo na ovom uređaju.';

  @override
  String get error_network => 'Izgleda da nisi povezan na internet. Proveri konekciju i pokušaj ponovo.';

  @override
  String get error_server => 'Kuhinja je trenutno zauzeta. Pokušaj ponovo za trenutak.';

  @override
  String get error_not_found => 'Nismo pronašli taj recept.';

  @override
  String get error_unknown => 'Nešto nije u redu. Pokušaj ponovo.';

  @override
  String get action_retry => 'Pokušaj ponovo';
}
